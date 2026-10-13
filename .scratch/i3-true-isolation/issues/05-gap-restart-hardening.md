# 05: Gap and restart hardening

**What to build:** Rapid and missed births still land correctly, automation pins stay rescued on the reserved workspace, and restarts never disturb pre-existing layout.

**Blocked by:** 01 (Tiled delivery for every arrival), 03 (Dialog stay-put via unanimous-family origin).

**Status:** resolved

- [ ] Two windows born half a second apart are both staged and delivered to the right workspaces with no lost birth
- [ ] A birth missed live is still moved, refocused, and badged on the next reconciliation cycle
- [ ] Guard restart leaves pre-existing windows alone; manager reload and restart preserve isolation; automation pins stay on the reserved workspace
- [ ] Typing focus and keystrokes never leak into background arrivals; hover never steals focus

## Comments
Resolved on integration branch spec/i3-true-isolation.
