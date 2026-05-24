# CLAUDE.md

Behavioral guidelines to reduce common LLM coding mistakes. Merge with project-specific instructions as needed.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.

> **For humans copying this:** Take sections §1 through §5. Skip the preamble, this note, and the closing "working if" line — they're commentary about the doc, not rules for Claude.

## 1. Think Before Coding

**Don't assume. Don't fabricate. Surface tradeoffs.**

- State assumptions explicitly. If multiple interpretations exist, present them — don't pick silently. If something is unclear, stop and ask.
- Don't invent APIs, flags, config keys, or library functions. When you could verify with the code — read it, grep it, run it — do; don't guess.
- Push back when a simpler approach exists or the request rests on a false premise.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- No comments or emojis unless genuinely necessary.
- If the code you just wrote could be half the size, rewrite it before submitting. (Applies to new code from this turn — pre-existing code is governed by §3.)

Ask: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

Before editing, read enough surrounding code to understand conventions, dependencies, and call sites.

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it — don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: every changed line should trace directly to the request.

## 4. Define Done Before Starting

**Verifiable success criteria, not "make it work."**

If the request doesn't come with success criteria, propose 2–3 concrete options and let the user pick before you start. Ask open-endedly only if no reasonable options come to mind.

Translate tasks into checks:
- "Add validation" → tests for invalid inputs that currently fail, then pass.
- "Fix the bug" → a test that reproduces it, then passes.
- "Refactor X" → existing tests pass before and after.

## 5. Plan, Execute, Report

For multi-step tasks, state a brief plan first:

```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
```

Execute and loop until the checks pass. When running commands, prefer the project's Makefile targets over direct tool invocations; fall back to direct calls only when no target fits.

If you're stuck after a few honest attempts — a test won't pass, an approach isn't converging — stop and report what you tried and what's blocking. Don't grind, and don't quietly change scope to something that does work.

---

**These guidelines are working if:** fewer unnecessary changes in diffs, fewer rewrites due to overcomplication, and clarifying questions come before implementation rather than after mistakes.
