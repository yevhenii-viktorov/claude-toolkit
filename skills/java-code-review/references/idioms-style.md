# Idioms & Style

Sources: [Google Java Style Guide](https://google.github.io/styleguide/javaguide.html), [Effective Java, 3rd ed.](https://www.oreilly.com/library/view/effective-java-3rd/9780134686097/) (Bloch), the [JLS](https://docs.oracle.com/javase/specs/). This is a **primary** dimension for this skill — hold the bar firmly. But flag style that hurts readability or correctness, not formatting Checkstyle already owns.

## Naming

### Casing (Google §5.2)
- Classes/interfaces/enums/records: `UpperCamelCase` — `OrderService`, `HttpClient`.
- Methods/fields/parameters/locals: `lowerCamelCase` — `parseUrl`, `maxRetries`.
- Constants (`static final`, deeply immutable): `UPPER_SNAKE_CASE` — `MAX_PACKET_SIZE`. A `static final` field that is **not** deeply immutable (e.g. a mutable map) is *not* a constant — name it `lowerCamelCase`.
- Type parameters: single capital letter (`T`, `K`, `V`, `E`) or `UpperCamelCase` ending in `T` (`RequestT`).
- Packages: all lowercase, no underscores — `com.acme.order`, not `com.acme.Order_Util`.

### Initialisms (Google §5.3)
Treat acronyms as words: `userId`, `parseHttpRequest`, `xmlParser`, `loadHtmlPage` — **not** `userID`, `parseHTTPRequest`, `XMLParser`. (This is the opposite of Go; the Google guide is explicit.)

```java
// BAD                          // GOOD
String userID;                  String userId;
void parseURL();                void parseUrl();
class HTTPClient {}             class HttpClient {}
```

### No `get`-prefix ceremony where it doesn't fit
`getX()`/`setX()` is the JavaBeans convention and is fine for beans/DTOs. But a `record` exposes `x()`, not `getX()` — don't hand-write `getX()` wrappers on records. Boolean getters read as `isActive()`/`hasNext()`.

### Meaningful names; no Hungarian, no noise
- No `strName`, `iCount`, `lstOrders` — the type is in the declaration.
- No noise words: `OrderData`, `OrderInfo`, `OrderManager`, `OrderObject` usually mean `Order`. `AbstractOrderFactoryBean` is a smell (see code-smells.md).
- Scope sets length: loop index `i`, short-lived `e`/`it`; fields and public methods are descriptive.

## `final`

- **Local variables and parameters that are never reassigned should be `final`** when the codebase uses that convention — it documents intent and prevents accidental reassignment. Apply consistently with the surrounding file; don't sprinkle `final` into a file that doesn't use it.
- **Fields that are set once should be `final`.** A non-final field with no reassignment path is a mutability smell (Effective Java Item 17).
- **Make classes `final`** unless they're explicitly designed and documented for extension (Effective Java Item 19: "design and document for inheritance or else prohibit it").

## `var` (local-variable type inference, Java 10+)

Use `var` when the initializer makes the type obvious; avoid it when it hides the type.

```java
var orders = new ArrayList<Order>();        // GOOD — type is right there
var result = service.process(input);        // QUESTIONABLE — what type is result?
var count = 3;                              // BAD — is this int or long? be explicit for primitives that matter
```

- Good: `new` expressions, obvious factory calls, `for (var entry : map.entrySet())`.
- Avoid: when the RHS is a bare method call returning a non-obvious type, for `null`/literals where the inferred type surprises, or where it harms a reader scanning the code.

## Control flow

### Early return; no `else` after `return`
```java
// BAD
if (x == null) {
    return defaultValue;
} else {
    return compute(x);
}
// GOOD
if (x == null) {
    return defaultValue;
}
return compute(x);
```
Reduces nesting. Same for `continue`/`break`/`throw`.

### No Yoda conditions
`if (x == 3)`, not `if (3 == x)`. The NPE-avoidance reason (`CONST.equals(x)`) is legitimate **only** when `x` may be null and `CONST` is non-null — call that out as intent, don't apply it blindly.

### Braces always (Google §4.1.1)
Even one-line `if`/`for`/`while` bodies get braces. Braceless bodies are the goto-fail class of bug.

### `switch` — prefer expressions (see modern-java.md)
Arrow-form `switch` expressions (`case X -> ...`) avoid fallthrough bugs and are exhaustive over enums/sealed types. Classic `switch` with `:` and implicit fallthrough is error-prone — every non-empty case needs a `break`/`return`/`throw` or a `// fall through` comment.

## `Optional` (Effective Java Item 55)

- **Return** `Optional<T>` for "might be absent" results. **Never** return `null` from a method declared to return `Optional`.
- **Don't** use `Optional` for fields, method parameters, or collection elements — it adds allocation and noise. An absent collection is empty (`List.of()`), not `Optional<List>`.
- **Don't** call `.get()` without first proving presence — it's the `Optional` equivalent of `null` deref. Use `orElse`, `orElseGet`, `orElseThrow`, `map`, `ifPresent`.
- `Optional.ofNullable(x).orElse(y)` over `x != null ? x : y` only when it reads cleaner — don't wrap a simple null-check in `Optional` ceremony.

```java
// BAD
Optional<Order> o = repo.find(id);
return o.get();                          // throws if empty — pointless Optional
// GOOD
return repo.find(id).orElseThrow(() -> new OrderNotFoundException(id));
```

## Imports (Google §3.3)

- **No wildcard imports** (`import java.util.*;`) — Checkstyle flags them.
- No unused imports.
- One ordering, applied consistently (Google: single ASCII-sorted block; many projects group `java`/`javax`, third-party, then project — match the file).
- Static imports sparingly, for genuinely improved readability (`assertThat`, `Math.max`) — not to hide where a symbol comes from.

## Comments

- Explain **why**, not **what** — the code shows what. A comment restating the line is noise; delete it.
- No commented-out code blocks — that's what version control is for. Flag them for deletion.
- `// TODO(owner): description` — assign accountability. Ownerless, undated TODOs rot.
- Javadoc on **published-library** public API is expected; on internal helpers it's usually noise (per the quality bar — don't demand it).

## Common findings (quick scan)

- `userID` / `parseHTTPRequest` — wrong initialism casing.
- `getName()` hand-written on a `record` — use the accessor `name()`.
- Non-`final` field set exactly once — should be `final`.
- `Optional.get()` without a presence check.
- `Optional` field or parameter — wrong place for `Optional`.
- Wildcard import.
- `else` after `return`/`throw`.
- Braceless `if` body.
- Commented-out code; what-not-why comments; ownerless TODOs.
- `var x = something()` where the type is non-obvious.
