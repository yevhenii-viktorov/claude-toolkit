# Workflow: Review Local Diff

<required_reading>
Always read first:
- references/checklist.md (master pre-flight list)

Read on-demand based on what's in the diff:
- references/errors.md — if diff touches `err` handling
- references/concurrency.md + references/context.md — if diff touches goroutines, channels, mutexes, `ctx`
- references/security.md — if diff touches HTTP handlers, DB, file paths, exec, crypto, auth
- references/performance.md — if diff touches hot paths, loops, allocations, I/O
- references/api-design.md — if diff changes exported API surface
- references/testing.md — for `_test.go` files
- references/idioms-style.md — always sanity-check naming + error strings
- references/generics.md — if diff introduces type parameters
- references/modern-go.md — if diff is on Go 1.21+ and uses logging, iteration, or built-ins
- references/structure.md — if diff adds/moves packages or imports
</required_reading>

<process>

## Step 1 — Identify what changed

```bash
git status
git diff --staged
git diff               # working tree, unstaged
git diff --stat        # file-level summary first
```

If both staged and unstaged changes exist, review **both as one logical change** unless the user said otherwise.

If the diff is empty, ask: "No local changes detected. Did you mean a specific commit, branch, or PR?"

## Step 2 — Understand intent

Read the surrounding code, not just the diff. For each changed file:
- Open the file with `Read` to see context around the hunk (the diff hides the 10 lines on either side that matter).
- Identify call sites of changed functions (`grep` for the symbol).
- Note pre-existing issues — do **not** flag them. Only the diff.

## Step 3 — Run static analysis

```bash
gofmt -l .
go vet ./...
golangci-lint run ./...      # if .golangci.yml exists or tool is installed
go test -race -count=1 ./... # if changes touch testable code
```

If `scripts/static-analysis.sh` is helpful, suggest running it. Capture output. **Don't restate** linter findings line-by-line — summarize ("3 staticcheck SA1019 deprecated-API findings, fix those") and focus your review on semantic issues.

If a tool isn't installed, note it once at the bottom of the review — don't try to install tooling.

## Step 4 — Walk the diff with the checklist

Open references/checklist.md and scan the diff against each row. For every match:

1. Note `file:line`.
2. Capture the offending snippet (≤5 lines).
3. Identify the **rule** it violates (cite the source: "Go Code Review Comments: don't panic", "Effective Go: receiver consistency", "Uber Style: error wrapping").
4. Write the fix as a code block.
5. Assign severity per the bar in SKILL.md.

Load additional reference files on demand for any dimension with hits.

## Step 5 — Write the review

Use templates/review-output.md. Order findings by severity (Critical → High → Medium → Nits). Within a severity, group by file.

**Self-check before delivering:**
- Did you flag anything outside the diff? (Drop it.)
- Did any finding duplicate the linter? (Drop or roll up.)
- Does every Critical actually meet the Critical bar? (Demote if not.)
- Did you cite a rule for each finding? (Add one if not.)
- Are there ≤3 positive observations and are they concrete? (Trim or drop "good job overall" filler.)

## Step 6 — Deliver

Print the review in the chat. Do not write it to a file unless the user asked.

</process>

<success_criteria>
- Findings reference `file:line` from the diff.
- No pre-existing-code findings.
- Linter output summarized, not duplicated.
- Each finding has rule + fix.
- Verdict line at the end (Approve / Approve with comments / Request changes).
</success_criteria>
