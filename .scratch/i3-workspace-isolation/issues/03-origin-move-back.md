# 03: Origin move-back for background spawns

**Status:** resolved

**What to build:** Windows-version virtual-desktop behavior for every app: what starts from workspace 1 stays on workspace 1 unless the user goes to look at it. When a background process spawns a window while the user is typing on another workspace, the new window moves back to its origin — the workspace of the launcher window found by walking OS process ancestry to the nearest ancestor that owns a visible window — and typing focus stays exactly where it was.

**Blocked by:** 02 (Guard daemon autostart with reload/restart survival)

- [ ] Spawning a window from workspace 1 while viewing workspace 2 places the new window on workspace 1 and leaves focus on the workspace 2 editor, so no keystrokes leak
- [ ] Origin resolution walks process ancestry to the nearest ancestor owning a visible window and uses that ancestor workspace as origin (replacing the start-time-versus-switch-time heuristic)
- [ ] Verified by the live cross-workspace opener repro, asserting window workspace assignment, focused workspace number, and focused window identity

## Comments
Resolved on integration branch spec/i3-workspace-isolation.
