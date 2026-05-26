# Master Review Checklist

Scan every Go review against this list. Each row points to the reference with the full rule and code examples. Don't open every reference — open only the ones the diff hits.

**Bar:** very good production code, not OSS-library-grade. Items marked **[library]** apply only when the package is a published/external library — skip them for internal code unless the user says otherwise.

## Correctness & errors → errors.md
- [ ] No ignored errors (`_` without justification, especially `Close`, `Flush`, `Write`).
- [ ] Errors wrapped with `%w` when caller may need `errors.Is`/`As`; otherwise context with `%v`.
- [ ] No double-wrapping or "context: context: …" chains.
- [ ] Error strings lowercase, no trailing punctuation, no capitalization (except proper nouns).
- [ ] No string-matching on `err.Error()` — use `errors.Is`/`As` + sentinel/typed errors.
- [ ] Sentinel errors named `Err*` and exported only when callers should match them.
- [ ] Custom error types end in `Error`, satisfy `Error()`, use pointer receiver.
- [ ] No in-band error values (`-1`, empty string as failure) — return `(T, error)` or `(T, bool)`.
- [ ] `error` is the last return value.
- [ ] Function returns `error` interface, not `*ConcreteErr` (nil-interface trap).
- [ ] No `panic` in library code; `MustX` only for "broken at startup" cases.
- [ ] No `log.Fatal`/`os.Exit` outside `main`/`init`.
- [ ] No "log AND return" — pick one.

## Concurrency → concurrency.md
- [ ] Every `go f()` has a documented termination path (context cancel, channel close, WaitGroup).
- [ ] No `init()` goroutines.
- [ ] Channel sends paired with `select { case ch <- v: case <-ctx.Done(): }` if blocking.
- [ ] Only senders close channels; no double-close; multi-producer pattern uses WaitGroup + dedicated closer.
- [ ] Buffered channel size is justified (1, or "exactly N").
- [ ] `chan struct{}` for signals, not `chan bool`.
- [ ] `sync.Mutex`/`WaitGroup`/`atomic.*` not copied (run `go vet`).
- [ ] `defer mu.Unlock()` immediately after `mu.Lock()`; no `defer` inside loops that should release per iteration.
- [ ] `sync.RWMutex` only when reads >> writes.
- [ ] `sync/atomic` typed wrappers (`atomic.Int64`, `atomic.Pointer[T]`) preferred over manual `LoadInt64`.
- [ ] Goroutine spawns in a loop are bounded (worker pool or `errgroup` with `SetLimit`).
- [ ] No reading/writing nil channels, no closing nil channels.
- [ ] Tests covering concurrency pass under `go test -race`.

## Context → context.md
- [ ] `ctx context.Context` is the first parameter of any function doing I/O or blocking work.
- [ ] `ctx` never stored in a struct (exception: `http.Request`).
- [ ] `ctx` never nil — `context.Background()` at root, `context.TODO()` if genuinely unknown.
- [ ] `defer cancel()` after every `WithCancel`/`WithTimeout`/`WithDeadline`.
- [ ] Long loops check `ctx.Done()`.
- [ ] `context.WithValue` only for request-scoped data; key is unexported custom type, not string.
- [ ] Functions taking `ctx` actually propagate it into downstream calls.

## Performance → performance.md
- [ ] Slices/maps preallocated when size is known (`make([]T, 0, n)`).
- [ ] No `s += part` in loops — use `strings.Builder`.
- [ ] No `defer` in tight inner loops (defers accumulate until function returns).
- [ ] Regex/templates compiled once at package level, not per-call.
- [ ] Large structs passed/returned by pointer; small ones by value.
- [ ] No `[]byte(s)` / `string(b)` round-trips in hot paths.
- [ ] `for i := range s` over `for _, v := range s` when `v` is a large struct.
- [ ] `sync.Pool` only for measured hot paths.

## Security → security.md
- [ ] No `math/rand` for tokens/IDs/keys/passwords — use `crypto/rand`.
- [ ] No MD5/SHA1 for crypto purposes.
- [ ] Secret comparison uses `subtle.ConstantTimeCompare`, not `==`.
- [ ] SQL queries are parameterized; no `fmt.Sprintf` or `+` into query strings.
- [ ] `exec.Command(name, args...)`, not `exec.Command("sh", "-c", input)`.
- [ ] User-controlled paths cleaned and bounded under a base directory.
- [ ] Zip/tar extraction validates each entry's resolved path.
- [ ] No `InsecureSkipVerify: true` outside tests.
- [ ] HTML rendering uses `html/template`, not `text/template`.
- [ ] Redirect destinations validated against allowlist.
- [ ] `http.Server` sets `Read/Write/IdleTimeout`; `http.MaxBytesReader` on bodies.
- [ ] No secrets in code, logs, struct tags, or commit history.
- [ ] No `encoding/gob` on untrusted input.
- [ ] Integer conversions to narrower types bounded; file sizes capped before allocation.

## API design → api-design.md
- [ ] Accept interfaces, return concrete types.
- [ ] Interfaces defined in consumer package, not producer.
- [ ] Interfaces small (1–3 methods); single-method named `-er`.
- [ ] Receiver kinds consistent across all methods on a type.
- [ ] Pointer receiver when type has `sync.Mutex`, is large, or methods mutate.
- [ ] Receiver name 1–2 letters, consistent; not `this`/`self`/`me`.
- [ ] Constructor named `New` or `NewT`.
- [ ] Zero value of types is useful, or the constructor's role is obvious from the code.
- [ ] No `Get` prefix on getters (`User()`, not `GetUser()`).
- [ ] Functional options pattern for optional config; struct for required.
- [ ] No `*Interface` parameters (interfaces are already reference-like).
- [ ] **[library]** Every exported identifier has a doc comment starting with its name.
- [ ] **[library]** Package doc comment present.
- [ ] **[library]** Compile-time interface check `var _ Foo = (*Impl)(nil)` on important implementations.

## Testing → testing.md
- [ ] Table-driven tests with named cases.
- [ ] `t.Run(tc.name, ...)` for subtests.
- [ ] `t.Helper()` in every test helper.
- [ ] `t.Cleanup(fn)` instead of `defer` for cleanup.
- [ ] `t.Parallel()` for independent tests.
- [ ] Standard library + `cmp.Diff` preferred over testify.
- [ ] `t.Error`/`t.Errorf` for continuable failures; `t.Fatal` only when continuation is meaningless.
- [ ] No `t.Fatal` from non-test goroutines.
- [ ] `go test -race` covers concurrent code.
- [ ] Fuzz tests on parsers/decoders/byte-slice consumers.
- [ ] Mocks at process boundaries only; fakes preferred.
- [ ] No timing-dependent or external-service-dependent tests without isolation.

## Idioms & style → idioms-style.md
- [ ] `MixedCaps` / `mixedCaps`; no `snake_case`, no `SCREAMING_CASE`.
- [ ] Initialisms preserve case: `ID`, `URL`, `HTTP`, `API` (`userID`, `ServeHTTP`).
- [ ] No package-name stutter (`bytes.Buffer`, not `bytes.BytesBuffer`).
- [ ] Early returns; no `else` after `return`/`continue`/`break`.
- [ ] Comma-ok type assertions unless panic is intended.
- [ ] `time.Duration` for periods, `time.Time` for instants.
- [ ] Three import groups separated by blank lines (stdlib / third-party / local).
- [ ] Doc comments start with the identifier name, are full sentences.

## Generics → generics.md
- [ ] Type params justified — duplication ≥3 times, container algorithm, or type-safe data structure.
- [ ] Behavior-varying-by-type uses interfaces, not type params.
- [ ] Constraints narrow (`constraints.Ordered`, not `any`, when possible).
- [ ] Type param names short single-capital letters (`T`, `K`, `V`).

## Modern Go (1.21+) → modern-go.md
- [ ] Uses `min`/`max`/`clear` built-ins (1.21) instead of hand-rolled helpers.
- [ ] Uses `log/slog` for structured logs, not `log.Printf`.
- [ ] Uses `errors.Join` for combined errors.
- [ ] Uses `sync/atomic` typed wrappers, not raw `LoadInt64`.
- [ ] Uses `slices`/`maps` stdlib packages over hand-rolled loops.
- [ ] If `go.mod` ≥ 1.22: no `tc := tc` shadow; `for i := range N` over `for i := 0; i < N; i++`.
- [ ] If `go.mod` ≥ 1.23: prefer iterators over returning large slices from container types.

## Project structure → structure.md
- [ ] `cmd/<binary>/main.go` per binary; `main` only wires `run() error`.
- [ ] `internal/` for non-exported subtrees.
- [ ] No `util`/`helpers`/`common`/`base`/`misc` package names.
- [ ] Package name = directory name (lowercase, no underscores, singular).
- [ ] No circular dependencies.
- [ ] No committed `replace` directives pointing to local paths.
- [ ] `go.mod` and `go.sum` tidied; no spurious `// indirect` churn.
