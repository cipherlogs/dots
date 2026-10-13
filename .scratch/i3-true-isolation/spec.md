Status: ready-for-agent

## Problem Statement

On a single-monitor tiling setup, workspaces still do not feel like isolated desktops. Three live defects remain after origin move-back landed:

1. **Birth flash.** A window born from one workspace briefly tiles onto the focused workspace (visible tiles resize, fullscreen video shrinks) and only then moves to its origin workspace. A correct final placement does not undo the disturbance.
2. **Floating delivery.** Windows moved to their origin workspace arrive floating freely instead of tiled with the other windows.
3. **Exiled dialogs.** A file picker opened from a browser on one workspace was moved to another workspace, so the user could not find it.

The required experience is virtual-desktop isolation: what starts on one desktop happens on that desktop, and activity elsewhere is never visible, not even for a blink.

## Solution

Hold every newborn window in the hidden scratchpad before it can draw or tile anywhere, then deliver it exactly once: to its origin workspace, or back where the window manager targeted it, or to the reserved automation workspace for automation pins. Delivered windows tile normally. Dialogs stay with the workspace of their parent window. Focus on the user's workspace is never taken, so there is nothing to restore in the common case; arrivals are findable through the urgency badge. The event subscription is held on a persistent connection that survives birth events, with snapshot reconciliation as backup for anything born during a reconnect gap.

## User Stories

1. As an engineer watching fullscreen video on workspace 2, I want a terminal spawned from workspace 1 to never resize my tiles, so that my video never shrinks or blinks.
2. As an engineer on workspace 2, I want a background birth to take zero pixels of my workspace even briefly, so that I cannot tell anything happened elsewhere.
3. As an engineer arriving on workspace 1 later, I want the spawned terminal waiting there tiled with my other windows, so that it is an ordinary citizen of that desktop.
4. As an engineer whose window was delivered, I never want it floating freely over my tiling layout, so that I do not have to fix its state by hand.
5. As an engineer opening a file picker from my workspace 2 browser, I want the picker on workspace 2 next to its parent, so that I am not surprised by a missing dialog.
6. As an engineer with single-process browsers, I want a dialog whose process family visibly lives on exactly one workspace to stay there without consulting ancestry, so that pid reuse cannot exile it.
7. As an engineer launching a browser new-window from workspace 1, I accept urgency-only placement (single-process origin hiding is a known limitation), but I still want zero tiling disturbance on my focused workspace.
8. As an engineer launching an app where I sit, I want it to appear on my workspace needing one explicit click to focus, so that background and foreground behavior stays predictable.
9. As an engineer opening the first window on an empty workspace, I want it focused despite the general no-autofocus rule, so that empty workspaces remain usable.
10. As an engineer with automation windows pinned to the reserved background workspace, I want those pins untouched and rescued there if staging ever displaces one, so that existing automation keeps working.
11. As an engineer spawning two windows half a second apart, I want both handled (no lost births in reconnect gaps), so that rapid launches are as safe as slow ones.
12. As an engineer restarting the guard, I want pre-existing windows left completely alone, so that a restart never mass-moves my layout.
13. As an engineer restarting the window manager in place, I want isolation to survive reload and restart, so that layout sessions are preserved.
14. As an engineer reading the guard's diary log, I want one line per birth showing stage, delivery destination, and refocus, so that any flash can be correlated by timestamp.
15. As an engineer recording a verification take, I want tile rectangles on the focused workspace byte-identical across a background birth, so that zero overlap is proven from frames, not claimed from logs.
16. As an engineer with a headless spawn (timer, service, no launcher window), I want fallback to urgency on the targeted workspace without focus steal, so that ownerless windows are visible but not disruptive.
17. As an engineer moving the mouse, I want hover over any tile to not steal focus, so that cursor position does not change typing context.
18. As an engineer typing while a background window arrives, I want zero keystrokes leaking into it, so that focus never leaves my window.
19. As an engineer whose birth the guard somehow misses live, I want snapshot reconciliation to still move, refocus, and badge it on the next cycle, so that a missed event degrades to a late fix, never a lost window.
20. As an engineer on a slow or loaded machine, I want the hide-before-map order verified against the reply from the window manager, so that a silently refused hide is visible in the diary instead of a mystery flash.

## Implementation Decisions

- Single birth-to-delivery seam in the focus-guard daemon: on a birth event, move the new container to the hidden scratchpad immediately (single-digit milliseconds, before mapping), then after a short settle delay resolve origin from OS process ancestry against the owner-workspace map, then deliver exactly once.
- Delivery targets: origin workspace when ancestry reaches a visible window elsewhere; the targeted workspace when there is no windowed ancestor or it matches; the reserved automation workspace for automation pins displaced by staging; the targeted workspace left focused for first windows on empty workspaces.
- Every delivery ends with floating disabled so arrivals always tile; scratchpad state never leaks onto real workspaces.
- Origin rule refinement for pid-reusing processes and dialogs: when the newborn's process family visibly owns windows on exactly one workspace, that workspace wins without consulting ancestry; ancestry (excluding self) is consulted only when the family spans workspaces or owns none.
- Event transport held on a persistent IPC socket owned by the daemon (standard library only), because the helper CLI subscription exits cleanly after delivering birth events; snapshot diff of window identity pairs on every (re)subscribe reconciles anything born during a gap, keyed to survive identifier recycling.
- Automation exclusion happens twice: birth-event properties skip staging, and post-settle properties confirm; automation is never moved except rescue to its reserved workspace.
- Focus restoration and urgency badge remain as the second net for anything that defeats staging (gap births, refused hides); urgency is applied after focus is settled since hints set while focused are cleared.
- Declarative window-manager settings (birth-diversion candidate rule, existing assign, no-focus, focus-on-activation, mouse focus behavior) stay the outer shell; if the in-daemon hide order is proven to lose the map race via the reply check, diversion moves into a manager rule so hiding happens with zero trip time.
- Diary discipline: one line per stage, delivery (with destination), refocus, and hide-reply verdict; no per-debug tagging left behind.

## Testing Decisions

- Good tests assert externally observable behavior only: tiling rectangles on the focused workspace, focused workspace number, focused window identity, window workspace assignment, floating versus tiled state, urgency flag, diary lines by timestamp. Never daemon internals or config text.
- Seams, highest first: (1) birth-to-delivery behavior seam asserted through live window births plus diary correlation; (2) event-transport seam asserted by absence of reconnect churn across consecutive births; (3) declarative config seam verified by reload plus live repro, not unit tests; (4) recorded video takes graded frame-by-frame as the done-condition.
- Prior art: the manual repro baseline from the earlier isolation effort (cross-workspace opener, single-process browser new-window, empty-workspace first window, ownerless-spawn fallback), extended with: rapid double birth half a second apart, timestamped single birth correlated to diary lines, Chrome upload-dialog stay-put check, restart-preexisting-windows-untouched check.
- Pure helpers (identity-pair diff, workspace-emptiness check) carry small self-checks; there is no repo test harness, and none is to be built for this effort.
- Video protocol: fullscreen capture during scripted births only; pass is byte-identical tiling on the focused workspace across each birth with the window found tiled on its origin workspace; failing takes loop through diary correlation and fixes until a passing take is confirmed from extracted frames.

## Out of Scope

- True origin recovery for single-process browsers beyond the unanimous-family rule (profile isolation remains deferred).
- Fully silent mode with no urgency badge.
- Automatic focus for self-launched windows beyond the one-click policy.
- Touchpad-specific focus tuning beyond existing global mouse settings.
- True OS-level isolation (containers, VMs, nested servers) or switching window managers.
- A repo test harness; throwaway harnesses and temp scripts only.
- Per-application pinning of everyday apps beyond automation and the existing assign rules.

## Further Notes

- Vocabulary (no glossary file in repo yet): workspace means numbered workspace on one monitor; origin means launcher window workspace; staged means held on the hidden scratchpad; delivered means moved to its final workspace; flash means any visible disturbance on a non-origin workspace (tile-shift, focus-steal, or overlay); free window means an arrival left floating; urgency-hint means bar highlight without focus; pin means force to a fixed workspace.
- Live code state at spec time: staging, raw-socket transport, gap reconciliation, and picker-adjacent ancestry are committed (auto-commits); floating-disable on delivery, hide-reply check, unanimous-family rule, and any manager birth-diversion rule are specified here but not yet implemented; the running daemon matches the repo file.
- Repro commands from session: raw-shell delayed spawn while switched away (move-back path), ownerless spawn (fallback path), rapid double spawn (gap path), Chrome upload dialog (dialog path).
- Single-seam preference holds: one daemon seam plus existing IPC, owner-identifier, and process-ancestry seams.
