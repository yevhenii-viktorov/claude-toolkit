# Testing

Sources: [testing package](https://pkg.go.dev/testing), [Go Wiki: TableDrivenTests](https://go.dev/wiki/TableDrivenTests), [Fuzzing](https://go.dev/security/fuzz/), Uber Go Style Guide, Google Go Style.

## Default form: table-driven + subtests

```go
func TestParseSize(t *testing.T) {
    tests := []struct {
        name    string
        in      string
        want    int64
        wantErr bool
    }{
        {"bytes", "100", 100, false},
        {"kilobytes", "10KB", 10240, false},
        {"invalid", "abc", 0, true},
    }
    for _, tc := range tests {
        t.Run(tc.name, func(t *testing.T) {
            got, err := ParseSize(tc.in)
            if (err != nil) != tc.wantErr {
                t.Fatalf("err = %v, wantErr %v", err, tc.wantErr)
            }
            if got != tc.want {
                t.Errorf("got %d, want %d", got, tc.want)
            }
        })
    }
}
```

- Named cases. The name becomes part of `-run TestX/case_name` for selective runs.
- `t.Run` subtests for isolation and finer error reporting.
- Pre-Go-1.22: shadow the loop variable inside `t.Run` (`tc := tc`). On 1.22+ it's no longer needed and the shadow is dead code.

## Helpers

```go
func mustOpen(t *testing.T, path string) *os.File {
    t.Helper()
    f, err := os.Open(path)
    if err != nil { t.Fatalf("open %s: %v", path, err) }
    return f
}
```

- `t.Helper()` in every helper — failures point to the caller, not the helper line.
- `t.Cleanup(fn)` over `defer` for teardown — runs even after `t.Fatal`.

```go
f := mustOpen(t, "x")
t.Cleanup(func() { f.Close() })
```

## Parallelism

```go
func TestX(t *testing.T) {
    t.Parallel()
    // ...
}
```

For table-driven tests, parallelize per case:

```go
for _, tc := range tests {
    tc := tc // pre-1.22 only
    t.Run(tc.name, func(t *testing.T) {
        t.Parallel()
        // ...
    })
}
```

Parallel tests must not share mutable state. Use per-test temp dirs (`t.TempDir()`), per-test contexts.

## Assertions

Prefer the standard library + `github.com/google/go-cmp/cmp` for diffs. testify is fine if the codebase already uses it — don't introduce it mid-project.

```go
if diff := cmp.Diff(want, got); diff != "" {
    t.Errorf("Foo() mismatch (-want +got):\n%s", diff)
}
```

- `t.Error`/`t.Errorf` to keep going after a failure (table-driven cases benefit from this).
- `t.Fatal`/`t.Fatalf` only when continuation is meaningless (setup failed, nil pointer would deref next line).
- **Never call `t.Fatal` from a non-test goroutine** — undefined behavior. Send the error back through a channel, or call `t.Error` and return.

## Coverage that matters

- Branchy logic: table-driven with one row per branch.
- Error paths: at least one test that exercises each error return.
- Boundary conditions: empty input, single-item, capacity-equals-length, off-by-one ranges.
- Coverage % is not the goal; meaningful coverage on critical paths is.

## Race detector

`go test -race -count=1 ./...` is required in CI on any package with goroutines, channels, or shared state. The `-count=1` defeats test caching when you actually want a real run.

If a PR adds concurrency without race-tested coverage, that's a finding.

## Fuzzing

```go
func FuzzParse(f *testing.F) {
    f.Add("100")
    f.Add("10KB")
    f.Fuzz(func(t *testing.T, in string) {
        _, _ = Parse(in) // should not panic
    })
}
```

- Any parser, decoder, or function accepting `[]byte`/`string` from untrusted input deserves a fuzz target.
- Crashing inputs land in `testdata/fuzz/FuzzX/...` and become regression cases automatically.

## Golden files

For large expected outputs (rendered HTML, generated SQL, etc.):

```
testdata/
  TestRender/
    simple.golden
    nested.golden
```

Update with a `-update` flag pattern:

```go
var update = flag.Bool("update", false, "update golden files")

if *update { os.WriteFile(goldenPath, got, 0644) }
```

## Mocks vs fakes

- **Fakes**: real, in-memory implementations of an interface (in-memory store, fake clock). Preferred — they catch interface contract violations the way mocks don't.
- **Mocks**: program expectations and return values. Use only at process boundaries (network, time, OS) where a real implementation is impractical.
- Don't mock the type under test.
- Don't introduce mock frameworks (gomock, mockery) just to avoid writing a 20-line fake.

## Examples **[library]**

```go
func ExampleParseSize() {
    n, _ := ParseSize("10KB")
    fmt.Println(n)
    // Output: 10240
}
```

Run as tests, render in godoc. Worth writing for published libraries; optional for internal code.

## Benchmarks

```go
func BenchmarkProcess(b *testing.B) {
    data := setup()
    b.ResetTimer()
    var sink Result
    for i := 0; i < b.N; i++ { sink = Process(data) }
    _ = sink
}
```

- `b.ResetTimer()` after setup.
- Assign output to a sink to prevent dead-code elimination.
- `b.ReportAllocs()` when allocation count is the metric.
- Compare runs with `benchstat`, not eyeballing.

## Common findings

- Helper functions without `t.Helper()`.
- `defer` cleanup that won't run after `t.Fatal` — use `t.Cleanup`.
- Parallel subtests sharing a captured loop var (pre-1.22).
- `t.Fatal` from a `go func()` inside the test.
- `time.Sleep` to "wait for goroutine" instead of synchronizing with a channel or `WaitGroup`.
- Tests that hit the real network/DB/filesystem without isolation.
- One giant test with sequential phases when it could be N subtests.
- Mock framework setup that's 3× longer than a hand-written fake.
- Concurrent test code without a `go test -race` run in CI.
