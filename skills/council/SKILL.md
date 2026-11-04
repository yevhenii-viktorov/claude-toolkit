---
name: council
description: Trigger this if the user says 'council'.
---

# Council

Before an audit, address outstanding PR comments, fix known issues, and run
relevant checks. Give council the updated implementation; do not defer known
fixes until reviews return. If the user wants to discard the implementation
and explore new ideas, skip fixes to code being replaced.

Bring in two delegates to help with the user's request, usually for review
or feedback. Use one strong model from each of two different providers, at
high reasoning effort. If the user's instructions name council members, use
those. Otherwise pick the latest flagship model from each provider, for
example Claude Opus and GPT Sol.

In T3 Code, use `orchestrator_capabilities` to resolve the models, then
`delegate_task` to start one delegate per model in parallel. Elsewhere, use
the harness's subagent tools. If a named member is unavailable, report it
instead of substituting. If you cannot reach two providers, say so and ask the
user whether to run a single-provider council instead. Never fall back without
a yes.

Give each delegate the request and relevant context. For review or feedback,
keep their work read-only. Collect their responses and summarize the useful
findings, disagreements, and recommended next steps.

For a code review, ask each delegate for a score out of 10.
Count each full review pass as one round.
A fresh review after fixes starts a new round.

If the work ends in a pull request, put the results in the PR description.
Put this section before the model and harness line at the end:

```markdown
## Council review

Rounds: 2

| Delegate | Round 1 | Round 2 |
| --- | --- | --- |
| Claude Opus | 7/10 | 9/10 |
| GPT Sol | 8/10 | 10/10 |
```

If a delegate gives no score, write `no score`. Do not invent one.
If the PR is open, edit the description. Do not post a comment for this.
If there is no PR, put the same results in the final reply only.

If you agree with their recommendations, make the changes and request a fresh
review after. Continue this process until all delegates are satisfied with the
outcome.

Do not let repeated reviews result in scope creep. It is your job to fight to
keep scope limited.

## Single-provider fallback

Only after the user agrees:

- Use two different models from the provider you can reach, strongest first,
  for example Claude Opus and Claude Sonnet. If it offers only one model, run
  two delegates of it.
- Give each delegate a different lens on the same request, for example one
  hunting correctness bugs and one arguing for less code and tighter scope.
- Keep their contexts apart: neither sees the other's review or your own
  conclusions.
- Models from one lab share blind spots. Treat their agreement as weaker
  evidence than a two-provider council and say so in the summary.
- Label the results `## Council review (single provider)` and name each
  delegate with its lens, for example `Claude Opus (correctness)`.
