# Workflow: Focused Discovery

Single feature or component discovery. Produces a PLAN (and optionally extends
an existing ROADMAP with a new phase).

<required_reading>
**Read these reference files NOW:**
1. references/lens-system.md
2. references/question-patterns.md (scope + analyze + plan stages)
3. references/plan-generation.md
</required_reading>

<preconditions>
- User selected focused mode (single feature, component, or enhancement)
- Context scan already completed (project type, .planning/ status known)
- If .planning/ exists: read BRIEF.md and ROADMAP.md for context
- If codebase exists: note project type, key directories, existing patterns
</preconditions>

<process>

<stage name="scope" questions="3-5">
**Purpose**: Understand what the user wants to build and its boundaries.

Start session state: Create .planning/DISCOVERY-SESSION.md from
templates/discovery-session.md with mode=focused.

**Question flow (one at a time, wait for each response):**

Q1 (always): "In one sentence, what do you want to build or add?"
- Free text response
- Record in session state under Scope

Q2 (always): "Who is this for?"
- A) End users of the product
- B) Developers using an API/tool
- C) Internal/admin users
- D) Infrastructure (no direct users)

Q3 (always, adapt based on context):
- If codebase exists: "Where does this fit in the existing codebase?"
  A) New route/page/component
  B) Extends existing [detected area]
  C) Replaces existing functionality
  D) Cross-cutting (touches multiple areas)
- If greenfield: "How big is this?"
  A) Small (1-2 files)
  B) Medium (3-6 files)
  C) Large (7+ files) -- consider switching to comprehensive mode

Q4-5 (if needed): Clarify constraints or dependencies based on Q1-Q3.

**Validation checkpoint:**
Present 150-200 word summary:
"Here's what I understand:
**Feature**: [from Q1]
**For**: [from Q2]
**Fits**: [from Q3]
[Any constraints from Q4-5]

Does this capture it?
A) Yes, continue
B) Adjust [something]
C) This is actually bigger -- let's do comprehensive mode"

If user selects C: switch to workflows/comprehensive.md, carrying over answers.
Update session state after validation.
</stage>

<stage name="shape" questions="2-5">
**Purpose**: Apply 1-2 lenses to determine the design shape.

**Lens selection** (auto-select based on scope answers):
- User-facing feature → UX lens + Architecture lens
- Data/backend feature → Data lens + Architecture lens
- Security-related → Security lens + one other
- Infrastructure → Operations lens + Architecture lens

**For each selected lens (max 2):**
1. Ask ONE targeted question from lens-system.md
2. Wait for response
3. Provide 2-3 sentence observation linking answer to plan implications

**If existing codebase**: Also identify:
- Specific files to create or modify
- Existing patterns to follow
- Components that need updating

**Validation checkpoint:**
Present 200-word design summary:
"Here's the design:
**Approach**: [architecture/structure choice]
**Key components**: [what needs building]
**Files**: [specific files to create/modify]
[Lens observation 1]
[Lens observation 2]

Does this look right?
A) Yes, let's plan the tasks
B) Revisit [aspect]
C) Different approach"

Update session state with lens observations.
</stage>

<stage name="plan" questions="1-2">
**Purpose**: Present task breakdown for user validation before generating.

Based on scope + shape, propose 1-3 tasks:

"Here's how I'd break this down:

**Task 1**: [name] ([files])
  - [what it does in 1-2 sentences]
**Task 2**: [name] ([files])
  - [what it does]
[**Task 3**: if needed]

[If UX lens was active:]
+ Human verification checkpoint after implementation

Does this task breakdown make sense?
A) Yes, generate the plan
B) Adjust [specific task]
C) Split differently
D) Add a task I'm missing"

If more than 3 tasks needed:
"This needs [N] tasks. I'll split into [M] plans:
- Plan 1: [tasks 1-3]
- Plan 2: [tasks 4-N]
Sound good?"

Update session state with task breakdown.
</stage>

<stage name="generate">
**Purpose**: Write the planning artifacts.

**If .planning/ exists with ROADMAP:**
1. Add new phase entry to ROADMAP.md
2. Create phase directory: .planning/phases/XX-name/
3. Generate PLAN(s): XX-YY-PLAN.md using templates/plan.md
4. Update ROADMAP progress table

**If no .planning/ exists:**
1. Create .planning/ directory
2. Generate minimal BRIEF.md using templates/brief.md
   (focused mode: brief can be very minimal -- just the feature context)
3. Generate PLAN.md in .planning/phases/01-name/01-01-PLAN.md
4. Skip full ROADMAP (single feature doesn't need it)

**For each PLAN.md:**
- Fill from templates/plan.md
- `<objective>`: from scope answers
- `<context>`: @BRIEF + @ROADMAP (if exists) + @source files from shape stage
- `<tasks>`: from plan stage breakdown, with:
  - `<action>`: specific implementation from shape stage lens observations
  - `<verify>`: concrete command from project type detection
  - `<done>`: measurable criteria from scope answers
- `<verification>`: build/test commands for the project type
- `<success_criteria>`: from scope validation summary

**Cleanup:**
- Delete .planning/DISCOVERY-SESSION.md
- Git commit if repo: "docs: plan [feature name] via brainstorm"

**Present results:**
"Plan generated:
- [list files created/updated]

To execute: run /run-plan [path to first plan]
To review: run /brainstorm review"
</stage>

</process>

<success_criteria>
Focused discovery is complete when:
- [ ] 5-10 questions asked, one at a time
- [ ] 1-2 lenses applied with observations
- [ ] User validated scope and design shape
- [ ] PLAN.md generated with max 3 tasks, specific files/actions/verification
- [ ] Session state cleaned up
</success_criteria>
