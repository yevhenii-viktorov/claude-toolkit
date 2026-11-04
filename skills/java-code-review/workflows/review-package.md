# Workflow: Audit a Whole Package / Module / File

Use when the user names a directory, module, or file with no diff context ("review the `order` package", "audit `OrderService.java`"). Unlike the diff/PR workflows, there is no "only what changed" constraint — you're assessing the whole surface. That makes **themes** (recurring problems) as important as individual findings.

<required_reading>
Always read first:
- the project's `AGENTS.md`/`CLAUDE.md`, plus `../java-code-style/SKILL.md` if the user opted in at intake (house style; wins over the references)
- references/checklist.md (master pre-flight list)

Load every reference whose dimension the code touches. For a full package audit, expect to consult most of them. The three primary dimensions (idioms-style, code-smells, bugs-correctness) apply to every file.
</required_reading>

<process>

## Step 1 — Map the target

```bash
# Scope and size first
find <path> -name '*.java' | head -50
cloc <path> 2>/dev/null || find <path> -name '*.java' -exec wc -l {} +
```

Read the package's entry points and public types first to understand its job, then the supporting classes. Build a mental model of responsibilities before judging any one class.

## Step 2 — Run static analysis

```bash
bash scripts/static-analysis.sh
```

Prefer the project's own verify command when `AGENTS.md`/`CLAUDE.md`/the README or a Makefile names one (for example `mvn clean verify` with the `JAVA_HOME` it asks for), and report the SonarQube gate if the project uses it. The script is the fallback.

Summarize the mechanical findings. For an audit, a *pattern* in the linter output (e.g. "8 `EI_EXPOSE_REP` across the package") is itself a theme worth calling out.

## Step 3 — Review file by file, dimension by dimension

For each file, walk references/checklist.md. Lead with the three primary dimensions:
- **House style** — the rules in `AGENTS.md` (and java-code-style, if opted in) that checkstyle can't enforce.
- **Style/idioms** — naming, `final`, no `var`, control flow, `Optional` use, modern-Java opportunities.
- **Code smells** — god classes, long methods, deep nesting, primitive obsession, duplication, over-engineering. At package scope, watch for *duplication across files* and *abstractions used by only one caller*.
- **Bugs/correctness** — nullability, `equals`/`hashCode`, overflow, resource leaks, concurrency on shared state.

Then the remaining dimensions where the code touches them.

Capture each finding as `file:line` + snippet + cited rule + fix + severity.

## Step 4 — Identify themes

Before writing, step back and name the 2–4 recurring problems. Themes are higher-leverage than scattered line findings — "the package leaks mutable collections from 6 getters" tells the author to fix a habit, not 6 lines. List representative `file:line` instances under each theme rather than enumerating all of them.

## Step 5 — Write and deliver

Use templates/review-output.md, **including the Themes section** (optional in the diff workflows, expected here). Order: Summary → Themes → Critical → High → Medium → Nits → Positive → Static Analysis → Recommendation.

Print in the chat unless the user asked for a file.

</process>

<success_criteria>
- The package's purpose is understood and stated before findings.
- Themes capture recurring problems; line findings give representative evidence, not exhaustive enumeration.
- Each finding has `file:line`, a cited rule, and a fix.
- Style, smells, and bugs led the audit.
- Over-engineering flagged as readily as bugs.
- Verdict line at the end.
</success_criteria>
