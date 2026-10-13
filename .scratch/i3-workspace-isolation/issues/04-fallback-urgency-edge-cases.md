# 04: Fallback urgency and edge-case matrix

**Status:** resolved

**What to build:** Safe behavior for every spawn the origin tracker cannot place: headless spawns with no launcher window and single-process browser new-window requests (which hide their true launcher origin) stay visible via an urgency-hint on the current workspace without ever stealing focus. Opening the first window on an empty workspace still focuses it, per window-manager design. The full repro matrix from the spec passes end to end.

**Blocked by:** 03 (Origin move-back for background spawns)

- [ ] A headless spawn with no windowed ancestor leaves placement alone, applies urgency-hint only, and never steals focus
- [ ] A single-process browser new-window request ends unfocused with urgency-hint only, never stealing typing focus
- [ ] The first window opened on an empty workspace is focused, per window-manager design
- [ ] Full matrix green: cross-workspace opener, single-process browser new-window, empty-workspace first-window, and ownerless-spawn fallback — each asserting focused workspace number, focused window identity, window workspace assignment, and urgency flag

## Comments
Resolved on integration branch spec/i3-workspace-isolation.
