# 06 — Pitch Deck Outline

## What this prompt does

Drafts a 12-slide investor deck outline with headlines, bullets, speaker-note hints, and explicit flags for which slides need real numbers vs. storytelling.

## Required inputs

- `BUSINESS_DETAILS` — same as the Executive Summary input (problem, solution, traction, team, market, ask). Reuse if available.
- Optional: `STAGE` — pre-seed / seed / Series A. Different stages emphasize different slides.

## Refinements over the original prompt

The original was a clean 12-slide structure with headlines + bullets. This version adds:
- **Speaker-note hint** for each slide — what the founder should say *aloud* that isn't on the slide. (Slides should be sparse; the talk track carries the weight.)
- **Real-numbers flag** — for each slide, is the content fact, estimate, or story? Critical so the founder doesn't fabricate at slide 3 and get caught at slide 9.
- **Common-mistake callout** per slide — the trap most founders fall into.
- **Optional `.pptx` generation** — offer to actually build the deck.

## Run this prompt

> Create a 12-slide pitch deck outline for **{BUSINESS_DETAILS}** at **{STAGE}** stage.
>
> Standard 12-slide structure: Problem, Solution, Market Size, Product, Business Model, Traction, Team, Competition, Financials, Go-to-Market, Timeline, The Ask.
>
> **For each slide, output:**
>
> ```
> Slide N: [Slide name]
> ─────────────────────
> Headline: [The one line at the top — should make the point on its own]
> Bullets:
>   • [bullet 1]
>   • [bullet 2]
>   • [bullet 3]
> Speaker-note: [What the founder should say aloud that isn't on the slide — usually the why behind the what]
> Tag: [FACT / ESTIMATE / STORY] — flags whether this is verifiable, projected, or narrative
> Watch out: [the common mistake to avoid on this slide]
> ```
>
> **Tagging rules:**
> - **FACT** — needs to be true and verifiable (traction numbers, team backgrounds, customer logos). Investors will check.
> - **ESTIMATE** — projected (financials, market size). Show your math, don't fabricate.
> - **STORY** — narrative (problem statement, vision, why-now). Doesn't need to be quantitative but needs to feel real.
>
> **Stage-specific emphasis:**
> - Pre-seed: lean hard on Problem, Team, Why-Now. Traction is forgivable. Vision matters.
> - Seed: Traction starts mattering — design partners, early MRR, validated pull. Market size matters more.
> - Series A: Numbers carry the deck. Slides 5, 6, 9 (Business Model, Traction, Financials) are the entire pitch.
>
> **At the end, output:**
> 1. **What's missing** — which slides you couldn't fully fill in because the user didn't give you the inputs. Specific list of what to gather.
> 2. **The 30-second version** — if the founder only had 30 seconds with one slide, which slide would it be and what would it say? (Usually Traction or Problem, depending on stage.)
>
> Then offer: "Want me to generate this as a .pptx file using the design skill?"

## Output format

Markdown outline by default.
If user accepts: generate a `.pptx` using the `pptx` skill. Save to `Research/06-pitch-deck.md` (+ `.pptx`) if running the full pass.

## Common failure modes to avoid

- Bullets that are full sentences. Bullets are anchors for the talk track, not the talk track.
- Putting the ask buried in slide 12 with no specifics — should be "$X to reach Y by date Z."
- Skipping the Why-Now framing — investors fund timing, not just ideas.
- Cluttered Competition slide (too many logos). Three competitors max + your wedge.
- Vague Team slide ("experienced team") — name the relevant past wins / domain expertise.
