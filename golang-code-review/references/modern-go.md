# Modern Go (1.21+)

Sources: [Go release notes](https://go.dev/doc/devel/release), [Go blog: range-over-func](https://go.dev/blog/range-functions), [Go blog: loopvar](https://go.dev/blog/loopvar-preview), [slog docs](https://pkg.go.dev/log/slog).

Flag code that re-implements what the stdlib now provides, and code that uses superseded patterns. Always check `go.mod`'s `go` directive — rules only apply when the module is on a sufficient version.

## Go 1.20

- `errors.Join(err1, err2, err3)` combines multiple errors into one. Inspect with `errors.Is`/`As`. Replaces ad-hoc multi-error packages for simple cases.

  ```go
  var errs error
  for _, x := range items {
      if err := process(x); err != nil {
          errs = errors.Join(errs, err)
      }
  }
  return errs
  ```

## Go 1.21

### Built-ins: `min`, `max`, `clear`

```go
n := max(a, b, c)        // works on any ordered type
m := min(x, y)
clear(myMap)             // delete all entries
clear(mySlice)           // zero all elements
```

Flag hand-rolled `func max[T constraints.Ordered](a, b T) T { ... }` — delete it.

### `log/slog` (structured logging)

```go
slog.Info("login", "user", id, "ip", req.RemoteAddr)
slog.Error("write failed", "err", err, "path", p)
```

- New code should use `slog`, not `log.Printf`.
- Set the default handler in `main`: `slog.SetDefault(slog.New(slog.NewJSONHandler(os.Stderr, nil)))`.
- Pass loggers via struct fields or context — not globals (except the default).
- Implement `LogValue() slog.Value` on types carrying secrets to control how they render.

### `sync/atomic` typed wrappers (since 1.19, common from 1.21)

```go
// BAD
var counter int64
atomic.AddInt64(&counter, 1)

// GOOD
var counter atomic.Int64
counter.Add(1)
```

Also `atomic.Bool`, `atomic.Uint64`, `atomic.Pointer[T]`.

### `context.WithoutCancel` / `context.AfterFunc` / `WithDeadlineCause`

- `context.WithoutCancel(parent)` — detach from cancellation but keep values. For fire-and-forget cleanup after the request context is done.
- `context.AfterFunc(ctx, fn)` — run `fn` when ctx is canceled. Returns a `stop` to deregister.
- `context.WithDeadlineCause(parent, d, cause)` — set a sentinel retrievable via `context.Cause(ctx)`.

### `sync.OnceFunc` / `OnceValue` / `OnceValues`

Type-safe alternatives to manual `sync.Once`:

```go
load := sync.OnceValue(func() *Config { return loadConfig() })
cfg := load()  // computed once, returns cached value
```

## Go 1.22

### Per-iteration loop variables

Each iteration of `for i := range s` gets a fresh `i`. The pre-1.22 closure-capture bug is fixed.

```go
// pre-1.22 — bug, all goroutines see last v
for _, v := range items { go func() { use(v) }() }

// 1.22+ — works correctly
for _, v := range items { go func() { use(v) }() }
```

If `go.mod` declares `go 1.22` or later, the old `v := v` shadow inside the loop is dead code — flag it for removal.

The behavior change is **per-module** based on the `go` directive, not the toolchain version. Watch out when reviewing a module pinned to `go 1.21`.

### `range` over integers

```go
for i := range 10 { fmt.Println(i) }
// equivalent to for i := 0; i < 10; i++
```

Use it where it reads naturally — counted loops without index arithmetic. Don't force it where the C-style `for` is clearer.

### `cmp.Or`

```go
host := cmp.Or(req.Host, defaultHost, "localhost")
// first non-zero value
```

Replaces `if x != "" { return x }; if y != "" { return y }; return z` chains.

## Go 1.23

### Range over functions (iterators)

```go
func Lines(r io.Reader) iter.Seq[string] {
    return func(yield func(string) bool) {
        sc := bufio.NewScanner(r)
        for sc.Scan() {
            if !yield(sc.Text()) { return }
        }
    }
}

for line := range Lines(r) { ... }
```

- `iter.Seq[V]` — single-value iterator.
- `iter.Seq2[K, V]` — key-value iterator.
- New stdlib helpers: `slices.All`, `slices.Values`, `maps.All`, `maps.Keys`, `maps.Values`, `slices.Collect`, `maps.Collect`.

When designing a container that yields elements, prefer an iterator method over returning a giant slice — caller can stop early without paying for full materialization.

### `unique.Handle[T]`

Canonical interning for comparable values — useful for deduplicating strings or small structs in long-running processes.

## Go 1.24

### `os.Root`

Path-traversal-safe filesystem operations bounded to a directory tree:

```go
root, err := os.OpenRoot("/var/data/users")
if err != nil { return err }
defer root.Close()

f, err := root.Open(userInput) // refuses to escape /var/data/users
```

Prefer this for any new code handling user-controlled paths under a known base. Replaces hand-rolled `filepath.Clean` + `HasPrefix` checks.

### `crypto/rand.Text`

```go
token := rand.Text() // 26 char base32, uniformly random
```

Use over hand-rolled `crypto/rand.Read` + encoding for tokens/IDs.

### `weak.Pointer[T]`

Weak references — niche, but useful for caches that should release entries under memory pressure.

## How to apply in review

- Check `go.mod`'s `go` directive first. A rule below this version doesn't apply.
- For new code: prefer the modern form. Suggest the upgrade as a Medium finding, not Critical, unless the old form has bugs (e.g., pre-1.22 loop capture).
- For existing code: only suggest migration when it actually simplifies or fixes something.

## Common findings

- Hand-rolled `func max(a, b int) int { ... }` on Go 1.21+.
- `log.Printf("user=%d err=%v", id, err)` in new code that should be `slog`.
- `atomic.AddInt64(&n, 1)` on Go 1.19+ — use `atomic.Int64`.
- Pre-1.22 loop variable shadow (`tc := tc`) in modules on 1.22+.
- Returning a 100k-element slice from a method that could be an `iter.Seq` (1.23+).
- Manual `filepath.Clean` + prefix check on 1.24+ where `os.Root` would be safer.
- `crypto/rand.Read` + custom encoding when `rand.Text` would suffice (1.24+).
- `pkg/errors.Wrap` in new code on 1.20+ — use `fmt.Errorf("...: %w", err)` or `errors.Join`.
