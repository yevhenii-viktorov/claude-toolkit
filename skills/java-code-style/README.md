# java-code-style

Default house style for Java projects: Google Java Style adapted the prebid-server-java way, effectively final
everywhere, no `var`, no explanatory comments or Javadoc on application code, a small Lombok whitelist, and Spring
and test conventions (constructor injection, injected `Clock`, AssertJ, behaviour-named tests).

A project's own checkstyle, `.editorconfig`, AGENTS.md/CLAUDE.md or existing code wins where it differs.

## When to use

- Writing or changing Java code
- Reviewing Java code (used by [java-code-review](../java-code-review) when you opt in)
- Answering "what's our Java style?"

## Install

```bash
cp -r java-code-style ~/.claude/skills/
```

## License

MIT — see repo root [LICENSE](../../LICENSE).
