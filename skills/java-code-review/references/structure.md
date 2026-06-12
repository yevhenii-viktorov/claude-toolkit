# Project Structure

Sources: Effective Java Item 15 (accessibility), package-design conventions. This is a **low-priority** dimension — flag genuine structural problems, not personal layout preferences.

## Packages

- **Package by feature, not by layer.** `com.acme.order` (containing the order's controller, service, repo) localizes change better than `com.acme.controller` / `com.acme.service` / `com.acme.repository` split across the whole app. A change to one feature touches one package. Flag layer-only packaging in new modules; don't crusade against it in an established codebase mid-PR (Surgical Changes).
- **No dumping-ground packages** — `util`, `common`, `helpers`, `misc`, `shared`, `core` that accrete unrelated classes. Each such class usually belongs next to what it serves, or in a focused package named for its job. A genuinely shared, cohesive utility is fine; a junk drawer isn't.
- Package names: all lowercase, no underscores, singular (idioms-style.md).

## Visibility & encapsulation (Item 15)

- **Minimize accessibility** — top-level classes `package-private` unless they're part of the module's API; members `private` by default. Public surface is a commitment; keep it small.
- A class only used within its package shouldn't be `public`.
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

- New package organized purely by layer where feature packaging fits.
- `util`/`common`/`misc`/`helpers` dumping-ground package accreting unrelated classes.
- `public` on a class/member only used within its package.
- Public mutable static field.
- New circular dependency between packages; domain depending on infrastructure.
- Unused/duplicate build dependency added.
