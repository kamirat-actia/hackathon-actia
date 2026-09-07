# Interactive Automotive Dashboard - Contributor Guide

## Business Context

This repository delivers a hackathon demonstration of an interactive electric-vehicle cockpit. A user controls a simulated vehicle and immediately sees speed, battery, warnings, and GPS react. It is an educational simulation, not a real vehicle interface or safety system.

Use `SPEC -> PLAN -> IMPLEMENT`:

1. Read the relevant requirement and acceptance criteria in `.github/spec/functional-specification.md`.
2. Confirm the architecture and owning module in `.github/spec/technical-specification.md`.
3. Select the next unblocked ticket in `.github/spec/backlog.md` and follow `.github/spec/implementation-plan.md`.
4. Implement one small behavior, run its narrowest validation, then continue.

## Technical Stack

- Semantic HTML5 in `index.html`.
- Modular CSS with design tokens in `src/css/`.
- Native JavaScript ES modules in `src/js/`.
- Native Node test runner through `npm test`.
- Static local HTTP serving through `npm start`.
- No backend, application framework, bundler, or runtime secret.
- Leaflet, OpenStreetMap-compatible tiles, OSRM, and Lucide are allowed only at documented adapter boundaries with graceful fallbacks.

## Communication Rules

- Keep answers concise and identify assumptions.
- Before a major modification, explain the architectural decision, affected `REQ-###` IDs, trade-offs, and validation plan.
- For a small change, state the owning module and focused validation before editing.
- Report commands run and any validation that could not be completed.
- Do not claim a requirement or ticket is complete without evidence.

## Folder Organization

| Path | Ownership |
| --- | --- |
| `index.html` | Semantic shell and static fallback content only. |
| `src/css/base/` | Tokens, reset, and typography. |
| `src/css/layout/` | Page and responsive layout. |
| `src/css/components/` | Styles owned by one instrument or control. |
| `src/js/config/` | Frozen constants, events, warnings, views, and command bindings. |
| `src/js/core/` | Vehicle state, simulation timing, and event distribution. |
| `src/js/input/` | Keyboard, pointer, and touch intent translation. |
| `src/js/components/` | Passive snapshot-to-DOM renderers. |
| `src/js/services/` | Browser and network adapters with normalized failures. |
| `src/js/ui/` | UI-only preferences and view state. |
| `src/js/utils/` | Small pure helpers with no domain ownership. |
| `test/` | Deterministic tests organized by owning module. |
| `.github/spec/` | Canonical specification, architecture, plan, and backlog. |
| `.github/instructions/` | File-scoped Copilot implementation rules. |
| `.github/agents/` | Focused role agents. |
| `.github/skills/` | Repeatable project workflows. |

Do not create alternate source roots, a generic `helpers` dumping ground, or a second state store.

## Architecture And Project Patterns

- `VehicleState` is the only owner of mutable vehicle data.
- Components receive immutable snapshots and never mutate domain state.
- Flow is unidirectional: input/service command -> state -> event -> component render.
- The simulation is elapsed-time based and clamps long frame deltas.
- Commands, key bindings, warnings, event names, limits, and thresholds have one configuration source.
- `HOLD` commands remain active until release/cancel; `PRESS` commands fire once and ignore key repeat.
- Optional maps, geolocation, routing, icons, and fonts must never block the core simulation.
- Services validate third-party data and return normalized outcomes.
- Renderers own one DOM subtree and update text, attributes, classes, and CSS properties without replacing the page.
- Use an existing concrete module or contract before adding an abstraction.

## Coding Conventions

### JavaScript

- Use ES modules, named exports, `const` by default, double quotes, and trailing commas.
- Use descriptive names and small focused functions; avoid one-letter identifiers.
- Keep pure calculations separate from browser APIs and DOM effects.
- Add JSDoc to public contracts or non-obvious data shapes, not to self-explanatory lines.
- Validate external input at boundaries and preserve the last valid state on recoverable failure.
- Do not duplicate numeric values from `src/js/config/constants.js` or command data from `keymap.js`.
- Do not add a dependency when the web platform provides a clear small solution.

### HTML And CSS

- Prefer native elements and semantic landmarks; do not simulate buttons with generic elements.
- Use `data-*` hooks for JavaScript and classes for styling.
- Keep component styles in their component file and shared values in CSS custom properties.
- Use mobile-first responsive constraints and stable dimensions for gauges, values, and controls.
- Avoid inline styles/scripts, `!important`, layout-changing hover effects, negative letter spacing, and viewport-scaled font sizes.
- Use familiar icons with accessible names; do not rely on color alone.

### Tests

- Name tests after observable behavior and use Arrange, Act, Assert.
- Use fake time, scheduling, DOM boundaries, and services; never call public network services in tests.
- Test public contracts, boundaries, invalid transitions, cleanup, and failure modes.
- Add the smallest relevant test with every behavior change.

## Design Principles

- Show the working cockpit as the first screen; do not add a marketing landing page.
- Keep speed visually dominant and battery, warning, GPS, and controls continuously discoverable.
- Use a restrained operational aesthetic with clear information hierarchy, not decorative cards or effects.
- Do not nest cards, add ornamental blobs, or use gradients as a substitute for meaningful vehicle imagery or instrumentation.
- Keep cards at `8px` radius or less unless an established component requires otherwise.
- Ensure all dynamic text fits at mobile, tablet, desktop, and `200%` zoom.
- Use a few meaningful state transitions and respect `prefers-reduced-motion`.
- Preserve a useful textual fallback for every visual gauge or map.

## Performance Requirements

- Target visible input feedback within `100 ms`.
- Target `60 fps` with no sustained normal-operation period below `30 fps`.
- Keep local startup under `2 seconds` on the reference development machine.
- Avoid DOM subtree recreation and layout-read/layout-write thrashing in animation frames.
- Bound simulation delta to `100 ms` and abort superseded route requests.
- Measure before adding caching or scheduling abstractions.

## Accessibility Requirements

- Meet WCAG 2.2 AA expectations for the core workflow.
- Support the complete workflow by keyboard and on-screen controls.
- Provide visible focus, programmatic names, native control semantics, and `44x44 CSS px` touch targets.
- Use text/icon/color together for status and severity.
- Announce priority warning changes without announcing high-frequency speed updates.
- Verify target viewports, `200%` zoom, reduced motion, and both supported themes.

## Change Discipline

- Prefer reusable code when it removes real duplication; avoid speculative frameworks and generic factories.
- Generate code in small incremental changes and validate immediately after each meaningful edit.
- Keep edits inside the ticket's owning modules and do not perform unrelated refactors.
- Preserve public contracts unless the requirement explicitly changes them.
- Update specification, plan, backlog, tests, and operator documentation when their facts change.
- Never mark P3 polish complete while a P1 acceptance criterion is failing.

## Required Validation

Run the narrowest applicable command first, then broaden at ticket completion:

```powershell
node --test test/<focused-file>.test.js
npm test
npm start
```

For UI work, also inspect browser console output, keyboard operation, service fallbacks, and screenshots at `360x800`, `768x1024`, and `1440x900`.
