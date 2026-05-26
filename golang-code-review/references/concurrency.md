# Concurrency

Sources: [Go Concurrency Patterns: Pipelines](https://go.dev/blog/pipelines), [Go Code Review Comments](https://go.dev/wiki/CodeReviewComments), Uber Go Style Guide, Dave Cheney "Practical Go".

## Core rules

- Share memory by communicating; don't communicate by sharing memory.
- Every `go f()` must have an explicit termination path. If you can't answer "how does this goroutine exit?" — it's a leak.
- No goroutines in `init()`.
- "Leave concurrency to the caller": libraries return values, not channels. The caller decides whether to spawn.

## Goroutine leaks

The classic leak: blocking send after the receiver is gone.

```go
// BAD: if nobody reads, this goroutine lives forever
go func() { ch <- compute() }()

// GOOD: tie send to a cancellation signal
go func() {
    select {
    case ch <- compute():
    case <-ctx.Done():
    }
}()
```

`errgroup` for managed fan-out — it propagates cancellation and the first error:

```go
g, ctx := errgroup.WithContext(ctx)
g.SetLimit(8)
for _, item := range items {
    item := item // pre-1.22 only
    g.Go(func() error { return process(ctx, item) })
}
return g.Wait()
```

## Channels

- Default to **unbuffered**. Buffered is justified for size 1 (single signal) or "exactly N tasks" patterns. Never use a buffer to "fix" a deadlock.
- **Only the sender closes.** Receiver-side close is a panic waiting to happen.
- **Never double-close** — sends on a closed channel panic, second close panics.
- For multiple producers, gate the close behind a `sync.WaitGroup`:

```go
var wg sync.WaitGroup
out := make(chan T)
for _, src := range sources {
    wg.Add(1)
    go func(src Src) {
        defer wg.Done()
        for v := range src { out <- v }
    }(src)
}
go func() { wg.Wait(); close(out) }()
```

- Signaling: use `chan struct{}`, not `chan bool` (zero-byte payload).
- Typed direction in signatures: `func work(in <-chan int, out chan<- int)`.

## Mutexes

- `sync.Mutex` zero value is ready — don't `new(sync.Mutex)`, don't embed.
- Don't copy structs containing `Mutex`, `WaitGroup`, or `atomic.*`. `go vet` flags this; respect it.
- `defer mu.Unlock()` immediately after `mu.Lock()` — covers panics and early returns.

```go
mu.Lock()
defer mu.Unlock()
// ...
```

- Caveat: `defer` in a tight loop keeps locks held until function return. If you need per-iteration release, extract a helper or use explicit `Unlock`.
- `sync.RWMutex` is only faster than `Mutex` when reads vastly dominate writes; otherwise it has higher overhead.

## Atomics

Prefer the typed wrappers (Go 1.19+):

```go
// BAD
var counter int64
atomic.AddInt64(&counter, 1)

// GOOD
var counter atomic.Int64
counter.Add(1)
```

`atomic.Pointer[T]` for lock-free swaps.

## sync.Once

```go
var (
    once sync.Once
    svc  *Service
)
func get() *Service {
    once.Do(func() { svc = build() })
    return svc
}
```

For re-init or once-per-key: `sync.OnceValue`/`OnceValues`/`OnceFunc` (1.21+) or a `map` of `sync.Once`.

## Context propagation in concurrency

Every blocking select branch should include `<-ctx.Done()`:

```go
for {
    select {
    case <-ctx.Done():
        return ctx.Err()
    case v := <-in:
        // process v
    }
}
```

`defer cancel()` always, even when the parent context is already canceled — `cancel` releases resources tracked by the context tree.

## Pipelines pattern

From [go.dev/blog/pipelines](https://go.dev/blog/pipelines):

1. Each stage is a goroutine.
2. Each stage closes its outbound channel when done.
3. Stages propagate `done`/`ctx` to allow early termination.
4. Fan-in uses `sync.WaitGroup` and a dedicated closer goroutine.

```go
func gen(ctx context.Context, nums ...int) <-chan int {
    out := make(chan int)
    go func() {
        defer close(out)
        for _, n := range nums {
            select {
            case out <- n:
            case <-ctx.Done():
                return
            }
        }
    }()
    return out
}
```

## Worker pools

Unbounded `go work(item)` on a stream of input is a memory bomb. Use a fixed worker pool:

```go
jobs := make(chan Job)
var wg sync.WaitGroup
for i := 0; i < runtime.GOMAXPROCS(0); i++ {
    wg.Add(1)
    go func() { defer wg.Done(); for j := range jobs { handle(j) } }()
}
for _, j := range list { jobs <- j }
close(jobs); wg.Wait()
```

Or `errgroup.SetLimit(n)`.

## Race detector

Tests with concurrent code must pass `go test -race`. Flag any new shared mutable state in a PR that doesn't add or already have race-tested coverage.

## Common findings

- `for _, v := range items { go func() { use(v) }() }` in Go <1.22 — captures last `v`. Add `v := v` or upgrade module to 1.22+.
- Reading from a `nil` channel — blocks forever; usually accidental.
- `close(ch)` in a `select` arm of a fan-in — receiver side closing.
- `sync.Mutex` passed by value through a function arg — copies and breaks the lock.
- Goroutine started in a constructor with no way to stop it — leaks on every `New()`.
