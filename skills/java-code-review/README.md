# java-code-review

Rigorous Java code review that doubles down on code style and hunts bugs and crappy code. Covers correctness, code smells, exceptions, concurrency, collections/streams, API design, security, performance, testing, and modern Java (21).

Bugs and crappy code first, design second, with an uncompromising style bar throughout. Every finding has a `file:line`, snippet, rule citation (Effective Java, Google Java Style, JLS, SpotBugs/Checkstyle ID), and a code fix. Trusts Checkstyle / SpotBugs to handle the mechanical floor — reviews the semantic issues those tools can't catch.

## When to use

- Reviewing a Java pull request
- Auditing a Java package or file
- Checking your local diff before pushing
- Finding bugs, smells, or security issues in Java code

## Modes

- **Local diff** — staged + working tree (`workflows/review-diff.md`)
- **Remote PR** — by number or URL, with optional inline comments (`workflows/review-pr.md`)
- **Package / file audit** — whole-package or single-file review (`workflows/review-package.md`)

If the target is ambiguous, the skill asks one routing question and then proceeds.

## Install

```bash
cp -r java-code-review ~/.claude/skills/
```

Then ask Claude Code to "review my Java changes", "review PR #123", or "audit src/main/java/.../auth".

## Structure

```
java-code-review/
├── SKILL.md              # Entry point, severity bar, routing, output format
├── workflows/            # Mode-specific playbooks (diff, pr, package)
├── references/           # Rule references per dimension (bugs, code-smells, concurrency, ...)
├── templates/            # Review output skeleton
└── scripts/
    └── static-analysis.sh  # Maven/Gradle auto-detect: Checkstyle / SpotBugs / compile warnings / tests
```

## License

MIT — see repo root [LICENSE](../../LICENSE).
