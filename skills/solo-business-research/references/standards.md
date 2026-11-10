# Output Standards — solo-business-research

These rules apply to every section of every output. They're what make this skill different from a generic LLM critique.

## The 5-tag epistemic discipline

Every claim falls into one of five tags. Use them inline.

| Tag | When to use | Format |
|-----|-------------|--------|
| **VERIFIED FACT** | Sourced URL, user's own data, or directly observable | `[FACT: source]` or footnote |
| **ESTIMATE** | Your reasoned guess with reasoning shown | `[ESTIMATE: reasoning in 1 line]` |
| **ASSUMPTION** | Input the user provided that may not be true | `[ASSUMPTION: from user input]` |
| **RISK** | What could go wrong if a claim is incorrect | `[RISK: what breaks if wrong]` |
| **VALIDATION** | How the user could verify in <1 week | `[VALIDATE: specific method]` |

The user's original prompt requires this discipline explicitly. Don't shortcut it.

## Banned language

These phrases signal LLM-generated startup theater. Don't use them:

- "Disrupt", "revolutionary", "game-changing", "next-generation"
- "Leverage" (as a verb), "synergize", "empower", "unlock value"
- "Cutting-edge", "best-in-class", "world-class", "innovative solution"
- "Seamlessly", "robust" (without a specific load number)
- "AI-powered" (only OK when describing what the AI specifically does)
- "10x better" (be specific or don't claim it)
- "Massive opportunity" (state the SOM in dollars instead)
- "In today's fast-paced world", "as more and more"
- "Imagine if..." (you're not writing a screenplay)

If you find yourself reaching for one of these, the underlying claim probably needs more substance.

## Numbers over adjectives

| Weak | Strong |
|------|--------|
| "Strong growth" | "37% YoY for 3 years per Crunchbase" |
| "Big market" | "$320M SAM, ~6.4M paying users in EN markets" |
| "Most users" | "62% of users surveyed (n=143, source link)" |
| "Quickly profitable" | "Operating break-even at month 14 base case" |
| "Loyal customers" | "5% monthly churn — 1.7x category average" |

If you can't replace an adjective with a number, the claim isn't ready to ship.

## Solo-builder filter

Every recommendation has to survive this question: *"Can one person actually do this with [stated weekly hours] and [stated monthly budget]?"*

If a recommendation requires:
- 40+ hours/week from one person
- $5K+/month in tooling/ads
- A specialist hire (designer, salesperson, ML engineer)
- A 6+ month build before launch
- An enterprise sales motion
- Compliance certification (SOC2, HIPAA, etc.) before launch

…then it's the wrong recommendation. Find the smaller version.

## Table formatting

The user asked for table-heavy output. Use markdown tables for:
- Any comparison (3+ items being compared)
- Any structured data (rows × columns)
- Any rating system (FATAL/SERIOUS/MINOR)
- Any list with multiple attributes per item

Don't use tables for:
- Free-form analysis paragraphs
- Single-item descriptions
- Step-by-step instructions where order matters more than structure

**Inside tables:** keep cells short. If a cell needs >20 words, move that detail below the table as a callout.

## Kill thresholds — be specific

The skill's value is its willingness to say things won't work. Use these definitions consistently:

| Rating | Definition | Required action |
|--------|-----------|-----------------|
| **FATAL** | Mathematically prevents working at any scale a solo builder reaches | Don't build until fixed; usually means the idea needs to change |
| **SERIOUS** | Could kill the business but is solvable | Address before launch |
| **MINOR** | Real concern but won't make-or-break | Note, monitor, fix later |
| **OK** | No significant issue | Move on |

For channels: **DOUBLE DOWN / TEST / WASTE AT YOUR STAGE / KILL** — same discipline.

For features: **MUST HAVE / LATER / NEVER** — same.

Don't introduce new rating systems within sections; consistency lets the user scan fast.

## What to do when the user disagrees

If the user pushes back on a verdict (especially in section 4 or 13):

1. Re-read their objection. Are they providing new information or expressing displeasure?
2. **New info → update the analysis.** Show what changed and why.
3. **Just displeasure → hold the line.** Restate the threshold for changing your mind. *"I'd change the verdict if you showed me X. Without that, the analysis stands."*

Reversing a verdict to please the user defeats the skill's purpose.

## Source quality hierarchy

When citing sources, prefer in this order:

1. The user's own data (cohort tables, financials, surveys)
2. Public company filings (10-K, S-1, investor decks)
3. Independent research (Gartner, Forrester, IDC, Statista)
4. Industry-specific publications (Stratechery, The Information, niche newsletters)
5. Crunchbase, LinkedIn, SimilarWeb (for competitor signals)
6. App store reviews, Reddit, G2/Capterra (for user complaints)
7. Vendor marketing pages (use only with caveats — biased)

Don't cite "studies show" or "industry experts say" without a link.

## When information is missing

Three options, in priority order:

1. **Run a web_search** if the info is plausibly findable.
2. **Tag as ESTIMATE** with reasoning if it's a reasonable inference.
3. **Skip the section and explain why** if the missing input makes it impossible to do honest work.

Never fabricate a number to fill a table cell.

## Final output rule

Every section ends with one of three structural elements (or all three for full-pass output):

- **The honest read on this is...** (1 paragraph takeaway)
- **What I don't know yet** (3-5 questions only the user can answer through interviews/data)
- **If you do nothing else, do this** (1 specific action)

The user remembers these endings, not the body. Make them count.
