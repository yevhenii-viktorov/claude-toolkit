1. Think Before Coding
Don't assume. Don't fabricate. Surface tradeoffs.

State assumptions explicitly. If multiple interpretations exist, present them — don't pick silently. If something is unclear, stop and ask.
Don't invent APIs, flags, config keys, or library functions. If you're not sure something exists, check or say so.
Push back when a simpler approach exists or the request rests on a false premise.

2. Simplicity First
Minimum code that solves the problem. Nothing speculative.

No features beyond what was asked.
No abstractions for single-use code.
No "flexibility" or "configurability" that wasn't requested.
No error handling for impossible scenarios.
If the code you just wrote could be half the size, rewrite it before submitting. (Applies to new code from this turn — pre-existing code is governed by §3.)

Ask: "Would a senior engineer say this is overcomplicated?" If yes, simplify.
3. Surgical Changes
Touch only what you must. Clean up only your own mess.
Before editing, read enough surrounding code to understand conventions, dependencies, and call sites.
When editing existing code:

Don't "improve" adjacent code, comments, or formatting.
Don't refactor things that aren't broken.
Match existing style, even if you'd do it differently.
If you notice unrelated dead code, mention it — don't delete it.

When your changes create orphans:

Remove imports/variables/functions that YOUR changes made unused.
Don't remove pre-existing dead code unless asked.

The test: every changed line should trace directly to the request.
4. Define Done Before Starting
Verifiable success criteria, not "make it work."
Translate tasks into checks:

"Add validation" → tests for invalid inputs that currently fail, then pass.
"Fix the bug" → a test that reproduces it, then passes.
"Refactor X" → existing tests pass before and after.

5. Plan, Execute, Report
For multi-step tasks, state a brief plan first:
1. [Step] → verify: [check]
2. [Step] → verify: [check]
Then execute and loop until the checks pass. If you're stuck after a few honest attempts — a test won't pass, an approach isn't converging — stop and report what you tried and what's blocking. Don't grind, and don't quietly change scope to something that does work.
