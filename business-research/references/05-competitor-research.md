# 05 — Competitor Reverse-Engineering

## What this prompt does

Maps out what 5 named competitors are actually doing — pricing, who they serve, how they acquire customers, where they're weak — and produces a positioning strategy to win the customers they're ignoring.

## Required inputs

- `COMPETITORS` — list of 5 specific competitors. If the user only names 2–3, push back: "Want me to find 2 more from your space, or run with these?"

## Refinements over the original prompt

The original asked for "estimated team size" and "key partnerships," which are hard to verify and often wrong. This version:
- Replaces unreliable signals with **verifiable ones**: pricing from their site, positioning quoted from their homepage, funding from Crunchbase, hiring signals from LinkedIn job posts.
- Forces **evidence for acquisition channel claims** — if you say "they're winning on SEO," show the keywords they rank for. If you say "they buy ads," show that you saw the ad.
- Ties the differentiation strategy to **specific underserved segments** the competitors are leaving on the table — not generic "be more user-friendly" advice.

## Run this prompt

> Research these 5 competitors:
> **{COMPETITORS}**
>
> For each, build a deep profile and then synthesize a positioning strategy.
>
> **Per-competitor profile (do this for each of the 5):**
>
> 1. **Positioning** — quote their tagline from their homepage. Then translate: "in plain English, they're saying: ..."
> 2. **Pricing** — entry tier, mid tier, top tier in $/month. Note free tier limits. (Get this from their pricing page — link it.)
> 3. **Target customer** — who they're pricing/positioning for. Cite evidence: case studies on their site, customer logos, the personas in their marketing.
> 4. **Acquisition channels (with evidence)** — pick 2–3 from: SEO (which keywords?), paid ads (have you seen them?), partnerships (which integrations are they leading with?), community (subreddit, Discord?), founder-led content (Twitter, blog?), App Store / marketplace, sales-led. Cite the evidence for each claim.
> 5. **Funding & stage** — last round + amount + date from Crunchbase. Note if bootstrapped.
> 6. **Hiring signals** — what roles are they hiring for right now? (LinkedIn / their careers page.) This reveals strategy.
> 7. **Visible weaknesses** — pull from G2/Capterra reviews (filter for 1–2 star), Reddit complaints, recent negative tweets. Quote 1–2 specific complaints with source.
>
> **Then synthesize:**
>
> **A. Competitive Matrix**
> Markdown table: columns = the 5 competitors, rows = positioning, entry price, target customer, primary channel, biggest weakness.
>
> **B. The Five-Point Differentiation Strategy**
> 5 specific bets, each tied to evidence from the profiles above. Not "we'll be more user-friendly." Instead: "Loom's reviews show users on macOS hate that recordings drift out of sync — we ship a Mac-native recorder with sample-accurate audio. This is a real complaint, this is fixable, and it's a wedge into prosumers Loom doesn't prioritize."
>
> Each point should answer: (1) which competitor's weakness am I exploiting, (2) which segment I'm winning, (3) why incumbents won't copy fast.
>
> **C. The Three Customers to Steal First**
> Specific personas — not "developers" but "DevRel engineers at Series B startups under 50 people who currently use Loom but complain about <X>." For each, where they hang out, what message moves them, what to charge.

## Output format

Markdown. Tables for the matrix. Save to `Research/05-competitor-research.md` if running the full pass.

## Common failure modes to avoid

- Listing competitors' marketing copy as if it were ground truth. Translate first.
- Inventing acquisition channels because you can't research them — say "I couldn't determine their primary channel" if true.
- Vague differentiation ("we'll focus on UX") that any of the competitors could also claim.
- Treating all 5 competitors as equally weighted — usually 1–2 are the real threats and the others are noise. Say which.
