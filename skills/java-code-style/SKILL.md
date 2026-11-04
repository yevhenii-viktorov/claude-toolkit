---
name: java-code-style
description: House Java code style (prebid-server-java formatting, final everywhere, no var, no comments, restricted Lombok, Spring and test conventions). Use when writing, changing or reviewing Java code (pom.xml, build.gradle or .java files present), or when asked about Java code style or conventions.
---

# Java code style

Default style for Java projects. A project's own checkstyle, `.editorconfig`, AGENTS.md/CLAUDE.md or existing code
wins where it differs; when a repo has none of those, follow this file.

## Formatting

Google Java Style adapted the prebid-server-java way:
- 4-space indent, 8-space continuation, 120-character lines, no tabs, no trailing spaces, newline at end of file.
- Braces are always required (K&R style). A method's closing brace stands on its own line.
- A blank line after every class, record, enum or interface header. Never more than one blank line in a row.
- Wrapped lines start with `.` and end with `,`. Operators wrap to the start of the new line.
- Imports:
  - no wildcards, no static imports outside tests, no unused imports;
  - order: all other imports, a blank line, `java.*`/`javax.*`/`jakarta.*`, then static imports.
- Never use `System.out`/`System.err`; use a logger.

## Effectively final

- Every local variable that is never reassigned is `final`, including enhanced-for variables.
- Every field is `final`. JPA entities are the only exception.
- Method, lambda and catch parameters are not marked `final`.
- No `var`: declare the type. Code is reviewed in GitHub diffs, where an inferred type can't be looked up.

## Comments

- No explanatory comments and no Javadoc on application code. Names carry the meaning.
- Rationale goes in the commit message or the README.
- Javadoc only for a published library's public API.

## Idioms (modern Java)

- **Records:** use them for DTOs, value objects and Spring `@ConfigurationProperties`. Put normalisation in the
  compact constructor, for example trimming a name.
- **Strings:** `"...".formatted(...)` and text blocks, not `String.format` or long concatenation.
- **Streams:** end with `.toList()`. Use pattern matching for `instanceof` and switch expressions where they read
  better.
- **Optional:** use it for "may be absent" returns. Never as a parameter or a field.
- **Immutable collections:** `List.of`, `Set.of`, `Map.of`, `EnumSet`; copy defensively at boundaries.
- **Helpers:** small and private, and `static` when they touch no instance state. Keep overloads next to each
  other; give a private helper its own name rather than overloading a public method.
- No speculative abstractions: no interface with one implementation, no config knob nobody asked for.

## Lombok

Only use:
- `@RequiredArgsConstructor` for constructor injection;
- `@Slf4j`;
- `@Getter`, `@Setter` and `@NoArgsConstructor(access = AccessLevel.PROTECTED)` on JPA entities.

Don't use `@Value`, `@Data` or `@Builder`: they hide mutability or finality from checkstyle and readers. When a
constructor parameter needs Spring's `@Value`, write the constructor by hand.

## Spring

- **Injection:** constructor injection into `private final` fields. No field injection in main code.
- **Transactions:** `@Transactional` on service methods only, with `readOnly = true` for queries.
- **Time:** business logic reads it from an injected `Clock` (`clock.instant()`, `LocalDate.now(clock)`) so tests
  can fix it. Only entity lifecycle callbacks (`@PrePersist`/`@PreUpdate`) may call `Instant.now()`.
- **Controllers** stay thin: validate, call one service method, return a DTO.
- **Validation:** Bean Validation annotations on request record components.
- **Errors:**
  - One `RuntimeException` subclass per failure case, with the message built in its constructor.
  - The HTTP status is mapped in one `@RestControllerAdvice`, and every error uses one shape.
- **Logging:** SLF4J with `{}` placeholders, only at boundaries (outbound calls, queue sends, failures). Never log
  secrets or request bodies.
- **Spring Boot 4:** databind is Jackson 3 (`tools.jackson.*`), while annotations still come from
  `com.fasterxml.jackson.annotation`.
- **Database:** schema changes go in a new Flyway migration; never edit an applied one.

## Tests

- **Kinds:**
  - `*Test`: unit tests, no Spring context, no Docker.
  - `*IT`: Spring and Testcontainers; may mock our own beans at the edges.
  - `*E2ETest`: black box over HTTP; mocks nothing of ours. Outside systems are replaced at the network level.
- **Method names** describe behaviour as a camelCase sentence, with no `test`/`should` prefix. For example
  `rejectsDuplicateNamesWithinAnOrg`.
- **Assertions:** AssertJ, or `jsonPath` in MockMvc tests. Assert concrete values (messages, paths, counts), not
  just status codes.
- **Mocks:** Mockito via `final` fields initialised with `mock(...)`, not `@Mock`/`@InjectMocks`. Spring tests take
  beans through an `@Autowired` constructor into `final` fields.
- Use `@ParameterizedTest` for tables of inputs, and constants or fixture classes for shared test data.
- When behaviour changes, change the tests first, watch them fail, then fix the code.
