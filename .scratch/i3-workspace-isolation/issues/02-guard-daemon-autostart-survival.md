# 02: Guard daemon autostart with reload/restart survival

**Status:** resolved

**What to build:** The focus-guard daemon as a first-class part of the dotfiles: installed from the repo, autostarted by the window-manager session as its single origin-tracking seam, running exactly once, and still subscribed and enforcing isolation after an in-place reload and an in-place restart that preserves the session layout.

**Blocked by:** None (can start immediately)

- [ ] A fresh session brings up exactly one running guard subscribed to new-window events with no manual steps
- [ ] A second start attempt exits without disturbing the already-running guard
- [ ] In-place reload keeps the guard subscribed and enforcing; in-place restart preserves layout with the guard still running
- [ ] Verified by reload plus restart-in-place with the session layout preserved, asserting the guard is alive and enforcing afterwards

## Comments
Resolved on integration branch spec/i3-workspace-isolation.
