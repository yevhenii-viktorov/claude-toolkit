# Workflow: Comprehensive Discovery

Full project discovery from idea to executable plans. Produces BRIEF + ROADMAP
+ PLANs for all phases.

<required_reading>
**Read these reference files NOW:**
1. references/lens-system.md
2. references/question-patterns.md (all stages)
3. references/plan-generation.md
4. references/anti-patterns.md
</required_reading>

<preconditions>
- User selected comprehensive mode (new project or multi-component idea)
- Context scan already completed
- If codebase exists: note project type, structure, existing patterns
- Topic may have been provided with the command
</preconditions>

<process>

<stage name="explore" questions="5-8">
**Purpose**: Understand the vision, problem space, audience, and constraints.
This is the most conversational stage. One question at a time. Build on answers.

Start session state: Create .planning/DISCOVERY-SESSION.md from
templates/discovery-session.md with mode=comprehensive.

**Question flow (follow question-patterns.md explore stage):**

Q1: "Tell me about your idea. What do you want to build?"
- Free text. If topic was provided: "You mentioned [topic]. Tell me more."

Q2: "What problem does this solve? Why does it need to exist?"
- Free text. If vague, follow up: "Give me a specific scenario."

Q3: "Who has this problem?"
- MCQ: You personally / Specific users / Developers / General public / Internal

Q4: "What exists today? How is this problem solved now?"
- MCQ: Nothing / Manual workaround / Competitors / Existing codebase / Combo

Q5: "If this could only do ONE thing, what would it be?"
- Free text. Push for specificity if broad.

Q6: "Any hard constraints?"
- MCQ (multi-select): Tech stack / Platform / Integration / Regulatory / None

Q7-8 (contextual, 0-2 questions based on gaps):
- Existing codebase → "What's the current architecture?"
- Competitors → "What would make yours different?"
- Vague core value → "Walk me through the ideal experience step by step."

**Validation checkpoint (200 words):**
"Here's what I understand:

**Building**: [name/concept]
**Problem**: [one sentence]
**For**: [audience]
**Core value**: [the ONE thing]
**Current state**: [greenfield/brownfield/competitive]
**Constraints**: [listed]

Does this capture it?
A) Yes, continue
B) Mostly, but [adjust]
C) No, let me restate"

Update session state with all Explore answers.
</stage>

<stage name="analyze" questions="4-8">
**Purpose**: Apply 3-4 lenses to shape the design. Go deep enough to determine
architecture, data model, component boundaries, and file structure.

**Lens selection** (comprehensive mode always includes Architecture + 2-3 more):
- Check lens activation rules in lens-system.md
- Typically: Architecture + Data + UX + Security (for web apps)
- Or: Architecture + Data + Security + Operations (for backend/API)
- Or: Architecture + UX + Operations (for CLI/tools)

**For each lens (1-2 questions each):**

Ask the primary question from lens-system.md for that lens.
Wait for response.
Provide 2-3 sentence observation in the format:
"[Lens]: [choice]. [Implication]. For the plan: [how this shapes phases/tasks]."

If the answer to a lens question is obvious from previous answers, state the
observation directly and ask if they agree instead of asking the full question:
"Based on what you've described, this sounds like a client+API architecture
with React and a Node backend. Sound right?
A) Yes, exactly
B) Close, but [adjust]
C) Actually, something different"

**Between lenses**, connect observations:
"Since you chose [arch answer] and need [data answer], the backend will need
[specific component]. Combined with [security answer], we should set up
auth in the first phase before building features."

**Validation checkpoint (250 words):**
"Here's the design taking shape:

**Architecture**: [choice + rationale]
**Data**: [storage + key entities + flow]
**UX**: [primary pattern + key interaction]
**Security**: [auth + data protection needs]
[Only include applied lenses]

Key observations:
- [How lenses interact]
- [Implication for project structure]
- [Major technical decision and rationale]

Does this direction feel right?
A) Yes, continue to scoping
B) Revisit [specific lens]
C) Changed my mind about [aspect]"

Update session state with all lens observations.
</stage>

<stage name="scope" questions="3-5">
**Purpose**: Define boundaries, priorities, and phasing. YAGNI enforcement.

**Q1 (feature prioritization):**
"Based on everything so far, here are the features I see:

**Must-have (v1):**
1. [derived from core value]
2. [derived from lens observations]
3. [derived from lens observations]

**Nice-to-have (v1.1+):**
4. [feature]
5. [feature]

Is this prioritization right?
A) Yes, exactly
B) Move [N] to must-have
C) Move [N] to nice-to-have
D) Missing something important"

Apply YAGNI guard: if user wants to add features, push back:
"Do we need [feature] for v1 to be useful? Or can it wait for v1.1?"

**Q2 (out of scope):**
"What should we explicitly NOT build?

Suggested out-of-scope:
A) [inference from nice-to-haves]
B) [inference from audience]
C) [common tempting feature]
D) All of the above
E) Add your own"

**Q3 (phasing):**
"Here's how I'd phase this:

Phase 1: [Name] - [goal, from architecture/data lens]
  Depends on: Nothing (foundation)
Phase 2: [Name] - [goal, from scope must-haves]
  Depends on: Phase 1
Phase 3: [Name] - [goal, from scope must-haves]
  Depends on: Phase 1, [maybe 2]
Phase 4: [Name] - [goal, from operations lens]
  Depends on: All above

Does this phasing make sense?
A) Yes
B) Merge [phases]
C) Split [phase]
D) Different order"

**Q4-5 (if ambiguity remains):** Resolve specific questions about
phase content, technology choices, or integration details.

**Validation checkpoint (200 words):**
"Final scope:

**Building**: [name]
**Must-have (v1)**: [numbered list]
**Out of scope**: [list]
**Phases**:
  1. [Name] - [one-line goal]
  2. [Name] - [one-line goal]
  3. [Name] - [one-line goal]
  [4. Name] - [one-line goal]

Ready to build the execution plans?
A) Yes, plan it
B) Adjust something
C) Ask me more questions"

Update session state with scope decisions.
</stage>

<stage name="plan" questions="2-4">
**Purpose**: Present task breakdown per phase for validation before generating.
This ensures the user sees and approves the concrete implementation plan.

**Build task breakdown** from:
- Scope: what features go in each phase
- Analyze: how components connect (determines task order)
- Shape: specific files, patterns, technology choices
- Codebase scan: existing files to modify, patterns to follow

**Present per phase:**
"Here's the task breakdown:

**Phase 1: [Name]** (1 plan, 2 tasks)
- Task 1: [name] → [files]
- Task 2: [name] → [files]

**Phase 2: [Name]** (2 plans, 5 tasks)
Plan 2-1:
- Task 1: [name] → [files]
- Task 2: [name] → [files]
- Task 3: [name] → [files]
Plan 2-2:
- Task 1: [name] → [files]
- Task 2: [name] → [files]
+ checkpoint:human-verify (UI review)

**Phase 3: [Name]** (1 plan, 2 tasks)
- Task 1: [name] → [files]
- Task 2: [name] → [files]

[Phase 4 if applicable]

Total: [N] phases, [M] plans, [P] tasks

Does this make sense?
A) Yes, generate everything
B) Adjust tasks in Phase [N]
C) Merge/split plans
D) Need more detail on [specific task]"

If user asks for more detail, expand specific tasks with:
- Exact implementation approach
- What libraries/patterns to use
- What to avoid and why

**Q2 (verification approach, if unclear):**
"How should we verify each phase?
A) Automated tests (unit + integration)
B) Build check + manual testing
C) Full CI pipeline
D) Combination"

Update session state with complete task breakdown.
</stage>

<stage name="generate">
**Purpose**: Write all planning artifacts.

**Step 1: Create .planning/ directory** (if needed)

**Step 2: Write BRIEF.md**
- Use templates/brief.md
- Fill from Explore + Scope stage answers
- Keep under 50 lines
- Verify success criteria are measurable

**Step 3: Write ROADMAP.md**
- Use templates/roadmap.md
- Phases from Scope stage
- Phase details from Analyze stage lens observations
- Dependencies from architecture analysis
- Progress table initialized

**Step 4: Write PLANs for each phase**
For each phase:
1. Create directory: .planning/phases/XX-name/
2. For each plan in the phase:
   - Generate XX-YY-PLAN.md using templates/plan.md
   - `<objective>`: from ROADMAP phase goal
   - `<context>`: @BRIEF + @ROADMAP + detected source files
   - `<tasks>`: from Plan stage breakdown, with:
     - `<action>`: specific implementation from Analyze + Plan stages
     - `<verify>`: concrete commands from project type
     - `<done>`: measurable criteria
   - `<verification>`: phase-level checks
   - `<success_criteria>`: from ROADMAP phase goal, made measurable
   - Max 3 tasks per plan file

**Step 5: Cleanup**
- Delete .planning/DISCOVERY-SESSION.md
- Git commit if repo: "docs: plan [project name] via brainstorm ([N] phases)"

**Step 6: Present results**
"Discovery complete! Generated:

- .planning/BRIEF.md (project vision)
- .planning/ROADMAP.md ([N] phases)
[For each phase:]
- .planning/phases/XX-name/XX-YY-PLAN.md

Total: [N] phases, [M] plans, [P] tasks
Lenses applied: [list]
Session: [Q] questions, [V] validation checkpoints

**Next steps:**
1. Execute Phase 1: /run-plan .planning/phases/01-name/01-01-PLAN.md
2. Review plans: /brainstorm review
3. Adjust scope: /brainstorm (select 'revisit')"
</stage>

</process>

<success_criteria>
Comprehensive discovery is complete when:
- [ ] 15-25 questions asked across 5 stages, one at a time
- [ ] 3-4 lenses applied with observations
- [ ] 3 validation checkpoints passed (explore, analyze, scope)
- [ ] User approved task breakdown in plan stage
- [ ] BRIEF.md under 50 lines with measurable success criteria
- [ ] ROADMAP.md with 3-6 phases, dependencies, progress table
- [ ] PLANs generated for all phases with XML task structure
- [ ] Each plan has max 3 tasks with specific files/actions/verification
- [ ] Session state cleaned up
</success_criteria>
