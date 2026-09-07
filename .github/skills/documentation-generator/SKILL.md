---
name: documentation-generator
description: "Create, update, or reconcile dashboard functional specs, technical specs, plans, backlog, README, architecture decisions, Copilot asset summaries, and hackathon presentation documentation. Use for docs, traceability, controls, setup, services, risks, or release-status changes."
argument-hint: "Document or verified behavior/decision to describe"
user-invocable: true
disable-model-invocation: false
---
# Documentation Generator

## Purpose

Produce concise, presentation-ready documentation that distinguishes proposed behavior from implemented and verified behavior, while keeping requirements, architecture, tickets, controls, services, and local commands consistent.

## Trigger Conditions

Use this skill when asked to:

- generate or update a functional or technical specification;
- create an implementation plan, backlog, project setup, README, or architecture decision;
- document keyboard controls, thresholds, external services, privacy, or fallbacks;
- reconcile documentation after implementation;
- prepare hackathon presentation material or a final project summary;
- audit `REQ-###`, `AC-###`, plan, and ticket traceability.

Do not use it to implement runtime behavior or mark unexecuted validation as passed.

## Folder Structure

```text
.github/skills/documentation-generator/
`-- SKILL.md
```

Canonical documentation locations:

```text
README.md
docs/project-setup.md
.github/AGENTS.md
.github/spec/functional-specification.md
.github/spec/technical-specification.md
.github/spec/implementation-plan.md
.github/spec/backlog.md
.github/agents/*.agent.md
.github/instructions/*.instructions.md
.github/skills/*/SKILL.md
```

## Source Hierarchy

Use the highest applicable authority:

1. User-approved scope or decision in the current request.
2. Functional specification for intended observable behavior.
3. Technical specification and architecture decisions for implementation boundaries.
4. Backlog and implementation plan for sequence and status.
5. Runtime configuration and source for implemented facts.
6. Automated and browser evidence for verified facts.
7. README for operator guidance only.

When sources conflict, report the conflict. Do not silently rewrite intended requirements to match a defect.

## Status Vocabulary

Use these terms precisely:

| Status | Meaning |
| --- | --- |
| Proposed | Specified but not approved or implemented |
| Ready | Approved and sufficiently defined for the next stage |
| Implemented | Code exists; full acceptance may not have run |
| Verified | Required automated and manual evidence passed |
| Deferred | Intentionally postponed with priority and impact stated |
| Blocked | Cannot proceed because a named dependency or decision is missing |

## Procedure

### 1. Define The Documentation Task

Identify:

- target audience and presentation purpose;
- target document and whether it is canonical or consolidated;
- affected behavior, command, threshold, service, requirement, ticket, or decision;
- intended status and evidence available;
- other documents that repeat the same fact.

### 2. Gather Minimal Evidence

1. Read the target document and its canonical upstream source.
2. Search exact identifiers, command labels, values, paths, and service names across documentation and configuration.
3. Read tests or validation reports before using `Verified` or stating that a target passed.
4. For a new architecture decision, capture context, decision, rationale, alternatives, trade-offs, and consequences.

Do not broadly summarize the repository when a specific source controls the fact.

### 3. Draft By Document Type

#### Functional Specification

- Define vision, objective, users, experience, states, interactions, errors, alerts, battery, GPS, assumptions, risks, testable requirements, and Given/When/Then acceptance criteria.
- Use unique sequential `REQ-###` and `AC-###` IDs.
- Describe what and why, not module implementation.

#### Technical Specification

- Define folder/file ownership, module contracts, state, events, rendering, services, accessibility, performance, testing, conventions, and architecture decisions.
- State rationale and fallback behavior for every external dependency.

#### Plan And Backlog

- Map every requirement to phases, small ordered tickets, dependencies, outputs, and validation evidence.
- Include ID, title, priority, description, acceptance criteria, and complexity for each ticket.
- Keep P1 required work ahead of P2 enhancements and P3 polish.

#### README

- Keep purpose, prerequisites, exact startup/test commands, controls, optional services, fallback behavior, and current status concise.
- Link to detailed specs instead of duplicating architecture rationale.

#### Consolidated Project Setup

- Make the document standalone and presentation-ready.
- Include functional and technical summaries, complete requirement/backlog indexes, Copilot instructions, agents, skills, decisions, assumptions, risks, and next-stage gate.

### 4. Reconcile Repeated Facts

Check at minimum:

- startup and test commands;
- key codes, action labels, and interaction modes;
- speed/battery limits and warning thresholds;
- service names, versions, attribution, privacy disclosure, and fallbacks;
- requirement, acceptance, plan, and ticket references;
- proposed/implemented/verified/deferred language;
- folder names and relative links.

### 5. Validate

- Confirm required headings are present.
- Confirm identifier uniqueness and sequence.
- Confirm every requirement maps to at least one plan item, ticket, and evidence type.
- Confirm every relative link target exists.
- Confirm YAML frontmatter in instructions, agents, and skills remains bounded by `---` and includes required fields.
- Run available Markdown/editor diagnostics.
- Report facts that could not be verified.

## Writing Rules

- Use professional Markdown, short paragraphs, flat lists, tables for matrices, and Mermaid for architecture/dependency diagrams.
- Keep wording explicit, testable, and free of marketing claims.
- Define assumptions and risks rather than hiding ambiguity.
- Use exact file paths and commands.
- Do not paste source code when a contract or link communicates the point.
- Keep code identifiers in English and preserve approved user-facing language.
- Avoid duplicate content except where a required standalone deliverable must remain usable by itself.

## Completion Checklist

- [ ] Audience, purpose, source, and status are explicit.
- [ ] Required sections are complete.
- [ ] Repeated facts match canonical sources.
- [ ] Identifiers are unique and traceable.
- [ ] Decisions include rationale and trade-offs.
- [ ] Assumptions, risks, privacy, and fallbacks are visible.
- [ ] Links, paths, commands, and frontmatter validate.
- [ ] No unsupported completion or test claim remains.

## Output Format

Return:

- **Documents changed:** path and purpose.
- **Authoritative evidence:** source used for each changed fact.
- **Traceability:** identifiers added, changed, or reconciled.
- **Validation:** structural, link, diagnostic, and evidence checks.
- **Open items:** proposed, deferred, blocked, or unverified facts.
