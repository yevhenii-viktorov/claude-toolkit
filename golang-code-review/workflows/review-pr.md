# Workflow: Review Remote PR

<required_reading>
Same as workflows/review-diff.md — load references on-demand based on what the PR changes.
</required_reading>

<process>

## Step 1 — Resolve the PR

User gives a PR number, a URL, or asks "review this PR." Extract `<owner>/<repo>` and `<number>`.

```bash
gh pr view <number> --json title,body,author,baseRefName,headRefName,additions,deletions,changedFiles,labels
gh pr diff <number>                 # full diff
gh pr checks <number>               # CI state
```

For URLs of the form `https://github.com/<owner>/<repo>/pull/<n>`, prefix `gh` commands with `--repo <owner>/<repo>`.

If the PR is large (>1000 LOC), tell the user upfront, focus on critical files, and skim the rest.

## Step 2 — Read the PR context

- **Title + body** — what does the author claim this PR does?
- **Linked issues** — `gh issue view <n>` if referenced.
- **Existing comments** — `gh api repos/<owner>/<repo>/pulls/<n>/comments` (inline) and `gh pr view <n> --comments` (top-level). Don't restate what reviewers already said.
- **CI state** — if checks are red, mention it once and prioritize unrelated semantic issues.

## Step 3 — Decide: checkout or remote-only?

**Checkout when** static analysis matters, the PR is non-trivial, or the user asked to run tests:
```bash
gh pr checkout <number>
```
After review, ask the user before switching branches back — don't auto-discard their state.

**Remote-only when** the PR is small (<100 LOC), well-described, and a textual diff review suffices. Use `gh pr diff <number>` and `Read` files via `gh api` if needed.

## Step 4 — Run static analysis (if checked out)

Same as workflows/review-diff.md Step 3.

## Step 5 — Walk the diff with the checklist

Same as workflows/review-diff.md Step 4. Findings must reference `file:line` from the PR diff.

## Step 6 — Decide on inline comments

The user invoked this with one of:
- `--comment` flag, or explicit "post inline comments" → file each finding as a PR review comment.
- Otherwise → print the review in chat only.

To post inline review comments:
```bash
gh pr review <number> --comment --body "<summary>"
# For per-line comments, use the API:
gh api repos/<owner>/<repo>/pulls/<n>/comments \
  -f body="..." -f commit_id="<sha>" -f path="<file>" -F line=<n> -f side=RIGHT
```

**Before posting**: show the user the full review and ask for confirmation. Posting comments is visible to others and hard to undo cleanly.

## Step 7 — Cleanup

If you ran `gh pr checkout`, ask: *"Switch back to `<original-branch>`?"* Don't auto-switch.

</process>

<success_criteria>
- PR title/body/linked-issues acknowledged in the summary.
- CI state checked.
- Existing review comments not duplicated.
- Verdict explicit: Approve / Approve with comments / Request changes.
- Inline comments posted only with user confirmation.
- Branch restored only with user consent.
</success_criteria>
