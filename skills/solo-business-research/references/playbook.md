# The Solo-Builder Research Playbook

This is the master 13-section playbook. Run the sections in order for a full pass; or pick one for a focused analysis.

## Master frame

Act as a ruthless but practical solo-builder research partner.

Optimize for bootstrapped execution, fast validation, low burn, and realistic founder capacity. Do not write like a VC deck. Avoid startup theater, buzzwords, vanity TAM, or unrealistic growth assumptions.

For every claim, separate:
1. **VERIFIED FACT** — sourced from a citable URL, the user's own data, or direct observation
2. **ESTIMATE** — your reasoned guess with the reasoning shown
3. **ASSUMPTION** — input the user provided that may not be true
4. **RISK** — what could go wrong with this claim being incorrect
5. **VALIDATION METHOD** — how the user could verify this in <1 week

Cite URLs when doing live research. Tag estimates with `[ESTIMATE: reasoning]`. Tag assumptions with `[ASSUMPTION: from user input]`.

---

## Section 1 — Market Reality

Research the user's industry. **Do not lead with the TAM number** — solo builders don't compete in the TAM, they compete in their first-100-users segment. Break the market into 5 layers:

| Layer | Definition | Estimated Size | Confidence | Why It Matters |
|---|---|---|---|---|
| TAM | Total market | $? | Low/Med/High | Context only — don't pitch this number |
| SAM | Serviceable market (geography + buyer type filter applied) | $? | | The reachable wallet |
| SOM | Realistic share for *any* startup in this space | $? | | The competitive ceiling |
| Beachhead | First narrow segment a solo builder could own | $? | | The wedge |
| First 100 users | Most realistic early adopters | # of people | | The next 90 days |

Then answer:
- Is this market growing, stable, or shrinking? Source the trend.
- What is driving the growth (or decline)?
- What's overhyped right now vs. what's quietly working?
- What user behavior is changing that creates the timing window?
- What about this market makes it *impossible* for a solo builder? (Be honest — some markets just aren't solo-doable.)

**Output rule:** End the section with a single paragraph: *"The honest read on this market is..."* — this is the takeaway the user will remember.

---

## Section 2 — Competitor Reverse Engineering

Research the listed competitors (or find 5 if the user didn't name them). For each, build a profile:

- Product category (be specific — "habit tracker for ADHD" not "productivity app")
- Target customer (with evidence — case studies on their site, who their marketing speaks to)
- Core promise (quote their tagline; translate to plain English)
- Pricing model and entry price
- Main acquisition channels (with evidence — keywords they rank for, ads you've seen, communities they post in)
- SEO strategy (what queries they own; check Ahrefs/SimilarWeb if accessible, otherwise inspect their content)
- Content/social strategy
- Product-led growth loops (free tier? referral? virality?)
- Estimated team size — **use LinkedIn employee count + recent job posts**, not vague guesses
- Funding status — Crunchbase or "bootstrapped" if no record
- ~~Estimated revenue range~~ — **skip this; for private companies it's noise.** Use *traffic signals* (SimilarWeb), *App Store rank*, or *paid-tier inference from review counts* instead.
- Strengths
- Weaknesses (pull 1–2 quoted complaints from G2/Capterra/Reddit/AppStore reviews)
- Customers they ignore (segments their pricing/positioning doesn't serve)
- Feature bloat / complexity opportunities (where they've gotten too heavy for new users)
- Switching friction (data export? lock-in? brand loyalty?)

Output as a markdown competitive matrix.

Then produce:
- **5 positioning angles a solo builder could take**
- **5 things NOT to copy** (what makes incumbents work for them but not for you)
- **5 specific gaps** where incumbents are too expensive, too complex, too enterprise, or too generic
- **5 landing-page headlines to test** — concrete, specific, not generic

---

## Section 3 — Underserved Segment Discovery

Find 3–5 underserved segments nobody is targeting well.

| Segment | Pain | Existing Workaround | Why Competitors Ignore It | Willingness to Pay | Reachability | MVP Angle |
|---|---|---|---|---|---|---|

**Prioritize segments that:**
- Are easy to find online (specific subreddits, Discord servers, niche newsletters)
- Have painful manual workflows (spreadsheets, copy-paste, multi-tool chains)
- Already spend money or time on alternatives
- Can be reached without paid ads
- Don't require enterprise sales motion
- Can be served with a narrow MVP

**Reject segments that:**
- Need long procurement / legal review
- Need compliance-heavy features on day one (HIPAA, SOC2, GDPR-as-blocker)
- Have low urgency ("nice to have")
- Have high support burden (every customer needs a 1:1 onboarding)
- Require network effects before value exists

For each accepted segment, end with: *"To validate this segment, I would..."* — give a specific 1-week test (e.g., "post in r/X with question Y, count responses meeting criterion Z").

---

## Section 4 — Solo-Builder Brutal Critique

The honest version of the idea critique. Rate each area FATAL / SERIOUS / MINOR / OK and explain.

| Area | Question | Rating | Explanation | Fix |
|---|---|---|---|---|
| Pain intensity | Is this painful enough that someone would pay TODAY? | | | |
| Frequency | Does the problem happen weekly, monthly, or yearly? | | | |
| Budget | Who pays, and from which budget line? | | | |
| Distribution | Can one person reach these users without ad spend? | | | |
| MVP scope | Can a useful version ship in 4–8 weeks at the founder's hours/week? | | | |
| Technical risk | Any hard infra/AI/data problems requiring specialist talent? | | | |
| Support burden | Will users need hand-holding that scales worse than revenue? | | | |
| Churn risk | Is this a one-time-use tool that won't retain? | | | |
| Moat | Will differentiation compound over time, or get copied in a sprint? | | | |
| Pricing power | Can you price above (support cost + infra cost + ~50% margin)? | | | |
| Legal/compliance | Any blocker (regulation, IP, data laws)? | | | |
| Platform dependency | Reliant on an API or platform that could change terms? | | | |

**Rating thresholds (use these, don't hedge):**
- **FATAL** = the issue mathematically prevents the business from working at any scale a solo builder can reach. Build only if you have a credible fix.
- **SERIOUS** = could kill it but is solvable with effort. Address before launch.
- **MINOR** = real concern but won't make-or-break.
- **OK** = no significant issue.

Then write:
- **The biggest reason this fails** (1 paragraph)
- **The second biggest reason this fails** (1 paragraph)
- **What must be true for this to work** (3 specific bullet points)
- **What evidence would change your mind** (3 specific things)
- **What to validate before writing serious code** (3 cheap tests)

---

## Section 5 — Business Model Analysis

Compare possible models for this product:

| Model | Price Range | Pros | Cons | Solo-Builder Fit | When to Use |
|---|---|---|---|---|---|
| Freemium SaaS | $0 / $X-Y/mo | | | | |
| Paid-only SaaS | $X-Y/mo, no free | | | | |
| Lifetime deal | $X one-time | | | | |
| Usage-based | per call / per item | | | | |
| Per-seat | $X / seat / mo | | | | |
| Creator/prosumer | $X/mo individual | | | | |
| Agency/team plan | $X-Y/mo for teams | | | | |
| API / add-on revenue | per call | | | | |
| Done-for-you launch | $X setup fee | | | | |

Recommend:
- **First pricing test** — exact number to put on the landing page
- **Free tier limits** — what's free, what's paywalled, exact thresholds
- **Paid plan packaging** — 1 plan vs. 2-3 tiers
- **What feature should be paywalled** (the moment of value the user will pay to unlock)
- **What should stay free** (the acquisition hook)
- **Pricing that signals quality without killing conversion** — the floor below which users assume it's a toy

End with: *"At launch, charge $X. Here's why."* — be specific, not "it depends".

---

## Section 6 — Unit Economics & Cost Reality

Estimate realistic per-customer and total monthly costs.

**Cost categories (don't skip any):**
- Hosting (database, compute, CDN)
- Storage (especially if user-uploaded content)
- AI / API costs (LLM inference, embeddings, image gen — if applicable)
- Email / notification service (transactional + marketing)
- Payment processing fees (Stripe ~3% + per-transaction)
- Support time per customer (estimate hours/customer/month × $50/hr blended founder time)
- Refunds / chargebacks (~1-2% of revenue)
- Monitoring / logging (Sentry, log infra)
- Analytics (PostHog, Mixpanel, etc.)
- Customer onboarding effort (one-time but real)
- Compliance / legal one-offs (Terms, Privacy, DPA template, etc.)

| Cost Item | MVP Cost / Month | At 100 Customers | At 1,000 Customers | Notes |
|---|---|---|---|---|

Then estimate:
- **Gross margin** at the proposed price point and at three pricing alternatives
- **Minimum viable price** — the floor below which this is a bad business
- **Maximum free usage** before free-tier abuse breaks the model
- **Operational bottlenecks** — which cost grows nonlinearly as customers scale (usually support, sometimes AI inference)
- **Hidden costs founders typically ignore** — pick the 2-3 most relevant from: bandwidth overage, free-tier abuse, refunds, support, compliance, App Store cut, currency conversion fees, infrastructure spike pricing

End with: *"At your proposed price, here's the cleanest unit economics story..."* — the one-paragraph honest summary.

---

## Section 7 — 3-Year Financial Projection

**Inputs to confirm before generating** (if any are missing, ask in one batched question):
- Starting revenue or current MRR
- Starting customer count
- Monthly growth rate (sanity-check this — early stage 8–15% is realistic; >20% requires evidence)
- ARPU (average revenue per user / month)
- Monthly churn (B2C: 5-10%, B2B SaaS: 1-3% typical)
- Gross margin assumption
- Founder salary (default: delayed until profitable)
- Paid ad spend (default: $0 unless user justifies)

**Output structure:**

**A. Three scenarios** (sensitivity table)
- Pessimistic: growth ÷ 1.5, churn × 1.3
- Base case: user's stated assumptions
- Optimistic: growth × 1.3, churn ÷ 1.3

**B. Year 1 — Monthly P&L (base case)**
Markdown table: Month, New customers, Total customers, MRR, COGS, Gross profit, OpEx, Net P/L, Cash balance.

**C. Year 2 + 3 — Quarterly P&L**
Same columns, quarterly.

**D. Key metrics over time**
- LTV (= ARPU × gross margin × 1/churn)
- CAC (or `[ASSUMPTION: $0 if user said zero ad spend]`)
- LTV/CAC ratio (target > 3 for paid acquisition)
- Gross margin %
- Months of runway from cash on hand

**E. Break-even and milestones**
- Month operating break-even
- Month founder could replace day-job income (if applicable)
- Month cash hits zero (if no profitability)

**F. Fragile assumptions flag**
List the 3 assumptions most likely to be wrong, in order of impact.

End with: *"This projection only works if [specific thing]. If that doesn't hold, here's what changes..."*

Offer `.xlsx` output via the xlsx skill — most solo builders want to poke at the numbers themselves.

---

## Section 8 — Go-To-Market Stress Test

Analyze each channel in the user's GTM plan (or propose 4-5 if they haven't given one).

| Channel | CAC | Time to First 10 | Time to First 100 | Scalability Ceiling | Founder Effort | Risk | Verdict |
|---|---|---|---|---|---|---|---|

**Channels to consider for solo builders specifically:**
- SEO (organic + comparison/alternatives pages)
- Programmatic SEO (templated pages at scale)
- Reddit / niche community posts
- X/Twitter / LinkedIn build-in-public
- YouTube tutorials / demos
- Direct outreach (cold email, DM)
- Founder-led sales (manual onboarding)
- Marketplace / app directory listings (Apple, Google, Chrome, Notion, Zapier)
- Integration partnerships
- Cold email
- Product Hunt launch
- AppSumo / lifetime deal sites
- Open-source / free tool funnel
- Templates / checklists / free calculators (lead magnets)
- Comparison pages ("X vs. Y")
- Newsletter sponsorships in adjacent niches

**Verdict values:** DOUBLE DOWN / TEST / WASTE AT YOUR STAGE / KILL.

**Channels to flag as wasteful at <$1M ARR for solo builders:**
- Paid social ads to cold traffic (CAC usually exceeds LTV until conversion data is solid)
- Conferences ($500+ per qualified lead)
- PR/press (one-off bumps, no compounding)
- Hiring SDRs (premature)
- Influencer paid placements ($1K+ per single post)

Rank channels by:
1. Fastest to validate
2. Lowest CAC at this stage
3. Best long-term compounding value
4. Most realistic for one person, X hours/week
5. Least platform-dependent

End with: *"If you only had time for ONE channel for the next 90 days, do this:"* — single channel, single message, single funnel.

---

## Section 9 — MVP Scope & Build Plan

Define a brutally small MVP. The core question: *what's the smallest thing that delivers a tangible user outcome?*

| Feature | Must Have / Later / Never | Why | Build Complexity (S/M/L) | Validation Value (Low/Med/High) |
|---|---|---|---|---|

**MVP rule:** "Must Have" should be ≤ 5 features. "Later" can be 10+. "Never" should include features the user mentioned that you're cutting (and explain why).

Then define:
- **MVP in one sentence** — *"<verb> for <ICP> who <pain>"* format
- **4-week build plan** — assuming the user's stated weekly hours, what ships
- **8-week build plan** — what's added in weeks 5-8
- **Manual concierge version** — how to deliver the value without writing code, for the first 5-10 users
- **No-code / low-code test version** — how to ship a fakeable v0 in 1 weekend (Airtable + Zapier + Carrd, etc.)
- **What to fake** — features the user thinks need to be built but can be wizard-of-Oz'd
- **What to automate later** — manual processes that work fine until 50+ customers
- **What NOT to build under any circumstances yet** — explicitly list features to defer (admin panels, SSO, complex billing, mobile apps if web-first, etc.)

Add:
- **Data model sketch** — main entities and relationships, 1 paragraph
- **Key workflows** — 2-3 user journeys, 1 sentence each
- **Core screens** — list of unique views (target: ≤ 6 for MVP)
- **API / integration dependencies** — external services required at MVP
- **Failure states** — what happens when [external API is down / payment fails / user hits limit]
- **Metrics to instrument from day one** — 3-5 specific events, no more

End with: *"The smallest possible version of this you can ship in 4 weeks is..."* — describe it concretely, including what URLs the user will visit.

---

## Section 10 — Differentiation Strategy

Avoid generic claims like "better UX" or "AI-powered" or "for everyone." Differentiation must be specific enough that an incumbent can't ship it in a sprint.

| Differentiation Angle | Who Cares | Why Competitors Cannot / Will Not Copy Quickly | Proof Needed |
|---|---|---|---|

**Angles to consider:**
- Narrow ICP differentiation ("only for HVAC contractors with <10 trucks")
- Workflow differentiation ("one-tap instead of 5-step wizard")
- Pricing differentiation ("annual at price of monthly elsewhere")
- Distribution differentiation ("the only one that has a Notion integration")
- Speed/simplicity differentiation ("does the one thing in 5 minutes vs. 1 hour")
- Trust / privacy / local-first differentiation ("data never leaves your device")
- Integration / developer differentiation ("API and webhooks at every plan, not just Enterprise")

Then write:
- **One-sentence positioning** — *"<Product> is the <category> for <ICP> that <unique angle>."*
- **Homepage hero headline** (≤ 8 words)
- **Subheadline** (≤ 20 words)
- **5 proof bullets** — specific facts that back the positioning
- **5 comparison-page angles** — *"<Product> vs. <Competitor>"* — what each comparison should emphasize

Test each angle with the question: *"Could the incumbent put this on their homepage tomorrow?"* If yes, it's not differentiation.

---

## Section 11 — Risk Register

| Risk | Category | Probability | Impact | Severity | Early Warning Signal | Mitigation |
|---|---|---|---|---|---|---|

**Categories** (cover at least one risk per category):
- Market (demand evaporates, segment shifts, competitive entry)
- Product (core value prop doesn't deliver)
- Technical (scaling issue, dependency failure, security breach)
- Distribution (channel saturates, algorithm changes, account ban)
- Pricing (race to bottom, wrong tier structure, payment gateway issues)
- Legal (regulation, IP claim, ToS violation)
- Platform (API changes, app store rejection, deprecation)
- Operational (single point of failure on founder)
- Founder capacity (burnout, life event, motivation collapse)
- Support burden (linearly scaling support cost, refund spike)

**Probability:** Low / Med / High
**Impact:** Low / Med / High
**Severity:** FATAL / SERIOUS / MINOR (probability × impact)

For each FATAL risk, the **early warning signal** is non-negotiable — the user should be able to tell you "if I see X, the risk is materializing."

End with: *"The 3 risks that should genuinely keep you up at night are..."*

---

## Section 12 — Validation Plan

A 30-day plan that tells the user whether to build, before they build.

| Day Range | Activity | Goal | Success Metric | Kill/Pivot Signal |
|---|---|---|---|---|

**Required activities:**
- 10–20 user interviews (with people in the target segment)
- Landing page test (specific page with email capture)
- Pricing smoke test (Stripe checkout that 404s after intent — measure clicks)
- Competitor review mining (read 50+ reviews on G2/AppStore/Reddit, extract patterns)
- Manual workflow simulation (do the thing for 3 customers by hand, measure time/effort)
- 5 direct sales conversations (offer to be paid for the manual version)
- One public demo (Twitter / LinkedIn / Loom video — measure engagement)
- One pre-order / waitlist / payment test (the strongest validation signal)

Then define:
- **Exact questions to ask in interviews** (5-7 questions, designed to extract pain not validate solution)
- **Where to find users** (specific subreddits, Discords, communities, with link)
- **Outreach message** (the actual copy to send)
- **Landing page copy** (the actual headline + sub + 3 bullets + CTA)
- **What counts as a weak signal** (e.g., "10 emails on waitlist" — interesting but inconclusive)
- **What counts as a strong signal** (e.g., "3 people offer to pre-pay $99 for manual delivery" — proceed)
- **Decision rule at end of 30 days**: BUILD if [criteria], PIVOT if [criteria], KILL if [criteria]

The decision rule must be **mechanical** — if the user has to interpret the result, the rule isn't tight enough.

---

## Section 13 — Build / Kill / Pivot Recommendation

The verdict. Be direct.

| Decision | Explanation |
|---|---|
| BUILD | Conditions met. Specific reasons. |
| BUILD ONLY IF | The 1-2 things that need to be true first. |
| PIVOT TO | Specific alternative direction. |
| KILL IF | Specific kill criteria from the validation plan. |

Pick exactly one as the headline recommendation.

Then write:
- **Best version of this idea** — if everything goes right, what does this become in 2 years?
- **Worst version of this idea** — the failure mode that's most likely
- **First product wedge** — the narrow first thing to build
- **First paid feature** — what users will pay for on day one
- **First acquisition channel** — only one
- **First metric to optimize** — only one (signups? trial→paid? retention? time-to-first-value?)
- **3 next actions for THIS WEEK** — specific tasks the user should do before doing anything else

End with one sentence: *"If you do nothing else, do this:"*

---

## Cross-section closing requirement

When running the full 13-section pass, end with a `00-summary.md` file (1 page max) containing:
- The one-line idea
- The verdict (Build / Build-if / Pivot / Kill)
- The 3 reasons for the verdict
- The 3 actions for this week
- The 3 things that would change the verdict

This summary is what the user re-reads in 6 months when they've forgotten the details.
