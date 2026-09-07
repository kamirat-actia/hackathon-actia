---
description: "Use when creating or modifying tests, acceptance criteria, browser validation, mocks, fixtures, or quality evidence for dashboard behavior."
applyTo: "test/**/*.test.js,src/js/**/*.js,package.json,.github/spec/**/*.md"
---
# Testing Instructions

## Test Strategy

- Trace every behavior test to at least one `REQ-###` or `AC-###` in its name or surrounding test group when practical.
- Use native `node:test` and `node:assert/strict`; do not add a test framework without an approved architecture decision.
- Test the smallest public contract that proves behavior.
- Keep deterministic logic executable without a browser, map library, geolocation permission, or network.

## Determinism And Isolation

- Inject or fake elapsed time, animation scheduling, DOM boundaries, geolocation, and route responses.
- Never call public map, tile, geolocation, or routing services from automated tests.
- Reset global listeners, timers, fake DOM, and mutable fixtures after each test.
- Use representative boundary values immediately below, at, and above configured thresholds.
- Compare numeric simulation output with an explicit tolerance when floating-point math is involved.

## Required Behavior Coverage

- Vehicle initial state, bounds, invariants, accepted/rejected transitions, and snapshot immutability.
- Acceleration, braking precedence, drag, steering, distance, charge drain, charging, and depletion under controlled deltas.
- Warning priority plus exactly-once raised and cleared events.
- Keyboard alternatives, repeat suppression, release, blur, visibility, pointer cancel, and teardown.
- Simulation loop first frame, delta clamp, duplicate start, and stop.
- Coordinate validation, geographic math, service timeout/abort/malformed response, and stale route suppression.
- Component formatting, safe fallback values, class/ARIA state, and unsubscribe behavior.

## Browser Acceptance

- Execute AC-001 through AC-014 against the full page before release.
- Test keyboard and on-screen controls separately and together.
- Inject denied geolocation and missing map, tile, and route resources; assert that core instruments continue.
- Check console output for uncaught errors.
- Capture `360x800`, `768x1024`, and `1440x900` screenshots and check overlap, clipping, and horizontal scroll.
- Perform automated accessibility checks plus manual focus order, names, live messages, reduced motion, and `200%` zoom review.

## Completion Rules

- Run the narrowest related test immediately after a behavior edit.
- Run `npm test` before closing any implementation ticket.
- Record skipped browser or accessibility checks explicitly; absence of tooling is not a passing result.
- Do not weaken assertions, increase tolerances, or delete tests solely to make a change pass.
- Report unrelated pre-existing failures separately and leave them unchanged.