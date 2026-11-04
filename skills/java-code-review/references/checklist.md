# Master Review Checklist

Scan every Java review against this list. Each row points to the reference with the full rule and code examples — open only the references the diff hits. The first four sections are this skill's **primary focus**: review them hardest.

**Bar:** very good production code, not OSS-library-author-grade. Items marked **[library]** apply only when the package is a published/external library — skip them for internal code unless the user says otherwise.

## ★ House style → project `AGENTS.md`/`CLAUDE.md` + java-code-style if opted in (they win over every row below)
- [ ] No explanatory comments or Javadoc on application code; rationale belongs in the commit or README.
- [ ] Records for DTOs, value objects and `@ConfigurationProperties`; normalisation in the compact constructor.
- [ ] `"...".formatted(...)` and text blocks, not `String.format` or `+` chains.
- [ ] Lombok only `@RequiredArgsConstructor`, `@Slf4j`, and `@Getter`/`@Setter`/`@NoArgsConstructor(access = PROTECTED)` on entities. No `@Value`/`@Data`/`@Builder`.
- [ ] Spring: constructor injection into `private final` fields; `@Transactional` only on service methods (`readOnly = true` for queries); thin controllers.
- [ ] Time comes from the injected `Clock`; `Instant.now()` only in entity `@PrePersist`/`@PreUpdate`.
- [ ] One `RuntimeException` subclass per failure, message built in its constructor; HTTP status mapped only in the `@RestControllerAdvice`; one error shape.
- [ ] SLF4J `{}` placeholders, logging only at boundaries; no secrets or request bodies in logs.
- [ ] Schema change = new Flyway migration; an applied one is never edited.
- [ ] Project-specific rules in `AGENTS.md` (package layout, naming suffixes, audit/metrics conventions, golden files) are followed.

## ★ Idioms & style → idioms-style.md
- [ ] Casing: `UpperCamelCase` types, `lowerCamelCase` members, `UPPER_SNAKE` only for deeply-immutable constants.
- [ ] Initialisms as words: `userId`, `parseHttpRequest` — not `userID`/`parseHTTPRequest`.
- [ ] Every field `final` (entities exempt); every non-reassigned local `final`; parameters not `final`; classes not required to be `final`.
- [ ] No `var`; types are declared.
- [ ] Early return; no `else` after `return`/`throw`; braces on all bodies; no Yoda conditions.
- [ ] `Optional` returned (never `null`) for maybe-absent; not used for fields/params; no blind `.get()`.
- [ ] No wildcard imports, unused imports or static imports outside tests; no commented-out code.

## ★ Code smells / crappy code → code-smells.md
- [ ] No single-use abstraction (interface/strategy/factory with one impl), no unrequested configurability, no premature framework.
- [ ] No defensive handling of impossible states; no needless indirection layers.
- [ ] No god class / overlong method / deep nesting; long param lists → a parameter `record`.
- [ ] No primitive obsession (`Map<String,Object>` / string-typed domain concepts → `record`/`enum`/type).
- [ ] No boolean-trap parameters; no magic numbers/strings in logic.
- [ ] No dead or duplicated code; no needless mutability; composition preferred over inheritance.

## ★ Bugs & correctness → bugs-correctness.md
- [ ] `.equals`/`Objects.equals` (not `==`) on `String`/boxed; `compareTo()==0` for `BigDecimal` value equality.
- [ ] `hashCode` overridden whenever `equals` is; `equals(Object)` with `@Override` (not an overload); contracts honored for map/set/sorted keys.
- [ ] No unboxing of a possibly-null `Integer`/`Long`/`Boolean`; no NPE on chained getters / `Map.get`.
- [ ] No `int` overflow in size/index/capacity math; no `int` division where a fraction is meant; no money in `double`/`float`.
- [ ] No colon-`switch` fallthrough; no `return`/`throw` in `finally`; no off-by-one at bounds.
- [ ] `split`/`replaceAll` regex escaped; `toLowerCase(Locale.ROOT)` for identifiers; no `ConcurrentModificationException`; no mutating `List.of`.

## Exceptions & resources → exceptions.md
- [ ] No swallowed exception (empty / log-only catch on a side-effectful call).
- [ ] Catch the specific type, not `Exception`/`Throwable`/`RuntimeException`; multi-catch where apt.
- [ ] Every `AutoCloseable` in try-with-resources; no manual `finally { close(); }`.
- [ ] Exceptions not used for normal control flow; no `throws Exception` on signatures.
- [ ] Cause chained on translation (`new X(msg, e)`); not logged-and-rethrown twice.

## Concurrency → concurrency.md
- [ ] No shared mutable state without sync/volatile/atomic; no mutable state on a singleton.
- [ ] `volatile` counters aren't `++`'d (use `Atomic*`); locks held briefly; lock on a `private final` object.
- [ ] DCL has `volatile` (or holder idiom); `SimpleDateFormat`/`Calendar` not shared (use `java.time`).
- [ ] `ExecutorService` shut down; `InterruptedException` not swallowed; `Future` exceptions not dropped.
- [ ] Virtual threads not blocking inside `synchronized`; `ThreadLocal` removed in pooled threads.

## Collections & streams → collections-streams.md
- [ ] No side-effecting `forEach` for computation (use `collect`/`toList`); no overlong stream where a loop is clearer.
- [ ] `findFirst`/`reduce` `Optional` handled; `Collectors.toMap` has a merger if keys can collide.
- [ ] Return empty (not `null`) for collections; internal mutable collections not leaked (copy/unmodifiable).
- [ ] Right collection type; presized when size known; no `Vector`/`Hashtable`/`Stack` in new code.

## API design → api-design.md
- [ ] Types immutable by default (`record`/all-`final`); defensive copies in and out for mutable members.
- [ ] Composition over inheritance.
- [ ] Small focused interfaces; no constant interface; no single-impl interface without a real seam.
- [ ] Public-API params validated (Bean Validation on request records; no checks for impossible states); a parameter `record` for many params, not a builder.
- [ ] Accessibility minimized; no public mutable fields.
- [ ] **[library]** Public API has Javadoc; nullability documented at boundaries.

## Security → security.md
- [ ] No string-built SQL / shell command / file path with user input (PreparedStatement / ProcessBuilder / path validation).
- [ ] No native deserialization of untrusted data; XML parsers disable external entities (XXE).
- [ ] No MD5/SHA-1/DES/ECB for security; `SecureRandom` (not `Random`) for tokens; password hashing with bcrypt/Argon2/PBKDF2.
- [ ] No trust-all `TrustManager`/`HostnameVerifier`; secrets not hardcoded or logged.
- [ ] Server-side URL fetch/redirect allowlisted; request bodies bound to DTOs, not entities.

## Performance → performance.md
- [ ] No `String +=` in loops (use `StringBuilder`/`join`); regex compiled once (`static final Pattern`).
- [ ] No autoboxing in loop accumulators; reusable constants not re-`new`'d in loops.
- [ ] Collections presized when size known; no `O(n²)` scan/`contains`-in-loop where a `HashSet`/`Map` fits.
- [ ] Buffered I/O in loops; no whole-file read where streaming fits. (No micro-opt that hurts readability.)

## Testing → testing.md
- [ ] JUnit 5 + AssertJ (no JUnit 4 imports in new code); `jsonPath` in MockMvc; concrete values asserted, not just status codes.
- [ ] Names are camelCase behaviour sentences with no `test`/`should` prefix; right kind and suffix (`*Test` no Spring, `*IT` Spring + Testcontainers, `*E2ETest` black box).
- [ ] Mocks are `final` fields set with `mock(...)`, never `@Mock`/`@InjectMocks`; Spring tests take beans through an `@Autowired` constructor.
- [ ] A behaviour change comes with a test change that would fail without it.
- [ ] No logic in tests (parameterize / use literals); descriptive names; focused assertions.
- [ ] Mock only at boundaries (no over-mocking); deterministic (fixed clock/seed/temp dir, no `sleep`-waits, order-independent).
- [ ] New tests exercise the changed branch; branchy logic covered per-branch and at boundaries.

## Modern Java → modern-java.md
- [ ] Hand-rolled immutable DTO / boilerplate `equals`/`hashCode` → `record`.
- [ ] `instanceof`+cast → `instanceof` pattern; closed subclass set → `sealed`; type-dispatch chain → pattern `switch`.
- [ ] Colon-`switch` with `break` → switch expression; `"\n"`-spliced literal → text block.
- [ ] `Date`/`Calendar`/`SimpleDateFormat` → `java.time`; virtual threads for blocking-I/O scale where natural.

## Project structure → structure.md
- [ ] New packages follow the project's existing layout (feature or layer); no `util`/`common`/`misc` dumping grounds.
- [ ] Accessibility minimized; no public mutable static fields.
- [ ] No new circular dependency; domain doesn't depend on infrastructure; no unused/duplicate build deps.
