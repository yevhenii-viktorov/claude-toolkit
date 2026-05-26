# 02 — Business Model Critique

## What this prompt does

A skeptical, structured tear-down of a business idea before the founder commits time/money. Rated FATAL / SERIOUS / MINOR with evidence.

## Required inputs

- `IDEA` — the user's pitch in their own words. Better if they include: who pays, how much, how acquired, what it costs to deliver. If they only have a one-liner, ask for 3-5 more sentences before tearing it apart.

## Refinements over the original prompt

The original was fine but vague on what makes a flaw "FATAL" vs "SERIOUS." This version forces each rating to include:
- A **quantitative threshold** ("if CAC > $X, this is fatal")
- **Evidence or reasoning**, not just "this seems risky"
- A **fix** the founder could attempt

It also adds two sections the original missed: **questions the founder hasn't answered** (often more revealing than weaknesses) and **the strongest version of the idea** (a steelman, so the critique isn't just dunking).

## Run this prompt

> Here's my business idea:
> **{IDEA}**
>
> Act as a skeptical, experienced VC partner who has seen 1000 pitches and isn't trying to be nice. But: be precise, not theatrical. "This is dumb" is useless. "Your CAC assumption of $40 is unrealistic because comparable B2C apps in this category run $80–120 — see a16z's 2024 consumer benchmarks" is useful.
>
> Output six sections:
>
> **1. The Steelman (1 paragraph)**
> The strongest version of why this could work. Don't skip this — if you can't write it, the critique below isn't fair.
>
> **2. Unit Economics**
> Pressure-test pricing, COGS, CAC, LTV, payback period. For each:
> - State the founder's implicit or explicit assumption.
> - State the realistic range based on comparables.
> - Rate: FATAL / SERIOUS / MINOR / OK.
> - Suggest the fix.
>
> **3. Market & Demand**
> Is the pain real? Are people already paying for adjacent solutions? Is this a vitamin or a painkiller? Same FATAL/SERIOUS/MINOR rating per finding.
>
> **4. Defensibility / Moat**
> Network effects? Data moat? Switching costs? Brand? Distribution lock-in? Or is it a feature that an incumbent could ship in a sprint? Rate honestly.
>
> **5. Scalability Bottlenecks**
> What breaks at 10x? At 100x? Is it ops-heavy (services-disguised-as-software)? Does CAC blow up after the early-adopter pool? Does support cost outrun ARPU?
>
> **6. The Five Questions You Haven't Answered**
> Five specific things the founder doesn't seem to have an answer for yet. Often more useful than the critique itself.
>
> **Closing: Rating**
> Overall: GO / GO-WITH-CHANGES / KILL — and one sentence why.
> Three things to fix this week before doing anything else.
>
> Use FATAL only when the issue mathematically prevents the business from working at any scale. SERIOUS = could kill it but might be solvable. MINOR = needs attention but won't make-or-break.

## Output format

Inline in chat for short critiques. Save to `Research/02-model-critique.md` if running the full pass.

## Common failure modes to avoid

- Performative meanness — "rip it apart" rhetoric without substance.
- Generic VC-speak ("how do you think about defensibility?") instead of specific challenges.
- Ignoring positive signals (steelman section is required).
- Rating things FATAL when they're really SERIOUS — devalues the rating.
