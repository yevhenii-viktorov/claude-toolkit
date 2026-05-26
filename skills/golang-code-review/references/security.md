# Security

Sources: [Go Security Best Practices](https://go.dev/security/best-practices), [gosec](https://github.com/securego/gosec), [OWASP Go](https://owasp.org/www-project-go-secure-coding-practices-guide/), Uber Go Style Guide.

## Randomness & crypto

- **Never `math/rand`** for tokens, IDs, keys, passwords, session IDs, or anything where unpredictability matters. Use `crypto/rand`.
- Don't seed `math/rand` with `time.Now()` and call it secure. It isn't.
- No MD5 / SHA1 for security (hashing passwords, signatures). They're acceptable for non-security checksums.
- SHA-256+ for hashes; `bcrypt`/`argon2`/`scrypt` for passwords.
- RSA keys ≥ 2048 bits.
- TLS minimum version: `tls.VersionTLS12`.
- **Never `InsecureSkipVerify: true`** outside tests.
- Compare secrets with `subtle.ConstantTimeCompare` — `==` is timing-attack vulnerable.

```go
// BAD
if hmac == expected { authed = true }
// GOOD
if subtle.ConstantTimeCompare(hmac, expected) == 1 { authed = true }
```

- Go 1.24+: `crypto/rand.Text()` returns a uniformly random base32 string suitable for tokens.

## SQL injection

**Always parameterize.** Flag every `fmt.Sprintf`/`+` inside a query argument.

```go
// CRITICAL
q := fmt.Sprintf("SELECT * FROM users WHERE id = %s", id)
db.Query(q)

// GOOD
db.Query("SELECT * FROM users WHERE id = ?", id)
```

ORMs aren't a get-out — `Raw(...)` / `Exec(...)` with interpolation reintroduces the bug.

## Command injection

```go
// CRITICAL: shell parses userInput
exec.Command("sh", "-c", "echo "+userInput).Run()

// GOOD: argv passed directly to the binary, no shell
exec.Command("echo", userInput).Run()
```

If the binary itself is dynamic, validate against an allowlist.

## Path traversal / zip-slip

User-controlled paths must be cleaned and bounded:

```go
clean := filepath.Clean(userPath)
full := filepath.Join(baseDir, clean)
rel, err := filepath.Rel(baseDir, full)
if err != nil || strings.HasPrefix(rel, "..") {
    return ErrEscapesBase
}
```

For zip/tar extraction, do this check for **every** entry before opening the destination file. Otherwise an attacker-crafted archive can write `../../etc/...`.

Go 1.24+: `os.Root` provides a path-bounded FS handle that refuses traversal — prefer it for new code.

## Input validation

- Validate at the boundary (HTTP handler / RPC entry), not deep in the call chain.
- Bound sizes before allocating: file uploads, JSON bodies, decompressed sizes. Otherwise → DoS.
- `http.MaxBytesReader(w, r.Body, N)` on every request body.
- For multipart: `r.ParseMultipartForm(maxBytes)`.

## HTML / templates

- `html/template`, not `text/template`. The former is context-aware-escaped.
- Don't `template.HTML(...)` on user input — it bypasses escaping.
- Set `Content-Security-Policy`, `X-Content-Type-Options: nosniff`, `X-Frame-Options: DENY` on HTML responses.

## URL handling

- Parse with `url.Parse`; validate `scheme` and `host` against an allowlist.
- Open-redirect: never `http.Redirect(w, r, r.URL.Query().Get("next"), 302)` without validating `next`.
- SSRF: when fetching a URL on behalf of a user, deny private/loopback IPs (`net.ParseIP` + range checks).

## Cookies

```go
http.SetCookie(w, &http.Cookie{
    Name:     "session",
    Value:    token,
    HttpOnly: true,
    Secure:   true,
    SameSite: http.SameSiteStrictMode,
})
```

## HTTP server defaults

`http.Server` zero value has no timeouts — production servers must set them:

```go
srv := &http.Server{
    Addr:              ":8080",
    Handler:           mux,
    ReadHeaderTimeout: 5 * time.Second,
    ReadTimeout:       10 * time.Second,
    WriteTimeout:      10 * time.Second,
    IdleTimeout:       120 * time.Second,
}
```

## Integer & bounds

- Narrowing conversions (`int64` → `int32`, `int` → `uint`) need range checks.
- File sizes / lengths from headers: cap before allocating. Decompressed sizes likewise (zip-bomb).
- `strconv.Atoi` returns an `int`; treat it as bounded.

## Deserialization

- `encoding/gob` on untrusted input = RCE risk (gob can decode into arbitrary types). Use JSON or protobuf with a fixed schema.
- `yaml.v2` anchors → memory explosions ("billion laughs"). `yaml.v3` with explicit limits, or `goccy/go-yaml`.
- XML: disable external entity processing.

## Secrets

- No secrets in code, struct tags, comments, log lines, or test fixtures.
- Redact via custom `String()` / `LogValue() slog.Value` methods on types carrying secrets.
- Don't log full request bodies on error paths.
- `.env` files in `.gitignore`. Check `git log -p` if you suspect leaks.

## TLS client

```go
&http.Client{
    Transport: &http.Transport{
        TLSClientConfig: &tls.Config{
            MinVersion: tls.VersionTLS12,
            // InsecureSkipVerify: false — never true in prod
        },
    },
}
```

## Dependencies

```bash
govulncheck ./...   # symbol-aware CVE check; required in CI
go list -m -u all   # see what could be updated
go mod tidy
```

`govulncheck` is stricter than dependabot — it checks whether your code actually calls the vulnerable function.

## Common findings

- `math/rand` for a token/ID/nonce.
- `db.Query(fmt.Sprintf(...))` anywhere.
- `exec.Command("sh", "-c", ...)` with anything user-controlled.
- `filepath.Join(base, userPath)` without containment check.
- `==` comparing HMACs, session tokens, or signatures.
- `http.Server{}` without timeouts in `main`.
- `InsecureSkipVerify: true` outside `_test.go`.
- Logging an entire request, error containing the auth header, or a struct with a secret field.
