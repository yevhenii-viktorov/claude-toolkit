---
name: market-research
description: Conduct market research, competitive analysis, investor diligence, market sizing, and technology vendor scans — and explain the methodology in plain English to users who don't have a marketing or business background. Use this skill whenever the user is researching a market, company, competitor, fund, or vendor; estimating market size; building an investor list; comparing tools or products; or pressure-testing a thesis before building, funding, or entering a market. Trigger this even if the user uses engineer-y phrasing like "is there a market for X", "who else is doing this", "should I bother building this", "where do I find investors", or "compare these tools" — they need real research, not a generic LLM summary.
---

# Market Research (for technical users)

Produce research that supports a decision, not research theater.

This skill assumes your user is a software engineer or technical founder who does not have a marketing or business background. Treat them accordingly: define every jargon term the first time you use it, show your math, prefer concrete examples over abstract frameworks, and never use LinkedIn-speak ("synergy", "leverage", "ecosystem play", "category leader", "best-in-class").

## How to talk to the user

These users are smart but new to this domain. Adapt:

- **Define jargon on first use, inline.** When you say "TAM", immediately follow it with "(total addressable market — the total annual revenue if literally everyone who could buy this did)". Same for SAM, SOM, ICP, CAC, LTV, ARR, MOIC, dry powder, anti-portfolio, vintage, IC, ACV, PLG, etc. Don't make them google.
- **Show the math.** SWEs trust derivations, not claims. `TAM = num_buyers × avg_annual_spend` beats "the market is $4B".
- **No vibes-only claims.** Don't say "the market is hot" — say "the category took $X in disclosed funding across Y rounds in the last 12 months, up from $Z" with the source.
- **Skip the marketing intro paragraph.** Get to the finding. SWEs scroll past throat-clearing.
- **Use tables, code blocks, and bullet points generously.** They scan, they don't read.
- **Name the decision being supported.** Every output should answer "what should I do differently after reading this?".
- **Confess uncertainty by default.** Better to say "I couldn't find primary data on X — this is my estimate from two adjacent data points" than to invent confidence.

If the user's request is vague ("should I build this?"), ask one clarifying question about the decision they're actually making before starting. Just one — don't interview them.

## Pick the scope before you start

Three tiers. Default to **standard** unless the user signals otherwise. Tell the user which tier you're picking before you start, so they can correct you.

| Tier | When | Time budget | Sources | Output length |
|---|---|---|---|---|
| Quick scan | "give me a sanity check", "is there anything here" | ~15 min | 3–5 | ½ page |
| Standard | default for most requests | ~1 hr | 8–15 | 1–3 pages |
| Deep dive | "I'm about to fundraise / quit my job / commit 6 months" | multi-hour | 20+ | 5+ pages, sectioned |

## The research process

Follow these steps in order. Don't skip step 1.

### Step 1: Restate the decision

Before searching anything, write one sentence: "The user is trying to decide whether to ___, and this research will help by ___."

If you can't write that sentence clearly, ask one clarifying question. The biggest failure mode in research is producing a beautiful summary of the wrong question.

### Step 2: Plan the sources

For each major claim you'll need to make, decide in advance what type of source would satisfy it. Use this hierarchy, from most to least credible:

1. **Primary documents** — SEC filings (10-K, S-1, 13F), company financial statements, court records, government datasets (BLS, Census, Eurostat), official APIs/dashboards. Trust these for numbers about the company itself.
2. **Reputable trade press with named reporters** — The Information, Bloomberg, Reuters, WSJ, FT, Stratechery. Trust for narrative and recent events. Watch for sourcing — "according to people familiar" is weaker than named sources.
3. **Analyst reports with methodology** — Gartner, Forrester, IDC, CB Insights, Pitchbook, Crunchbase. Trust the numbers only if you can see the methodology. Many analyst TAMs are circular references between firms.
4. **Company-published material** — blog posts, investor decks, earnings calls. Trust facts about themselves (audited revenue, headcount, customers named on stage). Discount claims about competitors and "market leadership".
5. **Specialized communities** — GitHub stars/forks, Hacker News threads, subreddit discussions, G2/Capterra reviews. Trust for qualitative signal (developer sentiment, sharp criticism), not quantitative claims.
6. **General web / LLM training data** — only as a starting point to figure out what to search for next. Never as a final source.

If a claim only shows up in tier 5–6, label it as "weak signal" in the output.

### Step 3: Search deliberately

Use the available search tools (`web_search`, `web_fetch`) with intent. Rules of thumb:

- Start broad (1–2 word queries), then narrow. `"vector databases"` → `"pgvector vs Pinecone benchmark"`.
- Search for the same fact two different ways and check the numbers agree. If they don't, that's a finding worth reporting.
- When you find a strong source, `web_fetch` the full page — snippets lie by omission.
- **Always do the negative-keyword pass.** For company research: `"<company> raise"`, `"<company> layoffs"`, `"<company> lawsuit"`, `"<company> outage"`, `"<company> review"`. For a thesis: `"<thesis> wrong"`, `"why <thesis> failed"`. If you didn't search for the downside, you haven't researched the topic.

### Step 4: Apply recency rules

Stale data is worse than missing data because it feels reliable. Use these windows by claim type:

| Claim type | Stale after | Why |
|---|---|---|
| VC investing behavior, fund check sizes | 12 months | Markets rotate fast |
| Company headcount, funding, product features | 6 months | Tech moves fast |
| Market sizing | 24 months | Big stuff changes slowly |
| Regulatory environment | 3 months | Can flip overnight |
| Technical benchmarks | 6 months | Models and hardware change |
| Pricing | 6 months | Always shifting |
| Founding stories, historical context | No limit | Doesn't change |

Tag every claim with the source's date in brackets: `Acme raised a $40M Series B [2025-08]`. If you can't find a date on the source, flag it.

### Step 5: Separate fact, inference, and recommendation

This is the single most useful discipline in this skill. In your output:

- **Fact**: a claim with a citation. "Acme has 230 employees on LinkedIn [as of 2026-04]."
- **Inference**: your synthesis. Mark it explicitly. "*Inference:* This implies they're spending ~$50M/yr on payroll, which means they need either profitability or another raise within ~18 months."
- **Recommendation**: what to do. "*Recommendation:* Reach out within the next 90 days while they still have runway. After that they'll either be desperate or already acquired."

Never let these three blur together in one sentence. That's where bad research lives.

### Step 6: Run the quality gate

Before delivering, verify each item below explicitly. Don't skip.

```
[ ] One sentence at top stating the decision this supports
[ ] Every number has a source and date, or is labeled "estimate" with the inputs shown
[ ] At least one contrarian source or downside case included
[ ] Inferences are labeled as inferences (not stated as fact)
[ ] Recommendation flows from evidence (not vibes)
[ ] Jargon is defined inline on first use
[ ] Output is dated at the top
[ ] If sources are thin, the gap is flagged rather than papered over
```

If any box is unchecked, fix it before sending.

## The four research modes

### Investor / fund diligence

Goal: help the user decide whether to reach out to a fund, and how.

Collect:

- **Fund-level**: AUM (assets under management — total money they manage), current fund size and vintage (vintage = the year the fund was raised; older fund = closer to needing to deploy what's left or wind down), typical check size for the user's stage, sectors, geographic focus.
- **Partner-level** (more important than fund-level — partners drive deals, not funds): which partner covers this category, what they've personally led in the last 12–18 months, their background, what they post about publicly.
- **Fit signals**: portfolio companies that are similar enough to be relevant but not so similar they conflict. "They invested in 3 dev tools in 2025" is a signal. "They invested in your direct competitor" is an anti-signal.
- **Dry powder estimate**: roughly how much of their current fund is still uninvested. (Dry powder = uninvested capital. Funds typically deploy over 3 years; if a $300M fund is 2.5 years in and has done 18 deals at ~$8M average, they have ~$150M left. Rough math is fine — label it as estimate.)
- **Anti-portfolio / conflicts**: direct competitors they're already in.
- **Decision process**: solo partner, full partnership vote, IC (investment committee)? You can usually tell from interviews and the speed of public moves.
- **Warm intro paths**: which of the user's contacts are connected (LinkedIn 2nd-degree, shared portfolio founders).

**Mini-example output:**

```
Sequoia Capital — Andrew Reed leads dev tools

Fund:        Sequoia Capital Fund 19, $2.85B, vintage 2022 [Pitchbook 2026-03]
Stage fit:   leads Series A ($8–15M), occasional seed
Recent led:  Linear (2024), Modal (2024), Bun (2025) — all dev infra
Conflicts:   invested in Vercel (mild overlap if your product touches deploy)
Dry powder:  ~40% deployed of Fund 19 → roughly $1.7B left across sectors (estimate)
Decision:    Andrew can move solo on Series A up to ~$10M
Warm path:   Guillermo Rauch (your Vercel contact) → Andrew (co-invested twice)
Fit grade:   A- (strong category match, mild conflict to disclose upfront)
```

### Competitive analysis

Goal: understand what the competitor actually does (not what they claim) and where the gaps are.

Collect:

- **Product reality, not marketing copy.** Sign up for free tiers, watch demo videos, read changelogs, read their docs. Marketing pages lie by omission; docs don't.
- **Funding history**: total raised, latest round, current investors. Heavily funded competitors burn fast and force you to compete on velocity; bootstrapped competitors compete on margins. Different threats, different responses.
- **Traction signals** if public: customer logos named on stage (real ones with quotes, not just logo-walls), case studies with numbers, hiring rate (LinkedIn jobs or BLS proxy), GitHub stars trajectory, web traffic via SimilarWeb if free tier permits.
- **Distribution**: how do they actually get customers? Cold sales? PLG (product-led growth — users sign up themselves and pay later)? Marketplace? Conferences? Their job postings tell you: "hiring 4 enterprise AEs" → they sell to enterprise; "hiring growth eng" → they do PLG.
- **Pricing**: from public pricing pages, support forum posts ("I'm paying $X"), Glassdoor reviews mentioning deal sizes, billing complaints on Reddit/HN.
- **Wins and losses**: search `"chose <competitor> over"` and `"switched from <competitor>"` to find both sides.
- **Positioning gaps**: where are users complaining? G2, Capterra, Reddit, HN. Bad reviews are the most useful business document on the internet.

Output as a comparison table when there are 2–4 competitors. As a 2x2 (axes chosen for the user's decision, e.g. "self-hosted vs. SaaS" × "code-first vs. UI-first") when positioning matters more than features.

### Market sizing

Goal: an honest number with the assumptions exposed, not a $40B headline.

**The single most important rule: never paste an analyst TAM as-is.** Recompute it. If you can't recompute it, you don't understand it.

Two methods. Do both. They should agree within ~2x. If they don't, something is wrong — investigate why before continuing.

**Top-down:** Start from a large established number and carve down.

```
Total industry spend (cite)
  × % of that spend addressable by this product category
  × % of that you can realistically reach (geo, segment)
  = TAM
```

Worked example:
```
Global SaaS spend in 2025:                  $280B    [Gartner 2025-12]
  × dev tools share of SaaS:                ~12%     [BVP State of the Cloud]
  ≈ dev tools spend:                        $34B
  × observability + monitoring share:       ~8%      [estimate: Datadog/Splunk/NR public revenue ÷ total]
  ≈ category spend:                         $2.7B
  × US/EU only:                             ~70%
  = TAM:                                    ~$1.9B
```

**Bottom-up:** Start from one customer and multiply up.

```
Number of potential customers in segment (cite from BLS, Crunchbase, etc.)
  × % likely to ever buy (adoption ceiling, usually 5–30%)
  × Average annual contract value (ACV — what one customer pays per year)
  = TAM
```

Worked example:
```
US software companies with 50–5,000 engineers:   ~12,000    [Crunchbase 2025]
  × % that adopt dedicated observability:        ~20%       [current ~15%, ceiling ~30%]
  × average ACV:                                 $30K       [Datadog/NR median deal in earnings]
  = segment TAM:                                 $72M
  × 8 comparable global segments:                8×
  = global bottom-up TAM:                        ~$580M
```

If top-down and bottom-up disagree wildly, top-down is usually inflated (analysts double-count, include adjacent categories, project forward optimistically). Trust the bottom-up more.

**Common failure modes:**
- Double-counting buyers (same company appears in both "SMB" and "mid-market" segments).
- Using "by 2030 the market will be $X" projections — these are vibes, not data.
- Confusing "TAM of the broader category" with "TAM of your specific product".
- GDP-style numbers ($1T market!) — almost always means the segmentation is wrong.
- Counting installed base × price as recurring revenue (it isn't, unless it's a subscription).

Also compute **SAM** (serviceable addressable market — TAM minus segments you realistically can't reach: China, government, on-prem-only, etc.) and **SOM** (serviceable obtainable market — what you could plausibly capture in 3–5 years, usually 1–10% of SAM for an early-stage entrant).

Always state in **annual recurring revenue terms** unless the user asked for installed base or GMV (gross merchandise value — total transaction volume, for marketplace businesses). Specify the year and currency.

### Technology / vendor research

Goal: help the user decide whether to adopt a tool, and what they're signing up for.

Collect:

- **How it actually works.** Read the docs and architecture page, not the marketing page. Summarize in 2–3 sentences.
- **Trade-offs.** Every tool is good at something at the cost of something else. Name both sides.
- **Adoption signals.** GitHub stars over time (trajectory matters more than current count), recent commits (is it maintained?), Docker pull counts if relevant, npm downloads, named users in production at scale.
- **Integration complexity.** What does the user have to do to make this work with their stack? Read the "getting started" guide and count the steps.
- **Operational risk.** Self-hosted vs managed, backup story, upgrade story, what happens if the company gets acquired. Look at funding stage — Series D+ companies that haven't gone public are acquisition-likely.
- **Security and compliance.** SOC 2, ISO 27001, GDPR/CCPA, HIPAA if relevant. Most vendors over-claim here — check the trust page directly.
- **Lock-in.** What does it cost to migrate off? Proprietary data formats? Closed APIs? Custom DSL? The more "ours" the system, the higher the lock-in.
- **Price at scale.** Free tiers and starter prices are misleading. Find the price for the user's actual scale (search `"<tool> pricing" reddit` or HN, look at billing complaints).

## Output format

Default structure (use this unless the question demands otherwise):

```
# [Topic] — [tier]
*Prepared 2026-MM-DD. Decision this supports: [one sentence].*

## TL;DR
Three bullets. The recommendation, the strongest evidence for it, the biggest risk.

## Key findings
3–7 bulleted findings. Each is a complete thought, not a fragment.
Each has citations inline with dates.

## Implications
What this means for the user's specific decision. Marked as inference.

## Risks and counterarguments
Sources that contradict the recommendation, and how strong they are.

## Recommendation
One paragraph. What to do. By when. What would change your mind.

## Sources
List with dates. Group by tier (primary, secondary, tertiary) if useful.

## What I couldn't find
The gaps where you wanted data and didn't get it. Honesty beats padding.
```

**Vary the structure when the question demands it:**

- Single-number answer ("is the market big enough?") → lead with the number + confidence, then math, then caveats.
- Competitor comparison → lead with the table, then per-competitor notes, then positioning analysis.
- Investor list → lead with a ranked table (fund / partner / fit grade / warm path), then per-row detail for top 5.

## Anti-patterns — do not do these

- **Summarizing the marketing page.** If the output could have been generated from the company's own website, you haven't done research.
- **"By 2030 the market will be $X billion."** Forward projections are vibes. Cite present-tense numbers; mention projections only with explicit "(forecast)" labels.
- **Padding when sources are thin.** If you only found two relevant sources, say so. Don't repeat the same point in three different sentences.
- **Confidence-laundering through structure.** A well-formatted document with 5 sections doesn't prove the underlying claims. Don't let layout substitute for evidence.
- **Mixing fact and inference in one sentence.** "Datadog is the leader in observability with $2.5B ARR and growing fast" — the ARR has a source; "leader" and "fast" are separate claims that need their own justification or labels.
- **Counting search results as evidence.** "This is a popular topic — 14,000 results on Google" is not a finding.
- **Trusting any single source for a load-bearing number.** Cross-check or label as "single source — verify before acting".
- **LinkedIn-speak.** "Robust", "innovative", "leverage", "synergy", "ecosystem", "best-in-class", "category-defining", "AI-powered" without specifics — strike all of these.
- **Skipping the negative search.** Mandatory before delivering.

## When the user resists the process

SWEs sometimes push back on this kind of work — "I just need a quick answer", "stop overcomplicating it". When that happens:

- Honor the quick-scan tier. 15 minutes, 3–5 sources, half a page.
- Still apply the quality gate (sourced numbers, dated, decision-oriented). It takes 30 extra seconds and saves them from acting on bad info.
- Don't lecture them about methodology. Produce the work and let it speak.

## When to push back on the user

If the user's underlying question is malformed — e.g., "what's the market size for my product" when their product is so specific that the right framing is "how many customers do I need to break even, and can I find them?" — say so. One sentence. Then offer the reframing and let them decide.

The goal is always: research that supports a real decision. If the question doesn't support a decision, the answer can't either.
