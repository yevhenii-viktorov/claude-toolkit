# Workflow: Review Remote PR

<required_reading>
Always read first:
- references/checklist.md (master pre-flight list)

Then load references on demand exactly as in workflows/review-diff.md `<required_reading>` — driven by what the PR's files touch. The three primary dimensions (idioms-style, code-smells, bugs-correctness) are sanity-checked on every PR.
</required_reading>

<process>

## Step 1 — Fetch the PR

Accept a number (`#123`), a bare number, or a full URL. Resolve the repo from the URL or the current directory's `gh` context.

```bash
gh pr view <number-or-url> --json number,title,body,author,baseRefName,headRefName,additions,deletions,files,state
gh pr diff <number-or-url>                       # the unified diff
gh pr checks <number-or-url>                     # CI status
gh pr view <number-or-url> --comments            # existing reviewer discussion
```

If `gh` isn't authenticated or the repo isn't accessible, say so and ask the user to provide the diff another way (paste, or check out the branch and use workflows/review-diff.md).

## Step 2 — Read the PR's intent

- Read the PR title + body for the stated goal. Review against *that* goal — a change that works but solves the wrong problem is a finding.
- Note CI status. If checks are red, lead the summary with that; your review is preliminary until they pass.
- Scan existing comments. If a reviewer already flagged something you also find, surface it as `Previously flagged by {reviewer}` and don't re-litigate. If the author responded with a fix, check the current diff reflects it.

## Step 3 — Get full file context

The PR diff shows only changed hunks. For non-trivial files, fetch enough context to judge correctness:

```bash
gh pr checkout <number>          # if you need to read whole files / run tools locally
# or fetch a single file at the PR head:
gh api repos/{owner}/{repo}/contents/{path}?ref={head_sha} --jq '.content' | base64 -d
```

Find call sites of changed methods (`grep`) — signature changes and newly-nullable returns ripple outward.

## Step 4 — Run static analysis (if checked out)

```bash
bash scripts/static-analysis.sh
```

If you didn't check out the branch, rely on the PR's CI checks for the mechanical layer and note that in the Static Analysis section. **Don't restate** CI/linter findings — summarize and move to the semantic review.

## Step 5 — Walk the diff with the checklist

Identical to workflows/review-diff.md Step 4: for each changed item, capture `file:line` + snippet + cited rule + fix + severity. Lead with style, smells, and bugs. Review **only the diff** — pre-existing code untouched by the PR is out of scope.

## Step 6 — Write and deliver the review

Use templates/review-output.md. Run the same self-check as review-diff.md Step 5.

**Delivery:**
- Default: print the review in the chat.
- If the user passed `--comment` or said "post comments" / "leave inline comments": file the findings as inline PR review comments.

```bash
# Single inline comment on a specific line
gh pr review <number> --comment --body "..."     # general comment
# For line-anchored comments, use the reviews API:
gh api repos/{owner}/{repo}/pulls/{number}/comments \
  -f body="<finding + fix>" -f commit_id="{head_sha}" -f path="{file}" -F line={line} -f side="RIGHT"
```

Confirm with the user before posting if the review has more than a handful of comments — bulk-posting is hard to undo.

</process>

<success_criteria>
- PR fetched and reviewed against its stated intent.
- CI status acknowledged; red checks surfaced in the summary.
- Existing reviewer feedback cross-referenced, not duplicated.
- Findings reference `file:line`, cite a rule, and include a fix.
- Only the diff is reviewed.
- Verdict line at the end; inline comments only when requested and confirmed.
</success_criteria>
