# API Design

Sources: [Effective Go](https://go.dev/doc/effective_go), [Go Code Review Comments](https://go.dev/wiki/CodeReviewComments), [Go Style Decisions (Google)](https://google.github.io/styleguide/go/decisions), Uber Go Style Guide.

**Calibration:** Internal-grade code does not need OSS-author ceremony. Rules marked **[library]** apply only to published packages and stable public APIs.

## Interfaces

### Accept interfaces, return concrete types

```go
// GOOD
func Process(r io.Reader) (*Result, error)
// caller can pass *os.File, *bytes.Buffer, http.Body, etc.

// BAD
func Process(f *os.File) (*Result, error)
```

Producers return concrete types so callers can use the full API; consumers declare the minimal interface they need.

### Define interfaces where they're used

Don't predeclare an interface "for mocking" in the producer package. Define it in the consumer package, naming the minimal contract the consumer needs.

```go
// processor uses Storage — defined here, not in the storage package
package processor

type Storage interface {
    Get(ctx context.Context, id string) ([]byte, error)
}
```

### Keep interfaces small

One method (`io.Reader`) is canonical. >3 methods needs justification. Big interfaces are hard to implement, hard to mock, and tend to over-couple.

### Don't pass `*Interface`

Interface values already contain a pointer. `*io.Reader` is almost always a mistake.

### Compile-time satisfaction check **[library]**

```go
var _ Storage = (*PostgresStorage)(nil)
```

Useful at API boundaries where breaking the contract should fail at compile time. Optional for internal code.

## Receivers

### Consistency

All methods on a type use the **same** receiver kind — all pointer or all value. Don't mix. Mixed receivers cause subtle bugs (methods drop off interface satisfaction depending on addressability).

```go
// BAD
func (c Client) Get() {}   // value
func (c *Client) Set() {}  // pointer

// GOOD
func (c *Client) Get() {}
func (c *Client) Set() {}
```

### When to use pointer

- Methods mutate the receiver.
- Type contains `sync.Mutex` / `sync.WaitGroup` / `atomic.*` — copying would break it.
- Type is large (>~64 bytes).
- Methods will satisfy an interface and consistency demands it.

Value receivers only for small immutable types — `time.Time`, `netip.Addr`, primitive wrappers.

### Receiver name

1–2 letters, consistent across all methods on the type. Not `this`, `self`, `me`.

```go
func (c *Client) Get() {}
func (c *Client) Set() {}
// not:
func (client *Client) Get() {}  // inconsistent if other methods use c
```

## Function signatures

### Context first, options last

```go
func Fetch(ctx context.Context, url string, opts ...Option) (*Response, error)
```

### Return errors, not booleans

```go
// BAD
func Validate(s string) bool

// GOOD
func Validate(s string) error
```

Exception: lookups returning `(value, ok bool)` — that's the idiomatic "present?" check, used by map access, type assertions, channel receive.

### Avoid many positional params

>4 positional args → group into a struct or use functional options. The reader at the call site can't tell what each value means.

### Functional options

For optional configuration where most params have sensible defaults:

```go
type Option func(*config)

func WithTimeout(d time.Duration) Option {
    return func(c *config) { c.timeout = d }
}

func New(opts ...Option) *Client {
    cfg := defaultConfig()
    for _, o := range opts { o(&cfg) }
    return &Client{cfg: cfg}
}

c := New(WithTimeout(5*time.Second))
```

### Options struct

When most fields are required and the type stabilizes:

```go
type Options struct {
    Addr     string
    Timeout  time.Duration
    Logger   *slog.Logger
}

func New(opts Options) *Server { ... }
```

Pick one style per package — don't mix.

### Variadic

Last param only. Don't use variadic just to make zero args legal — provide a no-arg method instead.

## Zero values

Aim for useful zero values when it's natural:

```go
// GOOD: zero value works
type Buffer struct { buf []byte }
func (b *Buffer) Write(p []byte) { b.buf = append(b.buf, p...) }

// Also fine if a constructor is clearly needed
type Server struct { /* requires Addr, Handler, etc. */ }
func New(opts Options) *Server { ... }
```

Don't contort designs to make every zero value usable when a constructor is more honest.

## Documentation

### For internal code

- Function/type names that read well are documentation. Comments only when the *why* isn't obvious from the name and body.
- A short comment on tricky exported helpers is enough; full godoc isn't required.

### For published libraries **[library]**

- Every exported identifier has a doc comment starting with the identifier name. `// Foo does X.`
- Package comment in one file, above `package`, with package overview.
- Document goroutine safety: "safe for concurrent use" / "callers must serialize calls".
- Document returned sentinel errors: "Returns io.EOF at end of stream."
- Example tests (`ExampleFoo`) for non-obvious usage.

## Naming

- No `Get` prefix on getters: `User()`, not `GetUser()`. `Set` prefix on setters is fine.
- Constructors: `New` for the package's primary type, `NewT` for additional types. Place right after the type declaration.
- Don't stutter: `bytes.Buffer` not `bytes.BytesBuffer`; `widget.Manager` not `widget.WidgetManager`.

## Error returns from APIs

- Document which sentinel/typed errors callers may match on. If your API doesn't document an error, callers can't safely match it.
- Return `error` interface, not concrete pointer types.

## Deprecation **[library]**

```go
// Deprecated: use NewClient instead. Will be removed in v2.
func New() *Client { return NewClient() }
```

The `// Deprecated:` marker is read by `staticcheck` and IDEs.

## Common findings

- Function takes `*bytes.Buffer` instead of `io.Writer`.
- Mixed receiver kinds on a type with a `sync.Mutex`.
- Variadic used to allow zero args ("we might want optionality later") — no actual variadic use case.
- 7-argument constructor with no struct grouping.
- `GetX()`/`SetX()` getter/setter pair when `X` is just a field.
- Returning `*MyError` instead of `error`.
- Receiver named `self` or matching the full type name.
