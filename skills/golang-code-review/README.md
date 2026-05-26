# golang-code-review

Rigorous, idiomatic Go code review covering correctness, concurrency, performance, security, API design, testing, and modern Go (1.21+).

Bugs first, design second, style last. Every finding has a `file:line`, snippet, rule citation, and code fix. Trusts `gofmt` / `vet` / `golangci-lint` to handle formatting — reviews the semantic issues those tools can't catch.

## When to use

- Reviewing a Go pull request
- Auditing a Go package or file
- Checking your local diff before pushing
- Finding bugs, races, or security issues in Go code

## Modes

- **Local diff** — staged + working tree (`workflows/review-diff.md`)
- **Remote PR** — by number or URL, with optional inline comments (`workflows/review-pr.md`)
- **Package / file audit** — whole-package or single-file review (`workflows/review-package.md`)

If the target is ambiguous, the skill asks one routing question and then proceeds.

## Install

```bash
cp -r golang-code-review ~/.claude/skills/
```

Then ask Claude Code to "review my Go changes", "review PR #123", or "audit internal/auth".

## Structure

```
golang-code-review/
├── SKILL.md              # Entry point, severity bar, routing, output format
├── workflows/            # Mode-specific playbooks (diff, pr, package)
├── references/           # Rule references per dimension (errors, concurrency, ...)
├── templates/            # Review output skeleton
└── scripts/
    └── static-analysis.sh  # gofmt / vet / staticcheck / golangci-lint / race / govulncheck
```

## License

MIT — see repo root [LICENSE](../../LICENSE).
