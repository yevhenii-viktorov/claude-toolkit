# Workflow: Review Output

Review and refine previously generated planning artifacts.

<preconditions>
- .planning/ exists with at least BRIEF.md or PLAN files
- User selected "revisit/refine" from intake or explicitly requested review
</preconditions>

<process>

<step name="load_artifacts">
Read all existing planning artifacts:
1. .planning/BRIEF.md (if exists)
2. .planning/ROADMAP.md (if exists)
3. All .planning/phases/*/PLAN.md files
4. Any SUMMARY.md files (completed phases)

Note: Do NOT read DISCOVERY-SESSION.md -- that's for resume, not review.
</step>

<step name="present_overview">
Present the current state:

"Here's what we have:

**Project**: [name from BRIEF]
**Phases**: [N] planned, [M] completed
**Plans**: [P] total

[If BRIEF exists:]
**Vision**: [one-liner from BRIEF]
**Success criteria**: [list from BRIEF]

[If ROADMAP exists:]
**Phase progress**:
[Progress table from ROADMAP]

What would you like to refine?
A) Project vision / problem statement (BRIEF)
B) Feature priorities / scope
C) Phase breakdown / ordering
D) Specific phase tasks (which phase?)
E) Add a new feature"
</step>

<step name="refine">
Based on user selection:

**A) Vision/problem (BRIEF):**
- Show current BRIEF content
- Ask: "What needs changing?"
  A) Problem statement
  B) Success criteria
  C) Constraints
  D) Out of scope
- Re-enter conversational flow for the selected section
- Update BRIEF.md in place

**B) Feature priorities (BRIEF + ROADMAP):**
- Show current must-have list and phase structure
- Re-enter scope stage from question-patterns.md
- Ask priority adjustment questions
- Update BRIEF (if scope changed) and ROADMAP

**C) Phase breakdown (ROADMAP):**
- Show current phases with dependencies
- Ask: "What needs adjusting?"
  A) Merge phases [which ones?]
  B) Split a phase [which one?]
  C) Reorder phases
  D) Add a phase
  E) Remove a phase
- Update ROADMAP.md
- Regenerate affected PLANs if task structure changed

**D) Phase tasks (specific PLAN):**
- Ask which phase to review
- Show tasks for that phase
- Ask: "What needs changing?"
  A) Add a task
  B) Remove a task
  C) Change task implementation details
  D) Split this plan into multiple plans
- Update the specific PLAN.md file(s)

**E) Add new feature:**
- Switch to workflows/focused.md with existing context
- This adds a new phase to the ROADMAP
</step>

<step name="confirm_changes">
After any refinement:

"Updated:
- [list of files modified]

Changes:
- [summary of what changed]

Anything else to refine?
A) Yes, [select another area]
B) No, looks good"

If yes: loop back to present_overview or directly to the selected area.
If no: done.
</step>

</process>

<success_criteria>
Review is successful when:
- [ ] User saw clear overview of current state
- [ ] Selected area was refined through conversation (not just edited)
- [ ] Artifacts updated in place without breaking structure
- [ ] PLANs remain valid XML structure after changes
- [ ] ROADMAP dependencies remain consistent
</success_criteria>
