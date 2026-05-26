# ROADMAP Template (Discovery-Populated)

Use this when generating `.planning/ROADMAP.md` from discovery session answers.

## Phase Derivation Rules

| Lens | Drives |
|------|--------|
| Architecture | Phase boundaries (separate components = separate phases) |
| Data | Phase ordering (data model before features that use it) |
| UX/DX | Checkpoint-heavy phases (needs human-verify) |
| Security | Security-specific tasks within relevant phases |
| Operations | Final deployment/infra phase |
| Scope priorities | Must-haves first, ordered by dependency |

## Template

```markdown
# Roadmap: [Project Name]

## Overview

[2-3 sentences: what we're building and the approach. Derived from Explore
summary + Scope decisions.]

## Phases

- [ ] **Phase 1: [Name]** - [Goal from architecture lens: foundational component]
- [ ] **Phase 2: [Name]** - [Goal from scope: core feature #1]
- [ ] **Phase 3: [Name]** - [Goal from scope: core feature #2]
- [ ] **Phase 4: [Name]** - [Goal from operations lens: deployment/polish]

## Phase Details

### Phase 1: [Name]
**Goal**: [From Explore Q5 + architecture lens observation]
**Depends on**: Nothing (foundation)
**Plans**: [count] ([list plan names])
**Lens notes**: [Relevant architecture/data observations from Analyze stage]

### Phase 2: [Name]
**Goal**: [From scope must-have + relevant lens observation]
**Depends on**: Phase 1
**Plans**: [count]
**Lens notes**: [Relevant observations]

[Repeat for each phase]

## Progress

| Phase | Plans | Status | Completed |
|-------|-------|--------|-----------|
| 1. [Name] | 0/[N] | Not started | - |
| 2. [Name] | 0/[N] | Not started | - |
| 3. [Name] | 0/[N] | Not started | - |
| 4. [Name] | 0/[N] | Not started | - |
```

## Rules

- 3-6 phases for a typical v1 project
- Phase goals should reference lens observations (not just feature names)
- Include "Lens notes" to carry forward analysis into planning
- Dependencies must be explicit
- No time estimates in phases
- Plan counts can be estimated (refined when PLANs are generated)
- Phase naming: XX-kebab-case (01-foundation, 02-core-features, etc.)
- For focused mode: add a single new phase entry to existing ROADMAP
