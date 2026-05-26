---
name: golang-code-review
description: Rigorous, idiomatic Go code review covering correctness, concurrency, performance, security, API design, testing, and modern Go (1.21+). Use when asked to review Go/Golang code, review a Go PR, audit a Go package, check Go code quality, or find issues/bugs in Go code. Supports local diffs and remote PRs (by ID/URL).
---

<essential_principles>
A Go review finds bugs first, design issues second, style last. Reviewers cite a rule and a fix — not opinions.

**Quality bar:** "very good production code" — not OSS-library-grade. Demand idiomatic Go and catch real bugs, but don't pad reviews with godoc-on-every-export, ExampleX functions, package-doc placement, or "justify your buffered channel size" ceremony. Apply OSS-grade rigor only when the package is clearly a published library or a stable public API.

**Severity bar** — only flag issues that meet this bar:
- **Critical** — data races, goroutine leaks, ignored errors on side-effectful calls, secrets in code, injection (SQL/command/path), missing `ctx` cancellation/`defer cancel()`, panics in non-`main` library code, unsafe concurrent map access, weak crypto for security-sensitive use, `InsecureSkipVerify: true` in production.
- **High** — missing error wrapping that loses debugging context, no `ctx` propagation through I/O, mutable global state, unbounded goroutine spawning, pointer/value receiver inconsistency on a type with a `Mutex`, race-detector failures, missing input bounds on user-controlled sizes, HTTP server without timeouts.
- **Medium** — oversized functions/interfaces, inefficient hot-path allocations, missing table tests on branchy logic, non-idiomatic naming where it harms readability, missing docs **on exported APIs of a published library**, deprecated APIs.
- **Low/Nit** — formatting (defer to `gofmt`/`goimports`), import grouping, missing godoc on internal exported helpers, comment style. Mention sparingly; don't pad reviews.

**Anchor every finding** — `file:line` reference, the offending snippet, why it's wrong (cite the rule: "Go Code Review Comments: error strings", "Effective Go: receiver consistency", etc.), and the fix as code.

**Trust gofmt, vet, golangci-lint** — don't restate what the linter would say. Run static analysis first; review the remaining semantic issues.

**Be specific, be constructive** — acknowledge non-obvious good patterns. Never invent issues to pad the review.
</essential_principles>

<intake>
Determine review target from the user's request:

1. **Remote PR** — user mentions PR number/URL, "review PR #123", "review this PR: <url>" → workflows/review-pr.md
2. **Local diff** — user says "review my changes", "review the diff", or no target specified → workflows/review-diff.md
3. **Whole package/file** — user names a directory or file ("review internal/auth", "review auth.go") with no diff context → workflows/review-package.md

If ambiguous, ask one question: *"Local diff, remote PR (give number/URL), or a specific package/file?"* — then route.
</intake>

<routing>
| Target | Workflow | Inline-comments option |
|--------|----------|------------------------|
| Local diff (staged + working tree) | workflows/review-diff.md | N/A — print findings |
| Remote PR (gh pr) | workflows/review-pr.md | Pass `--comment` or user says "post comments" to file inline |
| Whole package / file audit | workflows/review-package.md | Print findings |

**After reading the workflow, follow it exactly. The workflow tells you which references to load.**
</routing>

<review_dimensions>
Every Go review covers these dimensions. Each maps to a reference for detailed rules and examples:

| Dimension | Reference | Flag examples |
|-----------|-----------|---------------|
| Correctness & errors | references/errors.md | Lost error context, sentinel via string compare, ignored `err` |
| Concurrency | references/concurrency.md | Race, goroutine leak, sender-closes, missing `select { case <-ctx.Done() }` |
| Context | references/context.md | `ctx` in struct, `ctx.Value` for required args, missing cancel |
| Performance | references/performance.md | Hot-path allocs, string `+=` in loops, defer in tight loop |
| Security | references/security.md | `math/rand` for tokens, SQL string concat, path traversal, `==` on secrets |
| API design | references/api-design.md | Big interface, returning interface, accept concrete |
| Testing | references/testing.md | No `t.Helper()`, no `t.Cleanup`, no `-race`, missing table tests |
| Idioms & style | references/idioms-style.md | Capitalized error string, `getName()`, stuttering, mixedCaps |
| Generics | references/generics.md | Type param used where `any` would do, generic where interface is clearer |
| Modern Go (1.21+) | references/modern-go.md | `log` instead of `log/slog`, hand-rolled `min/max`, missing iterators where natural |
| Project structure | references/structure.md | `pkg/util`, layer-grouped packages, circular deps |

**Master checklist** — references/checklist.md is the one-shot pre-flight list to scan before writing the review.
</review_dimensions>

<static_analysis>
Before writing findings, run static analysis if the repo permits — most "issues" surface here for free:

```bash
gofmt -l .                       # files not gofmt'd
go vet ./...                     # built-in checks
staticcheck ./...                # extra checks
golangci-lint run ./...          # bundle (preferred)
go test -race -count=1 ./...     # race detector
govulncheck ./...                # known CVEs
```

A helper is bundled at `scripts/static-analysis.sh` — run it once; only review what static analysis cannot catch.

**Don't double-report** what the linter already flags. Mention "linter clean" or "X linter findings — fix those first" and move on to semantic issues.
</static_analysis>

<output_format>
Use templates/review-output.md as the structure. Brief skeleton:

```
## Summary
[1-2 sentences: overall verdict + headline concern]

## Critical
[Bugs, races, security, leaks. file:line + snippet + why + fix.]

## High
[Missing wrapping, context, docs on exported API, etc.]

## Medium
[Idiom violations, oversized functions, missing tests on branchy code.]

## Nits (optional)
[Only if substantive. Skip if linter already handles.]

## Positive
[1-3 concrete things done well. Skip if nothing stands out — don't pad.]

## Recommendation
Approve / Approve with comments / Request changes
```
</output_format>

<success_criteria>
A good Go review:
- Routes correctly (diff / PR / package) without asking unless ambiguous.
- Runs static analysis first; doesn't restate linter findings.
- Every finding has `file:line`, snippet, rule citation, and a code fix.
- Severity matches the bar above — no false-Critical, no Medium padding.
- Stays under 1 page for typical PRs (≤500 LOC). Longer only when the diff justifies it.
- Cites the canonical source where the rule comes from (Effective Go, Go Code Review Comments, Uber/Google style guide).
</success_criteria>
