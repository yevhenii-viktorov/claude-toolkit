# claude-skills

A collection of [Claude Code](https://docs.claude.com/en/docs/claude-code) skills.

## Skills

| Skill | Description |
|-------|-------------|
| [brainstorm](./brainstorm) | Transform ambiguous ideas into executable plans through conversational discovery. |
| [business-research](./business-research) | Founder-style business research playbook: market, financials, competitors, pitch, GTM. |

## Installation

Drop any skill folder into your Claude Code skills directory:

```bash
git clone https://github.com/<your-username>/claude-skills.git
cp -r claude-skills/brainstorm ~/.claude/skills/
cp -r claude-skills/business-research ~/.claude/skills/
```

Skills are picked up automatically by Claude Code on the next session.

## License

[MIT](./LICENSE)
