#!/usr/bin/env bash
# static-analysis.sh — run the standard Java review toolchain.
# Auto-detects Maven vs Gradle and skips any check whose plugin/goal isn't wired up.
# Usage: ./static-analysis.sh [project-dir]   (default: current directory)

set -u

DIR="${1:-.}"
cd "$DIR" 2>/dev/null || { echo "Cannot cd to $DIR"; exit 2; }
FAIL=0

section() { printf '\n=== %s ===\n' "$1"; }
ok()       { printf '  ok\n'; }
fail()     { printf '  FAIL\n'; FAIL=1; }
skip()     { printf '  skipped (%s)\n' "$1"; }
have()     { command -v "$1" >/dev/null 2>&1; }

# Detect build tool.
if [[ -f "pom.xml" ]]; then
  BUILD="maven"
elif [[ -f "build.gradle" || -f "build.gradle.kts" ]]; then
  BUILD="gradle"
else
  BUILD="none"
fi

# Pick the runner: prefer the wrapper, fall back to a system tool.
run_maven() {
  if [[ -x "./mvnw" ]]; then ./mvnw -q "$@"; else mvn -q "$@"; fi
}
run_gradle() {
  if [[ -x "./gradlew" ]]; then ./gradlew "$@"; else gradle "$@"; fi
}

# True if a Maven plugin goal is bound/available; we test by asking help:describe cheaply.
maven_has_plugin() {  # $1 = plugin prefix (checkstyle / spotbugs)
  run_maven -o "$1:help" >/dev/null 2>&1 || run_maven "$1:help" >/dev/null 2>&1
}
# True if a Gradle task exists.
gradle_has_task() {   # $1 = task name
  run_gradle -q tasks --all 2>/dev/null | grep -qiE "(^| )$1( |$)"
}

printf 'Build tool detected: %s\n' "$BUILD"

case "$BUILD" in
  maven)
    if ! have mvn && [[ ! -x "./mvnw" ]]; then
      echo "Maven not available (no mvn / ./mvnw) — cannot run checks."; exit 2
    fi

    section "Checkstyle (mvn checkstyle:check)"
    if maven_has_plugin checkstyle; then
      if run_maven checkstyle:check; then ok; else fail; fi
    else
      skip "checkstyle plugin not configured"
    fi

    section "SpotBugs (mvn spotbugs:check)"
    if maven_has_plugin spotbugs; then
      if run_maven spotbugs:check; then ok; else fail; fi
    else
      skip "spotbugs plugin not configured"
    fi

    section "Compile with lint (mvn compile)"
    if run_maven compile -Dmaven.compiler.showWarnings=true; then ok; else fail; fi

    section "Tests (mvn test)"
    if run_maven test; then ok; else fail; fi
    ;;

  gradle)
    if ! have gradle && [[ ! -x "./gradlew" ]]; then
      echo "Gradle not available (no gradle / ./gradlew) — cannot run checks."; exit 2
    fi

    section "Checkstyle (gradle checkstyleMain)"
    if gradle_has_task checkstyleMain; then
      if run_gradle checkstyleMain; then ok; else fail; fi
    else
      skip "checkstyle plugin not applied"
    fi

    section "SpotBugs (gradle spotbugsMain)"
    if gradle_has_task spotbugsMain; then
      if run_gradle spotbugsMain; then ok; else fail; fi
    else
      skip "spotbugs plugin not applied"
    fi

    section "Compile (gradle compileJava)"
    if gradle_has_task compileJava; then
      if run_gradle compileJava; then ok; else fail; fi
    else
      skip "no compileJava task"
    fi

    section "Tests (gradle test)"
    if gradle_has_task test; then
      if run_gradle test; then ok; else fail; fi
    else
      skip "no test task"
    fi
    ;;

  none)
    echo "No pom.xml or build.gradle found in $DIR — nothing to run."
    echo "If this is a plain-javac project, compile with: javac -Xlint:all <sources>"
    exit 2
    ;;
esac

printf '\n'
if [[ "$FAIL" -eq 0 ]]; then
  echo "All available checks passed (skipped checks are not failures)."
  exit 0
else
  echo "One or more checks failed."
  exit 1
fi
