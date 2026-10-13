# Next.js

These rules apply to any Next.js project.

## Documentation

- Read the bundled documentation before writing Next.js code; do not rely on memorized Next.js knowledge.
- Useful guides:
  - https://nextjs.org/docs/app/guides/ai-agents
  - https://nextjs.org/docs/app/guides/mcp
- Bundled docs live in `node_modules/next/dist/docs/`, resolved from the project root.
- In a monorepo, search from the app folder if needed.
- If you know the topic slug but not the numbered folder, run:
  `find node_modules/next/dist/docs -name '<slug>.md'`
- Respect any deprecation notice in the bundled docs.
- If the topic is not bundled, append `.md` to the `nextjs.org/docs` URL or send `Accept: text/markdown`.
- Start from `/docs/llms.txt` or `/docs/llms-full.txt` when using the web docs.
- Error pages under `/docs/messages/*` only exist on the web; always fetch the linked page and never guess from the short inline text.
- Other sources:
  - https://github.com/vercel/next.js/tree/canary/skills
  - https://www.skills.sh/vercel/next.js

## Next.js agent rules

- On Next 16.3 or newer, `next dev` auto-generates the managed `<!-- BEGIN:nextjs-agent-rules -->` block; never hand-edit inside the markers.
- On Next 16.2, add the block manually.
- On Next 16.1 or older, ask the user first, then run `npx @next/codemod@canary agents-md`; this writes `.next-docs/` plus an index.
- If `next.config.ts` sets `agentRules: false`, or the user passed `--no-agents-md`, leave it alone.

## Next Devtools

- Next Devtools is already installed globally; do not install it per project.
- Keep this command identical across clients: `npx -y next-devtools-mcp@latest`.
- Config locations:
  - OpenCode: `~/.config/opencode/opencode.jsonc`
  - Claude Code and Claude CLI: user scope in `~/.claude.json`
  - Codex: `~/.codex/config.toml`
- A project may list Next Devtools in its own `.mcp.json` as an optional override.
- If both global and project entries exist, Claude prefers the project entry, OpenCode merges global and project entries, and Codex uses the global entry everywhere.
- Next Devtools only shows tools while a Next.js 16 or newer dev server is running; it finds the server through `/_next/mcp`.
- “Connected but no tools” outside a Next project or while `next dev` is stopped is normal.
- If a dev server is already running, connect to it; find its port, PID, and URL in `.next/dev/lock` and the `next dev` banner.
- Never start a second dev server.
- While the server runs, browser console warnings and errors are forwarded to the terminal.
- Never move or delete `.next` while the server runs.
- Useful tools:
  - `get_compilation_issues`
  - `compile_route`
  - `get_errors`
  - `get_routes`
  - `get_page_metadata`
  - `get_logs`
  - `get_server_action_by_id`
- `get_compilation_issues` and `compile_route` check compilation without a full `next build`.
- Verify the connection with `opencode mcp list`, `claude mcp list`, and `codex mcp list`; all three should show Next Devtools as connected or enabled.
- If no tools appear, confirm `next dev` is running on Next 16 or newer, then restart the client; if needed, run `npx clear-npx-cache` and restart again.

## Runtime verification

- After every edit to app code, verify the page at runtime in a running app; compilation alone is insufficient.
- Use the `next-dev-loop` skill. It checks both `/_next/mcp` and the browser through `agent-browser`.
- If Next cannot run, state why and skip this check.
- If the preflight fails because Next is older than 16.3, webpack is used instead of Turbopack, or `agent-browser` is missing, explain the upgrade needed and stop; do not replace it with source search alone.
- Run `agent-browser skills get core` once before the browser check.
- Open the page in a worktree-tied session, wait for network idle, inspect the snapshot, console, and React tree, then close the session and leave `next dev` running.

## Error-guided fixes

- Next 16 prints a menu of labeled fixes such as `[stream]`, `[cache]`, and `[block]` in the dev overlay, terminal, and `next build` output; read the full menu, account for each trade-off, and choose deliberately.
- Always open the `Learn more:` link; the linked `/docs/messages/*` page contains the recommended pattern and its gotchas.
- If a production build error is minified and unclear, rerun with `next build --debug-prerender` for server source maps and to continue past the first failure.
- Scope debug builds with `--debug-build-paths="app/<route>/**"`, using file paths rather than URL paths.
- To make navigation instant, write a failing `@next/playwright` `instant()` test against a production-like build, fix the route, and keep the test as a regression guard.
- Use `experimental.exposeTestingApiInProductionBuild` only for measured builds, never real production.
- Never measure instant behavior on `next dev`.

## Larger workflows

Use these skills only for multi-step migrations, one at a time:

- Cache Components adoption requires App Router, Next 16.3 or newer, and a runnable app. Inspect rendering, data fetching, caching, and personalization first. Do not enable `cacheComponents` or add `use cache` blindly. Agree with the user on one branch versus small PRs; prefer small steps when the user has not chosen. Each step must pass the dev-loop check and `next build`.
- Cache Components optimization requires `cacheComponents: true` and a production-like setup. Find the shared UI that should appear immediately, such as navigation, headers, sidebars, and breadcrumbs, while preserving login, permissions, personalization, and caching behavior. Do not move fetching to the client, add unnecessary client state, duplicate requests, or publicly cache personal data just to look faster.
- Partial Prefetching adoption requires Cache Components, a passing build, and Next 16.3 or newer. Audit routing, prefetching, and existing `Link prefetch={true}` behavior before enabling it, preserve existing instant-navigation tests, and keep authentication and personalization unchanged.
