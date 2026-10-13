# 01: Tiled delivery for every arrival

**What to build:** Every window delivered to its origin or targeted workspace arrives tiled as an ordinary citizen, never as a free window floating over the layout.

**Blocked by:** None (can start immediately).

**Status:** resolved

- [ ] Background birth from another workspace waits tiled on its origin workspace alongside other windows
- [ ] No delivered arrival is left floating; tiling rectangles on the focused workspace are undisturbed
- [ ] Diary shows one delivery line with destination per birth

## Comments
Resolved on integration branch spec/i3-true-isolation.
Follow-up on spec/i3-true-isolation-diversion-v2 (345c54f9): foreground births were cross-delivered to the wrong workspace because i3 misroutes move-to-workspace at the visible workspace; deliveries bound for the focused workspace now go via scratchpad show with refocus. Verified live: alacritty spawned on ws1 lands tiled on ws1, focus restored, first-window and background paths green.
