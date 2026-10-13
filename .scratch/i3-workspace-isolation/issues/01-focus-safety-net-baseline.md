# 01: Focus safety-net baseline

**Status:** resolved

**What to build:** A typing session where the mouse and background arrivals can never yank keyboard focus. Moving the mouse over a new tile changes nothing about typing context, switching workspaces leaves the cursor put, and any background arrival shows up only as an urgency-hint on its workspace. Everyday browsers behave the same as every other app — background arrivals tile without stealing focus, and a self-launched window needs one explicit focus action. Existing automation pinning to the reserved background workspace keeps working exactly as before.

**Blocked by:** None (can start immediately)

- [ ] Mouse hover over a new tile never moves keyboard focus, and workspace switches never warp the cursor
- [ ] A background spawn from another workspace neither takes focus nor shifts the current layout; it marks urgency-hint only
- [ ] A self-launched window on the current workspace takes focus with one explicit user action, keeping background/foreground behavior predictable
- [ ] Automation windows already pinned to the reserved background workspace keep their existing pin and no-focus behavior unchanged
- [ ] Verified by window-manager reload plus the live cross-workspace opener repro, asserting focused workspace number, focused window identity, and urgency flag

## Comments
Resolved on integration branch spec/i3-workspace-isolation.
