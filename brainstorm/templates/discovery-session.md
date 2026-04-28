# Discovery Session State Template

Write this to `.planning/DISCOVERY-SESSION.md` at the start of discovery.
Update after each stage. Delete after artifact generation completes.

```markdown
# Discovery Session

**Mode**: [focused / comprehensive]
**Started**: [YYYY-MM-DD]
**Current Stage**: [explore / analyze / scope / plan / generate]
**Topic**: [user's initial topic or idea]

## Explore

- **What**: [one-sentence description of the idea]
- **Problem**: [what problem it solves]
- **Audience**: [who has this problem]
- **Current state**: [greenfield / brownfield / competitor exists]
- **Core value**: [the ONE thing it must do]
- **Constraints**: [hard constraints listed]

## Analyze (Lens Observations)

- **Architecture**: [observation or "not applied"]
- **Security**: [observation or "not applied"]
- **UX/DX**: [observation or "not applied"]
- **Data**: [observation or "not applied"]
- **Operations**: [observation or "not applied"]

## Scope

- **Must-have (v1)**: [numbered list]
- **Nice-to-have (v1.1+)**: [numbered list]
- **Out of scope**: [list]
- **Proposed phases**: [list with dependencies]

## Plan

- **Phase breakdown**: [phases with task counts]
- **File structure**: [key files/directories identified]
- **Verification approach**: [how to test]

## Open Questions

- [any unresolved questions]
```

**Usage rules:**
- Create at session start, update incrementally
- Only fill sections as stages complete (leave others blank)
- For focused mode: skip Explore section, start at Scope
- Delete immediately after GENERATE stage completes
- If session is interrupted, this file enables resume
