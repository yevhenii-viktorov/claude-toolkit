# Review Output Template

Copy this skeleton and fill it in. Drop any section that has no content — don't write "None" headers.

```markdown
## Summary

<1–2 sentences. State the overall verdict and the single most important concern. If linter is clean, say so. If CI is red, say so. Avoid filler.>

## Themes (optional — only for package/module reviews)

- **<Theme name>** — <one-line description, e.g. "Inconsistent error wrapping across the package: 4 sites return bare `err`.">
- **<Theme name>** — <…>

## Critical

### `<path/to/file.go>:<line>` — <short title>

<Why it's critical, 1 sentence. Cite the rule: e.g. "Go Code Review Comments: don't ignore errors.">

```go
// current
<offending snippet, ≤5 lines>
```

```go
// fix
<corrected snippet>
```

## High

### `<file>:<line>` — <title>

<Why. Cite rule.>

```go
// current
…
```

```go
// fix
…
```

## Medium

### `<file>:<line>` — <title>

<Why. Cite rule.>

<Code blocks as above. For very small medium findings, a one-line bullet is fine:>
- `<file>:<line>` — exported func `Foo` lacks doc comment ([Effective Go: commentary](https://go.dev/doc/effective_go#commentary)).

## Nits (optional — skip if nothing substantive beyond what `gofmt`/`goimports`/linter would flag)

- `<file>:<line>` — <nit>

## Positive

- `<file>:<line>` — <specific thing done well, e.g. "uses `errgroup.WithContext` to propagate cancellation across the fan-out.">
- <≤3 items. Skip the section if nothing concrete to say.>

## Static Analysis

- `gofmt`: clean / N files need formatting
- `go vet`: clean / N findings
- `staticcheck`: clean / N findings (e.g. `SA1019: deprecated`)
- `golangci-lint`: clean / N findings
- `go test -race`: pass / fail / not run
- `govulncheck`: clean / N CVEs

## Recommendation

**<Approve | Approve with comments | Request changes>** — <one-line reason.>
```

## Rules for filling this in

1. **`file:line`** is required for every finding (except themes and static-analysis summary).
2. **Cite a rule** — Effective Go, Go Code Review Comments, Uber Style, Google Style, or a Go blog post. If you can't cite one, the finding is probably opinion — drop it or demote.
3. **Show the fix** as a code block, not prose. Reviewers should be able to apply it directly.
4. **Severity matches the bar** in SKILL.md. No padding.
5. **Don't restate linter output** — summarize at the bottom under Static Analysis.
6. **Positive section is optional** and must be concrete. "Code is well-structured" is not a finding; "uses `t.Cleanup` consistently across all tests" is.
