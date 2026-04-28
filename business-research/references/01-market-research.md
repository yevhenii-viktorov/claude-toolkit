# 01 — Market Research

## What this prompt does

Sizes a market, identifies the top competitors, and finds underserved segments — with sources, not vibes.

## Required inputs

- `INDUSTRY` — be specific. "SaaS" is too broad. "Time-tracking software for solo consultants" is right.
- Optional: `GEOGRAPHY` (default: global English-speaking)
- Optional: `BUYER_TYPE` (B2B / B2C / B2B2C)

If the user gives a vague industry, push back before researching. A bad input wastes 10 web searches.

## Refinements over the original prompt

The original asked for "estimated revenue" of competitors, which is unreliable for private companies. This version uses **funding raised, employee count, and growth signals** — verifiable proxies. It also distinguishes **TAM / SAM / SOM** so the founder doesn't pitch a $300B TAM when their realistic SOM is $20M.

## Run this prompt

> Research the **{INDUSTRY}** market for **{BUYER_TYPE}** customers in **{GEOGRAPHY}**.
>
> Output a single document with five sections:
>
> **1. Market Size (TAM / SAM / SOM)**
> - **TAM** — total addressable market with source. Use a recent (last 24 months) report from Gartner, Grand View Research, IDC, Statista, or a public company's investor deck. Cite the URL.
> - **SAM** — serviceable addressable market: TAM filtered to the geography, buyer type, and segment that's actually reachable. Show your math.
> - **SOM** — realistic share a small startup could capture in 3 years. Reason from comparable startups, not wishful thinking.
> - **Growth rate** — CAGR with source. Flag if it's from the vendor's own report (biased) vs. independent.
>
> **2. Top 5 Competitors**
> Build a table with columns: Name, Positioning (one sentence), Pricing (entry tier $ / month), Funding raised + last round date (Crunchbase), Employee count (LinkedIn), Visible growth signal (traffic from SimilarWeb, App Store rank, GitHub stars, etc.).
> Skip "estimated revenue" — it's noisy. The signals above are more reliable.
>
> **3. Three Underserved Segments**
> For each segment:
> - Who they are (specific persona, not "SMBs")
> - Evidence the segment is underserved — link to forum complaints, negative reviews of incumbents, Reddit threads, or feature requests piling up unanswered.
> - Why incumbents won't go after them (structural reason, not just "they haven't yet")
> - Rough size estimate
>
> **4. Market Risks / Red Flags**
> - Is the market commoditizing on price?
> - Are big platforms (Google, Microsoft, Apple, Notion, etc.) likely to ship this as a feature?
> - Regulatory exposure?
> - Distribution chokepoints?
>
> **5. What I Don't Know Yet**
> 3–5 questions the founder still needs to answer through customer interviews — things research can't tell them.
>
> Cite a URL for every numerical claim. Tag estimates with `[ESTIMATE: reasoning]`.

## Output format

Single markdown file. Save to `Research/01-market-research.md` if running the full pass.

## Common failure modes to avoid

- Quoting TAM from a vendor's own marketing site (biased upward 2–10x).
- Listing competitors by Google ranking (you'll miss the actual market leaders, who often rank lower because they don't optimize for SEO).
- "Underserved segments" that are just adjacent verticals — those usually aren't underserved, they're just different markets.
- Confusing total industry revenue with software-spend-on-this-category.
