# 07 — Go-to-Market Stress Test

## What this prompt does

Pressure-tests a go-to-market plan channel-by-channel: realistic CAC, realistic time to first 100 customers, scalability ceiling, dependency risk, and ROI ranking.

## Required inputs

- `GTM_PLAN` — the founder's current plan, even if rough. Channels they're thinking about, current channel mix, what's working, what isn't.
- `BUSINESS_TYPE` — same definition as in prompt 03.
- `CURRENT_REVENUE` — to calibrate which channels even make sense at this stage.
- `ICP` — who they sell to. Required, because channel ROI depends entirely on where the ICP hangs out.

## Refinements over the original prompt

The original asked for "realistic CAC" but no payback period and no cohort thinking — which is where most founder GTM plans actually break. This version adds:
- **CAC payback period** — not just CAC. A $200 CAC is great if payback is 4 months, terrible if it's 24.
- **Cohort sustainability check** — does the channel keep working at 10x volume, or does it saturate fast?
- **Stage-calibrated suggestions** — under $1M ARR, certain channels (paid ads, conferences) are usually money-pits. Calls those out explicitly.
- **Time to first 100 customers should reflect realistic ramp** — most founders underestimate this by 2–4x.

## Run this prompt

> Here's my GTM plan:
> **{GTM_PLAN}**
>
> Business: **{BUSINESS_TYPE}**, currently at **${CURRENT_REVENUE}** ARR.
> ICP: **{ICP}**
>
> For each channel in the plan, evaluate:
>
> **Per-channel breakdown:**
>
> ```
> Channel: [name]
> ─────────────
> Realistic CAC for {ICP}: $X — based on {benchmark or comparable}
> CAC payback period: X months
> Time to first 100 paying customers: X months — ramp curve, not best case
> Scalability ceiling: stops working past X customers/month or $Y ad spend
> Dependency risks: platform changes, algorithm changes, team capacity
> ROI score: 1–10 at current stage
> Verdict: DOUBLE DOWN / TEST / WASTE OF TIME AT YOUR STAGE / KILL
> ```
>
> **Then synthesize:**
>
> **A. Ranked channel table**
> Markdown table sorted by ROI score, columns: channel, CAC, payback, time-to-100, scalability ceiling, verdict.
>
> **B. The cuts**
> Which channels are a waste of time at <$1M ARR. Be specific about why. Common ones to flag at this stage:
> - Paid ads to cold traffic (CAC usually exceeds LTV until you have product-market fit and conversion data)
> - Conferences (cost per qualified lead is often $500+)
> - PR / press (one-off bumps, no compounding)
> - SEO from scratch (12+ month payback, only worth it if you have time)
> - Hiring SDRs (only viable above ~$1M ARR with proven inbound interest)
>
> **C. The two missing channels**
> Two channels the founder is *not* doing that work for {BUSINESS_TYPE} at <$1M ARR. Common high-ROI plays at this stage:
> - Founder-led content + DM outreach
> - Niche community presence (specific subreddits, Discords, Slack groups)
> - Integrations / marketplaces with built-in distribution
> - Productized SEO (comparison pages, "vs" pages, alternatives pages)
> - Build-in-public on Twitter/X / LinkedIn
> - Templates / free tools as lead magnets
> - Cold email with a sharp ICP filter
>
> Pick the two highest-leverage for *this specific business* and explain why.
>
> **D. The cohort sanity check**
> If the founder hits the channel mix above, does it produce *sustainable* customer acquisition or a sugar high? Specifically:
> - Can the channels keep producing customers at 10x volume, or do they saturate?
> - Is the early CAC representative or a honeymoon (early adopters always cheaper than mainstream)?
> - What breaks first: ad costs, content saturation, ICP exhaustion, or your own time?
>
> **E. The 90-day plan**
> If you had to pick *one* channel to bet the next quarter on, which one and why. The action items for week 1, week 4, and week 12.

## Output format

Markdown. Tables for the ranked-channel breakdown. Save to `Research/07-gtm-stress-test.md` if running the full pass.

## Common failure modes to avoid

- Channel-agnostic CAC ranges — CAC for a $20/month B2C app and a $2K/month B2B SaaS are 50x apart, even on the same channel.
- Ignoring time as a cost — "SEO is free" is wrong; SEO costs 6–12 months of the founder's calendar.
- Recommending channels that worked for someone else without checking ICP fit.
- Treating "go viral on TikTok" as a strategy. It's an outcome, not a plan.
