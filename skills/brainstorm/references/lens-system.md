# Lens System Reference

<overview>
Lenses are lightweight perspective checks applied at specific moments during
discovery. They replace heavyweight persona simulation with targeted questions
and brief observations.

A lens is NOT a full persona with backstory and communication style.
A lens IS a 1-2 sentence perspective shift producing a 2-3 sentence observation
that feeds directly into planning artifacts.

Cost: ~1 question + ~3 sentences per lens.
Value: Catches blind spots, drives plan structure.
</overview>

<activation_rules>
**Focused mode**: 1-2 lenses (auto-selected based on scope answers)
**Comprehensive mode**: 3-4 lenses (always Architecture + 2-3 contextual)

**Never apply all 5 lenses.** Maximum 4 in comprehensive mode.

Selection criteria:
- Architecture: ALWAYS in comprehensive. In focused if multi-component.
- Security: If auth, user data, external APIs, inputs, financial data, or PII.
- UX/DX: If user-facing features, developer-facing APIs/tools, or config.
- Data: If persistence, state management, sync, migration, or schemas.
- Operations: If deployment decisions, monitoring, scaling, or CI/CD needed.

When uncertain, lean toward applying a lens. A skipped lens is a blind spot
in the plan; an unnecessary lens costs only one question.
</activation_rules>

<lens name="architecture">
<perspective>System structure, component boundaries, deployment model</perspective>

<questions>
- "How should this be structured?"
  A) Monolith (single app, single deploy)
  B) Client + API (frontend + backend)
  C) Multiple services (microservices/modular)
  D) Library/package (consumed by others)
  E) Not sure -- help me decide

- "How does this connect to what exists?" (if brownfield)
  A) Standalone, new route/component
  B) Extends existing [detected component]
  C) Replaces existing functionality
  D) Cross-cutting (touches multiple areas)

- "What are the main components?"
  [Free text or present inferred component list for validation]
</questions>

<observation_format>
"Architecture: [choice]. This means [implication]. For planning: [impact on phases]."
Example: "Architecture: Client + API with React frontend and Go backend. This means
separate build pipelines. For planning: Phase 1 should set up both projects, Phase 2+
can work on features with parallel frontend/backend tasks."
</observation_format>

<plan_impact>
- Drives phase boundaries (separate components = separate phases or parallel tracks)
- Determines dependency ordering between phases
- Influences file structure in @context references
- May split a single feature into multiple plans (frontend plan + backend plan)
</plan_impact>
</lens>

<lens name="security">
<perspective>Authentication, data protection, input validation, access control</perspective>

<questions>
- "Does this need authentication?"
  A) No -- public/anonymous access
  B) Simple (email/password)
  C) OAuth/social login
  D) Enterprise (SSO/SAML)
  E) API keys only

- "What sensitive data is involved?"
  A) None
  B) User PII (names, emails)
  C) Financial data (payments, billing)
  D) Health/regulated data
  E) Third-party secrets/tokens

- "Who should have access to what?" (if multi-role)
  [Present role options based on context]
</questions>

<observation_format>
"Security: [need level]. [specific concern]. For planning: [task/verification impact]."
Example: "Security: Simple auth with user PII. Passwords must be hashed, sessions
need expiry. For planning: add auth setup to Phase 1, add input validation tasks
to every phase with user input."
</observation_format>

<plan_impact>
- Adds security-specific tasks (auth setup, input validation, CSRF protection)
- Adds verification criteria (password hashing check, session expiry test)
- May create dedicated security phase for complex auth requirements
- Influences task ordering (auth before features that need it)
</plan_impact>
</lens>

<lens name="ux_dx">
<perspective>User flows, interaction patterns, error states, developer experience</perspective>

<questions>
- "What is the primary user flow?"
  A) Form/input -> submit -> result
  B) List/browse -> select -> detail
  C) Dashboard/visualization (read-mostly)
  D) Real-time/interactive (chat, collab)
  E) CLI/terminal workflow

- "What happens when things go wrong?"
  A) Simple error messages
  B) Guided recovery (retry, suggest fixes)
  C) Graceful degradation (offline support)
  D) Not sure yet

- "What does the user see first?"
  [Free text or present options based on flow choice]
</questions>

<observation_format>
"UX: [primary pattern]. [key interaction]. For planning: [checkpoint/task impact]."
Example: "UX: Form-driven flow with ingredient input and recipe output. Key
interaction is the AI generation step with loading state. For planning: add
checkpoint:human-verify after UI implementation in each phase."
</observation_format>

<plan_impact>
- Adds checkpoint:human-verify tasks after UI/visual implementation
- Influences task granularity (UI tasks need visual verification)
- Drives error handling tasks and edge case coverage
- May add accessibility or responsive design verification steps
</plan_impact>
</lens>

<lens name="data">
<perspective>Persistence, schemas, state management, data flow, migration</perspective>

<questions>
- "Where does the data live?"
  A) Local/in-memory only (no persistence)
  B) Single database (SQL or NoSQL)
  C) Multiple stores (cache + DB + files)
  D) External API (we consume, don't own the data)
  E) Combination of above

- "What are the main data entities?"
  [Free text or present inferred entities for validation]

- "How does data flow through the system?"
  A) Simple CRUD (create, read, update, delete)
  B) Event-driven (actions trigger reactions)
  C) Pipeline (data transforms through stages)
  D) Real-time sync (multiple clients, same data)
</questions>

<observation_format>
"Data: [storage choice]. Key entities: [list]. For planning: [schema/ordering impact]."
Example: "Data: PostgreSQL with User, Recipe, Ingredient entities. CRUD pattern
with AI generation step. For planning: database setup in Phase 1 before any
feature work. Schema migration tasks in later phases."
</observation_format>

<plan_impact>
- Drives Phase 1 tasks (database/schema setup before features)
- Determines entity relationships and migration ordering
- Adds schema validation to verification criteria
- Influences task splitting (data layer before business logic before UI)
</plan_impact>
</lens>

<lens name="operations">
<perspective>Deployment, monitoring, scaling, CI/CD, infrastructure</perspective>

<questions>
- "How will this be deployed?"
  A) Static hosting (Vercel, Netlify, GitHub Pages)
  B) Container (Docker, Kubernetes)
  C) Serverless (Lambda, Cloud Functions)
  D) Traditional server (VPS, EC2)
  E) Desktop/mobile app (no server deploy)
  F) Not decided yet

- "What needs monitoring?"
  A) Nothing yet (MVP, monitor later)
  B) Basic health checks and error logging
  C) Full observability (metrics, traces, logs)
  D) Specific SLAs or uptime requirements

- "Any CI/CD requirements?"
  A) None (manual deploy is fine for now)
  B) Basic (test on push, deploy on merge)
  C) Full pipeline (lint, test, build, deploy, notify)
</questions>

<observation_format>
"Operations: [deploy target]. [monitoring level]. For planning: [infra phase impact]."
Example: "Operations: Vercel deployment with basic health checks. CI via GitHub
Actions. For planning: deployment setup as final phase, add build verification
to every phase's verification section."
</observation_format>

<plan_impact>
- Creates deployment/infrastructure phase (typically last)
- Adds build/deploy verification to every phase
- Influences technology choices in earlier phases
- May add CI/CD setup tasks
</plan_impact>
</lens>

<combination_patterns>
Common lens combinations and what they produce:

**Web app (typical)**: Architecture + Data + UX + Security
- Result: 4-5 phases (foundation, data, features, UI polish, deploy)

**API/backend service**: Architecture + Data + Security + Operations
- Result: 3-4 phases (foundation, core API, auth/security, deploy)

**CLI tool**: Architecture + UX/DX + Operations
- Result: 2-3 phases (core functionality, UX polish, distribution)

**Library/package**: Architecture + UX/DX + Data
- Result: 2-3 phases (core API, documentation, publishing)

**Infrastructure/DevOps**: Architecture + Operations + Security
- Result: 3-4 phases (setup, automation, security hardening, monitoring)
</combination_patterns>
