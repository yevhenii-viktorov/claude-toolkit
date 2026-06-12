# Workflow: Review Local Diff

<required_reading>
Always read first:
- references/checklist.md (master pre-flight list)

Read on-demand based on what's in the diff (the first three are this skill's primary focus — sanity-check them on every diff):
- references/idioms-style.md — always: naming, casing, `final`/`var`, control flow, `Optional` use
- references/code-smells.md — always: long methods, deep nesting, over-engineering, dead/duplicated code
- references/bugs-correctness.md — always: `==` vs `.equals`, nullability, `equals`/`hashCode`, overflow, autoboxing
- references/exceptions.md — if diff touches `try`/`catch`/`finally`, `Closeable`, or resource handling
- references/concurrency.md — if diff touches threads, `synchronized`, `volatile`, `Atomic*`, executors, shared state
- references/collections-streams.md — if diff touches `Stream`, `Collectors`, collections, `Optional` pipelines
- references/api-design.md — if diff changes a public/protected API surface, constructors, or class hierarchy
- references/security.md — if diff touches SQL, file paths, deserialization, crypto, auth, external input
- references/performance.md — if diff touches hot paths, loops, string building, regex, large collections
- references/testing.md — for `*Test.java` / `*Tests.java` / `*Spec` files
- references/modern-java.md — if a Java 21 construct (record, sealed, pattern match, switch expr, virtual thread) would clearly improve the diff
- references/structure.md — if diff adds/moves packages or introduces cross-package coupling
</required_reading>

<process>

## Step 1 — Identify what changed

```bash
git status
git diff --stat          # file-level summary first
git diff --staged
git diff                 # working tree, unstaged
```

If both staged and unstaged changes exist, review **both as one logical change** unless the user said otherwise.

If the diff is empty, ask: "No local changes detected. Did you mean a specific commit, branch, or PR?"

## Step 2 — Understand intent

Read the surrounding code, not just the diff. The diff hides the lines on either side that decide whether a change is correct. For each changed file:
- Open the file with `Read` to see context around each hunk.
- Find call sites of changed methods/constructors (`grep` for the symbol) — a signature change or a newly-nullable return ripples outward.
- Note pre-existing issues — do **not** flag them. Only the diff. (A pre-existing bug directly worsened by the diff is fair game; say so explicitly.)

## Step 3 — Run static analysis

```bash
bash scripts/static-analysis.sh        # auto-detects Maven/Gradle, skips absent plugins
```

Capture output. **Don't restate** findings line-by-line — summarize ("Checkstyle clean; 2 SpotBugs `EI_EXPOSE_REP` on `OrderService`, fix those") and focus your review on what the tools can't see. If a tool isn't installed or the plugin isn't configured, note it once at the bottom — don't try to install tooling.

## Step 4 — Walk the diff with the checklist

Open references/checklist.md and scan the diff against each row, leading with the three primary dimensions (style, code smells, bugs). For every match:

1. Note `file:line`.
2. Capture the offending snippet (≤5 lines).
3. Identify the **rule** it violates and cite the source (Effective Java item, Google Java Style §, JLS §, SpotBugs/Checkstyle rule ID).
4. Write the fix as a code block — often the fix is *less code*.
5. Assign severity per the bar in SKILL.md.

Load additional reference files on demand for any dimension with hits.

## Step 5 — Write the review

Use templates/review-output.md. Order findings by severity (Critical → High → Medium → Nits). Within a severity, group by file.

**Self-check before delivering:**
- Did you flag anything outside the diff? (Drop it.)
- Did any finding duplicate the linter? (Drop or roll up under Static Analysis.)
- Does every Critical actually meet the Critical bar? (Demote if not.)
- Did you cite a rule for each finding? (If you can't, it's opinion — drop or demote.)
- Did you check for over-engineering, not just bugs? (A simpler design is a valid finding.)
- Are there ≤3 positive observations and are they concrete? (Trim "good job overall" filler.)

## Step 6 — Deliver

Print the review in the chat. Do not write it to a file unless the user asked.

</process>

<success_criteria>
- Findings reference `file:line` from the diff.
- No pre-existing-code findings (unless the diff worsened them — flagged as such).
- Linter output summarized, not duplicated.
- Each finding has rule + fix.
- Style, smells, and bugs visibly led the review.
- Verdict line at the end (Approve / Approve with comments / Request changes).
</success_criteria>
