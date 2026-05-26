# PLAN Template (Discovery-Populated)

Use this when generating `.planning/phases/XX-name/XX-YY-PLAN.md` from discovery session.

## Field Mapping

| PLAN Section | Source |
|--------------|--------|
| objective | ROADMAP phase goal + lens observations |
| context | BRIEF, ROADMAP + relevant source files from codebase scan |
| tasks | Plan stage task breakdown, verified with user |
| verification | Derived from lens observations (build commands, test commands) |
| success_criteria | Phase goal made measurable |

## Template

```markdown
---
phase: XX-name
type: execute
---

<objective>
[From ROADMAP phase goal: what this phase accomplishes]

Purpose: [Why this matters -- from Explore problem statement + Scope priorities]
Output: [What artifacts will be created -- specific files]
</objective>

<context>
@.planning/BRIEF.md
@.planning/ROADMAP.md
[If prior phase exists:]
@.planning/phases/[prev]/[prev]-SUMMARY.md
[Relevant source files from codebase scan:]
@src/path/to/relevant.ext
</context>

<tasks>

<task type="auto">
  <name>Task 1: [Action-oriented name]</name>
  <files>[exact file paths to create or modify]</files>
  <action>
    [Specific implementation instructions derived from Analyze stage.
    Include what to do AND what to avoid and WHY.
    Reference architectural decisions from lens observations.]
  </action>
  <verify>[Concrete command: build, test, lint, or specific check]</verify>
  <done>[Measurable: "X exists and passes Y" not "it works"]</done>
</task>

<task type="auto">
  <name>Task 2: [Action-oriented name]</name>
  <files>[exact file paths]</files>
  <action>[Specific implementation]</action>
  <verify>[Concrete command or check]</verify>
  <done>[Measurable criteria]</done>
</task>

[If UX lens was active and this phase has user-facing output:]
<task type="checkpoint:human-verify" gate="blocking">
  <what-built>[What was just built that needs visual/functional check]</what-built>
  <how-to-verify>
    1. Run: [dev server command]
    2. Visit: [URL or path]
    3. Test: [specific interactions]
    4. Confirm: [expected behaviors]
  </how-to-verify>
  <resume-signal>Type "approved" or describe issues</resume-signal>
</task>

</tasks>

<verification>
Before declaring phase complete:
- [ ] [Build/compile command passes]
- [ ] [Test command passes]
- [ ] [Lint/type check passes]
- [ ] [Phase-specific behavioral check]
</verification>

<success_criteria>
- All tasks completed and verified
- [Phase-specific measurable criteria from ROADMAP goal]
</success_criteria>

<output>
After completion, create `.planning/phases/XX-name/XX-YY-SUMMARY.md`:

**[Substantive one-liner -- what shipped, NOT "phase complete"]**

## Accomplishments
- [Key outcome 1]
- [Key outcome 2]

## Files Created/Modified
- `path/to/file` - Description

## Decisions Made
[Rationale for key choices, or "None"]

## Issues Encountered
[Problems and resolutions, or "None"]

## Next Step
[Next plan or next phase]
</output>
```

## Rules

- Max 3 tasks per plan. Split into XX-01, XX-02, etc. if more needed
- Split by: subsystem, dependency chain, or complexity
- `<action>` must be specific enough for autonomous agent execution
- `<verify>` must be a runnable command, not "check that it works"
- `<done>` must be objectively measurable
- Include checkpoint:human-verify after any UI/visual/interactive work
- Include checkpoint:decision only when implementation direction is truly ambiguous
- @context references must point to real files (verify during generation)
- SUMMARY template is included so executing agents know the expected output format
