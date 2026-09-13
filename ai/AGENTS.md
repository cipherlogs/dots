# Global Agent Instructions

<!-- This is the single shared source. It is symlinked to OpenCode, Claude Code, and Codex globals. Edit here and all three pick it up. -->

This file applies to every project. Project-specific details live in the repo's own AGENTS.md, not here.

## Next.js

These rules apply to any Next.js project. Useful guides:

- https://nextjs.org/docs/app/guides/ai-agents
- https://nextjs.org/docs/app/guides/mcp

Do not rely on memorized Next.js knowledge. Next.js changes fast. Always check the docs that ship with the installed version, and use skills only for multi-step workflows.

### 1. Read the matching docs first

Before writing any Next.js code, read the docs bundled with the installed Next.js version:

- They live in `node_modules/next/dist/docs/`, resolved from the project root.
- In a monorepo the `next` package may be nested, so search from the app folder if needed.
- If you know the topic slug but not the numbered folder, run:
  `find node_modules/next/dist/docs -name '<slug>.md'`
- Respect any deprecation notice you find there.

Agent rules block:

- On Next 16.3 or newer, running `next dev` auto-generates the managed `<!-- BEGIN:nextjs-agent-rules -->` block. Content outside that block is preserved, so never hand-edit inside the markers.
- On Next 16.2, add the block manually.
- On Next 16.1 or older, ask the user first, then run `npx @next/codemod@canary agents-md` (this writes `.next-docs/` plus an index).
- If `next.config.ts` sets `agentRules: false`, or the user passed `--no-agents-md`, leave it alone.

If the topic is not in the bundled docs:

- Append `.md` to any `nextjs.org/docs` URL to get plain Markdown, or send `Accept: text/markdown`.
- Start from the index at `/docs/llms.txt` and `/docs/llms-full.txt`.
- Error pages under `/docs/messages/*` only exist on the web. Always fetch the linked page. Never guess from the short inline text.

Other sources: https://github.com/vercel/next.js/tree/canary/skills and https://www.skills.sh/vercel/next.js.

### 2. Next Devtools is already installed globally

You do not need to install it per project. It is available in:

- Opencode: `~/.config/opencode/opencode.jsonc`
- Claude Code and Claude CLI (they share one config): user scope in `~/.claude.json`
- Codex: `~/.codex/config.toml`

All three use the same command: `npx -y next-devtools-mcp@latest`. Keep that string identical everywhere so versions do not drift.

A project may still list it in its own `.mcp.json`. That is an optional override, not a requirement. If both exist:

- Claude prefers the project entry over the user entry.
- Opencode merges global and project entries.
- Codex uses the global entry everywhere.

How it behaves:

- It only shows tools while a Next.js 16 (or newer) dev server is running. It finds the server automatically through the `/_next/mcp` endpoint.
- Seeing "connected but no tools" outside a Next project, or when `next dev` is stopped, is normal.
- If a dev server is already running, connect to it. Find its port, PID, and URL in `.next/dev/lock` and in the `next dev` banner. Never start a second dev server.
- While the dev server runs, browser console warnings and errors are forwarded to the terminal. Never move or delete the `.next` folder while the server runs.

What you can do with it:

- List available tools, then check compilation issues, compile a single route, read current errors, list routes, read page or project metadata, read dev logs, and resolve a Server Action ID to its source.
- Useful tools: `get_compilation_issues`, `compile_route`, `get_errors`, `get_routes`, `get_page_metadata`, `get_logs`, `get_server_action_by_id`.
- `get_compilation_issues` and `compile_route` tell you whether code compiles without running a full `next build`.

To verify it works, run:

- `opencode mcp list`
- `claude mcp list`
- `codex mcp list`

All three should show `next-devtools` as connected or enabled.

If it shows no tools: make sure `next dev` is running and the project uses Next 16 or newer, then restart your client. If that fails, run `npx clear-npx-cache` and restart again.

### 3. Always verify at runtime

After every edit to app code, check that the page still works in a running app. Compiling is not enough.

- This applies to any Next.js project where `next dev` can run. If it cannot run, say why and skip.
- Use the `next-dev-loop` skill for this check. It looks at the app from two sides: the framework side (`/_next/mcp`) and the browser side (`agent-browser`: DOM, console, network, Web Vitals, React tree, pending Suspense boundaries).
- If the preflight check fails (Next older than 16.3, webpack without Turbopack, or `agent-browser` missing), tell the user how to upgrade and stop. Do not fall back to just searching the source.

Browser check in short:

- Run `agent-browser skills get core` once so you use the matching version.
- Open the page in a session tied to the worktree, wait until the network is idle, then inspect the snapshot, console, and React tree.
- Close the session when done and leave `next dev` running.

### 4. Let errors guide the fix

Next 16 prints a menu of labeled fixes (such as `[stream]`, `[cache]`, `[block]`) in the dev overlay, the terminal, and `next build` output. Each option has a trade-off.

- Read the whole menu and pick deliberately.
- Always open the `Learn more:` link. Those `/docs/messages/*` pages describe the recommended pattern and its gotchas.
- If a production build error is minified and unclear, rerun with `next build --debug-prerender` for server source maps and to continue past the first failure. To scope it, add `--debug-build-paths="app/<route>/**"` using file paths, not URL paths.
- To make navigation instant, write a failing `@next/playwright` `instant()` test on a production-like build, work until it passes, and keep the test as a guard. Only use `experimental.exposeTestingApiInProductionBuild` for measured builds, never in real production. Never measure instant behavior on `next dev`.

### 5. Larger Next.js workflows

Use these skills only for multi-step migrations, one at a time:

- **Cache Components adoption.** Needs App Router, Next 16.3 or newer, and a runnable app. Look at the existing rendering, data fetching, caching, and personalization first. Do not turn on `cacheComponents` or add `use cache` blindly. Agree with the user on one branch versus small PRs (default to small steps if unsure). Each step must pass the dev-loop check and `next build`.
- **Cache Components optimizer (instant navigation).** Needs `cacheComponents: true` and a production-like setup. Find the shared UI that should appear immediately (navigation, headers, sidebars, breadcrumbs). Keep login, permissions, personalization, and caching behavior unchanged. Do not move data fetching to the client, add unneeded client state, duplicate requests, or cache personal data publicly just to look faster.
- **Partial Prefetching adoption.** Needs Cache Components adopted, a passing build, and Next 16.3 or newer. Look at routing, navigation, prefetching, and Cache Components first. Audit `<Link prefetch={true}>` usage and take a baseline before turning the flag on. Keep auth and personalization unchanged.

### 6. React composition
use the skill `vercel-composition-patterns` if you are Refactoring components with many boolean
props or Building reusable component libraries or Designing flexible component APIs or Reviewing
component architecture or Working with compound components or context providers


## shadcn

For any shadcn work (adding, searching, fixing, styling, composing UI, registries, presets, `components.json`), load the `shadcn` skill first and follow it. Never write a component from memory.

The normal workflow is:

1. Get project context with `info --json`.
2. Check which components are already installed.
3. Search before writing new UI.
4. Read the component docs and fetch the linked URLs.
5. Add with the CLI.
6. Fix imports for aliases and the icon library.
7. Review the added files.

Prefer the current `shadcn` skill (source `shadcn/ui`) over the old `shadcn-ui`. Use MCP `shadcn` tools for browsing and searching when that is faster, and the CLI for `add`, `docs`, and presets.

If the user does not name a registry, ask. Never guess a default.

Styling rules:

- Use `className` for layout only.
- Use `flex` with `gap-*`, never `space-x-*` or `space-y-*`.
- Use `size-*` for square elements and `truncate` for cut-off text.
- Use semantic color tokens like `bg-primary` and `text-muted-foreground`. No raw colors and no manual `dark:` overrides.
- Use `cn()` for conditional classes. Do not set z-index manually on overlays.
- For forms, use `FieldGroup` with `Field`, `InputGroupInput` or `Textarea`, and `ToggleGroup` for 2 to 7 options. Mark invalid fields with `data-invalid` and `aria-invalid`.
- Put items inside groups. Use `asChild` (Radix) or `render` (Base UI) for triggers. Dialogs, sheets, and drawers need a title. Cards need full composition. Avatars always need a fallback.
- Use `Alert`, `Empty`, `Separator`, `Skeleton`, and `Badge` where they fit. Build chat with `MessageScroller`, `Message`, `Bubble`, `Attachment`, and `Marker`.
- For icons, use `data-icon` with object imports matching the project's `iconLibrary`. Do not add sizing classes.

Presets and updates:

- Never decode preset codes or build preset URLs by hand. Only use the preset commands (`decode`, `url`, `resolve`, `apply`).
- Run `apply <code>` or `init --preset` inside the project folder.
- Preview updates with `--dry-run` and `--diff`, and keep local changes when merging.
- Never use `--overwrite` without explicit approval.
- Respect `aliases`, `isRSC` (`"use client"`), `tailwindVersion`, `tailwindCssFile`, `style`, `base`, `framework`, and `packageManager` from the project context.

Radix to Base UI migration:

- Only do this when explicitly asked. Load the `migrate-radix-to-base` skill.
- Start with a preflight: project info, correct package manager, clean git tree and branch, passing typecheck and build, and install `@base-ui/react` alongside Radix.
- Migrate one component at a time using the CLI or registry URL with a three-way merge, from the bottom of the dependency tree upward.
- After each component, search every file for leftover `radix-ui` or `@radix-ui` references.
- Save a report per component in `.migration/<component>.md` (plus `project.md` for whole projects).
- Never run bulk `--all --overwrite`. Never touch cmdk, vaul, sonner, input-otp, calendar, or chart.
- If behavior changes, flag it. Never patch it silently.

After installing or migrating, follow the paths, aliases, and theme in `components.json`. Verify with the `next dev` loop, not by searching source. If the MCP shows no tools, run `npx clear-npx-cache`, restart the client, and recheck with `/mcp`, `opencode mcp list`, or `codex mcp list`. Docs: https://ui.shadcn.com/docs/mcp

## graphify

Use the `graphify` skill (`~/.claude/skills/graphify/SKILL.md`) for any question about a codebase, its architecture, file relationships, or project content.

When the user types `/graphify`, follow that skill first before doing anything else. It turns input (code, docs, papers, images, video) into a persistent knowledge graph.

## Ruflo

When working on multi-file tasks or complex features, use ToolSearch to find and invoke Ruflo MCP tools.

Useful tools: `memory_store`, `memory_search`, `hooks_route`, `swarm_init`, `agent_spawn`.

Check system-reminder tags for `[INTELLIGENCE]` suggestions before starting work.

## GitHub

For any GitHub work (repos, issues, PRs, Actions, releases, code search) or GitHub docs lookup, prefer the `github` MCP server tools when available. Use the `gh` CLI only as a fallback when MCP is missing or disabled.

- Before creating an issue, search for duplicates.
- When closing an issue, always set a reason.
- For pull request reviews with line-specific comments, create a pending review, add comments to it, then submit it.
- Before creating a pull request, look for a pull request template in the repo and follow it.
- Never hardcode tokens. Use the `GITHUB_PAT_TOKEN` environment variable.
