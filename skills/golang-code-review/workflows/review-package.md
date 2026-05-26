# Workflow: Review Whole Package or File

Use this when the user wants a deep audit of a file, package, or module — not a diff review.

<required_reading>
- references/checklist.md
- references/structure.md (always — package layout matters here)
- references/api-design.md (always — exported surface review)

Then on-demand: errors, concurrency, context, performance, security, testing, idioms-style, generics, modern-go — same as workflows/review-diff.md.
</required_reading>

<process>

## Step 1 — Scope

Clarify with the user if unclear: single file, single package (directory), or whole module? Note the path.

## Step 2 — Map the territory

```bash
# Module info
head -20 go.mod

# Package layout
find <path> -type f -name '*.go' -not -name '*_test.go' | head -50
find <path> -type f -name '*_test.go' | head -20

# Exported API surface (quick glance)
grep -RhE '^func [A-Z]|^type [A-Z]|^var [A-Z]|^const [A-Z]' <path> | head -50

# Imports — spot heavy dependencies, internal/pkg boundaries
grep -RhE '^\t"' <path> | sort -u
```

Read the package doc comment (`doc.go` or top of the main file) — if missing, that's a finding.

## Step 3 — Static analysis

```bash
gofmt -l <path>
go vet ./<path>/...
staticcheck ./<path>/...
golangci-lint run ./<path>/...
go test -race -count=1 ./<path>/...
govulncheck ./...
```

Capture results. Linter findings are inputs to the review, not a substitute for it.

## Step 4 — Review pass

Read every `.go` file in the package. For each:

1. **Package-level concerns first** — naming, layout, package doc, exported-surface size, circular-dep risk.
2. **Per-file** — walk through with references/checklist.md.
3. **Tests** — separate pass on `_test.go` files (references/testing.md).

Pay extra attention to:
- **Exported API** — every exported symbol needs a doc comment starting with its name (Effective Go).
- **Interfaces** — defined where used, kept small, named `-er` for single-method.
- **Receiver consistency** — all methods on a type use the same receiver kind.
- **Zero-value usability** — is the zero value valid, or does the type require a constructor?

## Step 5 — Synthesize

Audits surface patterns, not just isolated issues. Group findings by **theme** in addition to severity:

- *Error handling pattern X is inconsistent across the package*
- *Goroutine lifecycle isn't tied to ctx in N places*
- *Tests don't use t.Parallel/t.Cleanup*

Use templates/review-output.md but add a **Themes** section at the top after Summary if multiple findings share a root cause.

## Step 6 — Deliver

Print the review. For large audits, offer to write it to `REVIEW-<package>.md` only if the user asks.

</process>

<success_criteria>
- Package-level concerns (layout, exported surface, doc) reviewed in addition to per-file.
- Themes extracted when ≥3 findings share a root cause.
- Static analysis run; findings summarized, not duplicated.
- Verdict per the standard format.
</success_criteria>
