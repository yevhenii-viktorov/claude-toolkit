# Code Smells / Crappy Code

The "find crappy code" half of this skill. A smell isn't always a bug — it's code that's hard to read, hard to change, or does more than it needs to. This reference operationalizes the user's own global engineering principles (Simplicity First; Surgical Changes) as review rules: **the minimum code that solves the problem, nothing speculative.** When in doubt, ask: *"Would a senior engineer call this overcomplicated?"* If yes, flag it and show the smaller version.

Sources: Effective Java (Bloch), Refactoring (Fowler), and the user's `CLAUDE.md` (§2 Simplicity First, §3 Surgical Changes).

## Over-engineering & speculative generality — flag as readily as bugs

The most common crappy-code pattern in otherwise-working Java.

- **Single-use abstraction** — an interface with one implementation, a strategy pattern with one strategy, a factory that builds one type. YAGNI. Inline it until a second caller actually exists. (Effective Java Item 64 is about *programming to interfaces that have multiple impls* — a 1:1 interface isn't that.)
- **Unrequested configurability** — constructor flags, options objects, and `protected` hooks for variation nobody asked for. Each knob is a maintenance and test burden.
- **Premature framework** — a generic engine/registry/plugin system for two concrete cases. Write the two cases.
- **Layered indirection** — `Service → ServiceImpl → Delegate → Helper` where each layer just forwards. Collapse it.
- **Reflection / annotations / dynamic dispatch** where a direct call works.
- **Defensive code for impossible states** — `null` checks on values that can't be null given the call graph, `default:` branches over exhaustive enums that throw "can't happen". (Genuine external-input validation is different — keep that.)

```java
// SMELL — interface + impl + factory for one concrete behavior
interface PriceCalculator { BigDecimal calc(Order o); }
class DefaultPriceCalculator implements PriceCalculator { ... }
class PriceCalculatorFactory { static PriceCalculator create() { return new DefaultPriceCalculator(); } }
// FIX — one class, one method, until a second impl is real
class PriceCalculator { BigDecimal calc(Order o) { ... } }
```

## God class / God method

- **God class** — a class doing several unrelated jobs (parsing + persistence + HTTP + formatting). Symptoms: hundreds of lines, many unrelated fields, "and" in the class's one-line description. Split by responsibility (SRP).
- **Long method** — past ~40–50 lines or doing several distinct steps, it should be decomposed into named helpers. The win is *readable names for the steps*, not line count for its own sake.
- **Deep nesting / arrow code** — 3+ levels of `if`/`for` nesting. Fix with guard clauses (early return), extracting the inner loop body to a method, or inverting conditions.
- **Long parameter list** — 4+ parameters, especially several of the same type (call-site argument-order bugs). Introduce a parameter object / `record`, or a builder.

## Primitive obsession

Modeling domain concepts as bare `String`/`int`/`Map` instead of types.

```java
// SMELL
void transfer(String fromIban, String toIban, long amountCents, String currency)
// FIX — types make illegal states unrepresentable and kill argument-swap bugs
void transfer(Account from, Account to, Money amount)
```

- `Map<String, Object>` / `Map<String, List<Map<...>>>` as a stand-in for a real type — make a `record`.
- String constants for a closed set of values — make an `enum`.
- A pair of parallel arrays / a `String` with a delimiter — make a type.

## Boolean trap

A boolean parameter forces the reader to look up what `true` means at every call site.

```java
process(order, true, false);            // SMELL — true/false meaning is opaque
process(order, Mode.ASYNC, Retry.NONE); // FIX — enums, or split into two methods
```

Two booleans = four call meanings to keep straight. Prefer enums or separate methods.

## Magic numbers & strings

Unexplained literals in logic (`if (status == 3)`, `Thread.sleep(86400000)`, `retry < 5`). Name them: `private static final int STATUS_SHIPPED = 3;`, `Duration.ofDays(1)`. Exceptions: `0`, `1`, `-1`, and `2` in obvious idioms don't need naming.

## Dead & duplicated code

- **Dead code** — unused private methods/fields, unreachable branches, code behind permanently-false flags, commented-out blocks. Delete it (note pre-existing dead code rather than deleting it during an unrelated review — per Surgical Changes).
- **Duplication** — the same 5+ lines in 3+ places, parallel `switch`/`if-else` chains over the same type. Extract a method/constant. (But don't over-DRY: two lines that are coincidentally similar aren't duplication — premature extraction couples unrelated code.)

## Needless mutability

- Mutable field that's only set in the constructor — make it `final` (Effective Java Item 17).
- Mutable static state (non-final static collections/counters) — a thread-safety and test-isolation hazard (see concurrency.md).
- Returning the internal mutable collection directly — leaks the invariant (see api-design.md / bugs-correctness.md).
- A class that could be immutable but exposes setters — immutable is the default; setters need justification.

## Feature envy / misplaced responsibility

A method that reaches deeply into another object's fields (`order.getCustomer().getAddress().getCity()`) probably belongs on that object (Law of Demeter). The chain is also NPE-prone. Add a method to the owning type (`order.shippingCity()`).

## Inheritance where composition fits (Effective Java Item 18)

Extending a class to reuse a few methods, overriding to change behavior in fragile ways, or `extends` across package boundaries you don't control. Prefer composition + delegation. Deep hierarchies (3+ levels) are a maintenance smell.

## Comments that signal trouble

- A comment explaining *what* a confusingly-named variable holds → rename the variable instead.
- A block comment dividing one method into "sections" → that's several methods.
- `// HACK` / `// this is wrong but` left in production → flag.

## Quick scan

- Interface/strategy/factory with exactly one implementation → inline.
- Config flags / hooks for variation nobody requested → remove.
- Method > ~50 lines or 3+ nesting levels → decompose.
- 4+ params, repeated types → parameter object / builder.
- `Map<String, Object>` modeling a real entity → `record`.
- Boolean parameter(s) → enum or split method.
- Magic literal in logic → named constant.
- Non-final field set once / mutable static → tighten.
- Same block in 3+ places → extract.
- Deep getter chains → move the behavior.
