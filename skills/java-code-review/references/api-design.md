# API Design

Sources: Effective Java Items 15–25, 49–56. Calibrate to the quality bar: full rigor (and the `[library]` checklist items) for **published libraries / stable public APIs**; for internal code, demand sound design but don't require Javadoc-on-everything.

## Immutability is the default (Items 15, 17)

- **Minimize mutability.** A class with all-`final` fields, no setters, and defensive copies is easier to reason about, share across threads, and cache. Make types immutable unless there's a concrete reason not to.
- Prefer `record` for value types (Java 16+) — immutable, with generated `equals`/`hashCode`/`toString`. (See modern-java.md.)
- **Defensive copies** (Item 50): copy mutable constructor arguments *in*, and copy mutable internal state *out* of getters — otherwise the caller holds a reference to your internals and can break your invariants. SpotBugs `EI_EXPOSE_REP` / `EI_EXPOSE_REP2`.

```java
// BUG — caller can mutate our internal list and our date after construction
private final List<Item> items;
private final Date created;
Order(List<Item> items, Date created) { this.items = items; this.created = created; }
List<Item> items() { return items; }
// FIX
Order(List<Item> items, Date created) {
    this.items = List.copyOf(items);          // copy in
    this.created = new Date(created.getTime());// (or use Instant — immutable)
}
List<Item> items() { return items; }           // already unmodifiable via copyOf
```

(Better still: take `Instant`/`LocalDateTime` — immutable — and avoid the `Date` copy entirely.)

## Composition over inheritance (Items 18–19)

- Favor composition + delegation over `extends`. Inheritance breaks encapsulation: a subclass depends on the superclass's implementation details and is fragile across versions.
- If you do design for inheritance, document the self-use of overridable methods, and otherwise **make the class `final`** (Item 19). A non-final class with overridable methods and no design intent is a hazard.
- Never call an overridable method from a constructor — the subclass override runs before the subclass is initialized.

## Interfaces (Items 20–22)

- Prefer interfaces to abstract classes for type definition. Keep them small and focused (interface segregation) — a fat interface forces implementers to stub methods.
- Don't define a constant interface (Item 22) — constants belong on the class/enum they describe, not a marker interface implementers `extends`.
- A single-implementation interface is usually over-engineering (see code-smells.md) — introduce the interface when a second implementation or a real seam exists.

## Method & parameter design (Items 49–56)

- **Validate parameters** (Item 49) at public-API boundaries — `Objects.requireNonNull`, range checks — and fail fast with a clear message. (But not defensive checks for states the call graph makes impossible — that's a smell.)
- **Return empty, not `null`** (Item 54), for collections/arrays/optionals.
- **`Optional` for "maybe absent" returns** (Item 55), not for params/fields. (See idioms-style.md.)
- **Builder for many parameters** (Item 2), especially optional ones — beats telescoping constructors and avoids the boolean/argument-order traps.
- **Minimize accessibility** (Item 15) — `private` by default, widen only as needed. Public mutable fields are almost always wrong; expose behavior, not state.
- **Overloading**: don't overload methods with the same arg count and ambiguous types (Item 52) — dispatch is by static type and surprises readers.
- **Varargs**: fine, but guard the zero-args case if it's invalid (Item 53).

## Nullability contracts

- Document/annotate nullability (`@Nullable`/`@NonNull` if the project uses them) at API boundaries so callers know. Consistency matters more than which annotation library.
- Don't return `Optional` *and* sometimes `null` — pick one (a `null` `Optional` is the worst of both).

## Quick scan

- Mutable type that could be a `record` / immutable class.
- Mutable constructor arg stored directly, or mutable internal returned by getter (no defensive copy).
- `extends` for code reuse where composition fits; non-final class with overridable methods and no inheritance design.
- Constant interface; single-impl interface with no real seam.
- `null` returned for a collection/array.
- Telescoping constructors where a builder belongs.
- Public mutable field; over-wide accessibility.
- Unvalidated public-API parameters (or defensive checks for impossible states).
