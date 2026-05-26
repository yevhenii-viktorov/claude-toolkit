#!/usr/bin/env bash
# static-analysis.sh — run the standard Go review toolchain.
# Usage: ./static-analysis.sh [package-path]
# Default package path: ./...

set -u

PKG="${1:-./...}"
FAIL=0

section() { printf '\n=== %s ===\n' "$1"; }
ok()       { printf '  ok\n'; }
fail()     { printf '  FAIL\n'; FAIL=1; }
skip()     { printf '  skipped (%s not installed)\n' "$1"; }

have() { command -v "$1" >/dev/null 2>&1; }

section "gofmt -l"
out=$(gofmt -l . 2>&1)
if [[ -z "$out" ]]; then ok; else printf '%s\n' "$out"; fail; fi

section "go vet $PKG"
if go vet "$PKG"; then ok; else fail; fi

section "staticcheck $PKG"
if have staticcheck; then
  if staticcheck "$PKG"; then ok; else fail; fi
else
  skip staticcheck
fi

section "golangci-lint run $PKG"
if have golangci-lint; then
  if golangci-lint run "$PKG"; then ok; else fail; fi
else
  skip golangci-lint
fi

section "go test -race -count=1 $PKG"
if go test -race -count=1 "$PKG"; then ok; else fail; fi

section "govulncheck $PKG"
if have govulncheck; then
  if govulncheck "$PKG"; then ok; else fail; fi
else
  skip govulncheck
fi

section "gosec $PKG"
if have gosec; then
  if gosec -quiet "$PKG"; then ok; else fail; fi
else
  skip gosec
fi

printf '\n'
if [[ "$FAIL" -eq 0 ]]; then
  echo "All checks passed."
  exit 0
else
  echo "One or more checks failed."
  exit 1
fi
