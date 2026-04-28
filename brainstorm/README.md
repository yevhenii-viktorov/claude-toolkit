# brainstorm

Transform ambiguous ideas into executable plans through conversational discovery.

One question at a time, multiple choice preferred, with multi-angle analysis via lightweight lenses. Full pipeline: idea → BRIEF + ROADMAP + executable PLANs.

## When to use

- Brainstorming features
- Exploring requirements
- Validating designs
- Starting new projects

## Modes

- **Focused** — single feature or component (5–10 questions, produces a `PLAN`)
- **Comprehensive** — full project (15–25 questions, produces `BRIEF` + `ROADMAP` + `PLAN`s)

## Install

```bash
cp -r brainstorm ~/.claude/skills/
```

Then invoke with `/brainstorm` in Claude Code.

## Structure

```
brainstorm/
├── SKILL.md          # Entry point, principles, routing
├── workflows/        # Mode-specific workflows (focused, comprehensive, review, resume)
├── references/       # Lens system, plan templates, examples
└── templates/        # BRIEF, ROADMAP, PLAN scaffolds
```

## License

MIT — see repo root [LICENSE](../LICENSE).
