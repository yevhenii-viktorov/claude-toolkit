# Project Structure

Sources: [Go Wiki: GoModules](https://go.dev/wiki/Modules), [go.dev/ref/mod](https://go.dev/ref/mod), [Effective Go](https://go.dev/doc/effective_go), community conventions.

## Layout

### Single binary

```
myapp/
├── go.mod
├── main.go        # only if very small; otherwise cmd/myapp/main.go
└── internal/
    ├── server/
    ├── store/
    └── ...
```

### Multiple binaries

```
myapp/
├── go.mod
├── cmd/
│   ├── api/main.go
│   └── worker/main.go
└── internal/
    ├── api/
    ├── worker/
    └── common/...
```

- `cmd/<binary>/main.go` — one per binary.
- `main()` only parses flags and calls `run(...) error`. Real logic lives elsewhere so it's testable without `os.Exit`.
- `internal/` is enforced by the compiler — packages under it cannot be imported by other modules.
- `pkg/` is optional, often unnecessary. Many projects put packages at the module root instead.

## Package boundaries

### Group by domain, not by layer

```
// BAD: layer-grouped, leads to circular deps
models/{user.go, order.go}
handlers/{user.go, order.go}
services/{user.go, order.go}

// GOOD: domain-grouped
user/{user.go, handler.go, service.go}
order/{order.go, handler.go, service.go}
```

### Package names

- Lowercase, single word, no underscores or `mixedCaps`: `http`, `json`, `user`.
- Singular: `user`, not `users`.
- Don't name a package `util`, `helpers`, `common`, `base`, `misc`, `shared`. These attract junk and create import dependencies on "everything". Name by what they provide.
- Package name = directory name.

### Stuttering

Don't repeat the package name in identifier names:

```go
// BAD
package user
type UserService struct{}

// GOOD
package user
type Service struct{}
// callers write user.Service
```

### Size

- One package per directory.
- Default to **fewer, larger** packages. Split when boundaries are obvious — not preemptively.
- Single-file, single-export packages are a smell unless the package genuinely encapsulates one concept (e.g., `errors`, `path`).

## Dependencies

### Circular

The compiler rejects them. When you hit one, the fix is rarely to invert the import — extract the shared types into a third package they both depend on, or define an interface in the consumer.

### Internal

Use `internal/` aggressively. It enforces "this is private to my module" at compile time. If a package outside the module imports `your/module/internal/x`, the build fails.

## go.mod / go.sum

```bash
go mod tidy   # before every commit
go mod verify # check go.sum integrity
go list -m -u all  # see available updates
```

- `go.mod` and `go.sum` must always be consistent. PR with mismatches is broken.
- `// indirect` markers (1.17+) on transitive deps are correct — don't strip them manually.
- Major versions ≥ 2 require a `/vN` suffix in the module path and import paths.
- `+incompatible` versions are a code smell — the upstream module hasn't adopted semantic import versioning. Avoid if avoidable.
- Pseudo-versions (`v0.0.0-YYYYMMDD-hash`) are fine when the upstream hasn't tagged, but prefer tagged releases when they exist.

### replace directives

`replace` is for local development, not for shipping. Flag any committed `replace` pointing to a local path (`replace foo => ./vendor-fork`). Replace targets in *dependencies'* go.mod files are ignored — only the main module's replaces apply, so don't rely on a dep's replace.

```go
// BAD (committed)
replace github.com/foo/bar => ../bar-fork

// OK (local dev only, must be removed before merge)
```

### Vendoring

Use `go mod vendor` only if there's a reason — reproducibility under network-isolated builds, regulated environments. Otherwise it's overhead.

## Imports

### Grouping

Three blank-line-separated groups: standard library, third-party, project-local.

```go
import (
    "context"
    "fmt"
    "net/http"

    "github.com/google/go-cmp/cmp"
    "go.uber.org/zap"

    "example.com/myapp/internal/store"
)
```

`goimports` handles this — make sure it runs. `golangci-lint` with `goimports` enforces it.

### Aliases

Only on conflict, or when the import-path tail isn't the package name:

```go
import (
    pb "example.com/proto/v1"
    httputil "example.com/internal/http"
)
```

Don't alias just for brevity.

### Blank and dot imports

- Blank `_ "github.com/lib/pq"` only in `main` packages or for `//go:embed`.
- Dot `.` imports only inside `_test.go` files when accessing internal helpers and reading clarity matters. Never in production code.

## Configuration

Pass config explicitly. Avoid package-level `var Config Cfg` that everything reads from — it kills testability.

```go
// GOOD
func NewServer(cfg Config) *Server { ... }

// BAD
var GlobalConfig Config
func NewServer() *Server { return &Server{cfg: GlobalConfig} }
```

## Common findings

- `pkg/util` or `pkg/helpers` package with a grab-bag of unrelated functions.
- `cmd/api/main.go` with 200 lines of business logic that should live in `internal/api`.
- Committed `replace` directive pointing to a local path.
- `go.mod` says `go 1.18` but the code uses generics — fine; says `go 1.18` but uses `min`/`max` — bug, bump to 1.21.
- `mypackage.MypackageType` stutter.
- Single-file `internal/types` package re-exported everywhere — leaky abstraction.
- Layer-based packages (`models/`, `repositories/`) when domain grouping would prevent circular deps.
