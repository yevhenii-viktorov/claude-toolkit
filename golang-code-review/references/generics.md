# Generics

Sources: [Go blog: When to use generics](https://go.dev/blog/when-generics), [Go generics tutorial](https://go.dev/doc/tutorial/generics), language spec.

Generics arrived in Go 1.18. They are useful in narrow cases — most code is still better written with concrete types or interfaces.

## When to use

1. **Algorithm on a container type, indifferent to element type.**

   ```go
   func Keys[K comparable, V any](m map[K]V) []K {
       out := make([]K, 0, len(m))
       for k := range m { out = append(out, k) }
       return out
   }
   ```

   `slices`, `maps` stdlib packages are this pattern.

2. **Same algorithm across multiple unrelated types** — sort, min/max-like, set operations, generic numeric algorithms.

3. **Type-safe data structures** — `Stack[T]`, `Set[T]`, `Tree[T]`, `Queue[T]`. The alternative is `interface{}` everywhere with runtime assertions.

## When not to use

- **"Just because we can."** Start with concrete types. If you find the same code 3+ times for different types, *then* refactor to generics.

- **Behavior varies by type** → use an interface, not type params. If you need a method on `T`, you really need an interface.

  ```go
  // BAD — type param can't express "T has a Serialize method"
  func Send[T Serializable](t T) { /* ??? */ }

  // GOOD — interface
  type Serializable interface{ Serialize() []byte }
  func Send(s Serializable) { ... }
  ```

- **Runtime type discovery** — use `reflect` or `any` + type switch. Generics resolve at compile time; they can't help you dispatch on unknown types at runtime.

- **API boundaries** — interfaces describe behavior; type params describe algorithms. Public APIs usually want the former.

- **Generic over `any`** — if every call site uses `any`, you've just added syntactic noise. Use `interface{}` or rethink.

## Style

### Type parameter names

Single capital letters: `T`, `K`, `V`, `E`. Two-letter names when there's no convention:

```go
func Reduce[E, A any](s []E, init A, fn func(A, E) A) A
```

### Constraints

Use the narrowest constraint you can:

```go
// BAD: T any when only numeric ops needed
func Sum[T any](s []T) T

// GOOD: constraints.Ordered (or your own union)
import "golang.org/x/exp/constraints"
func Sum[T constraints.Ordered](s []T) T { var z T; for _, v := range s { z += v }; return z }
```

`comparable` for map keys / `==`. `any` is the fallback.

### Custom constraints

```go
type Number interface {
    ~int | ~int64 | ~float64
}
```

`~` allows derived types (`type ID int` satisfies `~int`). Without `~`, only the literal type qualifies.

### Limits

- **Methods can't have additional type parameters** beyond the receiver's. If you need that, it's a free function.
- **Type parameters can't have method sets** — only the constraints' methods are callable.
- Generic functions are compiled (and inlined) once per "GCShape" — runtime performance can surprise you. Benchmark generics-heavy hot paths.

## Common findings

- `func F[T any](x T) T` where every call site passes `int` — drop the type param.
- Generic wrapper around an `interface{}` field — the storage is still `any` under the hood, runtime cost is identical.
- Type param used where the function calls a method on `T` — should be an interface.
- `func F[T any](xs []T) []T` re-implementing something already in `slices`.
- Constraint named `T` (the conventional value type name) — name constraints by what they represent.
- Generic type defined "for future flexibility" with only one concrete usage in the codebase.
