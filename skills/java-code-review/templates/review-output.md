# Review Output Template

Copy this skeleton and fill it in. Drop any section that has no content — don't write "None" headers.

```markdown
## Summary

<1–2 sentences. Overall verdict + the single most important concern. State if Checkstyle/SpotBugs are clean or if CI is red. No filler.>

## Themes (optional: expected for package/module audits, skip for small diffs)

- **<Theme>**: <one line, e.g. "Six getters leak internal mutable collections (`EI_EXPOSE_REP`); fix the pattern, not the lines.">
- **<Theme>**: <…>

## Critical

### `<path/to/File.java>:<line>`: <short title>

<Why it's critical, 1 sentence. Cite the rule: "AGENTS.md: Spring", "java-code-style: Comments", "Effective Java Item 9: prefer try-with-resources", SpotBugs `OBL_UNSATISFIED_OBLIGATION`, JLS §15.21.>

```java
// current
<offending snippet, ≤5 lines>
```

```java
// fix
<corrected snippet, often less code>
```

## High

### `<File.java>:<line>`: <title>

<Why. Cite rule.>

```java
// current
…
```

```java
// fix
…
```

## Medium

### `<File.java>:<line>`: <title>

<Why. Cite rule. For small findings a one-line bullet is fine:>
- `<File.java>:<line>`: hand-rolled immutable DTO with boilerplate `equals`/`hashCode` → `record` ([modern-java.md]; Effective Java Item 10).

## Nits (optional; skip what Checkstyle/SpotBugs already flag)

- `<File.java>:<line>`: <nit>

## Positive

- `<File.java>:<line>`: <specific thing done well, e.g. "uses try-with-resources for the JDBC connection/statement/result-set chain.">
- <≤3 items, concrete. Skip the section if nothing stands out.>

## Static Analysis

- Checkstyle: clean / N findings (e.g. `UnusedImports`, `WhitespaceAround`)
- SpotBugs: clean / N findings (e.g. `NP_NULL_ON_SOME_PATH`, `EI_EXPOSE_REP`)
- Compile (`-Xlint`): clean / N warnings (unchecked, deprecation)
- Tests: pass / fail / not run
- <Note any tool not installed / plugin not configured.>

## Recommendation

**<Approve | Approve with comments | Request changes>**: <one-line reason.>
```

## Rules for filling this in

1. **`file:line`** required for every finding (except themes and the static-analysis summary).
2. **Cite a rule** — house style section (`AGENTS.md`, `java-code-style`), Effective Java item, Google Java Style §, JLS §, or a SpotBugs/Checkstyle rule ID. If you can't cite one, it's probably opinion — drop it or demote.
3. **Show the fix** as a code block, not prose — applyable directly. Prefer the *simpler* version; "delete this" is a valid fix.
4. **Lead with the primary dimensions** — style, code smells, bugs should be visibly the focus.
5. **Severity matches the bar** in SKILL.md. No false-Critical, no Medium padding, no nit-spam.
6. **Don't restate linter output** — summarize under Static Analysis.
7. **Positive section is optional** and must be concrete. "Well structured" is not a finding; "consistent try-with-resources across all I/O" is.
8. **No em dashes** in the review's prose; use colons, commas or parentheses.
9. **Fixes follow the house style** too: `final` locals, no `var`, `formatted`, no comments in the suggested code.
