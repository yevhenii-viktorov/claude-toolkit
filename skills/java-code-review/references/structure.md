# Project Structure

Sources: Effective Java Item 15 (accessibility), package-design conventions. This is a **low-priority** dimension — flag genuine structural problems, not personal layout preferences.

## Packages

- **Follow the project's package layout.** If `AGENTS.md`/`CLAUDE.md` fixes one (for example layer packages `controller`/`service`/`repository`/`entity`/`model`), new classes go where it says, and a class in the wrong package is a finding. Only when a new module has no convention yet, suggest packaging by feature.
- **No dumping-ground packages** — `util`, `common`, `helpers`, `misc`, `shared`, `core` that accrete unrelated classes. Each such class usually belongs next to what it serves, or in a focused package named for its job. A genuinely shared, cohesive utility is fine; a junk drawer isn't.
- Package names: all lowercase, no underscores, singular (idioms-style.md).

## Visibility & encapsulation (Item 15)

- **Minimize accessibility** — members `private` by default. For top-level classes follow the codebase: Spring components in layer packages are normally `public`; a helper type used only inside its package can be package-private.
- No public mutable static fields (a global mutable-state and thread-safety hazard).

## Dependencies

- **No circular dependencies** between packages/modules — they signal blurred responsibilities and block independent reasoning/testing. Flag a new cycle introduced by the diff.
- **Dependency direction** — domain/core shouldn't depend on infrastructure/framework. A domain class importing a web/JPA/framework type is a leak.
- Don't reach across module boundaries into another module's internals; depend on its API.

## Build & module hygiene

- `module-info.java` (JPMS), if present, should export only intended packages — flag a `requires`/`exports` that leaks internals.
- No unused dependencies added to `pom.xml`/`build.gradle`; no duplicate/ conflicting versions introduced.
- One public top-level type per file, file named after it (compiler-enforced for public types, but flag multiple package-private top-level types crammed in one file when it hurts navigation).

## Quick scan

- New class in a package that breaks the project's documented layout.
- `util`/`common`/`misc`/`helpers` dumping-ground package accreting unrelated classes.
- `public` on a member only used within its class or package.
- Public mutable static field.
- New circular dependency between packages; domain depending on infrastructure.
- Unused/duplicate build dependency added.
