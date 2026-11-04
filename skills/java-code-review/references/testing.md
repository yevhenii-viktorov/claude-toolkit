# Testing

Sources: JUnit 5 + AssertJ conventions, Effective Java Item 1-adjacent test-design wisdom. Review test code with the same rigor as production code — a bad test gives false confidence. The house style's Tests section (`java-code-style`, project `AGENTS.md`) wins over this file.

## Framework & assertions

- **JUnit 5** (`org.junit.jupiter.api.*`) for new code. Flag lingering JUnit 4 imports (`org.junit.Test`, `org.junit.Assert`) in new/changed test files.
- **AssertJ** (`assertThat(x).isEqualTo(...)`) is the project-preferred fluent style on most modern Java codebases — readable failures, rich matchers. Avoid mixing `org.junit.Assert.assertEquals` and AssertJ in the same file; pick one (prefer AssertJ). Note the argument-order trap of JUnit's `assertEquals(expected, actual)` — AssertJ's `assertThat(actual).isEqualTo(expected)` reads unambiguously.
- Assert specific things: `assertThat(list).containsExactly(a, b)` beats `assertThat(list.size()).isEqualTo(2)` — better failure messages and stronger guarantees. Assert concrete values (messages, JSON paths, counts), not just status codes; MockMvc tests use `jsonPath`.

## Test kinds

- `*Test`: unit, no Spring context, no Docker.
- `*IT`: Spring and Testcontainers; may mock the project's own beans at the edges.
- `*E2ETest`: black box over HTTP; mocks nothing of ours. Outside systems are replaced at the network level (LocalStack, fake servers).

Flag a test whose name suffix doesn't match what it does (a `*Test` that boots Spring, an `*E2ETest` that mocks a bean).

## Test structure

- **One logical assertion concept per test**; a test asserting five unrelated things hides which broke. Multiple `assertThat` on the same outcome is fine.
- **Arrange / Act / Assert** (given/when/then) shape — keep setup, the call under test, and verification visually separable.
- **Names are camelCase behaviour sentences** with no `test`/`should` prefix and no underscores: `rejectsDuplicateNamesWithinAnOrg`. Not `test1`, `testTransfer`, `shouldFail`, `transfer_fails...`, and no `@DisplayName`.
- **No logic in tests** — loops, conditionals, and computed expected values in a test mean the test itself can be buggy. Prefer `@ParameterizedTest` with explicit case data over a hand-rolled loop. A literal expected value beats a recomputed one.

## Parameterized & data-driven

- `@ParameterizedTest` + `@ValueSource`/`@CsvSource`/`@MethodSource` for the same logic over many inputs — beats copy-pasted near-identical `@Test` methods (duplication smell) and beats an in-test loop.

## Mocking (Mockito)

- **Mock at boundaries** (external services, I/O, clocks, randomness) — not value objects or the class under test's own collaborators that are cheap to construct. Over-mocking tests the mocks, not the code.
- Prefer real objects / fakes for simple collaborators. A test wired with ten mocks is usually testing wiring, not behavior.
- `verify(...)` for interactions that matter; don't `verify` every call (brittle, asserts implementation not behavior).
- Inject a fixed `Clock`/seeded random rather than mocking time globally.
- Mocks are `final` fields initialised with `mock(...)`. Flag `@Mock`/`@InjectMocks` (they need non-final fields). Spring tests take beans through an `@Autowired` constructor into `final` fields, not field injection.

## Determinism & isolation

- **No dependence on wall-clock, real network, real filesystem (outside a temp dir), thread timing, or test-execution order.** Use `@TempDir`, fixed `Clock`, WireMock/local stubs, deterministic seeds.
- `Thread.sleep` in a test to "wait for" async work is flaky — use awaitility / latches / deterministic hooks.
- Tests must not leak state between runs (static singletons, shared mutable fixtures) — reset in `@AfterEach` or avoid shared mutable state.

## Coverage intent

- A new test should exercise the **branch/behavior the PR adds or changes**, not re-assert pre-existing behavior to pad a coverage number.
- Branchy logic (multiple `if`/`switch` paths, boundary values) needs cases per branch and at the boundaries; a single happy-path test on branchy code is insufficient.
- A behaviour change must come with a test that fails without it (the house workflow writes the test first). Flag behaviour changes with no test change.
- Don't demand 100% coverage or tests for trivial getters — match the quality bar.

## Quick scan

- JUnit 4 imports / `org.junit.Assert` in new test code.
- Logic (loops/conditionals/computed expected) inside a test → parameterize / use literals.
- Vague names (`test1`), `test`/`should` prefixes, underscores, `@DisplayName`; five unrelated asserts in one test.
- `@Mock`/`@InjectMocks` or `@Autowired` fields; status-only assertions; wrong test kind for the suffix.
- Over-mocking (mocking value objects / the SUT's cheap collaborators); `verify` on everything.
- `Thread.sleep`-based waits; real clock/network/filesystem; order-dependent tests.
- Copy-pasted near-identical `@Test` methods → `@ParameterizedTest`.
- New test re-asserts old behavior instead of the changed branch.
