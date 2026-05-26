# claude-toolkit

A collection of reusable resources for [Claude Code](https://docs.claude.com/en/docs/claude-code):
behavioral guidelines, skills, and more.

## Contents

### Behavioral guidelines

[`CLAUDE.md`](./CLAUDE.md) — copy-paste-ready behavioral rules that reduce common LLM
coding mistakes (think before coding, simplicity, surgical changes, define done, plan/execute/report).
Drop into any project root, or merge into `~/.claude/CLAUDE.md` for global use.

### Skills

| Skill | Description |
|-------|-------------|
| [brainstorm](./skills/brainstorm) | Transform ambiguous ideas into executable plans through conversational discovery. |
| [business-research](./skills/business-research) | Founder-style business research playbook: market, financials, competitors, pitch, GTM. |
| [golang-code-review](./skills/golang-code-review) | Rigorous, idiomatic Go code review for diffs, PRs, and whole packages. |

## Installation

Clone the repo, then pick what you want.

```bash
git clone https://github.com/yevhenii-viktorov/claude-toolkit.git
cd claude-toolkit
```

**Skills** — copy folders into your Claude Code skills directory:

```bash
cp -r skills/brainstorm ~/.claude/skills/
cp -r skills/business-research ~/.claude/skills/
cp -r skills/golang-code-review ~/.claude/skills/
```

Skills are picked up automatically by Claude Code on the next session.

**CLAUDE.md** — copy into a project root, or merge into `~/.claude/CLAUDE.md` for all projects:

```bash
cp CLAUDE.md /path/to/your/project/
```

## License

[MIT](./LICENSE)
