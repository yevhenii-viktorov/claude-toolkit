# Collections & Streams

Sources: Effective Java Items 42–48, the Stream/Collections Javadoc. Streams are great for transformation pipelines and terrible when abused for side effects or forced onto code that reads better as a loop.

## Streams: use them for what they're for (Items 45–46)

- **A stream pipeline should be side-effect-free** until the terminal operation. `forEach` that mutates external state is a smell — it's an imperative loop wearing a stream costume:

```java
// SMELL — forEach mutating an external collection
List<String> names = new ArrayList<>();
orders.stream().filter(Order::isOpen).forEach(o -> names.add(o.customerName()));
// FIX — collect
List<String> names = orders.stream()
    .filter(Order::isOpen)
    .map(Order::customerName)
    .toList();
```

- `forEach` is for *consuming* the result (printing, publishing), not for *computing* it. Computation belongs in `map`/`filter`/`collect`/`reduce`.
- **Don't force a stream** where a `for` loop is clearer. A single `filter` + `findFirst` is fine; a 6-stage pipeline with nested lambdas and a custom collector is often less readable than a loop. Readability wins.
- **No stateful lambdas** — a `map`/`filter` lambda that reads/writes shared mutable state breaks under parallelization and is hard to reason about.
- **`peek`** is for debugging only — `peek` with side effects in production is a smell.

## Terminal-op correctness

- `Stream.toList()` (Java 16+) returns an **unmodifiable** list — good default. `collect(Collectors.toList())` returns a mutable list with no guarantee of type; pick deliberately.
- `findFirst`/`findAny`/`reduce` return `Optional` — handle absence; don't `.get()` blindly (see idioms-style.md).
- `count()` after a `filter` that you then also iterate = two passes; restructure.
- `Collectors.toMap` throws on duplicate keys unless you supply a merge function — a common runtime surprise on real data.
- A stream over a resource (`Files.lines`) must be closed (try-with-resources) — see exceptions.md.

## `Optional` in streams

- `stream.map(this::find).filter(Optional::isPresent).map(Optional::get)` → use `.flatMap(Optional::stream)` (Java 9+) or `.mapMulti`.
- Don't build streams of `Optional` as a data model — flatten early.

## Collections: choice & construction

- **Right type for the job**: `ArrayList` for indexed/append, `ArrayDeque` over `Stack`/`LinkedList` for stack/queue, `HashMap` for lookup, `EnumMap`/`EnumSet` for enum keys (Item 37), `LinkedHashMap` when order matters. `Vector`/`Hashtable`/`Stack` are legacy — flag in new code.
- **Preallocate** when size is known: `new ArrayList<>(expectedSize)`, `new HashMap<>(expectedSize)` — avoids rehash/copy churn (see performance.md).
- **Immutable factories**: `List.of`, `Set.of`, `Map.of` for fixed contents (Item 15-adjacent) — but remember they're immutable *and* reject nulls; don't `.add` to them (see bugs-correctness.md).

## Returning collections (Item 54, 50)

- **Return empty, never `null`**, for a collection/array result — `Collections.emptyList()` / `List.of()`. A `null` return forces every caller to null-check and causes NPEs when they forget.
- **Don't leak internal mutable collections** — return an unmodifiable view (`Collections.unmodifiableList`, `List.copyOf`) or a defensive copy, or callers can mutate your invariants (Item 50; SpotBugs `EI_EXPOSE_REP`). See api-design.md.

## Iteration

- `for (var x : coll)` over manual index loops unless you need the index.
- Remove during iteration via `Iterator.remove`/`removeIf`, not by mutating the collection in a for-each (ConcurrentModificationException — bugs-correctness.md).
- `Map` iteration: `entrySet()` when you need both key and value (avoid `keySet()` + `get` — double lookup).

## Quick scan

- `forEach` mutating external state → `collect`/`toList`.
- Overlong stream pipeline that a loop would clarify.
- `Optional.get()` after `findFirst`; stream-of-`Optional` not flattened.
- `Collectors.toMap` with possible duplicate keys, no merger.
- `null` returned for a collection result.
- Internal mutable collection returned directly (no copy/unmodifiable).
- `Vector`/`Hashtable`/`Stack` in new code.
- Collection built without presizing when size is known.
