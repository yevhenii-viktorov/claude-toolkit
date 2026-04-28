# Plan Generation Reference

<overview>
How to derive executable planning artifacts from discovery session answers.
This reference covers the transformation from conversational answers to
structured BRIEF, ROADMAP, and PLAN files.
</overview>

<mapping_brief>
## Discovery Answers to BRIEF

| BRIEF Field | Source | Transform |
|-------------|--------|-----------|
| Project name | Explore Q1 | Extract noun phrase, capitalize |
| One-liner | Explore Q1 | Condense to one sentence |
| Problem | Explore Q2 + Q4 | 2-3 sentences: problem + current state |
| Success criteria | Explore Q5 + Scope must-haves | Make each measurable with verb + metric |
| Constraints | Explore Q6 | List as bullet points |
| Out of scope | Scope exclusions | List deferred features + explicit exclusions |

**Measurability transform**: "Users can search recipes" becomes
"Search returns relevant results within 2 seconds for any ingredient query"
</mapping_brief>

<mapping_roadmap>
## Discovery Answers to ROADMAP

Phase structure derives from multiple sources:

**Architecture lens** determines component boundaries:
- Monolith: phases by feature layer (data → logic → UI)
- Client + API: phases by component then feature
- Microservices: phases by service

**Data lens** determines ordering:
- Schema/model setup always comes first
- Features that depend on data models come after

**Scope priorities** determine phase content:
- Must-have #1 → earliest possible phase
- Must-have #2 → next phase (respecting dependencies)
- Foundation/infrastructure → Phase 1 always

**Operations lens** determines final phases:
- Deployment setup is typically the last phase
- CI/CD can be Phase 1 (if required) or final phase

**Phase naming convention**: `XX-kebab-case`
- 01-foundation, 02-core-api, 03-user-interface, 04-deployment
</mapping_roadmap>

<mapping_plans>
## Discovery Answers to PLANs

### Deriving Tasks

Each phase needs 1-3 tasks (max 3 per plan file). Tasks derive from:

1. **Lens observations** → what needs building
2. **Scope answers** → what specific features to include
3. **Architecture answers** → how components connect
4. **Codebase scan** → what files to create/modify

### Writing Good Actions

**BAD** (vague):
```xml
<action>Set up the database</action>
```

**GOOD** (specific):
```xml
<action>
Create PostgreSQL schema with User (id, email, passwordHash, createdAt),
Recipe (id, title, ingredients JSON, instructions TEXT, userId FK), and
Ingredient (id, name, category) tables. Use UUID for IDs. Add unique
constraint on User.email. Do NOT use auto-increment IDs -- UUIDs are
better for distributed systems.
</action>
```

Rules for `<action>`:
- Name specific files, tables, fields, functions
- Include technology choices from Analyze stage
- Add "do NOT" clauses with WHY for common mistakes
- Reference architectural decisions from lens observations
- If a task involves a choice between approaches, the choice should already
  be resolved from the Analyze or Plan stage

### Writing Good Verification

**BAD**:
```xml
<verify>Check that it works</verify>
```

**GOOD**:
```xml
<verify>npm run build && npm run test -- --coverage > 80%</verify>
```

Rules for `<verify>`:
- Must be a runnable command or specific manual check
- Derive from project type (go build, npm test, cargo check, etc.)
- Include specific pass criteria (exit code 0, coverage threshold, etc.)
- For UI work: "Run dev server, navigate to /path, verify [behavior]"

### Writing Good Done Criteria

**BAD**:
```xml
<done>Database is set up</done>
```

**GOOD**:
```xml
<done>Schema created with 3 tables, migrations run successfully, seed data loads without errors</done>
```

Rules for `<done>`:
- Countable or binary (not "works well" or "looks good")
- Reference specific artifacts (N files, N tables, N endpoints)
- Tie back to phase goal from ROADMAP
</mapping_plans>

<splitting_rules>
## When to Split Plans

**Max 3 tasks per plan.** If a phase needs more, split:

**By subsystem**:
```
Phase 3: User Dashboard
  03-01-PLAN.md: Backend API endpoints (3 tasks)
  03-02-PLAN.md: Frontend components (3 tasks)
```

**By dependency**:
```
Phase 2: Recipe Management
  02-01-PLAN.md: Database models + migrations (2 tasks)
  02-02-PLAN.md: CRUD API endpoints (3 tasks, depends on 02-01)
  02-03-PLAN.md: UI forms and pages (3 tasks, depends on 02-02)
```

**By complexity**:
```
Phase 4: AI Integration
  04-01-PLAN.md: API client setup (1 task, simple)
  04-02-PLAN.md: Prompt engineering + response handling (2 tasks, complex)
```

**By verification point**:
```
Phase 5: Deployment
  05-01-PLAN.md: Infrastructure setup (ends with checkpoint:human-verify)
  05-02-PLAN.md: CI/CD pipeline (ends with checkpoint:human-verify)
```
</splitting_rules>

<checkpoint_rules>
## When to Use Checkpoints

**checkpoint:human-verify** (use frequently):
- After any UI/visual implementation
- After deployment/infrastructure changes
- After complex integration work
- Whenever "does this look/work right?" matters

**checkpoint:decision** (use sparingly):
- When a genuine fork exists (two valid approaches, neither clearly better)
- When user preference matters (styling, naming, UX flow)
- NOT for technical decisions you can make (pick the better option)

**Golden rule**: If you can determine the right choice from the discovery
answers, make it. Only use checkpoint:decision for truly ambiguous choices
that weren't resolved during discovery.
</checkpoint_rules>

<file_structure>
## Output File Structure

```
.planning/
├── BRIEF.md                          # Project vision (< 50 lines)
├── ROADMAP.md                        # Phase structure + progress
├── DISCOVERY-SESSION.md              # TEMPORARY (deleted after generation)
└── phases/
    ├── 01-foundation/
    │   ├── 01-01-PLAN.md
    │   └── [01-01-SUMMARY.md -- created during execution]
    ├── 02-core-features/
    │   ├── 02-01-PLAN.md
    │   ├── 02-02-PLAN.md
    │   └── [summaries created during execution]
    └── 03-deployment/
        └── 03-01-PLAN.md
```

Naming: `{phase}-{plan}-PLAN.md` (e.g., `02-01-PLAN.md`)
Phase dirs: `XX-kebab-case` (e.g., `01-foundation`)
</file_structure>
