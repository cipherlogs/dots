# shadcn

For any shadcn work, including adding, searching, fixing, styling, composing UI, registries, presets, or `components.json`, load the `shadcn` skill first and follow it. Never write a component from memory.

## Normal workflow

- Get project context with `info --json`.
- Check which components are already installed.
- Search before writing new UI.
- Read component docs and fetch linked URLs.
- Add with the CLI.
- Fix imports for aliases and the icon library.
- Review the added files.

Prefer the current `shadcn` skill from shadcn/ui over the old `shadcn-ui`. Use shadcn MCP tools for browsing and searching when faster, and the CLI for `add`, `docs`, and presets.

If the user does not name a registry, ask; never guess a default.

## Styling

- Use `className` for layout only.
- Use `flex` with `gap-*`, never `space-x-*` or `space-y-*`.
- Use `size-*` for square elements and `truncate` for cut-off text.
- Use semantic color tokens such as `bg-primary` and `text-muted-foreground`.
- Do not use raw colors or manual `dark:` overrides.
- Use `cn()` for conditional classes.
- Do not set z-index manually on overlays.
- For forms, use `FieldGroup` with `Field`, `InputGroupInput` or `Textarea`, and `ToggleGroup` for 2 to 7 options.
- Mark invalid fields with `data-invalid` and `aria-invalid`.
- Put items inside groups.
- Use `asChild` for Radix triggers or `render` for Base UI triggers.
- Dialogs, sheets, and drawers need a title.
- Cards need full composition.
- Avatars need a fallback.
- Use `Alert`, `Empty`, `Separator`, `Skeleton`, and `Badge` where they fit.
- Build chat with `MessageScroller`, `Message`, `Bubble`, `Attachment`, and `Marker`.
- For icons, use `data-icon` with object imports matching the project's `iconLibrary`; do not add sizing classes.

## Presets and updates

- Never decode preset codes or build preset URLs by hand; use only the preset commands `decode`, `url`, `resolve`, and `apply`.
- Run `apply <code>` or `init --preset` inside the project folder.
- Preview updates with `--dry-run` and `--diff`, and keep local changes when merging.
- Never use `--overwrite` without explicit approval.
- Respect `aliases`, `isRSC` (`"use client"`), `tailwindVersion`, `tailwindCssFile`, `style`, `base`, `framework`, and `packageManager` from project context.

## Radix to Base UI

- Only migrate when explicitly asked; load the `migrate-radix-to-base` skill.
- Start with project info, the correct package manager, a clean git tree and branch, passing typecheck and build, and `@base-ui/react` installed alongside Radix.
- Migrate one component at a time using the CLI or registry URL with a three-way merge, from the bottom of the dependency tree upward.
- After each component, search every file for leftover `radix-ui` or `@radix-ui` references.
- Save a report per component in `.migration/<component>.md`, plus `project.md` for whole projects.
- Never run bulk `--all --overwrite`.
- Never touch `cmdk`, `vaul`, `sonner`, `input-otp`, `calendar`, or `chart`.
- Flag behavior changes; never patch them silently.

After installing or migrating, follow the paths, aliases, and theme in `components.json`. Verify with the `next-dev-loop` skill rather than source search. If shadcn MCP shows no tools, run `npx clear-npx-cache`, restart the client, and recheck with `/mcp`, `opencode mcp list`, or `codex mcp list`. Docs: https://ui.shadcn.com/docs/mcp
