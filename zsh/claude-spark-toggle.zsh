# claude-spark toggle — Muse Spark via local LiteLLM gateway vs normal Claude subscription.
# State: ~/.config/claude-spark/mode contains "spark" or "subscription".
# Single command `spark` flips the mode, applies it to the current shell,
# then re-sources ~/.zshrc (which re-applies from state, so resourcing is idempotent).
# No per-toggle edits to ~/.zshrc; only the static source block at the end of ~/.zshrc loads this file.
#
# Why a gateway: Claude Code speaks Anthropic-protocol auth (x-api-key) while
# Meta's API is OpenAI-compatible (Bearer). Direct env injection 401s, so the
# toggle manages a local LiteLLM proxy that translates. The gateway's model
# list aliases claude-opus-5/sonnet/haiku -> Spark so Task subagents stop 400ing.

export CLAUDE_SPARK_STATE_FILE="${CLAUDE_SPARK_STATE_FILE:-$HOME/.config/claude-spark/mode}"
export CLAUDE_SPARK_MODEL="${CLAUDE_SPARK_MODEL:-muse-spark-1.3-contributor}"
export CLAUDE_SPARK_GATEWAY_URL="${CLAUDE_SPARK_GATEWAY_URL:-http://127.0.0.1:4000}"
export CLAUDE_SPARK_GATEWAY_DIR="${CLAUDE_SPARK_GATEWAY_DIR:-$HOME/litellm-claude-gateway}"

_claude_spark_gateway_up() {
  # True if the gateway answers /health.
  [ -f "$CLAUDE_SPARK_GATEWAY_DIR/.master_key" ] || return 1
  curl -sf --max-time 2 "$CLAUDE_SPARK_GATEWAY_URL/health" \
    -H "Authorization: Bearer $(cat "$CLAUDE_SPARK_GATEWAY_DIR/.master_key")" >/dev/null 2>&1
}

_claude_spark_sync_gateway_env() {
  # Refresh the gateway.env snapshot from the live $MODEL_API_KEY when it changed
  # (e.g. after a key rotation in ~/.zshrc). The systemd service has no
  # login-shell env, so without this the gateway keeps calling Meta with the
  # old key. Returns 0 if the snapshot was rewritten, 1 otherwise.
  # Never prints the key itself.
  local snap="$CLAUDE_SPARK_GATEWAY_DIR/gateway.env" old=""
  if [ -z "${MODEL_API_KEY:-}" ]; then
    return 1
  fi
  [ -f "$snap" ] && old="$(grep -E '^MODEL_API_KEY=' "$snap" 2>/dev/null | cut -d= -f2-)"
  if [ "$MODEL_API_KEY" != "$old" ]; then
    printf 'MODEL_API_KEY=%s\n' "$MODEL_API_KEY" > "$snap"
    chmod 600 "$snap"
    echo "spark: gateway key snapshot refreshed" >&2
    return 0
  fi
  return 1
}

_claude_spark_ensure_gateway() {
  # $1 = seconds to wait (0 = fire-and-forget background start, for shell startup).
  local wait_secs="${1:-30}" i key_changed=0
  _claude_spark_sync_gateway_env && key_changed=1
  if [ "$key_changed" = "1" ] && _claude_spark_gateway_up; then
    # Key rotated while the gateway runs with the old env — restart to pick it up.
    systemctl --user restart litellm-claude-gateway.service >/dev/null 2>&1 || {
      echo "spark: ERROR: could not restart litellm-claude-gateway.service" >&2
      return 1
    }
  elif ! _claude_spark_gateway_up; then
    systemctl --user start litellm-claude-gateway.service >/dev/null 2>&1 || {
      echo "spark: ERROR: could not start litellm-claude-gateway.service" >&2
      return 1
    }
  fi
  if [ "$wait_secs" = "0" ]; then
    return 0
  fi
  for i in $(seq 1 "$wait_secs"); do
    sleep 1
    if _claude_spark_gateway_up; then
      return 0
    fi
  done
  echo "spark: ERROR: gateway did not become healthy within ${wait_secs}s" >&2
  return 1
}

_claude_spark_set_settings_model() {
  # $1 = model name to pin, or empty to remove the pin (subscription default).
  python3 - "$1" <<'PY' 2>/dev/null
import json, os, sys
p = os.path.expanduser("~/.claude/settings.json")
want = sys.argv[1] if len(sys.argv) > 1 else ""
try:
    with open(p) as f:
        data = json.load(f)
except (FileNotFoundError, json.JSONDecodeError):
    data = {}
if want:
    data["model"] = want
else:
    data.pop("model", None)
os.makedirs(os.path.dirname(p), exist_ok=True)
with open(p, "w") as f:
    json.dump(data, f, indent=2)
    f.write("\n")
PY
}

_claude_spark_apply() {
  # $1 = mode, $2 = gateway wait seconds (default 30; 0 = background start).
  local mode="$1" wait_secs="${2:-30}"
  if [ "$mode" = "spark" ]; then
    if [ -z "${MODEL_API_KEY:-}" ]; then
      echo "spark: WARNING: MODEL_API_KEY is empty — Spark auth will fail." >&2
    fi
    _claude_spark_ensure_gateway "$wait_secs" || return 1
    export ANTHROPIC_BASE_URL="$CLAUDE_SPARK_GATEWAY_URL"
    export ANTHROPIC_AUTH_TOKEN="$(cat "$CLAUDE_SPARK_GATEWAY_DIR/.master_key")"
    export ANTHROPIC_MODEL="$CLAUDE_SPARK_MODEL"
    export CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY=1
    export CLAUDE_CODE_MAX_CONTEXT_TOKENS="1048576"
    unset ANTHROPIC_API_KEY || true
    _claude_spark_set_settings_model "$CLAUDE_SPARK_MODEL"
  else
    unset ANTHROPIC_BASE_URL ANTHROPIC_AUTH_TOKEN ANTHROPIC_MODEL \
      CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY CLAUDE_CODE_MAX_CONTEXT_TOKENS || true
    _claude_spark_set_settings_model ""
  fi
}

spark_on() {
  printf 'spark\n' > "$CLAUDE_SPARK_STATE_FILE"
  _claude_spark_apply spark 30 || return 1
  echo "spark: ON — claude now points at $CLAUDE_SPARK_MODEL via $CLAUDE_SPARK_GATEWAY_URL"
}

spark_off() {
  printf 'subscription\n' > "$CLAUDE_SPARK_STATE_FILE"
  _claude_spark_apply subscription 0
  systemctl --user stop litellm-claude-gateway.service >/dev/null 2>&1 || true
  # A capped stop (TimeoutStopSec) can still leave a timeout marker; clear it.
  systemctl --user reset-failed litellm-claude-gateway.service >/dev/null 2>&1 || true
  echo "spark: OFF — claude back on subscription defaults (gateway stopped)"
}

spark_status() {
  local mode="subscription" gw="down"
  [ -f "$CLAUDE_SPARK_STATE_FILE" ] && mode="$(cat "$CLAUDE_SPARK_STATE_FILE" 2>/dev/null)"
  _claude_spark_gateway_up && gw="up"
  echo "mode: $mode (gateway: $gw)"
  echo "ANTHROPIC_BASE_URL=${ANTHROPIC_BASE_URL:-<unset>}"
  echo "ANTHROPIC_MODEL=${ANTHROPIC_MODEL:-<unset>}"
  echo "ANTHROPIC_AUTH_TOKEN=$([ -n "${ANTHROPIC_AUTH_TOKEN:-}" ] && echo '<set>' || echo '<unset>')"
}

spark() {
  local mode="subscription"
  [ -f "$CLAUDE_SPARK_STATE_FILE" ] && mode="$(cat "$CLAUDE_SPARK_STATE_FILE" 2>/dev/null)"
  if [ "$mode" = "spark" ]; then
    spark_off
  else
    spark_on || return 1
  fi
  # Always resource the config so the new mode takes effect everywhere it is read.
  # ~/.zshrc re-sources this file, which re-applies from the state file (idempotent).
  source "$HOME/.zshrc"
}

# Apply persisted mode on shell startup (no resourcing here — we are already being sourced).
# Background-start the gateway if needed so new shells stay fast.
if [ -f "$CLAUDE_SPARK_STATE_FILE" ]; then
  _claude_spark_apply "$(cat "$CLAUDE_SPARK_STATE_FILE" 2>/dev/null)" 0 >/dev/null 2>&1 || true
fi
