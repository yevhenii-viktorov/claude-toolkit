# Performance

Sources: Effective Java Items 6, 67. **Measure before optimizing** (Item 67) — don't flag micro-optimizations on cold paths, and don't let "performance" justify unreadable code. Flag the genuine, well-known inefficiencies, especially in loops and hot paths.

## String building (Item 63)

```java
// BAD — O(n²): each += allocates a new String
String s = "";
for (final String part : parts) s += part + ",";
// GOOD
final StringBuilder sb = new StringBuilder();
for (final String part : parts) sb.append(part).append(',');
```

- `+` in a loop → `StringBuilder`. (A few `+` outside a loop is fine — the compiler handles it.)
- `String.join` / `Collectors.joining` for simple concatenation with a delimiter.

## Avoid needless object creation (Item 6)

- **Recompiling regex per call** — `s.matches("...")` and `Pattern.compile` inside a method called in a loop recompile every time. Hoist to a `private static final Pattern` and reuse.
- **Autoboxing in hot paths/loops** — `Long sum = 0L; for (...) sum += i;` boxes on every iteration. Use the primitive. SpotBugs-adjacent.
- **`new` of cheap immutables in a loop** — `new BigDecimal("0")` vs `BigDecimal.ZERO`, `Boolean.valueOf` vs `new Boolean`. Reuse constants.
- Don't over-apply: object pooling and `sync.Pool`-style tricks are usually premature in modern JVMs (escape analysis, fast allocation). Reserve for measured hot paths.

## Collections sizing & choice

- **Presize** when the size is known: `new ArrayList<>(n)`, `new HashMap<>(expectedSize)`. Avoids repeated grow-and-copy / rehash. (See collections-streams.md for type choice.)
- `EnumMap`/`EnumSet` over `HashMap`/`HashSet` for enum keys — array-backed, faster, ordered.
- `ArrayDeque` over `LinkedList` for queue/stack — better locality, less allocation.
- Iterating a `Map` via `keySet()` + `get(k)` does two lookups per entry; use `entrySet()`.

## I/O & streams

- Wrap raw streams in buffers (`BufferedReader`/`BufferedInputStream`) for byte/char I/O in loops, or use `Files.readAllLines`/`Files.lines` appropriately.
- Don't read a large file fully into memory when you can stream it.
- Close resources (try-with-resources) — leaks degrade the whole process (see exceptions.md).

## Algorithmic

- **Nested loop over the same collection** (`O(n²)`) where a `HashSet`/`HashMap` lookup gives `O(n)` — e.g. "for each a, scan all b to find a match." Flag when `n` can be large.
- Repeated `list.contains` inside a loop on an `ArrayList` is `O(n²)` — use a `HashSet`.
- Sorting or building a structure inside a loop that could be done once outside it.

## Streams vs loops

- Streams have per-element overhead (boxing, lambda indirection). On a measured hot path with primitives, a plain loop or an `IntStream`/`LongStream` (no boxing) may be warranted. Don't rewrite cold-path streams into loops for "performance" — readability wins there.

## Quick scan

- `String +=` in a loop → `StringBuilder`/`join`.
- `Pattern.compile` / `s.matches(...)` inside a frequently-called method → hoist to `static final`.
- Autoboxing in a loop accumulator; `new` of a reusable constant in a loop.
- Collection built without presizing when size is known.
- `O(n²)`: nested scan or `ArrayList.contains` in a loop where a `HashSet`/`HashMap` fits.
- Unbuffered byte/char I/O in a loop; whole-file read where streaming fits.
- (Resist) micro-optimizations on cold paths that hurt readability.
