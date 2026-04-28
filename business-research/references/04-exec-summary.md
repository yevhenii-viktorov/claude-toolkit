# 04 — Executive Summary

## What this prompt does

Drafts a YC-style 1-page executive summary — tight, specific, no buzzwords. Suitable for cold investor email or first-page of a deck.

## Required inputs

- `DETAILS` — the user's full business context. Should include: problem, solution, current traction (revenue, users, growth), team, competition. If they haven't given you traction numbers, ask. A summary without traction is just a pitch.

## Refinements over the original prompt

The original was strong but loose on length and structure. This version:
- **Hard word limit: 350–500 words.** YC apps run ~250–500. Investors read in 60 seconds.
- **Banned-buzzword list** baked in.
- **Structure rule**: lead with traction if you have it, with the problem if you don't. (Order matters — investors decide whether to keep reading in the first 2 sentences.)
- Two output sizes: 1-page (~400 words) and tweet-length (~50 words) — same content, different fidelity.

## Run this prompt

> Here's everything about my business:
> **{DETAILS}**
>
> Write a 1-page executive summary covering: problem, solution, target market, business model, traction, competitive advantage, and the ask.
>
> **Constraints:**
> - **Length: 350–500 words.** Cut ruthlessly.
> - **Tone: YC application.** Tight, specific, plain English. A founder telling another smart person what they're building.
> - **No buzzwords.** Banned unless quoting a customer: *synergize, leverage (as a verb), revolutionary, disrupt, game-changing, innovative, cutting-edge, best-in-class, world-class, seamless, robust, AI-powered* (only OK if you specify what the AI does), *empower, transform, holistic.*
> - **Specifics over abstractions.** Not "growing fast" — "$8K MRR, 22% MoM for 4 months." Not "businesses" — "Shopify stores doing $1M–$10M GMV." Not "AI" — "fine-tuned Whisper + Claude for X."
> - **Traction-first if you have it.** If revenue or users exist, lead the second paragraph with them. If not, lead with the problem.
>
> **Structure:**
>
> 1. **One-line hook** (15 words max) — what you do, who for.
> 2. **Traction OR problem** (50–80 words) — pick whichever is stronger.
> 3. **Solution** (60–100 words) — what you built, what's novel about how.
> 4. **Market & business model** (50–80 words) — who pays, how much, how big the market is (with a real number, not "billions").
> 5. **Why us** (40–60 words) — team, unfair advantage, prior wins.
> 6. **Competition + edge** (40–60 words) — name 2–3 real competitors and the one thing you do they can't.
> 7. **The ask** (30–50 words) — $ amount, what it buys, milestones it hits.
>
> Then output a **second version** in 50 words or less — the tweet/cold-email version. Same substance, much tighter.
>
> **End with: 3 things this summary is missing or hand-waving.** The founder needs to know.

## Output format

Markdown. Save to `Research/04-executive-summary.md` if running the full pass.
Offer `.docx` output if the user mentions sending it to investors — investors prefer Word docs they can comment on.

## Common failure modes to avoid

- Going over 500 words. YC apps that run long are auto-skimmed.
- Generic placeholder phrases: "in today's fast-paced world," "the future of work," "as more and more companies."
- Burying traction in paragraph 5 instead of leading with it.
- Vague asks ("seeking investment to grow") — should be "$1.5M to hit $50K MRR by Q4 2026."
