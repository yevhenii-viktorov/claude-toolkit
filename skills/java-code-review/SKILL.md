---
name: java-code-review
description: Rigorous Java code review that doubles down on code style and hunts bugs and crappy code. Covers correctness, code smells, exceptions, concurrency, collections/streams, API design, security, performance, testing, and modern Java, and enforces the project's AGENTS.md/CLAUDE.md conventions plus, if the user opts in, the java-code-style skill's house style. Use when asked to review Java code, review a Java PR, audit a Java package, check Java code quality, or find bugs/smells in Java code. Supports local diffs and remote PRs (by ID/URL).
---

<essential_principles>
A Java review hunts **bugs and crappy code first**, and holds an **uncompromising style bar throughout**. Style is not an afterthought here — sloppy naming, dead code, needless mutability, and over-engineering are findings, not nits to wave through. Reviewers cite a rule and a fix — not opinions.

**Read the code, don't relay the linter.** Checkstyle and SpotBugs are a floor — run them, summarize them, then move past them. The value you add is the judgment a tool can't: the swallowed exception that hides a real failure, the class that does five jobs, the abstraction built for one caller, the `equals` that breaks the map it's a key in. Open the files, follow the call sites, understand intent, then review.

**Quality bar:** "very good production code" — not OSS-library-author-grade. Demand idiomatic, simple, correct Java and catch real bugs, but don't pad reviews with Javadoc-on-every-method, `@since`/`@author` tags, `package-info.java` ceremony, or "document this private helper" nits. Apply OSS-grade rigor only when the package is clearly a published library or a stable public API surface.

**Bias toward simplicity.** The best fix is often *less code*. Flag speculative generality, single-use abstractions, configurability nobody asked for, and defensive handling of impossible states. If a senior engineer would call it overcomplicated, say so and show the smaller version.

**Anchor every finding** — `file:line` reference, the offending snippet (≤5 lines), why it's wrong (cite the rule: "Effective Java Item 17: minimize mutability", "Google Java Style §5.2.4", SpotBugs `EI_EXPOSE_REP`, JLS §15.21.1), and the fix as a code block.

**Be specific, be constructive** — acknowledge non-obvious good patterns. Never invent issues to pad the review.
</essential_principles>

<style_sources>
**Load the house style before reviewing.** Read, in this order of precedence (earlier wins where they disagree):

1. The project's own rules: checkstyle config, `.editorconfig`, `AGENTS.md`/`CLAUDE.md`, and the conventions visible in the existing code. Always applied.
2. The java-code-style skill (`../java-code-style/SKILL.md`), only when the user opts in at intake. If that file is missing, say so once and skip it.
3. The references in this skill (Google Java Style, Effective Java).

The references are generic; where one of them disagrees with 1 or 2 (for example on `final` parameters, builders, Javadoc, comments, package layout or test names), follow the house style and don't flag code for following it. A violation of the house style that checkstyle can't catch is a finding: cite it as `AGENTS.md: <section>` or `java-code-style: <section>`. When the user opts out of 2, don't cite it or flag anything only it requires.
</style_sources>

<severity_bar>
Only flag issues that meet this bar. Calibrate Critical/High deliberately — a review that cries Critical at a style nit is noise.

- **Critical** — resource leaks (I/O, `Stream`, JDBC, `ExecutorService` not closed / no try-with-resources), SQL/command/path injection, unsafe deserialization (`ObjectInputStream` on untrusted data, unguarded `readObject`), broken `equals`/`hashCode` contract on a type used as a map/set key, data races on shared mutable state, swallowed exception on a side-effectful call that hides failure, hardcoded secrets/credentials, returning `null` where the contract promises a collection/`Optional` and callers will NPE.
- **High** — dereference of a known-nullable value without a guard, internal mutable state leaked via getter/constructor with no defensive copy (`EI_EXPOSE_REP`), `catch (Exception|Throwable)` that hides bugs or downgrades them to logs, `ExecutorService`/`Closeable` with no shutdown/close path, non-thread-safe field mutated on a shared singleton, integer overflow in size/index/capacity math, `==` on `String`/boxed types where `.equals` is meant.
- **Medium** — god classes / overlong methods / deep nesting (arrow code), primitive obsession, **over-engineering & speculative generality** (single-use abstraction, unused config knobs, premature interface), legacy idiom where a modern construct the project's Java version supports is clearly better (hand-rolled DTO vs `record`, `instanceof`+cast vs pattern match), missing tests on branchy logic, `Stream` pipeline with side effects, mutable static state, duplicated code blocks, **house-style violations checkstyle can't enforce** (Lombok outside the allowed set, field injection, `@Transactional` off service methods, `Instant.now()` instead of the injected `Clock`, `String.format`/concatenation chains instead of `formatted`, explanatory comments or Javadoc on application code, HTTP status chosen outside the exception handler).
- **Low/Nit** — formatting Checkstyle owns, import order, naming nits. Never ask for Javadoc or explanatory comments on application code: the house style forbids them. Mention sparingly; don't pad. Items marked **[library]** apply only to published libraries.
</severity_bar>

<intake>
Determine review target from the user's request:

1. **Remote PR** — user mentions PR number/URL, "review PR #123", "review this PR: <url>" → workflows/review-pr.md
2. **Local diff** — user says "review my changes", "review the diff", or no target specified → workflows/review-diff.md
3. **Whole package/file** — user names a directory, module, or file ("review src/main/java/.../auth", "review OrderService.java") with no diff context → workflows/review-package.md

If ambiguous, ask one question: *"Local diff, remote PR (give number/URL), or a specific package/file?"* — then route.

Then ask whether to apply the java-code-style house style, unless the request already says. Use AskUserQuestion when available, in the same call as the target question if that one is needed:
- **Yes**: project rules, then java-code-style, then the references.
- **No**: project rules and the references only.
</intake>

<routing>
| Target | Workflow | Inline-comments option |
|--------|----------|------------------------|
| Local diff (staged + working tree) | workflows/review-diff.md | N/A — print findings |
| Remote PR (`gh pr`) | workflows/review-pr.md | Pass `--comment` or user says "post comments" to file inline |
| Whole package / module / file audit | workflows/review-package.md | Print findings |

**After reading the workflow, follow it exactly. The workflow tells you which references to load.**
</routing>

<review_dimensions>
Every Java review covers these dimensions. The first four are the **primary focus** of this skill — review them hardest. Each maps to a reference for detailed rules and examples.

| Dimension | Reference | Priority | Flag examples |
|-----------|-----------|----------|---------------|
| House style | project `AGENTS.md`/`CLAUDE.md` + java-code-style (if opted in) | **PRIMARY** | Lombok outside the allowed set, `String.format`, explanatory comments/Javadoc, field injection, `Instant.now()` in business logic, `@Mock` fields, `test`/`should` test names |
| Idioms & style | references/idioms-style.md | **PRIMARY** | Wrong casing/initialism, `Get`-prefix getters, missing `final`, any `var`, `else` after `return`, Yoda conditions |
| Code smells / crappy code | references/code-smells.md | **PRIMARY** | God class, long method, deep nesting, primitive obsession, boolean trap, magic numbers, dead/duplicated code, over-abstraction |
| Bugs & correctness | references/bugs-correctness.md | **PRIMARY** | `==` vs `.equals`, broken `equals`/`hashCode`, autoboxing NPE, overflow, `switch` fallthrough, `finally`-return |
| Exceptions & resources | references/exceptions.md | High | Swallowed/empty catch, broad `catch`, no try-with-resources, exceptions as control flow |
| Concurrency | references/concurrency.md | High | Shared mutable state, missing `volatile`, unshut `ExecutorService`, double-checked locking, deadlock |
| Collections & streams | references/collections-streams.md | Medium | Side effects in streams, mutable returns, `Optional.get()`, no presizing, loop-beats-stream |
| API design | references/api-design.md | Medium | Mutable type, inheritance over composition, leaky abstraction, `null` over empty, non-final fields |
| Security | references/security.md | High when present | SQL concat, path traversal, unsafe deserialization, weak crypto, hardcoded secrets |
| Performance | references/performance.md | Medium | `String` concat in loop, boxing in hot path, regex recompiled per call, no presizing |
| Testing | references/testing.md | Medium | Logic in tests, no AssertJ, vague names, over-mocking, no parameterized cases |
| Modern Java | references/modern-java.md | Medium | Hand-rolled DTO vs `record`, `instanceof`+cast vs pattern, verbose `switch`, no virtual threads where natural |
| Project structure | references/structure.md | Low | `util`/`common`/`misc` dumping grounds, package = layer not feature, circular deps |

**Master checklist** — references/checklist.md is the one-shot pre-flight list to scan before writing the review.
</review_dimensions>

<static_analysis>
Run static analysis if the repo permits — mechanical issues surface here for free.

**Use the project's own verify command first.** If `AGENTS.md`/`CLAUDE.md`/the README or a Makefile names one (for example `mvn clean verify`, which may also run integration tests, PIT and checkstyle in `validate`), run that, with the `JAVA_HOME` it asks for. If the project uses SonarQube, report its quality gate when you can reach it. The commands below and the bundled script are the fallback. Detect the build tool first (`pom.xml` → Maven, `build.gradle[.kts]` → Gradle):

```bash
# Maven
mvn -q checkstyle:check spotbugs:check
mvn -q compile -Dmaven.compiler.showWarnings=true   # -Xlint surfaces unchecked/deprecation
mvn -q test

# Gradle
./gradlew checkstyleMain spotbugsMain
./gradlew compileJava -Pwarnings
./gradlew test
```

A helper is bundled at `scripts/static-analysis.sh` — it auto-detects the build tool and skips any check whose plugin isn't wired up. Run it once.

**The linters are a floor, not the review.** Summarize their output ("Checkstyle clean", "3 SpotBugs `NP_NULL_ON_SOME_PATH` findings — fix those") and **don't restate it finding-by-finding**. Your review is the semantic and design layer the tools can't reach. If a tool isn't installed or the plugin isn't configured, note it once at the bottom — don't try to install tooling.
</static_analysis>

<output_format>
Use templates/review-output.md as the structure. Brief skeleton:

```
## Summary
[1-2 sentences: overall verdict + headline concern]

## Critical
[Bugs, leaks, injection, broken contracts. file:line + snippet + why + fix.]

## High
[Nullability, leaked mutable state, broad catch, unshut resources.]

## Medium
[Code smells, over-engineering, oversized methods, legacy-vs-modern, missing tests.]

## Nits (optional)
[Only if substantive. Skip what Checkstyle already handles.]

## Positive
[1-3 concrete things done well. Skip if nothing stands out — don't pad.]

## Static Analysis
[Checkstyle / SpotBugs / compile-warnings / tests — one line each.]

## Recommendation
Approve / Approve with comments / Request changes
```
</output_format>

<success_criteria>
A good Java review:
- Routes correctly (diff / PR / package) without asking unless ambiguous.
- Runs static analysis first; summarizes, doesn't restate, linter findings.
- Asks about java-code-style unless the request settles it, loads the house style (project rules, then java-code-style if opted in) before reviewing, and never flags code for following it.
- Leads with bugs and crappy code, and holds the style bar firmly — the primary dimensions visibly drive the review.
- Every finding has `file:line`, snippet, rule citation, and a code fix.
- Severity matches the bar — no false-Critical, no Medium padding, no nit-spam.
- Prefers the simpler design; flags over-engineering as readily as under-engineering.
- Stays under ~1 page for typical PRs (≤500 LOC). Longer only when the diff justifies it.
- Cites the canonical source (house style section, Effective Java item, Google Java Style Guide, JLS, SpotBugs/Checkstyle rule ID).
- The review's own prose has no em dashes (use colons, commas or parentheses).
</success_criteria>
