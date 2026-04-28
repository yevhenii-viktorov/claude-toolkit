---
name: business-research
description: Run rigorous founder-style business research using a battle-tested 7-prompt playbook. Use this skill whenever the user wants to research a market, stress-test a business idea, build financial projections, write an executive summary or pitch deck, do competitor analysis, or pressure-test a go-to-market plan. Trigger on phrases like "research the market for X", "tear apart my idea", "build me projections", "write an exec summary", "compare these competitors", "draft my pitch deck", "review my GTM", or anything about validating, planning, or fundraising for a startup. Use it even when the user only mentions one of the seven tasks — the skill knows how to run a single piece in isolation.
---

# Business Research Skill

A 7-prompt playbook for founder-grade business research. Each prompt is honed to produce specific, defensible, decision-grade output instead of generic LLM mush.

## How to use this skill

1. **Identify which prompt(s) the user needs.** Map their request to one of the seven below. If they're asking for the full picture, run them in order. If they only need one (e.g. "stress-test my GTM"), run just that one.

2. **Read the matching reference file** in `references/` for the full instructions, refinements, and output format. The summaries below are pointers, not the full spec.

3. **Collect missing inputs before starting.** Each prompt has required variables (industry, idea details, numbers, etc.). If the user didn't provide them, ask in a single batched question — don't trickle.

4. **Cite sources for any factual claim.** Market sizes, competitor pricing, funding amounts, growth rates — all need a source link. If you can't verify something, label it `[ASSUMPTION]` or `[ESTIMATE]` and explain the basis.

5. **Be honest, not flattering.** Founders pay for sharp feedback, not encouragement. If the unit economics don't work, say so. If the market is crowded, say so. The goal is decisions, not dopamine.

## The seven prompts

| # | Name | When to use | Reference |
|---|------|-------------|-----------|
| 1 | Market Research | Sizing a market, finding competitors, spotting underserved segments | `references/01-market-research.md` |
| 2 | Business Model Critique | Stress-testing an idea before committing time/money | `references/02-model-critique.md` |
| 3 | Financial Projections | Building a 3-year P&L + cash runway | `references/03-financials.md` |
| 4 | Executive Summary | Drafting a 1-page YC-style summary | `references/04-exec-summary.md` |
| 5 | Competitor Reverse-Engineering | Beating specific named competitors | `references/05-competitor-research.md` |
| 6 | Pitch Deck Outline | Drafting a 12-slide investor deck | `references/06-pitch-deck.md` |
| 7 | GTM Stress Test | Pressure-testing a go-to-market plan | `references/07-gtm-stress-test.md` |

## Cross-cutting rules

These apply to every prompt — they are what separate this from a generic ChatGPT response.

**No buzzword fluff.** Banned words unless quoting someone: *synergize, leverage (as a verb), revolutionary, disrupt, game-changing, innovative solution, cutting-edge, best-in-class, world-class, seamless, robust, scalable* (use only with a specific scaling number), *AI-powered* (use only when describing what the AI actually does).

**Numbers over adjectives.** "Fast growth" is useless. "37% YoY for 3 years per Crunchbase" is useful. Every claim with a number gets a source or an `[ESTIMATE: reasoning]` tag.

**Specificity over coverage.** A 5-line answer that's specific beats a 50-line answer that's generic. If the user gave you a B2B SaaS for HVAC contractors, the answer should reference HVAC contractors, not "businesses."

**Surface unknowns explicitly.** End each output with a "What I don't know yet" section listing 3-5 questions the founder still needs to answer. This is more valuable than fake confidence.

**Output format defaults:**
- Tables → use markdown tables for any comparative data
- Long deliverables (financial models, pitch decks, exec summaries) → offer to also save as a file (`.xlsx`, `.pptx`, `.docx`, `.md`)
- Short critiques → inline in chat
- Always lead with the headline finding, then the detail

## When the user wants the full pass

If the user wants all 7 run on a single business, do them in this order — earlier outputs feed later ones:

1. Market Research → grounds everything in real numbers
2. Competitor Reverse-Engineering → identifies who you're up against
3. Business Model Critique → tests whether the idea survives contact with reality
4. Financial Projections → quantifies the path
5. GTM Stress Test → checks whether you can actually reach customers
6. Pitch Deck Outline → packages it for investors
7. Executive Summary → distills it to one page

Save each output as a separate file in a `Research/` folder so the user can review and iterate on each piece independently.

## When inputs are vague

Don't make up inputs to seem helpful. If the user says "research the SaaS market," that's too broad — push back: "SaaS is too broad to size meaningfully. What vertical? Who's the buyer? Pick one and I'll run it." Same for "build me a financial model" without numbers — ask for starting revenue, pricing, growth rate, and major cost categories before generating anything.

The exception: if the user has already given you context earlier in the conversation (or in a previous chat the search tool can find), use that context and confirm rather than re-asking.
