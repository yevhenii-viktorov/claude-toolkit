# Errors

Sources: [Go Code Review Comments](https://go.dev/wiki/CodeReviewComments), [Effective Go](https://go.dev/doc/effective_go#errors), [Errors are values](https://go.dev/blog/errors-are-values), Uber Go Style Guide.

## Shape of an error return

- `error` is always the **last** return value.
- Return the `error` interface, not a concrete `*MyError` — concrete pointers create the [nil-non-nil interface trap](https://go.dev/doc/faq#nil_error).
- No in-band errors: don't use `-1`, `""`, or `0` to mean failure. Return `(T, error)` or `(T, bool)`.

```go
// BAD: caller can't distinguish "not found" from "id 0"
func UserID(name string) int

// GOOD
func UserID(name string) (int, error)
```

## Error strings

- Lowercase first letter, no trailing punctuation, no capitalization (except proper nouns/acronyms).
- Errors get wrapped — strings are concatenated by readers like `fmt.Errorf("op: %v", err)`.

```go
// BAD
errors.New("Failed to open file.")
// GOOD
errors.New("open file: not found")
```

## Wrapping

Wrap with `%w` only when callers may need `errors.Is`/`errors.As` to identify the cause. Otherwise annotate with `%v` to hide the cause at an API boundary.

```go
// GOOD: caller can errors.Is(err, fs.ErrNotExist)
return fmt.Errorf("read config %q: %w", path, err)

// GOOD: hide internal detail at RPC boundary
return fmt.Errorf("upstream lookup failed: %v", err)
```

Place `%w` at the end of the format string in the common case. Use it at the start when the wrapped value is the sentinel that callers match against:

```go
return fmt.Errorf("%w: field %q", ErrInvalid, field)
```

**Don't double-wrap.** If the inner error already says "open foo.txt", don't wrap as "open foo.txt: open foo.txt: ...".

**Don't log AND return.** Pick one — log at the top, return everywhere else. Double-logging is the most common cause of noisy production logs.

## Matching errors

```go
// BAD: fragile, breaks on translation, formatting tweaks
if strings.Contains(err.Error(), "not found") { ... }

// GOOD
if errors.Is(err, fs.ErrNotExist) { ... }

var pathErr *fs.PathError
if errors.As(err, &pathErr) { ... }
```

## Sentinel vs typed errors

| Case | Use |
|------|-----|
| Static message, no caller matching | Inline `errors.New("msg")` or `fmt.Errorf` |
| Static message, callers match | Exported `var ErrFoo = errors.New("foo")` |
| Dynamic message, callers match on cause | Custom error type with pointer receiver |

Custom error types end in `Error`, satisfy `Error() string`, and use a pointer receiver so `errors.As` is predictable:

```go
type ValidationError struct {
    Field, Reason string
}

func (e *ValidationError) Error() string {
    return fmt.Sprintf("%s: %s", e.Field, e.Reason)
}
```

## Panic vs error

- Libraries return errors; they do not panic on user input.
- `panic` is for "impossible" invariants (the program is already broken).
- `MustX` constructors are acceptable for setup that, if it failed, would mean a broken binary: `var re = regexp.MustCompile(...)`.
- `log.Fatal*` / `os.Exit` only in `main` (and `init` for setup).

## Ignoring errors

`_` to discard an error is acceptable only when the call has no side effects you care about. Common safe cases:

```go
_ = file.Close()           // best-effort on a read-only file after read
_ = json.NewEncoder(w).Encode(x)  // NOT safe — failure means client gets wrong response
```

If you discard an error from a write/close path that matters, that's a bug.

## "Errors are values" patterns

Sticky-error: track an error once across many calls instead of checking every call.

```go
type ew struct{ w io.Writer; err error }

func (e *ew) write(p []byte) {
    if e.err != nil { return }
    _, e.err = e.w.Write(p)
}

w := &ew{w: out}
w.write(a); w.write(b); w.write(c)
return w.err
```

This is what `bufio.Scanner.Err()` and `database/sql.Rows.Err()` look like internally — flag a long chain of `if err != nil { return err }` that could collapse to this pattern.

## Common findings

- `if err != nil { return err }` losing context that the caller needs to debug → wrap with `%w` + identifying value.
- `errors.New(fmt.Sprintf(...))` → use `fmt.Errorf` directly.
- `return fmt.Errorf("%v", err)` → either `return err` or wrap with `%w`.
- `errors.Wrap` from `pkg/errors` in new code → migrate to stdlib `%w`.
