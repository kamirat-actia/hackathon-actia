---
name: acceptance-test-generator
description: "Generate and execute requirement-traceable acceptance tests for the automotive dashboard. Use for Given/When/Then scenarios, native Node tests, browser flows, boundary matrices, offline GPS failures, accessibility checks, responsive screenshots, regression evidence, or release gates."
argument-hint: "REQ-###, AC-###, ticket ID, or user flow to validate"
user-invocable: true
disable-model-invocation: false
---
# Acceptance Test Generator

## Purpose

Turn approved requirements and acceptance criteria into the smallest deterministic automated tests plus the browser evidence needed to verify observable dashboard behavior.

## Trigger Conditions

Use this skill when asked to:

- generate acceptance tests or Given/When/Then scenarios;
- add tests for a requirement, ticket, component, command, state transition, or defect;
- test keyboard/touch behavior, battery, warnings, speed, GPS, service degradation, or accessibility;
- create a responsive or browser validation matrix;
- perform a regression or final release gate.

Do not use it to invent product behavior. Missing expected outcomes must be resolved in the functional specification first.

## Folder Structure

```text
.github/skills/acceptance-test-generator/
`-- SKILL.md
```

Generated automated tests belong under:

```text
test/event-bus.test.js
test/vehicle-state.test.js
test/simulation-loop.test.js
test/keyboard-controller.test.js
test/navigation.test.js
test/cockpit-view-controller.test.js
test/<new-owning-module>.test.js
```

Do not create a second test root. Add a new test file only when no existing owner fits.

## Required Inputs

- One or more `REQ-###`, `AC-###`, or an approved ticket.
- Observable Given/When/Then outcome.
- Owning module and public contract.
- Relevant limits, thresholds, timing tolerance, and failure modes.
- Available unit, integration, browser, accessibility, and screenshot tooling.

If the expected result is ambiguous or contradicts another requirement, stop and report the conflict.

## Test Layer Selection

Choose the lowest layer that proves the requirement:

| Layer | Use for | Avoid |
| --- | --- | --- |
| Unit | Pure calculations, bounds, thresholds, state transitions, parsers | DOM appearance |
| Integration | Input -> state -> event, loop -> state, service adapter -> normalized result | Full visual workflow |
| Component contract | Snapshot -> text/class/ARIA/CSS property and cleanup | Vehicle physics |
| Browser acceptance | Keyboard/pointer workflow, permissions, external failures, focus, layout | Exhaustive numeric permutations |
| Visual/accessibility | Viewports, zoom, contrast, reduced motion, overlap, announcements | Domain correctness alone |

Do not push deterministic state logic into a browser test when a faster unit test can prove it.

## Procedure

### 1. Build The Traceability Record

For each selected requirement, record:

| Field | Value |
| --- | --- |
| Requirement | `REQ-###` and exact expected behavior |
| Acceptance | Existing `AC-###` or newly approved scenario |
| Ticket | Owning implementation ticket |
| Contract | Public method, event, snapshot field, or user-visible control |
| Evidence | Unit, integration, browser, accessibility, or performance |

Reject orphan tests that cannot name an observable contract.

### 2. Derive Cases

Include only applicable categories:

1. Initial/default state.
2. Typical success path.
3. Immediately below, at, and above each boundary.
4. Invalid transition or malformed input.
5. Repeated operation and idempotent cleanup.
6. Concurrent or opposing input.
7. Time-step equivalence and oversized delta.
8. Permission denial, unavailable API, timeout, abort, stale response, and invalid remote payload.
9. Offline fallback and recovery.
10. Keyboard, pointer/touch, focus, zoom, reduced motion, and target viewport behavior.

Use pairwise or parameterized cases where they remain readable. Do not create redundant permutations without distinct risk.

### 3. Implement Deterministic Automated Tests

- Use `node:test` and `node:assert/strict`.
- Name tests by behavior, not method internals.
- Follow Arrange, Act, Assert.
- Inject fake clocks, animation schedulers, services, and minimal DOM boundaries.
- Use explicit floating-point tolerances for navigation and elapsed-time math.
- Validate emitted payloads and public snapshots rather than private fields.
- Restore globals, listeners, timers, and fixtures after each test.
- Never call real geolocation, map, tile, font, icon, or route services.

When fixing a defect, first add the smallest test that fails for the reported behavior, run it, then implement the repair.

### 4. Execute Focused Then Broad Validation

Run the owning test first:

```powershell
node --test test/<owning-module>.test.js
```

Then run:

```powershell
npm test
```

If the focused test fails, fix the same slice and rerun it before widening scope. Do not weaken a valid assertion to make the result pass.

### 5. Execute Browser Acceptance

For browser-relevant criteria:

1. Start the local static server.
2. Confirm the initial cockpit and console are error-free.
3. Execute the Given/When/Then flow with keyboard.
4. Repeat with equivalent on-screen controls.
5. Inject geolocation denial and missing map/tile/route behavior when relevant.
6. Capture `360x800`, `768x1024`, and `1440x900` screenshots.
7. Check focus order, accessible names, live warnings, contrast, `200%` zoom, and reduced motion.
8. Check text overlap, clipping, horizontal scroll, stuck input, and layout shift at extreme values.

Record browser name/version, viewport, network state, permission state, and result. An unexecuted check is `NOT RUN`, never `PASS`.

## Core Risk Matrix

| Area | Minimum acceptance evidence |
| --- | --- |
| Speed | Start, accelerate, brake, coast, min/max clamp, finite display |
| Battery | Drain, accelerated drain, valid charge guard, full clamp, empty shutdown |
| Warnings | Each threshold, priority, exactly-once raise/clear, non-color cue |
| Commands | Arrow/WASD parity, repeat suppression, release, blur, visibility, pointer cancel |
| GPS | Valid default, heading/movement, denied location, offline map, failed/stale route |
| State | Invalid transition preservation and immutable snapshots |
| Layout | Three target viewports, `200%` zoom, long messages, extreme values |
| Accessibility | Keyboard completion, focus, names, status semantics, reduced motion |
| Reliability | No uncaught console error during optional-service failures |

## Completion Checklist

- [ ] Every test maps to a requirement, acceptance scenario, and public contract.
- [ ] Boundary and failure cases cover the identified risk.
- [ ] Automated tests are deterministic and network-independent.
- [ ] Focused test ran before the full suite.
- [ ] Browser-only claims have browser evidence.
- [ ] Accessibility and viewport evidence is explicit.
- [ ] Environment blockers and `NOT RUN` checks are visible.
- [ ] Failures include reproducible expected/actual behavior and likely ownership.

## Output Format

Return:

- **Traceability matrix:** requirement, acceptance, ticket, layer, and evidence.
- **Automated results:** command, pass/fail counts, and focused failures.
- **Browser matrix:** browser, viewport, network/permission state, and result.
- **Defects:** severity, reproduction, expected, actual, and owning module.
- **Verdict:** `PASS`, `FAIL`, or `BLOCKED`, followed by every `NOT RUN` check.