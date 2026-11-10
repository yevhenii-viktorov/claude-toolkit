---
name: solo-business-research
description: Run a 13-section solo-builder / indie-hacker product research pass that decides whether an idea is worth building, can ship as a 4-8 week MVP, and can reach paying users without ad spend. Use this skill when the user describes themselves as a solo founder, indie hacker, bootstrapper, or small bootstrapped team — or when they say things like "should I build this", "can I ship this in 8 weeks", "MVP scope", "validate before building", "no VC funding", "kill / pivot / build", "validation plan", "first 100 users", or ask for a brutal practical critique of a product idea. This skill is explicitly NOT for VC-track founders raising money — for that, use the `business-research` skill instead. Trigger this skill even when the user only asks for one section (e.g. just MVP scope, just risk register, just validation plan).
---

# Solo-Builder Product Research Skill

A 13-section playbook for deciding whether a software product idea is worth a solo builder's time. Optimizes for: bootstrapped execution, fast validation, low burn, founder capacity, and shipping in weeks not quarters.

## When to use this vs. `business-research`

| Signal | Use this skill | Use `business-research` |
|--------|---------------|-------------------------|
| Audience | Solo / indie / bootstrapped | VC-track / raising money |
| Time horizon | 4–8 week MVP, profitable in months | Multi-quarter milestones, Series Seed in 18 mo |
| Output style | Brutal practical, no startup theater | YC-application style, traction-led |
| Key questions | "Can I build this in 6 weeks?" "First 100 users?" | "What's my LTV/CAC?" "What's the ask?" |
| Default growth assumption | Zero ad spend until PMF | Paid acquisition tested early |

If the user is unclear, ask one question: *"Are you bootstrapping or planning to raise?"* Then pick.

## How to use this skill

1. **Read `references/playbook.md` for the full 13 sections.** The summaries below are pointers, not the spec.
2. **Read `references/standards.md` for cross-cutting output rules** — banned buzzwords, evidence tags, table formatting, kill thresholds.
3. **Gather inputs first.** The playbook needs ~15 fields (product name, target users, competitors, founder constraints, etc.). The full list is in `references/inputs.md`. If the user hasn't given them, ask in **one batched question** — never trickle.
4. **Decide scope before running.**
   - User said "run the full pass" or similar → run all 13 sections, save each as a separate file in `Research/`.
   - User asked for one section ("just the MVP scope", "what's my risk register?") → run only that section, output inline unless long.
   - User is mid-build and wants validation only → run sections 11, 12, 13 (Risk / Validation / Recommendation).
5. **Be brutal but practical.** This skill exists because most idea critiques are either too soft (sycophantic LLM) or too theatrical (fake VC meanness). Be the third thing: a friend who has shipped 5 SaaS products and tells you the truth.

## The 13 sections

| # | Section | Decides... |
|---|---------|-----------|
| 1 | Market Reality | Is the market growing, reachable by one person, big enough? |
| 2 | Competitor Reverse Engineering | Who's already doing it, how, with what gaps? |
| 3 | Underserved Segment Discovery | Where can a solo builder win? |
| 4 | Solo-Builder Brutal Critique | Why might this fail under solo constraints? |
| 5 | Business Model Analysis | What pricing model fits the product + founder? |
| 6 | Unit Economics & Cost Reality | Will it actually make money at scale? |
| 7 | 3-Year Financial Projection | When does it break even? When can the founder quit their job? |
| 8 | GTM Stress Test | Which channels actually work for one person, no ad budget? |
| 9 | MVP Scope & Build Plan | What's the smallest possible thing to ship? |
| 10 | Differentiation Strategy | How to position so customers pick you over incumbents? |
| 11 | Risk Register | What could kill this, what's the early warning? |
| 12 | Validation Plan | What 30 days of work would tell you if this is real? |
| 13 | Build / Kill / Pivot Recommendation | The verdict. |

When running the full pass, output sections in this order — earlier sections feed later ones.

## Cross-cutting rules (apply to every section)

These are what separate this skill from a generic AI response. Full detail in `references/standards.md`. Highlights:

- **Tag every claim**: VERIFIED FACT / ESTIMATE / ASSUMPTION / RISK / VALIDATION-METHOD. The user explicitly asked for this — it's the core epistemic discipline of the skill.
- **No VC theater**: No "disrupt", no "10x", no "billion-dollar TAM" framing. The audience is solo builders deciding what to build next month.
- **Tables over prose**: The user specified table-heavy output. Default to markdown tables for any comparative or structured info.
- **Solo-builder constraints are first-class**: Every recommendation has to pass the "can one person actually do this with limited weekly hours and ~$X/month budget" filter.
- **Kill criteria stated upfront**: Don't hedge. If the idea fails the brutal critique, say so. If a channel is a waste at this stage, say WASTE. If a feature shouldn't be built, say NEVER.

## Output format defaults

- **Full pass**: Each section saved as a separate `.md` file in a `Research/` folder. Plus a `00-summary.md` with the verdict from section 13 at the top.
- **Single section**: Inline in chat unless > ~80 lines, then file.
- **Financial projections (section 7)**: Offer `.xlsx` output via the xlsx skill if available.
- **Validation plan (section 12)**: Always end with a clear day-by-day calendar + the decision rule (build / kill / pivot at end of 30 days).

## When the user has skipped sections in their inputs

Don't fabricate. If the user gave you product name + problem but no competitors and no pricing hypothesis, run sections that work (1, 4, 9, 12) and **explicitly skip** sections that need the missing inputs — list what's missing and why. A partial honest output beats a complete fabricated one.

## When the user pushes back on the verdict

If section 13 says "kill" and the user disagrees, don't reverse the verdict to please them. Re-examine the specific claim they're disputing, update if they have new info, otherwise hold the line and explain the threshold you'd need to see crossed to change the recommendation.
