# claude-toolkit

A collection of reusable resources for [Claude Code](https://docs.claude.com/en/docs/claude-code)
and Codex: behavioral guidelines and skills for building, reviewing, and shipping software.

## Contents

### Behavioral guidelines

[`CLAUDE.md`](./CLAUDE.md) — copy-paste-ready behavioral rules that reduce common LLM
coding mistakes (think before coding, simplicity, surgical changes, define done, plan/execute/report, writing style).
Drop into any project root, or merge into `~/.claude/CLAUDE.md` for global use.

### Skills

| Skill | Description | Source |
|-------|-------------|--------|
| [brainstorm](./skills/brainstorm) | Transform ambiguous ideas into executable plans through conversational discovery. | original |
| [grilling](./skills/grilling) | Stress-test a plan, decision, or idea a round of questions at a time. | [mattpocock/skills](https://github.com/mattpocock/skills) |
| [grill-me](./skills/grill-me) | Manual shortcut that starts `grilling`. | [mattpocock/skills](https://github.com/mattpocock/skills) |
| [grilling-old](./skills/grilling-old) | Earlier version of `grilling` that asks one question at a time. | [mattpocock/skills](https://github.com/mattpocock/skills) |
| [grill-me-old](./skills/grill-me-old) | Manual shortcut that starts `grilling-old`. | [mattpocock/skills](https://github.com/mattpocock/skills) |
| [backlog](./skills/backlog) | Keep a repo's deferred work in `docs/backlog/`, one file per item. | [umputun/cc-thingz](https://github.com/umputun/cc-thingz) |
| [run-plan](./skills/run-plan) | Execute a PLAN.md file (manual). | [glittercowboy/taches-cc-resources](https://github.com/glittercowboy/taches-cc-resources) |
| [whats-next](./skills/whats-next) | Write a handoff document for continuing in a fresh session (manual). | [glittercowboy/taches-cc-resources](https://github.com/glittercowboy/taches-cc-resources), modified |
| [business-research](./skills/business-research) | Founder-style business research playbook: market, financials, competitors, pitch, GTM. | original |
| [solo-business-research](./skills/solo-business-research) | Solo-builder product research: worth building, 4-8 week MVP, first paying users. | original |
| [market-research](./skills/market-research) | Market research, competitive analysis, market sizing, and vendor scans, explained in plain English. | original |
| [council](./skills/council) | Two-provider review council, with a prompted single-provider fallback. | [t3dotgg/tstack](https://github.com/t3dotgg/tstack), modified |
| [council-plus-fable](./skills/council-plus-fable) | Council with Claude Fable as a third member. | based on [t3dotgg/tstack](https://github.com/t3dotgg/tstack) `council` |
| [sol-loop](./skills/sol-loop) | Review changes with GPT Sol in a loop before filing a PR. | [t3dotgg/tstack](https://github.com/t3dotgg/tstack) |
| [golang-code-review](./skills/golang-code-review) | Rigorous, idiomatic Go code review for diffs, PRs, and whole packages. | original |
| [java-code-review](./skills/java-code-review) | Rigorous Java code review for diffs, PRs, and whole packages, with optional house style. | original |
| [java-code-style](./skills/java-code-style) | Default Java house style for writing and reviewing code. | original |
| [full-send](./skills/full-send) | Prove, file, babysit, and merge a PR unattended. | [t3dotgg/tstack](https://github.com/t3dotgg/tstack) |
| [full-stop](./skills/full-stop) | Same as `full-send`, but stop with the PR ready to merge. | [t3dotgg/tstack](https://github.com/t3dotgg/tstack) |
| [file-pr](./skills/file-pr) | File a concise pull request. | [t3dotgg/tstack](https://github.com/t3dotgg/tstack) |
| [babysit-pr](./skills/babysit-pr) | Monitor a pull request through review and CI. | [t3dotgg/tstack](https://github.com/t3dotgg/tstack) |
| [leaving-pr-comments](./skills/leaving-pr-comments) | Format agent-authored GitHub PR comments. | [t3dotgg/tstack](https://github.com/t3dotgg/tstack) |
| [modernize](./skills/modernize) | Rebase and reassess an aging pull request. | [t3dotgg/tstack](https://github.com/t3dotgg/tstack) |
| [takeover](./skills/takeover) | Take over an existing PR, branch, or agent thread. | [t3dotgg/tstack](https://github.com/t3dotgg/tstack) |
| [debug-like-expert](./skills/debug-like-expert) | Methodical debugging: evidence, hypotheses, verification. | [glittercowboy/taches-cc-resources](https://github.com/glittercowboy/taches-cc-resources) |
| [ui-ux-pro-max](./skills/ui-ux-pro-max) | UI/UX design intelligence: styles, palettes, font pairings, stacks. | [nextlevelbuilder/ui-ux-pro-max-skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) |

Skills from other projects keep their original MIT license in their folder (`LICENSE`).

## Installation

```bash
git clone https://github.com/yevhenii-viktorov/claude-toolkit.git
cd claude-toolkit
./install.sh
```

`install.sh` links every skill into `~/.claude/skills/` (Claude Code) and `~/.codex/skills/` (Codex),
and `CLAUDE.md` into `~/.claude/CLAUDE.md` and `~/.codex/AGENTS.md`. It only touches agents that are
installed. Anything already at one of those paths is moved to a backup folder first (`~/.Trash` on macOS,
`~/.local/share/claude-toolkit-backups` elsewhere).

The skills are links into the clone, so pulling updates them. Re-run the script after pulling to pick up
new skills:

```bash
git pull && ./install.sh
```

To pick and choose instead, copy single folders from `skills/` into `~/.claude/skills/` or `~/.codex/skills/`.

## License

[MIT](./LICENSE). Skills from other projects are MIT licensed by their authors; see the `LICENSE` file in each.
