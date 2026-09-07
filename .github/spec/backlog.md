# Interactive Automotive Dashboard - Technical Backlog

**Status:** Ready for implementation  
**Ordering:** Dependency-first execution sequence  
**Related plan:** [Implementation plan](./implementation-plan.md)

## Priority And Complexity

| Value | Meaning |
| --- | --- |
| P1 | Required for the hackathon MVP and final acceptance. |
| P2 | Important enhancement or hardening after the offline MVP works. |
| P3 | Optional polish; never blocks P1 or P2. |
| XS | Up to 2 hours; one narrow file or configuration change. |
| S | Up to half a day; small behavior with focused tests. |
| M | About one day; coordinated component or domain behavior. |
| L | Up to two days; multi-file behavior or broad validation. |

Estimates are relative planning aids for one contributor familiar with the repository, not commitments.

## Ordered Tickets

### T001 - Establish Local Project Baseline

- **Priority:** P1
- **Complexity:** S
- **Dependencies:** None
- **Requirements:** REQ-025, REQ-032, REQ-033, REQ-035
- **Description:** Confirm the recommended folders, ES module setup, `npm start`, and `npm test` in `package.json`; add the smallest smoke test needed to prove the native test runner.
- **Acceptance criteria:**
  - The app is served over local HTTP without a backend or build step.
  - `npm test` succeeds from a clean install with no test framework dependency.
  - Runtime, test, documentation, and `.github/` concerns occupy the documented folders.
  - No secret or machine-specific path is required.

### T002 - Create Semantic Dashboard Shell

- **Priority:** P1
- **Complexity:** M
- **Dependencies:** T001
- **Requirements:** REQ-001, REQ-002, REQ-029
- **Description:** Build `index.html` with landmarks and named regions for speed, battery, energy, alerts, GPS, and controls, including useful static fallback values.
- **Acceptance criteria:**
  - The first screen is the cockpit and contains all four required instruments.
  - Heading order, landmarks, labels, and native buttons are valid.
  - Static content remains understandable before JavaScript runs.
  - JavaScript hooks use `data-*` attributes rather than cosmetic classes.

### T003 - Define Design Tokens And Base Styles

- **Priority:** P1
- **Complexity:** M
- **Dependencies:** T001
- **Requirements:** REQ-016, REQ-029, REQ-030
- **Description:** Implement tokens and base rules in `src/css/base/variables.css`, `reset.css`, and `typography.css`, then register cascade order in `src/css/main.css`.
- **Acceptance criteria:**
  - Repeated colors, spacing, typography, motion, and instrument dimensions use tokens.
  - Numeric values use stable-width typography without viewport-scaled font sizes.
  - Focus, reduced-motion, and high-contrast-safe defaults exist.
  - No component-specific layout is placed in base files.

### T004 - Build Responsive Cockpit Layout

- **Priority:** P1
- **Complexity:** M
- **Dependencies:** T002, T003
- **Requirements:** REQ-030
- **Description:** Implement cockpit regions and responsive constraints in `src/css/layout/dashboard.css` for mobile, tablet, and desktop.
- **Acceptance criteria:**
  - Core content has no overlap or horizontal page scroll at all target viewports.
  - Speed remains visually dominant while battery, alerts, GPS, and controls stay discoverable.
  - Fixed-format instruments have stable dimensions or aspect ratios.
  - The mobile workflow is operable without hover.

### T005 - Implement Event Bus

- **Priority:** P1
- **Complexity:** S
- **Dependencies:** T001
- **Requirements:** REQ-023, REQ-024, REQ-032
- **Description:** Implement `src/js/core/event-bus.js` with synchronous `on`, `emit`, and unsubscribe behavior; cover it in `test/event-bus.test.js`.
- **Acceptance criteria:**
  - Subscribed listeners receive the published payload once in registration order.
  - The returned unsubscribe function is idempotent.
  - Listener removal during publish does not skip unrelated listeners.
  - Unknown events do not throw.

### T006 - Centralize Simulation And Warning Configuration

- **Priority:** P1
- **Complexity:** S
- **Dependencies:** T001
- **Requirements:** REQ-002, REQ-014, REQ-017, REQ-032
- **Description:** Define frozen speed, battery, navigation, simulation, event, and warning catalogs in `src/js/config/constants.js`.
- **Acceptance criteria:**
  - Limits and thresholds match the functional specification.
  - Warning IDs, labels, severities, and priority are defined once.
  - Exported configuration cannot be mutated by consumers.
  - No runtime component duplicates physical constants.

### T007 - Implement Vehicle State And Guarded Commands

- **Priority:** P1
- **Complexity:** M
- **Dependencies:** T005, T006
- **Requirements:** REQ-003, REQ-013, REQ-014, REQ-022, REQ-023, REQ-032, REQ-033
- **Description:** Implement initial state, snapshots, ignition, charging, and validated position commands in `src/js/core/vehicle-state.js`; add focused tests in `test/vehicle-state.test.js`.
- **Acceptance criteria:**
  - Initial state matches AC-001.
  - Charging is rejected while ignition is on or speed exceeds the stop threshold.
  - Ignition cannot start with empty battery and cancels charging when started.
  - Invalid coordinates and transitions preserve the last valid state.
  - Snapshots and nested position/warning values are immutable copies.

### T008 - Implement Time-Based Vehicle Motion

- **Priority:** P1
- **Complexity:** L
- **Dependencies:** T007
- **Requirements:** REQ-004, REQ-005, REQ-006, REQ-007, REQ-019, REQ-022, REQ-033
- **Description:** Add acceleration, braking, drag, steering response, distance, heading, position, and odometer updates to `src/js/core/vehicle-state.js`; place pure geographic math in `src/js/utils/math.js`.
- **Acceptance criteria:**
  - Equivalent elapsed time produces equivalent results across frame step sizes within documented tolerance.
  - Braking takes precedence over acceleration and speed stays in range.
  - Steering changes heading only while moving.
  - Coordinates and heading remain valid after movement.
  - Tests cover zero, normal, maximum, and oversized deltas.

### T009 - Implement Battery Simulation

- **Priority:** P1
- **Complexity:** M
- **Dependencies:** T007, T008
- **Requirements:** REQ-011, REQ-012, REQ-013, REQ-014, REQ-033
- **Description:** Add time-based idle/drive/acceleration drain, range calculation, charging, full-charge clamping, and depletion shutdown in `src/js/core/vehicle-state.js`.
- **Acceptance criteria:**
  - Battery drains only under specified operating conditions and faster under acceleration.
  - Range follows battery percentage and never becomes negative.
  - Charging increases charge only in the valid charging state and stops at `100%`.
  - Empty battery forces ignition off and prevents acceleration.
  - Tests use controlled elapsed time rather than real timers.

### T010 - Implement Alert Derivation And Lifecycle

- **Priority:** P1
- **Complexity:** M
- **Dependencies:** T006, T007, T009
- **Requirements:** REQ-015, REQ-017, REQ-032, REQ-033
- **Description:** Derive the ordered active warning set in `src/js/core/vehicle-state.js` and publish raised/cleared events only on transitions.
- **Acceptance criteria:**
  - Low, critical, overspeed, charging, and ignition-off rules match their thresholds.
  - Critical battery replaces low battery rather than duplicating it.
  - Active warnings are in deterministic severity order.
  - Raised and cleared events occur once per boundary crossing.
  - Parameterized tests cover both sides of every threshold.

### T011 - Implement Bounded Simulation Loop

- **Priority:** P1
- **Complexity:** S
- **Dependencies:** T001
- **Requirements:** REQ-027, REQ-033
- **Description:** Implement start, frame calculation, delta clamping, callback invocation, and stop in `src/js/core/simulation-loop.js` with injected scheduling for tests.
- **Acceptance criteria:**
  - Starting twice does not create duplicate loops.
  - The first frame establishes time without a physics jump.
  - Long pauses are clamped to the configured maximum delta.
  - Stop cancels the scheduled frame and is idempotent.

### T012 - Define Keyboard Command Catalog

- **Priority:** P1
- **Complexity:** S
- **Dependencies:** T006
- **Requirements:** REQ-003, REQ-008, REQ-010, REQ-032
- **Description:** Define immutable actions and key bindings with `codes`, display label, accessible label, and `HOLD` or `PRESS` mode in `src/js/config/keymap.js`.
- **Acceptance criteria:**
  - Arrow keys, `WASD`, `E`, and `C` match the approved command matrix.
  - No key code maps ambiguously to multiple actions.
  - Every action has a visible and accessible label.
  - Consumers can build an efficient lookup without redefining data.

### T013 - Implement Keyboard Controller

- **Priority:** P1
- **Complexity:** M
- **Dependencies:** T007, T012
- **Requirements:** REQ-003, REQ-004, REQ-005, REQ-008, REQ-009, REQ-022, REQ-026, REQ-029
- **Description:** Implement hold/press handling, intent snapshots, command dispatch, key-repeat suppression, default prevention, and cleanup in `src/js/input/keyboard-controller.js`; test in `test/keyboard-controller.test.js`.
- **Acceptance criteria:**
  - Hold actions remain active only between down and release/cancel events.
  - Press actions execute once and ignore repeated keydown events.
  - Blur and visibility loss clear every held action.
  - Unrecognized keys are ignored and retain browser defaults.
  - The controller can be destroyed without leaving listeners.

### T014 - Generate On-Screen Controls And Legend

- **Priority:** P1
- **Complexity:** M
- **Dependencies:** T002, T003, T012, T013
- **Requirements:** REQ-003, REQ-008, REQ-010, REQ-029, REQ-030
- **Description:** Generate command labels and equivalent pointer/touch buttons in `src/js/components/controls-legend.js` with styles in `src/css/components/controls-legend.css`.
- **Acceptance criteria:**
  - Every command in the catalog appears once with its approved label.
  - Pointer down/up/cancel/lost-capture match keyboard hold and press semantics.
  - Buttons expose names, pressed state where relevant, visible focus, and `44x44` minimum touch targets.
  - Keyboard and pointer input can coexist without a stuck action.

### T015 - Implement Speedometer

- **Priority:** P1
- **Complexity:** M
- **Dependencies:** T002-T004, T006
- **Requirements:** REQ-002, REQ-024, REQ-026, REQ-029, REQ-030
- **Description:** Implement snapshot-driven speed rendering in `src/js/components/speedometer.js` and component styling in `src/css/components/speedometer.css`.
- **Acceptance criteria:**
  - Numeric speed, `km/h`, and a fixed `0-300` visual scale are visible.
  - The visual indicator is clamped and uses a CSS custom property or transform without rebuilding markup.
  - Non-finite input renders a safe fallback and never leaks `NaN`.
  - Value changes do not resize or shift surrounding layout.
  - The textual speed is available to assistive technology without excessive live announcements.

### T016 - Implement Battery Gauge And Energy Monitor

- **Priority:** P1
- **Complexity:** M
- **Dependencies:** T002-T004, T006, T009
- **Requirements:** REQ-011, REQ-014, REQ-016, REQ-024, REQ-029, REQ-030
- **Description:** Render charge, range, status, consumption, and odometer in `src/js/components/battery-gauge.js` and `energy-monitor.js` with their component styles.
- **Acceptance criteria:**
  - Percentage and range are always visible and consistently formatted.
  - Normal, low, critical, and charging states include text/icon cues in addition to color.
  - Gauge fill is clamped to `0-100%`.
  - Secondary metrics never displace the primary charge reading.
  - Component tests cover threshold-side presentation states.

### T017 - Implement Warning Panel

- **Priority:** P1
- **Complexity:** M
- **Dependencies:** T002-T004, T006, T010
- **Requirements:** REQ-015, REQ-016, REQ-017, REQ-024, REQ-029, REQ-030
- **Description:** Resolve, sort, and render warning IDs in `src/js/components/warning-panel.js` with severity styles in `src/css/components/warning-panel.css`.
- **Acceptance criteria:**
  - The highest-severity active alert is visually prominent and all active alerts remain inspectable.
  - Unknown warning IDs degrade to a safe generic label without throwing.
  - Severity uses label/icon/color and passes contrast checks.
  - Newly raised priority changes are announced once through a polite live region.
  - Clearing the final warning produces a stable non-alarming state.

### T018 - Implement Offline-Safe GPS Indicator

- **Priority:** P1
- **Complexity:** M
- **Dependencies:** T002-T004, T008
- **Requirements:** REQ-007, REQ-018, REQ-019, REQ-021, REQ-028, REQ-030
- **Description:** Implement coordinate, heading, movement trail, and offline status rendering in `src/js/components/gps-panel.js` and `src/css/components/gps-panel.css` without requiring external libraries.
- **Acceptance criteria:**
  - A valid default position and heading appear with the network disabled.
  - Displayed position follows simulated movement.
  - The GPS region has a clear offline/enhancement-unavailable state.
  - Missing map globals do not throw or disable other instruments.
  - Coordinates are formatted consistently and remain in valid ranges.

### T019 - Implement Opt-In Geolocation Adapter

- **Priority:** P2
- **Complexity:** M
- **Dependencies:** T007, T018
- **Requirements:** REQ-020, REQ-021, REQ-028, REQ-034
- **Description:** Wrap browser geolocation in `src/js/services/geolocation-service.js` and connect it to an explicitly activated GPS control.
- **Acceptance criteria:**
  - No permission request occurs during startup.
  - Success coordinates are validated before updating vehicle state.
  - Denied, unavailable, timeout, and invalid responses map to user-readable non-blocking statuses.
  - Repeated denial does not create an automatic permission loop.
  - Location remains in memory only.

### T020 - Add Progressive Leaflet Map

- **Priority:** P2
- **Complexity:** L
- **Dependencies:** T018
- **Requirements:** REQ-018, REQ-021, REQ-028, REQ-030, REQ-031
- **Description:** Integrate a pinned Leaflet version and attributed OpenStreetMap-compatible tiles inside `src/js/components/gps-panel.js`, preserving the existing non-map render path.
- **Acceptance criteria:**
  - The map initializes only when its container and library are available.
  - Vehicle marker and heading follow valid snapshots without recentering unexpectedly.
  - Tile failure leaves coordinates and controls usable.
  - Attribution is visible and external versions are pinned.
  - Map controls remain usable at target viewports and zoom levels.

### T021 - Implement Route Service And Destination Flow

- **Priority:** P2
- **Complexity:** L
- **Dependencies:** T018, T020
- **Requirements:** REQ-021, REQ-028, REQ-034
- **Description:** Implement abortable OSRM lookup and validation in `src/js/services/route-service.js`, then add destination selection and fallback route summary to `gps-panel.js`.
- **Acceptance criteria:**
  - A destination request displays route distance and next instruction when valid.
  - A new request aborts or supersedes the prior request.
  - Timeout, HTTP error, and malformed response use a straight-line or unavailable fallback.
  - Raw service errors and markup are never injected into the DOM.
  - Documentation discloses when coordinates are sent to the route provider.

### T022 - Compose Application And Initial Render

- **Priority:** P1
- **Complexity:** M
- **Dependencies:** T005-T018 excluding optional T019-T021
- **Requirements:** REQ-001, REQ-024, REQ-026, REQ-028, REQ-032, REQ-035
- **Description:** Instantiate configuration, state, input, loop, components, and optional services in `src/js/main.js`; render the initial snapshot and register cleanup.
- **Acceptance criteria:**
  - The initial snapshot renders before animation starts.
  - One accepted state update reaches every subscribed instrument exactly once.
  - Optional GPS integrations are isolated so their failure does not block startup.
  - Page cleanup stops the loop and removes global listeners.
  - Startup emits no uncaught console error.

### T023 - Complete Responsive And Accessibility Pass

- **Priority:** P1
- **Complexity:** L
- **Dependencies:** T014-T018, T022
- **Requirements:** REQ-016, REQ-029, REQ-030
- **Description:** Audit and correct `index.html` and `src/css/**` for focus, names, semantics, contrast, zoom, reduced motion, touch targets, and target viewport integrity.
- **Acceptance criteria:**
  - All core actions are reachable and understandable by keyboard alone.
  - Automated accessibility checks have no critical core-flow findings.
  - Severity and status remain understandable without color.
  - At `200%` zoom and target viewports, controls and text do not overlap or clip.
  - Reduced-motion mode removes nonessential animation without hiding state change.

### T024 - Complete Deterministic Unit And Integration Tests

- **Priority:** P1
- **Complexity:** L
- **Dependencies:** T005-T018, T022
- **Requirements:** REQ-022, REQ-023, REQ-024, REQ-032, REQ-033
- **Description:** Complete native Node coverage under `test/` for event flow, vehicle boundaries, keyboard lifecycle, loop timing, navigation math, and component contracts using fakes where needed.
- **Acceptance criteria:**
  - `npm test` runs without a browser or network.
  - Every state invariant and warning boundary has a failing-before/passing-after test.
  - Time, animation scheduling, DOM boundaries, and services are injected or faked deterministically.
  - Tests assert observable contracts rather than private fields.
  - The suite leaves no global listeners or timers active.

### T025 - Execute Browser Acceptance And Failure Matrix

- **Priority:** P1
- **Complexity:** L
- **Dependencies:** T019-T024; T020-T021 may be marked not implemented if P2 is intentionally deferred
- **Requirements:** REQ-010, REQ-020, REQ-021, REQ-026, REQ-028, REQ-029, REQ-030, REQ-031
- **Description:** Execute AC-001 through AC-014 in a real browser, capture target-viewport evidence, and inject geolocation, map, tile, and route failures.
- **Acceptance criteria:**
  - Every P1 acceptance scenario has pass/fail evidence and no uncaught console errors.
  - Keyboard and on-screen control flows both complete without stuck state.
  - Offline and denied-permission runs retain all minimum features.
  - Screenshots show no overlap, clipping, or horizontal scrolling at target sizes.
  - Deferred P2 behavior is clearly separated from failed P1 behavior.

### T026 - Validate Performance And Browser Compatibility

- **Priority:** P2
- **Complexity:** M
- **Dependencies:** T022-T025
- **Requirements:** REQ-026, REQ-027, REQ-031, REQ-035
- **Description:** Measure startup, input response, animation frame pacing, and smoke behavior in the supported Chrome, Edge, and Firefox versions; correct regressions in owning modules.
- **Acceptance criteria:**
  - Local startup is usable within `2 seconds` on the reference machine.
  - Accepted input is visibly reflected within `100 ms`.
  - Normal operation targets `60 fps` with no sustained period below `30 fps`.
  - Current and prior major supported browsers complete the P1 smoke flow.
  - Results and environment details are recorded for the final presentation.

### T027 - Add Optional Theme And View Polish

- **Priority:** P3
- **Complexity:** M
- **Dependencies:** All P1 tickets through T025
- **Requirements:** REQ-029, REQ-030, REQ-032
- **Description:** Implement non-blocking theme and exclusive cockpit-view behavior in `src/js/ui/theme-controller.js`, `cockpit-view-controller.js`, and `src/js/config/view-modes.js` only if the MVP is accepted.
- **Acceptance criteria:**
  - Theme preference is validated, persisted, and reflected in accessible control text.
  - Each theme passes contrast and state-distinction checks.
  - Exactly one registered cockpit view is exposed at a time.
  - Changing views never pauses or resets vehicle simulation.
  - Omitting this ticket leaves no broken or unreachable P1 control.

### T028 - Reconcile Project Documentation

- **Priority:** P1
- **Complexity:** S
- **Dependencies:** T025; T026-T027 when implemented
- **Requirements:** REQ-025, REQ-034
- **Description:** Update `README.md`, `docs/project-setup.md`, and `.github/spec/*.md` to match verified startup, commands, architecture, dependencies, fallbacks, privacy behavior, and deferred scope.
- **Acceptance criteria:**
  - A new contributor can start and test the app from README instructions alone.
  - Controls and thresholds match configuration and generated UI.
  - External services, attribution, location disclosure, and fallbacks are accurate.
  - No document presents a deferred feature as complete.

### T029 - Run Final Demo Readiness Gate

- **Priority:** P1
- **Complexity:** S
- **Dependencies:** T028 and all accepted MVP tickets
- **Requirements:** REQ-001 through REQ-035
- **Description:** Run the clean-start, complete test, browser smoke, accessibility, responsive, offline, and two-minute demo checks; record final status and residual risks.
- **Acceptance criteria:**
  - All P1 tests and acceptance scenarios pass from a clean local checkout.
  - The prepared demo covers ignition, acceleration, braking, battery, alerts, steering/GPS, and offline resilience within two minutes.
  - Known P2/P3 omissions are explicit and do not break the MVP.
  - Requirement traceability has no uncovered ID.
  - The final presentation names assumptions, decisions, evidence, and residual risks.

## Requirement Coverage Index

| Requirement | Tickets |
| --- | --- |
| REQ-001 | T002, T022, T029 |
| REQ-002 | T002, T006, T015, T029 |
| REQ-003 | T007, T012-T014, T029 |
| REQ-004 | T008, T013, T029 |
| REQ-005 | T008, T013, T029 |
| REQ-006 | T008, T029 |
| REQ-007 | T008, T018, T029 |
| REQ-008 | T012-T014, T029 |
| REQ-009 | T013, T029 |
| REQ-010 | T012, T014, T025, T029 |
| REQ-011 | T009, T016, T029 |
| REQ-012 | T009, T029 |
| REQ-013 | T007, T009, T029 |
| REQ-014 | T006, T007, T009, T016, T029 |
| REQ-015 | T010, T017, T029 |
| REQ-016 | T003, T016, T017, T023, T029 |
| REQ-017 | T006, T010, T017, T029 |
| REQ-018 | T018, T020, T029 |
| REQ-019 | T008, T018, T029 |
| REQ-020 | T019, T025, T029 |
| REQ-021 | T018-T021, T025, T029 |
| REQ-022 | T007, T008, T013, T024, T029 |
| REQ-023 | T005, T007, T024, T029 |
| REQ-024 | T005, T015-T017, T022, T024, T029 |
| REQ-025 | T001, T028, T029 |
| REQ-026 | T013, T015, T022, T025, T026, T029 |
| REQ-027 | T011, T026, T029 |
| REQ-028 | T018-T022, T025, T029 |
| REQ-029 | T002, T003, T013-T017, T023, T025, T027, T029 |
| REQ-030 | T003, T004, T014-T018, T020, T023, T025, T027, T029 |
| REQ-031 | T020, T025, T026, T029 |
| REQ-032 | T001, T005-T010, T012, T022, T024, T027, T029 |
| REQ-033 | T001, T007-T011, T024, T029 |
| REQ-034 | T019, T021, T028, T029 |
| REQ-035 | T001, T022, T026, T029 |

## Backlog Operating Rules

- Work in ticket order unless every listed dependency for a later ticket is complete.
- Keep each pull request focused on one ticket or one tightly coupled pair.
- Add or update the narrowest executable test with behavior changes.
- Record requirement IDs in the change description and test evidence.
- Do not start P3 work while any P1 acceptance criterion is failing.
- Split a ticket before implementation if it grows beyond its stated complexity or ownership boundary.