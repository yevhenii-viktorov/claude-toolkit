# Modern Java

Baseline: **the project's Java version** (check `java.version`/`release` in the build; at least 21). Treat these constructs as the idiomatic default and flag verbose legacy equivalents — but only when the modern form genuinely reads better. Don't demand a rewrite for its own sake. Cross-references idioms-style.md.

## Records (Java 16) — for value/data types

A `record` is the right tool for an immutable data carrier: it generates a canonical constructor, accessors (`name()`, not `getName()`), `equals`/`hashCode`/`toString`.

```java
// LEGACY — 40 lines of boilerplate, hand-written equals/hashCode (easy to get wrong)
final class Point { private final int x, y; /* ctor, getters, equals, hashCode, toString */ }
// MODERN
record Point(int x, int y) {}
```

- Flag hand-written immutable DTOs/value objects that should be records (especially ones with hand-rolled `equals`/`hashCode` — a correctness risk, see bugs-correctness.md).
- Records are also the house choice for Spring `@ConfigurationProperties`.
- Records can have compact constructors for validation/normalization and defensive copies — use them (house style puts normalisation, such as trimming a name, there).
- Records are *not* for mutable entities (JPA `@Entity`) or types needing inheritance — don't force it.

## Sealed types (Java 17) — closed hierarchies

`sealed interface Shape permits Circle, Square {}` makes the set of subtypes explicit and lets `switch` be **exhaustive** (no `default` needed, compiler enforces all cases). Ideal for algebraic-data-type modeling. Flag a comment-documented "these are the only subclasses" hierarchy that should be `sealed`.

## Pattern matching

- **`instanceof` pattern** (Java 16): `if (o instanceof Order order) { use(order); }` — replaces the `instanceof` + cast pair (which risks a redundant/ wrong cast). Flag the old form.

```java
// LEGACY
if (o instanceof Order) { Order order = (Order) o; ... }
// MODERN
if (o instanceof Order order) { ... }
```

- **Pattern matching for `switch`** (Java 21): switch over types, with guards (`when`) and record deconstruction. Combined with sealed types, gives exhaustive, safe type dispatch — replaces `if/else instanceof` chains and visitor boilerplate.

## Switch expressions (Java 14) — over statement switches

Arrow form returns a value, has **no fallthrough**, and is exhaustive over enums/sealed types:

```java
// LEGACY — fallthrough-prone, mutable accumulator
String label;
switch (status) {
    case SHIPPED: label = "shipped"; break;   // forget break → bug
    default: label = "unknown";
}
// MODERN
String label = switch (status) {
    case SHIPPED -> "shipped";
    case PENDING -> "pending";
    case CANCELLED -> "cancelled";   // exhaustive: compiler flags a missing enum constant
};
```

Flag colon-form switches with `break`-per-case where an expression switch is clearer and removes fallthrough risk (bugs-correctness.md).

## Text blocks (Java 15)

For multi-line string literals (SQL, JSON, HTML), `"""..."""` beats `"\n"`-spliced concatenation — readable and fewer escaping bugs. For interpolation, `"...".formatted(...)` is the house choice over `String.format`.

## Virtual threads (Java 21)

For high-concurrency **blocking I/O**, `Executors.newVirtualThreadPerTaskExecutor()` / `Thread.ofVirtual()` lets you write straightforward blocking code at scale instead of reactive callback chains. See concurrency.md for the pinning caveat (avoid `synchronized` around blocking calls; prefer `ReentrantLock`). Don't use for CPU-bound work.

## Smaller wins

- **`var`** (Java 10): not used; the house style declares types (idioms-style.md).
- **`Optional.stream()`** (Java 9), **`Stream.toList()`** (Java 16), `Collectors.teeing` — see collections-streams.md.
- **`List.of`/`Map.of`/`Set.of`** (Java 9) for small immutable collections.
- **`java.time`** over `Date`/`Calendar`/`SimpleDateFormat` — immutable, thread-safe, clearer (a correctness win, see concurrency.md).
- **Helpful NPE messages** (Java 14, on by default) — no action, but means a raw NPE now names the null variable.

## Quick scan

- Hand-written immutable DTO with boilerplate / hand-rolled `equals`/`hashCode` → `record`.
- `instanceof` + explicit cast → `instanceof` pattern.
- Comment-documented closed subclass set → `sealed`.
- Colon-`switch` with per-case `break` / fallthrough risk → switch expression.
- `if/else instanceof` type-dispatch chain → pattern-matching `switch` (+ sealed).
- `"\n"`-concatenated multi-line literal → text block.
- `Date`/`Calendar`/`SimpleDateFormat` → `java.time`.
- Reactive/callback ceremony for blocking I/O where virtual threads simplify.
