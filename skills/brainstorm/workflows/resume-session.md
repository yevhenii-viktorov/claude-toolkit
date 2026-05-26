# Workflow: Resume Session

Resume an interrupted discovery session from saved state.

<preconditions>
- .planning/DISCOVERY-SESSION.md exists (session was interrupted)
- User selected "Resume" from intake
</preconditions>

<process>

<step name="load_state">
Read .planning/DISCOVERY-SESSION.md.

Extract:
- Mode (focused / comprehensive)
- Current stage (explore / analyze / scope / plan / generate)
- All answers collected so far
- Lens observations accumulated
- Open questions remaining
</step>

<step name="present_summary">
Present where the session left off:

"Found an interrupted [mode] discovery session.

**Topic**: [from session state]
**Progress**: Completed [stages completed], currently in [current stage]

**What we know so far:**
[Summarize key answers: 3-5 bullet points from completed stages]

**Where we left off:**
[Current stage name] stage, [N] questions remaining

What would you like to do?
A) Continue from where we left off
B) Go back to [previous stage] and revise
C) Start over (this will delete the session)"
</step>

<step name="route">
Based on user response:

**A) Continue:**
- Load the appropriate workflow (focused.md or comprehensive.md)
- Skip completed stages
- Resume at the current stage, next unanswered question
- Carry forward all previous answers and observations

**B) Go back:**
- Load the appropriate workflow
- Reset the selected stage (clear its answers in session state)
- Resume from the beginning of that stage
- Keep earlier stage answers intact

**C) Start over:**
- Delete .planning/DISCOVERY-SESSION.md
- Route back to SKILL.md intake
</step>

</process>

<success_criteria>
Resume is successful when:
- [ ] Session state loaded without loss
- [ ] User saw clear summary of progress
- [ ] Session continued seamlessly from interruption point
- [ ] No questions were unnecessarily repeated
</success_criteria>
