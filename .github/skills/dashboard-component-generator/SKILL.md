---
name: dashboard-component-generator
description: "Create or extend one automotive dashboard instrument across semantic HTML, snapshot-driven JavaScript, component CSS, composition, and focused tests. Use when asked to add a gauge, indicator, monitor, warning display, GPS panel, control surface, or dashboard component."
argument-hint: "Component name plus ticket or REQ-### IDs"
user-invocable: true
disable-model-invocation: false
---
# Dashboard Component Generator

## Purpose

Generate one complete dashboard component that follows the repository's state, rendering, styling, accessibility, and validation patterns. This workflow covers the component boundary, not new vehicle physics or product scope.

## Trigger Conditions

Use this skill when the request includes phrases or intent such as:

- add or create a dashboard component;
- implement a gauge, indicator, instrument, monitor, panel, or control legend;
- add a speed, battery, warning, energy, GPS, status, or vehicle metric display;
- connect an existing snapshot field to the cockpit UI;
- scaffold component HTML, JavaScript, CSS, and tests.

Do not use it to invent a new state field, threshold, command, or service contract. Resolve those through the functional and technical specifications first.

## Folder Structure

```text
.github/skills/dashboard-component-generator/
`-- SKILL.md
```

Generated runtime files follow this pattern:

```text
index.html
src/js/components/<component-name>.js
src/css/components/<component-name>.css
src/css/main.css
src/js/main.js
test/<component-name>.test.js
```

Touch only the files needed by the selected component. Do not create empty placeholder files.

## Required Inputs

- Component name and user-visible purpose.
- At least one approved `REQ-###` or backlog ticket.
- Snapshot fields or events the component consumes.
- Required normal, boundary, disabled, offline, and failure states.
- The narrowest executable validation available.

If a required state field or behavior is absent from the specification, stop and return the missing decision instead of guessing.

## Procedure

### 1. Resolve Ownership

1. Read the ticket in `.github/spec/backlog.md`.
2. Read its functional requirements and acceptance scenarios.
3. Read the component and rendering sections of `.github/spec/technical-specification.md`.
4. Inspect one neighboring component and its closest test.
5. Confirm that the requested values already exist in an immutable snapshot or approved presentation service.

State one local hypothesis before editing, for example: "The component can remain passive because every displayed value exists in `VehicleSnapshot`." Name one focused test that would disprove it.

### 2. Define The Component Contract

Record a short contract before implementation:

| Concern | Decision |
| --- | --- |
| Root hook | One stable `data-*` selector in `index.html` |
| Inputs | Exact snapshot fields and optional presentation status |
| Output | Text, attributes, classes, and CSS custom properties owned by the root |
| States | Initial, normal, every boundary, invalid-input fallback, and degraded state |
| Accessibility | Name, textual equivalent, focus behavior, and live announcement policy |
| Cleanup | Subscriptions, listeners, observers, or external instance to release |

The contract must not include writes to `VehicleState` from `render()`.

### 3. Implement Incrementally

1. Add or refine semantic fallback markup in `index.html`.
2. Add a small renderer in `src/js/components/<component-name>.js`.
3. Cache owned DOM references at construction.
4. Implement one `render(snapshot)` path using safe formatting and clamped presentation values.
5. Add component-owned styles in `src/css/components/<component-name>.css` using shared tokens.
6. Register the stylesheet in `src/css/main.css` only if the import pattern requires it.
7. Compose the component in `src/js/main.js` and render the initial snapshot before starting the loop.
8. Add focused tests for formatting, boundary states, invalid values, ARIA/class state, and cleanup.

After the first substantive edit, run the focused component test before making additional changes.

## Implementation Rules

- Keep simulation, battery, warning, command, and navigation rules out of the component.
- Never mutate, retain, or augment the supplied snapshot.
- Use `textContent`, attributes, classes, and CSS custom properties; never insert external strings with `innerHTML`.
- Round only for display and render a safe fallback for non-finite values.
- Keep dynamic values from changing component dimensions.
- Use native elements and meaningful visible text before adding ARIA.
- Do not announce high-frequency speed, heading, or battery updates in a live region.
- For priority warnings, announce only meaningful state transitions.
- Never rely on color alone; combine text, icon, shape, or position.
- Respect `prefers-reduced-motion` and make animation nonessential.
- Provide useful output when optional map, route, font, or icon resources are missing.

## Validation

Run checks in this order:

1. Focused component or owning-module test:

   ```powershell
   node --test test/<component-name>.test.js
   ```

2. Full deterministic suite:

   ```powershell
   npm test
   ```

3. Browser checks for the initial state, minimum/maximum values, every severity or status, and degraded state.
4. Screenshots at `360x800`, `768x1024`, and `1440x900`.
5. Keyboard, focus, `200%` zoom, reduced-motion, overlap, clipping, horizontal-scroll, and console checks.

If a focused test does not yet exist, create the smallest test that proves the public component contract before broad browser work.

## Completion Checklist

- [ ] Approved requirement and ticket are identified.
- [ ] Semantic fallback exists.
- [ ] Component consumes existing immutable data only.
- [ ] JavaScript and CSS remain component-owned.
- [ ] Initial, boundary, invalid, and degraded states are covered.
- [ ] Text/icon/state cues satisfy accessibility rules.
- [ ] Focused and full tests pass.
- [ ] Required viewport and browser evidence is recorded.
- [ ] Documentation changes only describe verified behavior.

## Output Format

Return:

- **Component contract:** root, inputs, states, output, and cleanup.
- **Files changed:** one line per file and responsibility.
- **Traceability:** ticket, `REQ-###`, and `AC-###` IDs.
- **Validation:** commands and browser checks with results.
- **Remaining risk:** skipped evidence, unresolved decision, or optional enhancement.
