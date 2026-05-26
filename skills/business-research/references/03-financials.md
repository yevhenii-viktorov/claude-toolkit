# 03 — Financial Projections

## What this prompt does

Builds a defensible 3-year P&L with break-even analysis and key SaaS metrics — not a spreadsheet of made-up numbers.

## Required inputs

- `BUSINESS_TYPE` — be specific: B2B SaaS, B2C subscription, marketplace, e-commerce, etc.
- `STARTING_REVENUE` — current MRR or first-month projected MRR
- `GROWTH_RATE` — monthly growth rate (assume early-stage 8–15% if user doesn't know)
- `PRICING` — average revenue per customer / month
- `CAC` — customer acquisition cost (or "I don't know" — we'll estimate)
- `CHURN` — monthly churn % (B2C SaaS: 4–7%, B2B SaaS: 1–3% are typical)
- `COGS_STRUCTURE` — variable cost per customer (hosting, payments, support)
- `FIXED_COSTS` — salaries, tools, rent
- `STARTING_CASH` — for runway calc

If 3+ are missing, ask for them in one batched question before generating anything. Don't fabricate.

## Refinements over the original prompt

The original asked for monthly Year 1 + quarterly Year 2-3 inline, which is unreadable in chat and missing the metrics that actually matter. This version:
- Asks for **3 scenarios** (conservative / base / aggressive) so the founder sees the range.
- Adds **CAC payback period, LTV/CAC, gross margin, MRR** — the metrics investors actually look at.
- Offers to output as `.xlsx` so the founder can poke at the numbers.
- Calls out **break-even and runway-out dates** explicitly — the two questions that determine fundraising urgency.

## Run this prompt

> Build a 3-year financial projection for a **{BUSINESS_TYPE}** business.
>
> **Inputs (state these clearly at the top of the output):**
> - Starting MRR: ${STARTING_REVENUE}
> - Monthly growth rate: {GROWTH_RATE}%
> - ARPU: ${PRICING} / month
> - CAC: ${CAC}
> - Monthly churn: {CHURN}%
> - Variable COGS / customer: ${COGS_PER_CUSTOMER}
> - Fixed monthly costs: ${FIXED_COSTS}
> - Starting cash: ${STARTING_CASH}
>
> **Output structure:**
>
> **A. Assumptions and how I derived any defaults**
> If I had to estimate any number, explain why and cite a benchmark source.
>
> **B. Three scenarios (Conservative / Base / Aggressive)**
> Vary growth rate and churn by ±30% from the user's assumption. Show base case in detail, conservative + aggressive as a sensitivity table.
>
> **C. Year 1 — monthly P&L (base case)**
> Markdown table with columns for each month: New customers, Total customers, MRR, COGS, Gross profit, Gross margin %, OpEx, Net profit/loss, Cash on hand.
>
> **D. Year 2 + Year 3 — quarterly P&L**
> Same columns, by quarter.
>
> **E. Key SaaS metrics over time**
> - LTV (= ARPU × gross margin × 1/churn)
> - LTV / CAC ratio (target > 3)
> - CAC payback period in months (target < 12 for B2B, < 6 for B2C)
> - Magic number / efficiency ratio if applicable
>
> **F. Break-even and runway**
> - Month the business hits operating break-even (or "never within projection window")
> - Month cash hits zero if no fundraise
> - How much to raise + at what month to extend runway 18 months
>
> **G. Sanity checks**
> Three checks: Are the unit economics defensible? Does the implied market share at end of Year 3 exceed your SOM estimate (red flag)? Is the growth rate consistent with the CAC budget?
>
> Then offer: "Want this as an .xlsx file you can edit?"

## Output format

- Markdown tables inline by default.
- Offer `.xlsx` output — most founders will say yes. Use the `xlsx` skill if available.
- Save to `Research/03-financial-projections.md` (+ `.xlsx`) if running the full pass.

## Common failure modes to avoid

- Compounding monthly growth at 15% for 36 months → implies world domination. Apply a decay function or just cap it after the early-stage period.
- Ignoring churn → MRR looks great, real revenue doesn't.
- Treating CAC as a one-time cost → it's recurring, every new customer costs money.
- Forgetting that gross margin % matters more than revenue dollars for SaaS valuation.
