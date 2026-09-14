# dots — lean, portable, stow-managed

One repo, three stow roots. Only hand-edited configs live here.
Caches, app state, and secrets are never committed (see `.gitignore`).

```
dots/
  home/      # stow -t ~            (.zshrc, .zshenv, .aliases, .gitconfig, …)
  config/    # stow -t ~/.config    (nvim/, i3/, tmux/, zsh/, opencode/, …)
  localbin/  # stow -t ~/.local/bin (scripts; merges ~/bin + .config/bin)
  hosts/     # per-machine overlays, stowed last (arch-desktop/, laptop/, …)
  install.sh # bootstrap: checks deps, stows everything
```

## Fresh machine

```bash
git clone git@github.com:cipherlogs/dots.git ~/dots
cd ~/dots
./install.sh
cp config/zsh/zsh/secrets.env.template ~/.config/zsh/secrets.env  # fill in
cp config/environment.d/environment.d/github_pat.conf.template ~/.config/environment.d/github_pat.conf
gh auth login   # regenerates config/gh/hosts.yml (never committed)
```

Requires `stow` (`sudo pacman -S stow` on Manjaro).

## Sync

Live paths are symlinks into this repo, so editing a config edits the
repo — sync is just commit + push. Two ways, both safe to mix:

- **Manual:** `dotsync` — shows status, stages tracked changes only
  (untracked files are listed, never auto-added), scans the staged
  diff for secrets, prompts for a message, asks before pushing.
  Subcommands: `dotsync status|pull|push|log`. The old `upp()` now
  calls `dotsync` for its dots half.
- **Auto:** `dotsync-auto.timer` (every 30 min) runs `dotsync --auto`:
  commits tracked changes as `auto: <host> <timestamp>` and pushes
  only on clean fast-forward. No auto-pull, no conflict resolution —
  on anything unexpected it sends a dunst notification and leaves the
  repo for your next manual `dotsync`.

Multi-machine rule: push before leaving a machine, `dotsync pull`
(`--rebase`) on arrival. Host-specific files live in `hosts/` so
machines don't fight.

## Tracking a new app

```bash
dotsync track ~/.config/coolApp     # config dir  -> config/coolApp/
dotsync track ~/.coolapprc          # home dotfile -> home/<name>/
dotsync track ~/.local/bin/cooltool # script       -> localbin/<name>/
dotsync track --host <path>         # machine-specific -> hosts/<host>/
```

`track` moves the path into the repo, stows it back, verifies the link,
stages it, and continues into the commit flow. It refuses symlinks,
paths outside `$HOME`, state dirs (`node_modules`, caches, logs), and
secret-looking paths or contents — and rolls the move back if stowing
fails. `--auto` never tracks.

## Rules

- `git add` is explicit per file — never `git add .` (state dirs sit next to configs).
- Packages mirror their target 1:1: `config/nvim/nvim/init.lua` lands at
  `~/.config/nvim/init.lua`; `home/zsh/.zshrc` lands at `~/.zshrc`.
  `install.sh` stows every package dir it finds, no registry to update.
- Secrets go in `*.template` + local-only real file. If a secret touches the
  index, rotate it; history rewrites don't unfire a pushed token.
- Machine-specific stuff (monitors, mimeapps, autostart) goes under `hosts/`.
- Dead apps get removed, not ignored: this repo is curated, not a backup.
