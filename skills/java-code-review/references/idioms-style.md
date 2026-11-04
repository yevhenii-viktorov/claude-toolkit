# Idioms & Style

Sources: [Google Java Style Guide](https://google.github.io/styleguide/javaguide.html), [Effective Java, 3rd ed.](https://www.oreilly.com/library/view/effective-java-3rd/9780134686097/) (Bloch), the [JLS](https://docs.oracle.com/javase/specs/). This is a **primary** dimension for this skill — hold the bar firmly. But flag style that hurts readability or correctness, not formatting Checkstyle already owns.

**House style wins.** Where this file and the project's `AGENTS.md`/`CLAUDE.md` or the java-code-style skill (when opted in) disagree, follow those (see SKILL.md `<style_sources>`).

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

House style (`java-code-style: Effectively final`):
- **Every local variable that is never reassigned is `final`**, including enhanced-for variables (`for (final Order order : orders)`).
- **Every field is `final`.** JPA entities are the only exception. A non-final field with no reassignment path is a mutability smell (Effective Java Item 17).
- **Method, lambda and catch parameters are not `final`.** `final` on a parameter is a nit, not a virtue.
- **Classes don't need to be `final`.** `final` is about fields and locals; never flag a class for missing it.

## No `var`

House style (`java-code-style: Effectively final`): don't use `var`; declare the type. Reviews happen in GitHub diffs, where a reader can't hover to see what `var` inferred, so even an "obvious" `var` costs the reviewer. Flag every new `var` (Low), with the explicit `final` declaration as the fix.

```java
var result = service.process(input);              // BAD — what is result?
final ProcessResult result = service.process(input);  // GOOD
for (final Map.Entry<String, Order> entry : orders.entrySet()) { ... }
```

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
- House order: all other imports, a blank line, `java.*`/`javax.*`/`jakarta.*`, then static imports. Usually checkstyle enforces it; don't restate.
- No static imports outside tests. In tests, static imports for `assertThat`, Mockito and MockMvc matchers are expected.

## Comments

House style (`java-code-style: Comments`):
- **No explanatory comments and no Javadoc on application code.** Names carry the meaning. Flag a comment that explains code: the fix is a better name or a smaller method, and the rationale moves to the commit message or the README.
- No commented-out code blocks — that's what version control is for. Flag them for deletion.
- A `TODO` needs a ticket reference, or it goes.
- Javadoc only on a **published library's** public API.

## Strings

- Build strings with `"...".formatted(...)` and text blocks, not `String.format` or long `+` chains (`java-code-style: Idioms`). Exception messages included.

## Helpers and overloads

- Helpers are small and `private`, and `static` when they touch no instance state.
- Overloads sit next to each other (checkstyle). A private helper gets its own name instead of overloading a public method.

## Common findings (quick scan)

- `userID` / `parseHTTPRequest` — wrong initialism casing.
- `getName()` hand-written on a `record` — use the accessor `name()`.
- Non-`final` field set exactly once — should be `final`.
- `Optional.get()` without a presence check.
- `Optional` field or parameter — wrong place for `Optional`.
- Wildcard import.
- `else` after `return`/`throw`.
- Braceless `if` body.
- Commented-out code; any explanatory comment or Javadoc on application code; TODO without a ticket.
- Non-reassigned local without `final`; `final` on a parameter.
- Any `var`: declare the type.
- `String.format` or a `+` chain where `formatted` or a text block reads better.
- Non-private helper used in one class; instance helper that touches no state.
