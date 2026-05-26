# Performance

Sources: [Effective Go](https://go.dev/doc/effective_go), Dave Cheney "Practical Go", Uber Go Style Guide, Go runtime docs.

## Order of operations

1. Measure first. `go test -bench` / `pprof` / `trace`. No optimization without a profile.
2. Optimize the hot path; ignore cold code.
3. Reduce allocations before tweaking instructions — Go GC pressure dominates most workloads.

## Allocations

### Preallocate

```go
// BAD
var out []string
for _, s := range in { out = append(out, transform(s)) }

// GOOD
out := make([]string, 0, len(in))
for _, s := range in { out = append(out, transform(s)) }
```

Same for maps when size is known: `make(map[K]V, n)`.

### Slice reuse

```go
buf = buf[:0]  // reuse backing array between iterations
```

Subslicing keeps the original backing array alive. If you keep a small slice from a large source for a long time, copy:

```go
small := append([]byte(nil), big[start:end]...)
```

### sync.Pool

Only in measured hot paths. Misused, it adds complexity without speedup. Reset on `Get`:

```go
var bufPool = sync.Pool{New: func() any { return new(bytes.Buffer) }}

buf := bufPool.Get().(*bytes.Buffer)
defer bufPool.Put(buf)
buf.Reset()
```

### Avoid boxing into `interface{}` / `any` in hot paths

Each `any`-typed slot allocates. Use concrete types or generics where the call site is hot.

## Strings

- `strings.Builder` for concatenation in loops. `s += part` is O(n²) allocations.
- `strconv.Itoa(i)` is ~2× faster than `fmt.Sprint(i)` for integers.
- `strings.EqualFold(a, b)` for case-insensitive compare, not `strings.ToLower(a) == strings.ToLower(b)`.
- Don't round-trip `[]byte` ↔ `string` in loops — each conversion copies. Convert once outside.

## Defer

`defer` is cheap (a few ns) but **not free**. The cost matters in two cases:

- Tight inner loops calling `defer` per iteration.
- Per-iteration `defer` inside a long-running outer function — defers accumulate until the function returns.

```go
// BAD: each file's Close runs only when DoEverything() returns
for _, p := range paths {
    f, _ := os.Open(p)
    defer f.Close()
    // ...
}

// GOOD: scope each defer to one iteration
for _, p := range paths {
    func() {
        f, _ := os.Open(p)
        defer f.Close()
        // ...
    }()
}
```

## Escape analysis

- Returning a pointer to a local struct → escapes to the heap. For small types, returning by value is faster.
- Passing a large struct by value copies the whole thing — use a pointer.
- Closures that capture variables may force those variables onto the heap.

Inspect with `go build -gcflags="-m"`.

## Loop forms

```go
// BAD if Item is large: copies each element
for _, it := range items { use(it) }

// GOOD: avoids the copy
for i := range items { use(&items[i]) }
```

## I/O

- Wrap `os.File` / `net.Conn` with `bufio.NewReader` / `NewWriter` for many small reads/writes. Flush before close.
- Reuse read buffers — don't `make([]byte, n)` inside a hot read loop.

## Regex and templates

Compile **once at package level**, reuse:

```go
var re = regexp.MustCompile(`...`)
```

`regexp.MustCompile` inside a function called per request is a common hot-path bug.

## Maps

- `clear(m)` (Go 1.21+) to reset a map for reuse is faster than re-`make`.
- Iteration order is randomized — never assume it.
- Map lookup with `comma, ok`: `if v, ok := m[k]; ok { ... }`.

## Time

`time.Now()` is cheap but called millions of times per second adds up. Cache a "now" value if used many times within one logical operation.

## Database

- `db.Query/Exec` with `?`/`$1` placeholders — prepared on first use, cached by the driver.
- Batch inserts where the driver supports it.
- Pool size (`SetMaxOpenConns`/`SetMaxIdleConns`) sized for the backend, not "infinity".

## Benchmarking checklist

```go
func BenchmarkX(b *testing.B) {
    data := setup()
    b.ResetTimer()
    var sink Result
    for i := 0; i < b.N; i++ {
        sink = Process(data)
    }
    _ = sink
}
```

- `b.ResetTimer()` after setup.
- Assign to a sink (package-level var or `_ = sink` outside the loop) to prevent dead-code elimination.
- `benchstat` to compare runs, not eyeballing ns/op.

## Common findings

- `make([]T, 0)` then growing in a loop — should be `make([]T, 0, n)`.
- `regexp.MustCompile` inside a hot function.
- `fmt.Sprintf("%d", n)` in tight code — `strconv.Itoa(n)`.
- `defer mu.Unlock()` inside a for loop expected to release per iteration.
- Returning `&LocalStruct{...}` when value return would do.
- `for _, big := range bigSlice { ... }` copying large structs.
