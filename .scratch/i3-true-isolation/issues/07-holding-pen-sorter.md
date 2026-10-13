# 07: Holding-pen sorter (workspace 20)

**What was built:** Manager diverts every birth to workspace 20 pre-map
(`for_window [all] move to workspace number 20`); the daemon sorts each
arrival exactly once (origin / viewed / ws10 rescue / first window),
unfocused with an urgency badge. Staging kept as fallback for births found
outside the pen. Inbox drain on every resubscribe recovers i3-restart dumps
(restart re-applies the rule) and daemon-restart backlogs.

**Blocked by:** 01, 02, 04 (diversion proof, verdict, fallback evaluation).

**Status:** resolved

- [x] Background births never tile the focused workspace, not even a frame
- [x] Foreground births land tiled on the invocation workspace, unfocused + badged
- [x] Reload safe; restart dumps drained by origin; automation rescued to ws10
- [x] Proven in Xvfb scratch session (hold / safety / sorter suites green)

## Comments
Root cause of the ws1->ws2 misdelivery: `workspace_auto_back_and_forth`
resolves `move to`/`workspace` targets naming the viewed workspace to the
previous workspace. The sorter never names the viewed workspace
(`scratchpad show` instead). ws20 is reserved; never keep windows there.
