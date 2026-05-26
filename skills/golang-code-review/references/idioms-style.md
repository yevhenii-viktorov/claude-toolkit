# Idioms & Style

Sources: [Effective Go](https://go.dev/doc/effective_go), [Go Code Review Comments](https://go.dev/wiki/CodeReviewComments), [Go Style Decisions](https://google.github.io/styleguide/go/decisions), Uber Go Style Guide.

**Calibration:** flag style issues that hurt readability or correctness. Don't pad reviews with `gofmt` re-statements or godoc nits on internal helpers.

## Naming

### Casing

- Exported: `MixedCaps`. Unexported: `mixedCaps`. **No** `snake_case`, **no** `SCREAMING_CASE`.
- Constants follow the same rule: `MaxPacketSize`, not `MAX_PACKET_SIZE`.

### Initialisms

Keep case consistent across an identifier:

```go
// GOOD
userID, ServeHTTP, parseURL, xmlRPC
// BAD
userId, ServeHttp, parseUrl, xmlRpc
```

`URL`, `ID`, `HTTP`, `API`, `IO`, `DB`, `SQL`, `JSON`, `XML`, `RPC` — all uppercase when exported, lowercase when not (`url`, `id`, etc.).

### Scope-based length

- Tight scope (loop var, one-line closure): `i`, `v`, `k`, `c`. Short is good.
- Function-local: a few characters, named for what they are: `buf`, `cfg`, `req`.
- Package-level: descriptive: `DefaultTimeout`, `maxRetries`.

### No stutter

```go
// BAD
package user
type UserService struct{}
func (s *UserService) GetUser() {}

// GOOD
package user
type Service struct{}
func (s *Service) Get() {}
// callers: user.Service, svc.Get()
```

### Receivers

1–2 letters, consistent across all methods on the type. Not `this`, `self`, `me`, or the full type name.

```go
func (c *Client) Get() {}
func (c *Client) Set() {}  // same letter, every method
```

### No `Get` prefix

```go
// BAD
func (u *User) GetName() string { return u.name }
// GOOD
func (u *User) Name() string { return u.name }
```

`Set` prefix on setters is fine: `SetName(n string)`.

## Control flow

### Early return; no else after return

```go
// BAD
if err != nil {
    return err
} else {
    return process(x)
}

// GOOD
if err != nil { return err }
return process(x)
```

Reduces nesting. Same for `continue`, `break`.

### Scoped if-init

```go
if v, err := f(); err != nil {
    return err
} else {
    use(v)
}
// BAD — else after return-in-then would be cleaner; but if you need v outside, just don't scope it
```

Better:

```go
v, err := f()
if err != nil { return err }
use(v)
```

`if x, err := f(); err != nil { ... }` is good when `x` is only used inside the `if`.

### Switch

```go
switch v := x.(type) {
case int, int64:   // comma for multi-match
    use(v)
case string:
    use(v)
default:
    panic("unreachable")
}
```

No implicit fallthrough; explicit `fallthrough` is rare and a smell.

### Naked returns

Only in short functions (<10 lines) where the named returns are *the* documentation:

```go
func split(s string) (head, tail string) {
    // ...
    return
}
```

In larger functions, always explicit: `return x, nil`.

## Variable declaration

```go
// "I want the zero value":
var s []string   // not s := []string{}

// "I have an initial value":
s := []string{"a", "b"}

// Exception: JSON-serialized slices need [] not null:
s := []string{}  // ok when zero value matters for encoding
```

`var` for zero values, `:=` for initialization. Avoid `var x int = 0` — redundant.

## Comma-ok idiom

```go
v, ok := m[k]    // map lookup
v, ok := <-ch    // channel receive
v, ok := i.(T)   // type assertion
```

Always use comma-ok unless a panic is genuinely the right outcome.

## Time

- `time.Duration` for periods. **Never** raw `int` for seconds/ms.
- `time.Time` for instants.
- Compare with `.Before(t2)` / `.After(t2)` / `.Equal(t2)`, not arithmetic.
- Don't depend on a specific time zone unless documented.

```go
// BAD
func Wait(seconds int)
// GOOD
func Wait(d time.Duration)
```

## Strings

- Raw strings (`` ` ``) for regex, JSON literals, multi-line — avoids backslash hell.
- `strings.Contains/HasPrefix/HasSuffix` over manual indexing.
- `strings.EqualFold(a, b)` for case-insensitive compare.

## Comments

- Explain *why*, not *what*. The code shows what.
- TODO format: `// TODO(username): description` — assigns accountability.
- Doc comments on exported library APIs **[library]** start with the identifier name and are full sentences.
- For internal code: comment only when the *why* isn't in the name and body.

## Formatting

- `gofmt` / `goimports` are non-negotiable. Don't review formatting findings — let the tool handle it.
- Line length: no fixed rule. Break for readability, not arbitrary columns.
- Struct literals: field names required across package boundaries; encouraged in tests; optional within a package for small structs.
- Omit zero fields in struct literals.

```go
// GOOD
opts := Options{Timeout: 5 * time.Second}

// AVOID
opts := Options{
    Addr:    "",
    Timeout: 5 * time.Second,
    Logger:  nil,
}
```

## Common findings

- `userId` / `httpUrl` / `xmlRpc` — wrong initialism casing.
- `package user; type UserService` — stuttering.
- `func GetUser()` getter with `Get` prefix.
- `else` after `return` / `continue`.
- `func Wait(seconds int)` — should be `time.Duration`.
- `var s []string = []string{}` — pick one form, not both.
- `if x.(*T).Method()` — un-checked type assertion that will panic on bad input.
- `// TODO: ...` without an owner — won't be tracked, stays forever.
- TODO comments dated >1 year, untouched.
