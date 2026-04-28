# BRIEF Template (Discovery-Populated)

Use this when generating `.planning/BRIEF.md` from discovery session answers.

## Field Mapping

| BRIEF Section | Source |
|---------------|--------|
| Project name | Explore Q1: extract noun phrase |
| One-liner | Explore Q1: one sentence |
| Problem | Explore Q2 + Q4: problem + current alternatives |
| Success Criteria | Explore Q5 (the ONE thing) + Scope must-haves, made measurable |
| Constraints | Explore Q6: hard constraints |
| Out of Scope | Scope stage: nice-to-haves deferred + explicit exclusions |

## Template

```markdown
# [Project Name]

**One-liner**: [What this is in one sentence]

## Problem

[2-3 sentences from Explore Q2: what problem does this solve]
[1 sentence from Explore Q4: how it's solved today, if applicable]

## Success Criteria

How we know it worked:

- [ ] [From Explore Q5: the ONE thing, made measurable]
- [ ] [From Scope must-have #2, made measurable]
- [ ] [From Scope must-have #3, made measurable]

## Constraints

- [From Explore Q6: constraint 1]
- [From Explore Q6: constraint 2]

## Out of Scope

What we're NOT building:

- [From Scope: nice-to-have deferred to v1.1]
- [From Scope: explicit exclusion]
- [From Scope: explicit exclusion]
```

## Rules

- Keep under 50 lines total
- Success criteria MUST be measurable/verifiable (not "works well" or "is fast")
- Out of scope should include nice-to-haves from Scope stage
- Problem section: 2-3 sentences max, no solution description
- This is the human-focused document -- keep it readable
- For focused mode (single feature): skip BRIEF, extend existing ROADMAP instead
