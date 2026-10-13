# 03: Dialog stay-put via unanimous-family origin

**What to build:** Dialogs stay on the workspace of their parent window; a dialog whose process family visibly lives on exactly one workspace stays there without consulting ancestry, so pid reuse cannot exile it.

**Blocked by:** 01 (Tiled delivery for every arrival).

**Status:** resolved

- [ ] File picker opened from a browser stays on the parent's workspace next to its parent
- [ ] Single-process dialog with family on exactly one workspace stays there; multi-workspace or windowless families fall back to ancestry or urgency-only
- [ ] Focus never leaves the user's workspace; arrival is findable via urgency-hint only

## Comments
Resolved on integration branch spec/i3-true-isolation.
