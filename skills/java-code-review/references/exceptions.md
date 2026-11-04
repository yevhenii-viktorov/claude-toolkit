# Exceptions & Resources

Sources: Effective Java Items 69–77, the JLS, SpotBugs. Exception handling is where bugs hide in plain sight — a swallowed exception turns a loud failure into a silent one.

## Swallowed exceptions — the cardinal sin (Effective Java Item 77)

An empty or log-only catch block on a side-effectful operation hides real failures.

```java
// CRITICAL — failure vanishes; caller thinks it succeeded
try {
    repository.save(order);
} catch (Exception e) {
    // ignored
}

// STILL BAD — logs and continues as if nothing happened
} catch (Exception e) {
    log.error("save failed", e);   // ...then proceeds to use a not-saved order
}
```

An empty catch is acceptable only when ignoring is *genuinely correct*; name the variable `ignored` and make the reason clear from the method name (the house style allows no explanatory comments; the rationale goes in the commit). SpotBugs `DE_MIGHT_IGNORE`, `REC_CATCH_EXCEPTION`.

## Catching too broadly (Item 73 spirit)

- `catch (Exception e)` / `catch (Throwable e)` / `catch (RuntimeException e)` around a block that throws specific checked exceptions catches *more than intended* — including `NullPointerException`/`IllegalStateException` that signal bugs, and (for `Throwable`) `Error`s like `OutOfMemoryError` you must not swallow.
- Catch the **most specific** exception you can handle. If you genuinely handle several the same way, Java 7 multi-catch is clearer than a broad catch: `catch (IOException | SQLException e)`.
- Never catch `Error` / `Throwable` to "be safe" — `Error` means the JVM is in trouble.

## Resources — try-with-resources, always (Effective Java Item 9)

Any `AutoCloseable` must be managed by try-with-resources, never a manual `finally { close(); }` (which itself can leak or mask exceptions).

```java
// BUG — leaks on exception; close() in finally can throw and mask the original
Connection c = ds.getConnection();
Statement s = c.createStatement();
... // if this throws, c and s leak

// CORRECT
try (Connection c = ds.getConnection();
     Statement s = c.createStatement();
     ResultSet rs = s.executeQuery(sql)) {
    ...
}
```

- Streams that hold resources (`Files.lines`, `Files.list`, `Files.walk`, JDBC-backed streams) must be closed — wrap in try-with-resources. SpotBugs `OBL_UNSATISFIED_OBLIGATION`.
- Manual `finally { x.close(); }` can throw from `close()` and **replace** the in-flight exception (the original is lost). Try-with-resources suppresses correctly (original wins, close-exception attached as suppressed).

## Exceptions as control flow (Item 69)

Don't use exceptions for ordinary flow — they're for *exceptional* conditions.

```java
// SMELL/BUG — throwing to break a loop, catching to detect end-of-data
try {
    int i = 0;
    while (true) { process(arr[i++]); }
} catch (ArrayIndexOutOfBoundsException e) { /* done */ }
```

Also: don't throw-and-immediately-catch within the same method to simulate `goto`. And don't use `Exception` to return a status — return the status.

## Checked vs unchecked (Items 70–71)

- **Unchecked (`RuntimeException`)** for programming errors / precondition violations the caller can't reasonably recover from (`IllegalArgumentException`, `IllegalStateException`, `NullPointerException`).
- **Checked** for recoverable conditions the caller should handle — but don't over-use them; an unrecoverable checked exception just forces noise. Modern Java leans toward unchecked for most application errors.
- Don't declare `throws Exception` — it tells the caller nothing and forces broad catches. Declare the specific types.

## Losing the cause (Item 75–76 spirit)

When translating an exception, **always** chain the cause:

```java
// BUG — original stack trace and message lost
catch (SQLException e) {
    throw new DataAccessException("load failed");
}
// CORRECT — cause preserved
catch (SQLException e) {
    throw new DataAccessException("load failed for id=%s".formatted(id), e);
}
```

- `throw new X(e.getMessage())` without passing `e` loses the stack trace — a common debugging nightmare. SpotBugs-adjacent; flag it.
- Don't log **and** rethrow the same exception — it gets logged twice at different layers. Log at the boundary that handles it, or rethrow; not both.

## Custom exceptions

House style (`java-code-style: Spring`):
- **One `RuntimeException` subclass per failure case**, with its message built in the constructor using `formatted` (`super("Run '%s' not found".formatted(id))`). Callers pass the domain values, not a message.
- Add a cause-taking constructor only when the exception actually wraps one (for example a failed outbound call).
- The HTTP status is chosen only in the `@RestControllerAdvice`, and every error uses one response shape. Flag `ResponseStatusException`, `@ResponseStatus` on exceptions, or status logic in controllers.
- One type per failure *case*, not per call site: two places that throw for the same reason share a type.

## `finally` hazards (see also bugs-correctness.md)

- `return`/`break`/`continue`/`throw` in `finally` discards any exception or return from `try` — never do it.
- Work in `finally` that can throw will mask the original exception (use try-with-resources instead of manual cleanup).

## Quick scan

- Empty catch, or catch-and-only-log on a side-effectful call → swallowed failure.
- `catch (Exception | Throwable | RuntimeException)` where specific types are thrown.
- `AutoCloseable` without try-with-resources; manual `finally { close(); }`.
- Exceptions driving normal control flow.
- `throws Exception` on a signature.
- `new X(msg)` dropping the cause `e`; log-and-rethrow double logging.
- `return`/`throw` inside `finally`.
