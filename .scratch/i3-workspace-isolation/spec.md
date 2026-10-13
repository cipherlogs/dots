Status: ready-for-agent

## Problem Statement

On a single-monitor i3 setup, workspaces do not feel isolated. A background process spawned from workspace 1 opens its window on the currently visible workspace 2, tiles next to the focused editor, and steals keyboard focus. The user wants Windows virtual-desktop behavior: what starts from workspace 1 stays on workspace 1 unless they go look at it.

## Solution

System-wide origin tracking for all applications, not per-app pinning. New windows are moved back to the workspace of their launcher, focus stays where the user types, background arrivals only set an urgency badge. Mouse hover and warping never yank focus. Existing per-automation background workspace rules stay untouched.

## User Stories

1. As an engineer editing in a terminal on workspace 2, I want a browser spawned by a process on workspace 1 to open on workspace 1, so that my layout does not shift.
2. As an engineer editing in a terminal on workspace 2, I want a background spawn to never steal typing focus, so that keystrokes do not leak into the wrong window.
3. As an engineer who launched an app myself on the current workspace, I want to focus it with one explicit action, so that background and foreground behavior stays predictable.
4. As an engineer with a background arrival, I want an urgency badge on its workspace, so that I can find it later without being interrupted now.
5. As an engineer moving the mouse, I want hover over a new tile to not steal focus, so that cursor position does not change typing context.
6. As an engineer switching workspaces, I want the cursor to stay put, so that focus switches do not warp under background popups.
7. As an engineer running any app (browser, file manager, updater, dialog), I want the same isolation guarantee, so that browsers are not a special case.
8. As an engineer using single-process browsers with new-window requests to a running instance, I want no focus steal even when origin is hidden, so that the worst offender is still safe.
9. As an engineer opening the first window on an empty workspace, I want it focused despite the general no-autofocus rule, so that empty workspaces remain usable per window manager design.
10. As an engineer with automation windows already pinned to a reserved background workspace, I want those rules unchanged, so that existing automation keeps working.
11. As an engineer restarting the window manager in place, I want isolation to survive reload and restart, so that layout sessions are preserved.
12. As an engineer with a headless spawn (timer, service, no launcher window), I want fallback to urgency-on-current without focus steal, so that ownerless windows are visible but not disruptive.

## Implementation Decisions

- Declarative focus safety net: disable mouse-follows-focus and mouse warping globally; background activations mark urgency and never steal focus.
- New focus-guard daemon subscribed to new-window events as the single origin-tracking seam; autostarted by the window manager session.
- Origin resolution: read the new window owner identifier, walk the OS process ancestry to the nearest ancestor that owns a visible window, use that ancestor workspace as origin; move the new window there and restore prior focus.
- Fallback when no windowed ancestor exists: leave placement, apply urgency only, never steal focus.
- Known single-process browser limitation: new-window requests reuse the existing browser process identifier, hiding true launcher origin; handled as urgency-only, with optional isolated-profile follow-up deferred.
- Known empty-workspace exception: the window manager focuses the first window on a workspace by design; accepted, not worked around.
- Existing automation pinning to the reserved background workspace is out of touch; no changes to its assign and no-focus pairing.

## Testing Decisions

- Good tests assert externally observable behavior only: focused workspace number, focused window identity, window workspace assignment, urgency flag — never daemon internals or config text.
- Modules under test: focus safety-net behavior and daemon move-back behavior; declarative config is verified by reload plus live repro, not unit tests.
- Prior art: none in repo; manual repro is the baseline — cross-workspace opener test and single-process browser new-window test, plus empty-workspace first-window case and ownerless-spawn fallback case.
- Class verification uses the window property query tool clicking the offending window; regex coverage is validated against pasted class strings, not guessed.

## Out of Scope

- Per-application pinning of everyday browsers to a hidden workspace.
- Fully silent mode with no urgency badge.
- Automatic focus for self-launched windows via startup-notification heuristics.
- True OS-level isolation (containers, VMs, nested servers) or switching window managers.
- Chrome profile isolation via separate data directories beyond documenting the quirk.
- Touchpad-specific focus tuning beyond the global mouse settings.

## Further Notes

- Vocabulary per session, no glossary file in repo yet: workspace means numbered i3 workspace on one monitor; focus-steal means new window takes keyboard focus; urgency-hint means bar highlight without focus; pin means force to fixed workspace (rejected for general apps); origin means launcher window workspace.
- Repro commands from session: cross-workspace URL opener while switched away, and single-process browser new-window with isolated data dir — both must end unfocused on origin or fallback urgency, never stealing.
- Seams: one new daemon seam plus existing IPC, owner-identifier, and process-ancestry seams; confirmed as single-seam preference in grilling Q12.

## Comments
