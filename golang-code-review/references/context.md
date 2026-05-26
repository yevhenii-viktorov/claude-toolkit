# Context

Sources: [Go blog: Context](https://go.dev/blog/context), [pkg.go.dev/context](https://pkg.go.dev/context), Go Code Review Comments.

## Placement

`ctx context.Context` is the **first** parameter of any function that does I/O, blocks, or makes outbound calls.

```go
func Fetch(ctx context.Context, url string) (*Response, error)
```

Exceptions: HTTP handlers (use `r.Context()`), test functions, methods on types that wrap a request (where `ctx` is bound via the wrapper).

## Don't store ctx in a struct

```go
// BAD
type Worker struct { ctx context.Context }

// GOOD
type Worker struct { /* ... */ }
func (w *Worker) Run(ctx context.Context) error
```

Exception: `http.Request` carries its own ctx because the type is request-scoped by design. Otherwise, pass through the call chain explicitly.

## Never pass nil

- `context.Background()` at top-level (`main`, root of long-lived processes).
- `context.TODO()` only when you genuinely don't know which to use yet (placeholder for "wire this through later").
- Never `nil` — derived calls will panic on `nil.Done()`.

## Always cancel

```go
ctx, cancel := context.WithTimeout(ctx, 5*time.Second)
defer cancel()
```

`cancel` releases resources even when the deadline already fired. The vet check `lostcancel` will catch missing `defer cancel()` — respect it.

## Honor cancellation in long work

```go
for _, item := range items {
    select {
    case <-ctx.Done():
        return ctx.Err()
    default:
    }
    process(item)
}
```

If `process(ctx, item)` already takes ctx and propagates it into I/O, that internal check is sufficient — don't add ceremonial `select` wrappers around already-ctx-aware calls.

## context.Value

For request-scoped data crossing API boundaries (request ID, auth principal, tracing span). **Not** for optional function arguments — those go in the signature or an options struct.

Use an unexported custom key type to prevent collisions:

```go
type ctxKey int
const userKey ctxKey = 0

func WithUser(ctx context.Context, u *User) context.Context {
    return context.WithValue(ctx, userKey, u)
}
func UserFrom(ctx context.Context) (*User, bool) {
    u, ok := ctx.Value(userKey).(*User)
    return u, ok
}
```

Never use `string` keys. Never export the key type.

## Don't wrap Context

Don't define your own `MyContext` interface or wrap `context.Context` in a custom type. Tools and the runtime rely on the standard interface.

## Modern additions

- `context.WithoutCancel(parent)` (1.21) — detach from parent's cancellation while preserving values. Useful for fire-and-forget cleanup after the request ctx is canceled.
- `context.AfterFunc(ctx, f)` (1.21) — run `f` when ctx is canceled. Returns a `stop` to deregister.
- `context.WithDeadlineCause` / `WithTimeoutCause` (1.21) — set a sentinel cause retrievable via `context.Cause(ctx)` to distinguish "deadline" from "explicit cancel because X".

## Common findings

- `WithTimeout` without `defer cancel()`.
- Functions doing I/O but not taking `ctx`.
- `context.Background()` deep in a handler instead of `r.Context()`.
- `ctx` in a struct field, then methods that "use the stored ctx" — request-scoped state hidden in the type.
- `context.WithValue(ctx, "user", u)` with a string key.
- `select { case <-ctx.Done(): ... }` in a function that doesn't actually do blocking work — ceremonial check.
