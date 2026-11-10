# Inputs to Gather Before Running

The skill needs ~15 inputs to produce a full pass. If the user hasn't given them, ask in **one batched question** — don't trickle.

## Required for full pass

```yaml
product_name: ""              # What's it called? (working name OK)
business_type: ""             # SaaS, marketplace, mobile app, browser ext, etc.
industry: ""                  # Be specific. "SaaS" is too broad. "Time-tracking for solo lawyers" is right.
target_users: ""              # ICP. Specific persona, not "businesses".
core_problem: ""              # 1-2 sentences on the pain.
proposed_solution: ""         # 1-2 sentences on what you're building.
geography: ""                 # Default: "global English-speaking" if unspecified
pricing_hypothesis: ""        # First guess at price point. OK to be uncertain.

solo_builder_constraints:
  founder_count: 1            # Or 2 if co-founder
  engineering_capacity_per_week: ""  # Hours/week. Critical for MVP scope.
  budget_per_month: ""        # $/mo for tools, hosting, ads, etc.
  preferred_stack: ""         # Optional. Affects build complexity estimates.
  launch_deadline: ""         # Optional. Affects scope ruthlessness.

competitors:                  # 3-5 names. If user can't name any, search.
  - ""

existing_assets:
  audience: ""                # Twitter following, newsletter, etc.? Or "none"
  domain: ""                  # Bought a domain? Built a landing page?
  waitlist: ""                # Number on waitlist, or "none"
  prototype: ""               # Status: "idea only" / "Figma" / "no-code MVP" / "shipped"
```

## How to ask for them

If 5+ are missing, send one batched question. Format suggestion:

> Quick — to run the full pass I need a few inputs. Paste back filling in what you have (skip what you don't):
>
> 1. **Product**: name + 2-sentence pitch
> 2. **Target user**: who specifically?
> 3. **Pricing hypothesis**: first-guess price point
> 4. **Founder constraints**: hours/week available, monthly budget, target launch date
> 5. **Competitors**: 3-5 names you'd compare yourself to
> 6. **Existing assets**: audience size, waitlist, any prototype?
>
> If you'd rather just describe it freeform, that works too.

## When to skip the batched ask

- User has already pasted a full brief — extract from that, don't re-ask.
- User asked for ONE section only (not full pass) — gather only what that section needs.
- User explicitly said "just run with what I've given you" — note assumptions inline and proceed.

## Sensible defaults when user is missing inputs

| Input | Default if user doesn't specify |
|-------|--------------------------------|
| Geography | Global English-speaking |
| Founder count | 1 |
| Hours/week | 20 (part-time bootstrap) — flag this as critical to confirm |
| Monthly budget | $300 (hosting + tools, no ad budget) |
| Launch deadline | "8 weeks from start of build" |
| Founder salary in projections | $0 until profitable |
| Paid ad spend in projections | $0 unless user specifies otherwise |
| Pricing hypothesis | Generate 3 options in section 5 if user hasn't set one |
| Churn assumption | B2C: 7% monthly. B2B SaaS: 2% monthly. |
| Growth rate | 10% MoM base case (early-stage default) |

Always tag defaults inline as `[ASSUMPTION: default — confirm]` so the user can correct.

## Section-specific input requirements

If the user only wants one section, here's what each section minimally needs:

| Section | Minimum inputs |
|---------|----------------|
| 1. Market Reality | Industry + target users |
| 2. Competitor Reverse | Competitor list (or willingness to find them) |
| 3. Underserved Segments | Industry + competitor list |
| 4. Brutal Critique | Full pitch + founder constraints |
| 5. Business Model | Product type + target users |
| 6. Unit Economics | Pricing + product type |
| 7. Financial Projection | Pricing + growth rate + churn assumption + starting state |
| 8. GTM Stress Test | Target users + current channels (or willingness to brainstorm) |
| 9. MVP Scope | Pitch + founder hours/week |
| 10. Differentiation | Competitor list + ICP |
| 11. Risk Register | Pitch (the rest can be inferred) |
| 12. Validation Plan | ICP + pitch (and where they hang out online) |
| 13. Recommendation | All earlier sections (this is the synthesis) |
