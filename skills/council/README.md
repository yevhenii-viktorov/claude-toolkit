# council

Brings in two delegates, one strong model from each of two AI providers, to review or give feedback on the work,
then summarizes their findings, disagreements and scores, and repeats after fixes until both are satisfied. For
code reviews, the scores per round go into the PR description.

## Single-provider fallback

If only one provider is reachable (for example Claude Code, whose subagents are all Claude models), the skill says
so and asks before running a single-provider council. That council uses two different models from the same lab,
gives each a different lens (such as correctness and scope), keeps their contexts apart, and labels the results
`Council review (single provider)`, because same-lab models share blind spots and their agreement is weaker
evidence.

## When to use

Say "council", usually to get an independent review of a change before merging.

## Install

```bash
cp -r council ~/.claude/skills/
```

## Credit

Adapted from the `council` skill in [t3dotgg/tstack](https://github.com/t3dotgg/tstack) by Theo Browne
(MIT). This version uses two providers instead of three and adds the single-provider fallback.

## License

MIT. The original is Copyright (c) 2026 Theo Browne; its license is in [LICENSE](./LICENSE).
