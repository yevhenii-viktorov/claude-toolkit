# Question Patterns Reference

<overview>
Question design principles for discovery sessions:

1. **One question at a time** -- never dump multiple questions
2. **Multiple choice preferred** -- reduces cognitive load
3. **3-5 options max** -- more causes decision fatigue
4. **Escape hatch always** -- include "Not sure" or "Something else" option
5. **Free text only** for genuinely open-ended questions (vision, problem statement)
6. **Build on previous answers** -- each question should reference what you learned
</overview>

<stage name="explore">
Used in comprehensive mode. Purpose: understand the idea, problem, audience.

<question name="what" type="free_text" required="true" order="1">
"Tell me about your idea. What do you want to build?"
Note: This is always free text. Let the user describe in their own words.
If they provided a topic with the command, say: "You mentioned [topic]. Tell me
more -- what should this do?"
</question>

<question name="problem" type="free_text" required="true" order="2">
"What problem does this solve? Why does it need to exist?"
Note: Free text. If the answer is vague, follow up: "Can you give me a specific
scenario where someone would use this?"
</question>

<question name="audience" type="mcq" required="true" order="3">
"Who has this problem?"
A) You personally (scratching your own itch)
B) A specific type of user (describe briefly)
C) Developers/technical users
D) General public / consumers
E) Internal team / organization
</question>

<question name="current_state" type="mcq" required="true" order="4">
"What exists today? How is this problem solved now?"
A) Nothing -- completely greenfield
B) Manual workaround exists (spreadsheets, scripts, etc.)
C) Competitors exist but missing something
D) We have an existing codebase to extend
E) Combination (describe)
</question>

<question name="core_value" type="free_text" required="true" order="5">
"If this could only do ONE thing, what would it be?"
Note: Forces minimal viable scope. If the answer is broad ("manage recipes"),
push: "More specific -- what's the single interaction that makes this valuable?"
</question>

<question name="constraints" type="mcq" required="true" order="6">
"Any hard constraints I should know about?"
A) Tech stack is locked (specify)
B) Platform requirement (web, iOS, desktop, etc.)
C) Must integrate with existing system (specify)
D) Regulatory/compliance requirement
E) No constraints yet
Note: Allow multiple selections.
</question>

<question name="follow_up" type="contextual" required="false" order="7-8">
Ask 1-2 follow-ups based on gaps in previous answers:
- If existing codebase: "What's the current architecture? Key technologies?"
- If competitors: "What would make yours different?"
- If constraints: "Any flexibility in [constraint]?"
- If vague core value: "Walk me through the ideal user experience, step by step."
</question>

<validation>
After explore stage, present 200-word summary:

"Here's what I understand so far:

**Building**: [name/concept from Q1]
**Problem**: [from Q2, one sentence]
**For**: [from Q3]
**Core value**: [from Q5, the ONE thing]
**Current state**: [from Q4]
**Constraints**: [from Q6, listed]

Does this capture it?
A) Yes, continue
B) Mostly right, but [let me adjust]
C) No, let me restate"
</validation>
</stage>

<stage name="analyze">
Used in both modes. Purpose: apply lenses to shape the design.
Questions come from references/lens-system.md.

<guidance>
- Select lenses based on explore/scope answers (see lens activation rules)
- Ask ONE question per lens (occasionally two for complex domains)
- After each lens answer, provide 2-3 sentence observation
- Don't announce "Now applying the security lens" -- just ask naturally
- Weave observations together: "Since you chose client+API architecture and
  need user auth, the security layer will sit in the API..."
</guidance>

<validation>
After analyze stage, present design shape summary:

"Here's the design taking shape:

**Architecture**: [choice + rationale]
**Data**: [choice + rationale]
**UX**: [choice + rationale]
**Security**: [choice + rationale]
[Only include lenses that were applied]

Key observations:
- [observation 1 -- how lenses interact]
- [observation 2 -- implication for plan structure]

Does this direction feel right?
A) Yes, continue to scoping
B) Revisit [specific lens]
C) I changed my mind about [aspect]"
</validation>
</stage>

<stage name="scope">
Used in both modes. Purpose: define boundaries and priorities.

<question name="priorities" type="mcq_validation" required="true" order="1">
"Based on everything so far, here are the features I see:

**Must-have (v1):**
1. [feature derived from core value]
2. [feature derived from lens observations]
3. [feature derived from lens observations]

**Nice-to-have (v1.1+):**
4. [feature]
5. [feature]

Is this prioritization right?
A) Yes, exactly
B) Move [N] to must-have
C) Move [N] to nice-to-have
D) Missing something important"
</question>

<question name="out_of_scope" type="mcq" required="true" order="2">
"What should we explicitly NOT build? (Prevents scope creep later)

Suggested out-of-scope:
A) [inference from nice-to-haves]
B) [inference from audience -- features for other audiences]
C) [common feature that's tempting but unnecessary]
D) All of the above
E) Add your own"
</question>

<question name="phasing" type="mcq" required="conditional" order="3">
Only ask if comprehensive mode or multi-component feature.

"How should we phase this?
A) [suggested phasing based on architecture + dependencies]
B) [alternative phasing]
C) Let me suggest my own phasing"
</question>

<validation>
After scope stage:

"Final scope:

**Building**: [name]
**Must-have (v1)**: [list]
**Out of scope**: [list]
**Phases**: [if applicable]
  1. [Phase name] -- [one-line goal]
  2. [Phase name] -- [one-line goal]
  ...

Ready to build the execution plan?
A) Yes, plan it
B) Adjust something first
C) Ask me more questions"
</validation>
</stage>

<stage name="plan">
Used in both modes. Purpose: validate task breakdown before generation.

<question name="task_review" type="mcq_validation" required="true" order="1">
"Here's the task breakdown:

**Phase 1: [Name]**
- Task 1: [name] ([files])
- Task 2: [name] ([files])

**Phase 2: [Name]**
- Task 1: [name] ([files])
- Task 2: [name] ([files])
[...]

Does this make sense?
A) Yes, generate the plans
B) Adjust tasks in Phase [N]
C) Merge/split phases
D) Ask me about specific tasks"
</question>

<question name="verification" type="mcq" required="false" order="2">
Only ask if verification approach is unclear.

"How should we verify each phase works?
A) Run tests (unit + integration)
B) Build/compile check only
C) Manual testing (start app, check UI)
D) Combination (tests + manual check)"
</question>
</stage>
