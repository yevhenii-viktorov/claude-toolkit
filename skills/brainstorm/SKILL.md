---
name: brainstorm
description: "Transform ambiguous ideas into executable plans through conversational discovery. One question at a time, multiple choice preferred, with multi-angle analysis via lightweight lenses. Full pipeline: idea to BRIEF + ROADMAP + executable PLANs. Use when brainstorming features, exploring requirements, validating designs, or starting new projects."
---

<objective>
Turn ideas into agent-executable plans through natural collaborative dialogue.

This skill runs the full pipeline: from a rough idea through requirements discovery
to concrete, executable planning artifacts (.planning/BRIEF.md, ROADMAP.md, and
PLAN.md files with XML task structure). No separate planning step needed.

Two modes:
- **Focused**: Single feature or component (5-10 questions, produces PLAN)
- **Comprehensive**: Full project (15-25 questions, produces BRIEF + ROADMAP + PLANs)
</objective>

<essential_principles>

<principle name="conversation_first">
One question at a time. Multiple choice preferred (3-5 options). Never dump a
questionnaire. Validate incrementally in 200-300 word summaries. The user should
feel like a conversation, not a form.
</principle>

<principle name="lenses_not_personas">
Check designs from multiple angles using lightweight "lenses" -- not full persona
simulations. A lens is a targeted question producing a 2-3 sentence observation
that feeds into planning artifacts.

Five lenses: Architecture, Security, UX/DX, Data, Operations.
Activate when relevant, not exhaustively. Max 4 in comprehensive, 2 in focused.

See: references/lens-system.md
</principle>

<principle name="full_pipeline">
The final output is NOT a brainstorming document or requirements spec. It IS
executable planning artifacts:
- BRIEF.md: Project vision (under 50 lines)
- ROADMAP.md: Phase structure with progress tracking
- PLAN.md files: XML-structured tasks with verification criteria

Every question asked should contribute to producing better plans.
</principle>

<principle name="yagni_guard">
Resist scope expansion. Every feature proposed must pass: "Do we need this for v1?"
If ambiguous, it goes to Out of Scope in the BRIEF. Discovery finds the MINIMAL
viable shape, not the maximal feature set.
</principle>

<principle name="two_modes">
- Focused: 5-10 questions, single feature/component. Produces PLAN (or extends
  existing ROADMAP with new phase + plan).
- Comprehensive: 15-25 questions across 5 stages. Produces BRIEF + ROADMAP + PLANs.

If no mode specified, infer from scope. Single feature = focused.
New project or multi-component = comprehensive.
</principle>

<principle name="no_external_dependencies">
Self-contained. No MCP servers required. Uses only native Claude Code tools:
Read, Write, Bash (read-only during discovery), WebSearch (if research needed),
TodoWrite (progress tracking), AskUserQuestion (dialogue).
</principle>

</essential_principles>

<context_scan>
Run on EVERY invocation before intake:

1. Check for .planning/ directory and existing artifacts (BRIEF, ROADMAP, PLANs)
2. Check if current directory is a git repo
3. Detect project type from codebase (package.json, go.mod, Cargo.toml, etc.)
4. Note existing file structure for plan file path suggestions

Present relevant findings before intake. This determines fresh start vs extension.
</context_scan>

<intake>
Context-aware entry point:

**If .planning/ exists with artifacts:**
"Found existing project: [name from BRIEF]

What would you like to do?
1. Add a new feature (extends roadmap with new phase + plan)
2. Revisit/refine an existing phase
3. Start a fresh project (new .planning/)
4. Resume interrupted session"

**If no .planning/ exists:**
"What would you like to explore?

1. New project idea (comprehensive discovery)
2. Single feature or component (focused discovery)
3. I have a rough idea, help me shape it"

**Wait for response before proceeding.**

If the user provided a topic with the command (e.g., /brainstorm "recipe app"),
use it as context but still present intake options to determine mode.
</intake>

<routing>
| Response | Mode | Workflow |
|----------|------|----------|
| "new project", "comprehensive", 1 (no .planning/) | comprehensive | workflows/comprehensive.md |
| "feature", "focused", "single", 2 (no .planning/) | focused | workflows/focused.md |
| "rough idea", "shape", 3 | auto-detect | Start with 2-3 questions, then route |
| "add feature", 1 (has .planning/) | focused | workflows/focused.md (with existing context) |
| "revisit", "refine", 2 (has .planning/) | review | workflows/review-output.md |
| "fresh", "start over", 3 (has .planning/) | comprehensive | workflows/comprehensive.md |
| "resume", 4 (has .planning/) | resume | workflows/resume-session.md |

After reading the selected workflow, follow it exactly.
</routing>

<lens_quick_reference>
Five lenses, applied contextually (not exhaustively):

| Lens | Activate When | Plan Impact |
|------|---------------|-------------|
| Architecture | Multi-component, integrations, deployment decisions | Phase boundaries, dependency order |
| Security | Auth, user data, external APIs, financial data | Security tasks, verification criteria |
| UX/DX | User-facing features, APIs, developer tools | checkpoint:human-verify tasks |
| Data | Persistence, state, sync, schemas, migration | Data model tasks, phase ordering |
| Operations | Deployment, monitoring, scaling, CI/CD | Deployment phase, infra tasks |

Full definitions: references/lens-system.md
</lens_quick_reference>

<plan_format>
Inline reference for XML task structure (so workflows don't need external deps):

```xml
---
phase: XX-name
type: execute
---

<objective>
[What and why]
Purpose: [Why this matters]
Output: [What artifacts]
</objective>

<context>
@.planning/BRIEF.md
@.planning/ROADMAP.md
@relevant/source/files.ext
</context>

<tasks>
<task type="auto">
  <name>Task N: [Action-oriented name]</name>
  <files>[exact file paths]</files>
  <action>[Specific what-to-do. Include what-to-avoid and WHY.]</action>
  <verify>[Command or check to prove completion]</verify>
  <done>[Measurable acceptance criteria]</done>
</task>

<task type="checkpoint:human-verify" gate="blocking">
  <what-built>[What was just built]</what-built>
  <how-to-verify>
    1. [Step 1]
    2. [Step 2]
  </how-to-verify>
  <resume-signal>Type "approved" or describe issues</resume-signal>
</task>

<task type="checkpoint:decision" gate="blocking">
  <decision>[What needs deciding]</decision>
  <context>[Why this matters]</context>
  <options>
    <option id="a"><name>[Name]</name><pros>[Benefits]</pros><cons>[Tradeoffs]</cons></option>
    <option id="b"><name>[Name]</name><pros>[Benefits]</pros><cons>[Tradeoffs]</cons></option>
  </options>
  <resume-signal>Select: a or b</resume-signal>
</task>
</tasks>

<verification>
- [ ] [Specific test/build commands]
</verification>

<success_criteria>
- [Measurable completion criteria]
</success_criteria>

<output>
After completion, create SUMMARY.md with: one-liner, accomplishments, files, decisions, issues
</output>
```

Rules:
- Max 3 tasks per plan. If more needed, split into multiple plans (XX-01-PLAN.md, XX-02-PLAN.md)
- `<action>` must be specific enough that an agent can execute without clarifying questions
- `<verify>` must be a concrete command or check, not "it works"
- `<done>` must be measurable, not subjective
- Use checkpoint:human-verify after UI/visual work
- Use checkpoint:decision when implementation direction is ambiguous

See: references/plan-generation.md for detailed guidance.
</plan_format>

<session_state>
Discovery sessions are stateful. Track progress in .planning/DISCOVERY-SESSION.md
(temporary file, deleted after artifacts are generated).

Session state includes: current mode, current stage, answers collected, lens
observations, decisions made, open questions remaining.

Template: templates/discovery-session.md
</session_state>

<workflows_index>
| Workflow | Purpose | Mode |
|----------|---------|------|
| focused.md | Single feature discovery + planning | Focused |
| comprehensive.md | Full project discovery + planning | Comprehensive |
| resume-session.md | Resume interrupted session | Either |
| review-output.md | Refine generated artifacts | Either |
</workflows_index>

<references_index>
| Reference | Purpose |
|-----------|---------|
| lens-system.md | 5 lens definitions, activation rules, question templates |
| question-patterns.md | Question templates by stage, MCQ vs free text guidance |
| plan-generation.md | Deriving executable tasks from discovery answers |
| anti-patterns.md | Common brainstorming mistakes to avoid |
</references_index>

<templates_index>
| Template | Purpose |
|----------|---------|
| discovery-session.md | Session state tracking (temporary) |
| brief.md | BRIEF template with discovery fill rules |
| roadmap.md | ROADMAP template with lens-driven phases |
| plan.md | Executable PLAN template with XML task structure |
</templates_index>

<success_criteria>
Discovery succeeds when:
- User engaged in conversation (not interrogation)
- Multiple choice offered when possible
- Incremental validation happened (200-300 word summaries)
- At least 2 lenses were applied
- YAGNI guard prevented scope creep
- Output is executable: BRIEF + ROADMAP + PLANs with XML task structure
- Plans have max 3 tasks each with specific files, actions, verification
- User knows what to do next (run the first plan)
</success_criteria>
