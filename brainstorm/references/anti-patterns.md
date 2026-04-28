# Anti-Patterns Reference

Common mistakes to avoid during discovery sessions.

<anti_pattern name="interrogation_mode">
**What**: Asking 3+ questions in a single message.
**Why bad**: Overwhelms the user, gets shallow answers, feels like a form.
**Fix**: One question per message. Wait for response. Build on the answer.

**Bad**:
"What are you building? Who is it for? What's the tech stack? Any constraints?"

**Good**:
"Tell me about your idea. What do you want to build?"
[wait for response]
"Interesting. Who would use this?"
</anti_pattern>

<anti_pattern name="scope_explosion">
**What**: Saying "yes" to every feature idea or suggesting features unprompted.
**Why bad**: Discovery should NARROW scope, not expand it. Every added feature
means more phases, more plans, more complexity.
**Fix**: Apply YAGNI guard. For every feature ask: "Do we need this for v1?"
Move uncertain features to Out of Scope or Nice-to-have.

**Bad**: "We should also add notifications, analytics, admin dashboard,
export functionality, and a mobile app!"

**Good**: "That's a nice-to-have. Let's put it in v1.1 and focus on the
core value for now."
</anti_pattern>

<anti_pattern name="analysis_paralysis">
**What**: Applying all 5 lenses with 3+ questions each, spending too long
in the Analyze stage.
**Why bad**: Diminishing returns after 2-3 lenses. User gets fatigued.
Context gets bloated.
**Fix**: Max 4 lenses, 1-2 questions each. Skip lenses that aren't relevant.
If a lens produces an obvious answer, state it and move on without asking.

**Bad**: Asking 15 questions during Analyze stage.

**Good**: "Since this is a web app with user accounts, I'll check architecture,
data, UX, and security." [4 questions, 4 observations, move on]
</anti_pattern>

<anti_pattern name="premature_solutioning">
**What**: Jumping to implementation details before understanding the problem.
Suggesting specific libraries, patterns, or code structures during Explore stage.
**Why bad**: Anchors the discussion around a solution before the problem space
is understood. Misses better alternatives.
**Fix**: Explore stage is problem-only. Analyze stage is solution-shape.
Plan stage is implementation details.

**Bad**: (in Explore) "We should use PostgreSQL with Prisma ORM and Next.js
with server components for this."

**Good**: (in Explore) "So the core problem is [X] for [Y] users."
(in Analyze) "For the data layer, given your needs..."
</anti_pattern>

<anti_pattern name="persona_theater">
**What**: Full persona simulation during analysis. "As the security architect,
I believe we must implement defense-in-depth with WAF, IDS/IPS..."
**Why bad**: Burns context tokens on theater. Produces broad-but-shallow
analysis. User doesn't need the roleplay, they need the insight.
**Fix**: Lenses, not personas. A lens is a question + observation, not a
character performance.

**Bad**: "Let me now put on my Security Architect hat. From a security
perspective, considering the OWASP Top 10, NIST frameworks, and SOC2
compliance requirements..."

**Good**: "Security note: since you have user PII, passwords need hashing
and sessions need expiry. I'll add auth setup tasks to Phase 1."
</anti_pattern>

<anti_pattern name="vague_plans">
**What**: Generating plans with non-specific tasks. "Add authentication"
instead of specific files, commands, and verification criteria.
**Why bad**: An agent executing a vague plan will either ask clarifying
questions (defeating the purpose) or make wrong assumptions.
**Fix**: Every task must name specific files, specific implementation
details, and specific verification commands.

**Bad**:
```xml
<task type="auto">
  <name>Set up auth</name>
  <action>Add authentication to the app</action>
  <verify>Test it</verify>
</task>
```

**Good**:
```xml
<task type="auto">
  <name>Task 1: Create auth API endpoints</name>
  <files>src/api/auth/login.ts, src/api/auth/register.ts</files>
  <action>POST /api/auth/login: accept {email, password}, validate with
  bcrypt, return JWT in httpOnly cookie (15min expiry). POST /api/auth/register:
  accept {email, password, name}, hash password with bcrypt (12 rounds),
  create User record. Use jose library for JWT (not jsonwebtoken -- CommonJS
  issues with ESM bundlers).</action>
  <verify>curl -X POST /api/auth/register -d '{"email":"test@t.com",
  "password":"test123","name":"Test"}' returns 201; curl -X POST
  /api/auth/login with same creds returns 200 + Set-Cookie header</verify>
  <done>Both endpoints return correct status codes, JWT is valid, password
  is hashed in DB</done>
</task>
```
</anti_pattern>

<anti_pattern name="over_splitting">
**What**: Creating 8+ plans for a simple 2-phase project.
**Why bad**: Administrative overhead exceeds value. Each plan needs its own
context loading, summary generation, etc.
**Fix**: 2-3 tasks per plan, 1-3 plans per phase. A 3-phase project should
have 3-9 plans total, not 15+.

**Bad**: 12 plans for a CLI tool with 3 commands.
**Good**: 3 plans: core framework, commands, distribution.
</anti_pattern>

<anti_pattern name="documentation_for_documentation">
**What**: Producing a 500-line brainstorming document, meeting notes, or
requirements spec that nobody will read.
**Why bad**: The output should be EXECUTABLE, not documentary. An agent
reads PLANs, not meeting minutes.
**Fix**: Output is BRIEF (<50 lines) + ROADMAP + PLANs. No intermediate
brainstorming documents. DISCOVERY-SESSION.md is temporary scaffolding,
not a deliverable.
</anti_pattern>
