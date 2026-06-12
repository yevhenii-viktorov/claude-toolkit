# Bugs & Correctness

The "find bugs" core. These are defects that compile and often pass a happy-path test but fail in production. Sources: Effective Java (Bloch), the JLS, SpotBugs bug patterns.

## `==` vs `.equals` on references

`==` compares identity; `.equals` compares value. On `String`, boxed primitives (`Integer`, `Long`), `BigDecimal`, and most objects, `==` is a bug.

```java
if (status == "SHIPPED")            // BUG — reference compare; works by luck via interning, fails for runtime strings
if ("SHIPPED".equals(status))       // OK — null-safe too
Integer a = 1000, b = 1000;
if (a == b)                         // BUG — false; outside the -128..127 cache (JLS §5.1.7)
```

- For `BigDecimal`, even `.equals` is a trap: `new BigDecimal("1.0").equals(new BigDecimal("1.00"))` is `false` (scale matters). Use `compareTo() == 0` for numeric equality.
- Prefer `Objects.equals(a, b)` for null-safe value comparison.

## `equals` / `hashCode` / `compareTo` contracts (Effective Java Items 10, 11, 14)

A type used as a `HashMap`/`HashSet` key or in a `TreeMap`/sorted structure **must** honor these contracts. Violations cause silent lookup failures and lost entries.

- Override `hashCode` **whenever** you override `equals` (Item 11). Unequal `hashCode` for equal objects breaks every hash-based collection. SpotBugs `HE_EQUALS_NO_HASHCODE`.
- `equals` must be reflexive, symmetric, transitive, consistent, and `x.equals(null) == false` (Item 10). The classic break: a subclass adding a field to `equals` violates symmetry.
- `equals` must take `Object`, not the concrete type — `boolean equals(Order o)` *overloads* instead of *overriding* and silently does nothing in collections. Use `@Override` to catch this.
- `compareTo` should be **consistent with `equals`** (Item 14); `BigDecimal` famously isn't, which is why a `TreeSet<BigDecimal>` behaves differently from a `HashSet<BigDecimal>`.
- For mutable keys: mutating a field that participates in `equals`/`hashCode` after insertion corrupts the collection.

`record` types generate correct `equals`/`hashCode`/`toString` for you — prefer them for value types.

## Null pointer hazards

- **Dereferencing a known-nullable** — a method documented/annotated `@Nullable`, a `Map.get` that may miss, a chained getter (`a.getB().getC()`) where any link can be null. SpotBugs `NP_NULL_ON_SOME_PATH`.
- **Autoboxing NPE** — unboxing a `null` `Integer`/`Long`/`Boolean` throws NPE, often invisibly:

```java
Map<String, Integer> counts = ...;
int n = counts.get(key);            // BUG — NPE if key absent (null unboxed to int)
boolean flag = config.getBoolean(); // BUG — NPE if returns null Boolean in a condition
```

- **Ternary autoboxing** — `cond ? intValue : nullInteger` unboxes both branches to `int`, NPE on the null branch (JLS §15.25).
- **`Map.getOrDefault` / `Optional` / explicit checks** fix these. Don't pad with null checks for values that genuinely can't be null (that's a code smell) — check what *can* be null.

## Integer overflow & numeric bugs

- `int` arithmetic silently wraps at 2^31. Size/capacity/index/duration math on large or user-controlled values overflows: `int total = a * b;`, `int mid = (low + high) / 2;` (classic binary-search overflow — use `low + (high - low) / 2`). Use `long`, or `Math.addExact`/`multiplyExact` to fail fast.
- `int` division truncates: `5 / 2 == 2`. `double avg = sum / count;` where both are `int` computes integer division *then* widens — wrong. Cast first.
- Money in `double`/`float` — never. `0.1 + 0.2 != 0.3`. Use `BigDecimal` (with explicit scale/rounding) or integer minor units.
- `float`/`double` equality with `==` — compare with a tolerance (`Math.abs(a - b) < EPSILON`), and watch `NaN` (`NaN == NaN` is false; use `Double.isNaN`).

## `switch` fallthrough

Classic colon-form `switch` falls through when a `case` lacks `break`/`return`/`throw`. A missing `break` is a frequent, silent bug. Prefer arrow-form `switch` (no fallthrough) — see modern-java.md. SpotBugs `SF_SWITCH_FALLTHROUGH`.

## Control-flow traps

- **`return`/`continue`/`break` inside `finally`** silently discards an exception thrown (or a value returned) in the `try` block. Never put control flow in `finally`. SpotBugs `FI_*` / compiler lint.
- **Assignment in a condition** — `if (x = getFlag())` instead of `==` (legal when boolean). Suspicious.
- **Empty statement** — stray `;` after `if (...)` / `for (...)` makes the body a no-op.
- **Off-by-one** — `<=` vs `<` on `array.length`, `substring` bounds, loop termination. Check boundary cases explicitly.

## String & formatting bugs

- `String.format` / `printf` argument-count or type mismatch — `%d` with a `String` throws at runtime, not compile. SpotBugs `VA_FORMAT_STRING_*`.
- Locale-dependent `toLowerCase()`/`toUpperCase()` without an explicit `Locale` — the Turkish-`i` bug. Use `toLowerCase(Locale.ROOT)` for protocol/identifier strings.
- `split`, `replaceAll`, `matches` take **regex**, not literal strings — `"a.b.c".split(".")` returns empty. Use `Pattern.quote` or `split("\\.")`.

## Collection & iteration bugs

- **`ConcurrentModificationException`** — structurally modifying a collection while iterating it (other than via the iterator's own `remove`). Use `Iterator.remove`, `removeIf`, or iterate a copy.
- **`Arrays.asList` / `List.of` immutability** — these return fixed-size/immutable lists; `.add`/`.remove` throws `UnsupportedOperationException`.
- **Mixing `==` with `.contains`** on collections of boxed types — `contains` uses `equals`, which is correct; manual `==` loops are the bug.
- **Unchecked cast / raw types** — `(List<Order>) rawList` defers a `ClassCastException` to a later, confusing line. Heed `-Xlint:unchecked`.

## Resource correctness

Covered in depth in exceptions.md — but flag here too: any `Closeable`/`AutoCloseable` (`InputStream`, `Reader`, `Connection`, `Statement`, `ResultSet`, `Stream` from `Files.lines`) not in a try-with-resources leaks on the exception path. SpotBugs `OBL_UNSATISFIED_OBLIGATION`.

## Quick scan

- `==` on `String`/boxed/`BigDecimal` → `.equals`/`compareTo`.
- `equals` without `hashCode`, or `equals(ConcreteType)` without `@Override`.
- Unboxing a possibly-null `Integer`/`Long`/`Boolean`.
- `int` math that can overflow; `int` division where a fraction was meant; money in `double`.
- colon-`switch` case with no `break`.
- `return`/`continue` in `finally`.
- `split(".")` / unescaped regex; `toLowerCase()` without `Locale`.
- modifying a collection during iteration; mutating a `List.of`.
- `AutoCloseable` without try-with-resources.
