# 04: Manager birth-diversion fallback

**What to build:** If the hide-reply verdict proves the in-daemon hide loses the map race, hiding moves into a manager rule so staging happens with zero trip time; otherwise no manager change lands and the daemon path stands.

**Blocked by:** 02 (Hide-reply verdict in the diary).

**Status:** resolved

- [ ] Verdict from 02 is evaluated against live births; diversion lands only on proven race loss
- [ ] With diversion (if landed), background births cause zero tiling disturbance on the focused workspace
- [ ] Declarative settings verified by reload plus live repro, with diary correlation unchanged

## Comments
Resolved on integration branch spec/i3-true-isolation.
