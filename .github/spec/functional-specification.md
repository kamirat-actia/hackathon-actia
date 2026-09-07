# Interactive Automotive Dashboard - Functional Specification

**Status:** Proposed baseline  
**Version:** 1.0  
**Methodology stage:** SPEC  
**Audience:** Product, design, engineering, QA, and hackathon judges

## 1. Project Vision

Create an immediately understandable digital cockpit in which a user drives a simulated electric vehicle with keyboard or on-screen controls and sees every action reflected in speed, energy, warning, and navigation instruments.

The product is a browser-based simulation and demonstration. It is not intended to control, diagnose, or represent a real vehicle.

## 2. Business Objective

- Demonstrate a coherent, polished automotive experience within a hackathon time box.
- Show disciplined delivery using the `SPEC -> PLAN -> IMPLEMENT` workflow.
- Demonstrate effective GitHub Copilot customization through repository instructions, role agents, and reusable skills.
- Provide an architecture that can be extended without a framework or backend.
- Make the minimum product usable even when location permission or external map services are unavailable.

## 3. Target Users

| User | Need |
| --- | --- |
| Hackathon judge | Understand the concept and exercise every core feature within two minutes. |
| Demonstrator | Reliably present vehicle behavior using a keyboard, mouse, or touch screen. |
| Developer | Add instruments or commands without coupling simulation logic to the DOM. |
| Accessibility evaluator | Operate and understand the dashboard without relying only on color or pointer input. |

## 4. Scope

### 4.1 In Scope

- A single-page automotive cockpit.
- Simulated ignition, acceleration, braking, steering, drag, and vehicle movement.
- Speedometer, battery gauge, prioritized warning display, and GPS indicator.
- Keyboard controls and equivalent visible controls.
- Responsive desktop, tablet, and mobile presentation.
- Optional browser geolocation and optional map/routing services with deterministic fallbacks.
- Local execution through a static HTTP server.

### 4.2 Out of Scope

- Connection to a real vehicle, CAN bus, or safety-critical system.
- Authentication, user accounts, backend APIs, cloud persistence, or analytics.
- Real-world driving guidance guarantees.
- Multiplayer, traffic simulation, collision detection, or autonomous driving.
- Native mobile packaging and production telemetry.

## 5. Assumptions

1. The application is an educational simulation; values are plausible rather than homologated vehicle data.
2. The baseline starts with ignition off, speed `0 km/h`, battery `85%`, and a deterministic default location.
3. The speed range is `0-300 km/h`; overspeed begins at `130 km/h`.
4. Low and critical battery thresholds are `20%` and `8%` respectively.
5. Charging is permitted only while the vehicle is stopped and ignition is off.
6. Arrow keys and `WASD` support driving; `E` toggles ignition and `C` toggles charging.
7. On-screen controls provide functional parity for touch and pointer users.
8. Network-dependent maps and routes enhance the GPS but never block the vehicle simulation.
9. English is the baseline presentation language; localization is an extension.

## 6. User Experience

The first screen is the working cockpit, not a landing page. The dominant speed reading remains visible at a glance, while battery, active alerts, GPS status, and controls have stable positions. An input must produce visible feedback on the next rendered frame. Important states use icon, text, and color together.

The interface supports three operating widths:

- **Desktop:** integrated cockpit with simultaneous speed, energy, warning, and map visibility.
- **Tablet:** compact grid preserving the same information hierarchy.
- **Mobile:** vertically ordered instruments with controls reachable without horizontal scrolling.

## 7. Dashboard And Display Behavior

### 7.1 Speedometer

- Shows current speed numerically in `km/h` and visually on a fixed scale.
- Clamps displayed and simulated speed to the supported range.
- Responds continuously while acceleration or braking input is held.
- Returns gradually toward zero when neither acceleration nor braking is active.
- Never displays `NaN`, infinity, negative values, or values beyond the scale.

### 7.2 Battery Gauge

- Shows battery percentage and estimated remaining range.
- Decreases while an energized vehicle is operating and decreases faster under acceleration.
- Increases while charging and never exceeds `100%`.
- Stops the ignition automatically at `0%`.
- Communicates normal, low, critical, and charging states without color alone.

### 7.3 Warning Indicator

- Displays the highest-priority active alert prominently.
- Supports multiple simultaneous alerts in a deterministic order.
- Announces newly raised critical alerts through an accessible live region.
- Clears an alert automatically when its triggering condition ends.
- Uses severity order `critical > warning > info`.

### 7.4 GPS Indicator

- Always shows a valid simulated position and heading.
- Updates position only when the vehicle moves and updates heading while steering at a non-zero speed.
- May show an interactive map, route, distance, and next instruction when network services are available.
- Lets the user request browser location explicitly; it never requests location silently on initial load.
- Retains a usable coordinate/heading fallback if permission is denied, the map library fails, or routing is offline.

### 7.5 Display Integrity

- Instrument dimensions remain stable as values change.
- Text does not overlap, clip, or become unreadable at supported widths.
- Units and labels remain visible; meaning is not encoded by color alone.
- The dashboard preserves the last valid state if a presentation-only service fails.

## 8. Keyboard Shortcuts

| Key | Action | Interaction mode | Preconditions |
| --- | --- | --- | --- |
| `ArrowUp` or `W` | Accelerate | Hold | Ignition on, battery above `0%`, not charging |
| `ArrowDown` or `S` | Brake | Hold | None |
| `ArrowLeft` or `A` | Steer left | Hold | Vehicle moving |
| `ArrowRight` or `D` | Steer right | Hold | Vehicle moving |
| `E` | Toggle ignition | Press once | Starting requires battery above `0%` |
| `C` | Toggle charging | Press once | Ignition off and vehicle stopped |

Handled driving keys prevent browser scrolling only while the dashboard is active. Repeated keydown events must not retrigger press-once actions. Held inputs are cleared when the window loses focus or becomes hidden.

## 9. User Interactions

1. The user opens the local application and sees a complete, initialized dashboard.
2. The user starts the ignition with `E` or the equivalent control.
3. The user holds acceleration, braking, or steering inputs and observes continuous feedback.
4. The user releases a held input and the associated intent stops immediately.
5. The user can stop, turn off ignition, and toggle charging.
6. The user can request browser location or choose a map destination when enhanced GPS is available.
7. The user can operate every core command by keyboard and by on-screen control.

## 10. Error Handling

| Condition | Expected behavior | User communication |
| --- | --- | --- |
| Geolocation denied or unavailable | Keep the deterministic simulated location. | Non-blocking GPS status message. |
| Map library or tiles unavailable | Keep coordinates, heading, and simulation active. | Replace map area with an offline state. |
| Route service timeout or invalid response | Keep destination and show a straight-line fallback or unavailable route. | Non-blocking route status message. |
| Unsupported command | Ignore it without changing vehicle state. | No alert required. |
| Invalid state transition | Reject it and preserve the prior valid state. | Brief contextual message when useful. |
| Invalid numeric update | Clamp or reject before publishing state. | Log a development diagnostic; do not expose raw errors. |
| Unexpected startup failure | Keep static controls and explanatory fallback visible. | Human-readable error without stack traces. |

## 11. Alert Management

| Alert | Trigger | Severity | Clear condition |
| --- | --- | --- | --- |
| Battery critical | Battery at or below `8%` | Critical | Battery rises above `8%` |
| Battery low | Battery at or below `20%` and above `8%` | Warning | Battery rises above `20%` or becomes critical |
| Overspeed | Speed at or above `130 km/h` | Warning | Speed falls below `130 km/h` |
| Charging | Charging active | Info | Charging stops or ignition starts |
| Ignition off | Ignition inactive and not charging | Info | Ignition starts or charging begins |

Alert identifiers, labels, severity, and ordering form one catalog. Components consume alert data; they do not independently recreate alert rules.

## 12. Battery Management

- Battery state is a bounded percentage in the range `0-100`.
- Estimated range is derived from battery state and a documented full-charge range.
- Drain is time-based so behavior remains consistent across frame rates.
- Charging is time-based and automatically stops increasing at `100%`.
- Starting ignition cancels charging; charging cannot begin while moving or while ignition is on.
- At `0%`, acceleration is unavailable and ignition is forced off, while braking and display functions remain available.

## 13. GPS Behavior

- The default position is deterministic so demonstrations and tests are repeatable.
- Simulated movement uses elapsed time, speed, and heading rather than frame count.
- Latitude and longitude remain within valid geographic ranges.
- Browser geolocation is opt-in and validates returned coordinates before use.
- Location permission denial is recoverable and does not trigger repeated prompts.
- If routing is enabled, stale responses must not replace a newer destination request.
- Any disclosure of coordinates to a third-party routing service must be documented in the UI or project documentation.

## 14. Application States

| State | Ignition | Speed | Charging | Permitted transitions |
| --- | --- | --- | --- | --- |
| Ready | Off | `0` | Off | Start ignition; begin charging |
| Driving | On | `> 0` | Off | Accelerate; brake; steer; coast to stopped |
| Energized stopped | On | `0` | Off | Accelerate; switch ignition off |
| Coasting with ignition off | Off | `> 0` | Off | Brake; coast to ready |
| Charging | Off | `0` | On | Stop charging; reach full charge |
| Battery depleted | Off | Any residual speed trending to `0` | Off | Brake/coast; begin charging once stopped |
| Degraded GPS | Any valid vehicle state | Any | As applicable | Retry optional service; continue simulation |
| Fatal initialization error | Unavailable | Unavailable | Unavailable | Reload after corrective action |

State invariants:

- Charging and ignition cannot both be active.
- Charging and movement cannot both be active.
- Speed and battery always remain within their declared bounds.
- Every published snapshot is internally consistent and cannot be mutated by consumers.

## 15. Functional Requirements

| ID | Requirement | Verification |
| --- | --- | --- |
| REQ-001 | The application shall open directly to an initialized, usable dashboard. | Initial-load acceptance test. |
| REQ-002 | The application shall provide a speedometer with numeric value, unit, and fixed visual scale from `0-300 km/h`. | Component and browser test. |
| REQ-003 | The application shall toggle ignition through `E` and an equivalent on-screen control. | Input/state test. |
| REQ-004 | The application shall accelerate continuously while an acceleration command is held and driving is permitted. | Time-based state test. |
| REQ-005 | The application shall brake continuously while a braking command is held. | Time-based state test. |
| REQ-006 | The application shall apply drag when no longitudinal command is active. | Time-based state test. |
| REQ-007 | The application shall steer and update heading only while the vehicle is moving. | State and navigation test. |
| REQ-008 | The application shall support arrow keys and `WASD` alternatives from one command definition. | Mapping consistency test. |
| REQ-009 | The application shall clear held commands on key release, focus loss, and page visibility loss. | Controller test. |
| REQ-010 | The application shall expose on-screen controls equivalent to all keyboard commands. | Browser interaction test. |
| REQ-011 | The application shall display battery percentage and estimated range. | Component test. |
| REQ-012 | The application shall drain battery according to elapsed operating time and driving demand. | State test with controlled time. |
| REQ-013 | The application shall allow charging only while stopped with ignition off. | State transition test. |
| REQ-014 | The application shall bound battery charge to `0-100%` and disable ignition at `0%`. | Boundary test. |
| REQ-015 | The application shall raise, prioritize, display, and clear cataloged alerts from vehicle conditions. | Alert lifecycle test. |
| REQ-016 | The application shall distinguish critical, warning, and informational alerts without relying only on color. | Visual and accessibility review. |
| REQ-017 | The application shall raise low battery, critical battery, overspeed, charging, and ignition-off alerts at the specified conditions. | Threshold parameterized test. |
| REQ-018 | The application shall display valid position and heading without requiring network access. | Offline browser test. |
| REQ-019 | The application shall update simulated position from elapsed time, speed, and heading. | Navigation calculation test. |
| REQ-020 | The application shall request browser geolocation only after an explicit user action. | Permission-flow browser test. |
| REQ-021 | The application shall preserve GPS status and core simulation when geolocation, maps, tiles, or routing fail. | Failure-injection browser test. |
| REQ-022 | The application shall reject invalid transitions without corrupting the last valid state. | State invariant test. |
| REQ-023 | The application shall publish immutable state snapshots to independently rendered instruments. | Unit test. |
| REQ-024 | The application shall update affected instruments after each accepted input or simulation step. | Integration test. |
| REQ-025 | The application shall run locally from a documented static HTTP server command with no backend. | Clean-machine smoke test. |

## 16. Non-Functional Requirements

| ID | Category | Requirement | Target |
| --- | --- | --- | --- |
| REQ-026 | Performance | Accepted input shall produce visible feedback without perceptible lag. | Within `100 ms` under normal desktop conditions. |
| REQ-027 | Performance | Continuous animation shall remain smooth during normal operation. | Target `60 fps`; no sustained drop below `30 fps`. |
| REQ-028 | Reliability | Optional service failures shall not stop the core simulation. | Zero uncaught errors in defined failure tests. |
| REQ-029 | Accessibility | Core workflows shall meet WCAG 2.2 AA expectations for keyboard access, focus, names, contrast, and non-color cues. | Automated checks plus manual keyboard review. |
| REQ-030 | Responsive design | Core controls and values shall remain usable without overlap or horizontal scrolling. | Verified at `360x800`, `768x1024`, and `1440x900`. |
| REQ-031 | Compatibility | The application shall support current and previous major versions of Chrome, Edge, and Firefox. | Browser smoke matrix. |
| REQ-032 | Maintainability | Simulation, input, rendering, configuration, and external services shall remain separate modules. | Architecture review and dependency check. |
| REQ-033 | Testability | Deterministic business logic shall run without a browser or network. | Native automated unit tests. |
| REQ-034 | Privacy | Location shall be opt-in, kept in memory only, and sent externally only when required for an explicitly requested route. | Code and UX review. |
| REQ-035 | Load time | The local dashboard shall become usable promptly on a typical development machine. | Within `2 seconds` after static assets are available. |

## 17. Acceptance Criteria

| ID | Scenario | Given | When | Then | Requirements |
| --- | --- | --- | --- | --- | --- |
| AC-001 | Initial dashboard | The local server is running | The user opens the application | Speed is `0`, battery is `85%`, ignition is off, GPS has a valid fallback, and all core instruments are visible | REQ-001, REQ-002, REQ-011, REQ-018, REQ-025 |
| AC-002 | Start and accelerate | Battery is above `0%` and ignition is off | The user presses `E`, then holds acceleration | Ignition starts, charging is off, speed rises smoothly, and affected displays update within `100 ms` | REQ-003, REQ-004, REQ-024, REQ-026 |
| AC-003 | Brake and coast | The vehicle is moving | The user brakes and later releases all longitudinal controls | Speed falls under braking, continues falling under drag, and never becomes negative | REQ-005, REQ-006, REQ-022 |
| AC-004 | Steering and GPS | The vehicle is moving | The user holds left or right steering | Heading and subsequent position change consistently while coordinates remain valid | REQ-007, REQ-019 |
| AC-005 | Keyboard alternatives | The dashboard has focus | The user drives once with arrows and once with `WASD` | Equivalent actions produce equivalent state changes and press actions do not repeat from key repeat | REQ-008, REQ-009 |
| AC-006 | Touch parity | The application is used on a pointer or touch device | The user operates each visible control | Every keyboard action has an operable equivalent and no control becomes stuck | REQ-010, REQ-030 |
| AC-007 | Battery lifecycle | Ignition is on | Simulated time advances under idle and acceleration | Battery drains by elapsed time, range follows charge, and battery remains bounded | REQ-011, REQ-012, REQ-014 |
| AC-008 | Charging guard | The vehicle is moving or ignition is on | The user requests charging | Charging is rejected and state remains valid; once stopped with ignition off, charging can begin | REQ-013, REQ-022 |
| AC-009 | Alert lifecycle | Vehicle values cross each configured threshold | State updates occur | The correct alert is raised, ordered by severity, displayed with text/icon/color, and cleared after recovery | REQ-015, REQ-016, REQ-017 |
| AC-010 | GPS permission denied | Default GPS is visible | The user requests location and denies permission | The fallback position remains usable, a non-blocking status appears, and driving continues | REQ-020, REQ-021, REQ-028, REQ-034 |
| AC-011 | Services offline | The browser has no network after local assets load | The user drives and attempts routing | Speed, battery, warnings, coordinates, and controls continue; the map or route shows a fallback | REQ-018, REQ-021, REQ-028 |
| AC-012 | Accessibility and responsive use | The app is tested at target widths with keyboard and assistive tooling | The evaluator completes the core flow | Focus is visible, controls are named, critical changes are announced, and content does not overlap or scroll horizontally | REQ-029, REQ-030, REQ-031 |
| AC-013 | State isolation | A component receives a vehicle snapshot | It attempts mutation or another component renders it | The source state is unchanged and each component receives consistent values | REQ-023, REQ-032, REQ-033 |
| AC-014 | Local startup | Dependencies are available and no backend is running | The documented start command is executed | The dashboard is usable within `2 seconds` and all local modules load successfully | REQ-025, REQ-031, REQ-035 |

## 18. Success Criteria

- All 35 requirements map to at least one planned ticket and validation method.
- All P1 acceptance scenarios pass in a clean local run.
- A first-time user can start, accelerate, brake, identify battery state, read an alert, and identify GPS state within two minutes without instruction from the demonstrator.
- The four required instruments remain useful with network access disabled.
- No tested input sequence produces an invalid application state or uncaught runtime error.
- Accessibility review finds no blocker in the core driving workflow.

## 19. Risks

| Risk | Impact | Mitigation |
| --- | --- | --- |
| Hackathon scope expands into nonessential map or visual effects | Core flow remains unfinished | Lock P1 scope and enforce ticket sequence. |
| Public maps or routing fail during judging | GPS appears broken | Ship deterministic coordinate and route fallbacks; rehearse offline. |
| Frame-rate-dependent simulation produces inconsistent results | Demo and tests become unreliable | Base all calculations on bounded elapsed time. |
| Keyboard focus or stuck inputs create unsafe-looking behavior | Vehicle continues accelerating | Clear inputs on release, blur, and visibility change. |
| Visual styling reduces readability | Dashboard looks polished but is unusable | Validate contrast, stable sizing, and target viewports early. |
| Copilot generates duplicated state or hard-coded controls | Architecture drifts | Enforce AGENTS.md, scoped instructions, and focused review agents. |

## 20. Definition Of Spec Complete

- Scope, assumptions, states, errors, and external dependencies are explicit.
- Every requirement is unique, testable, and represented by an acceptance scenario or verification method.
- Product behavior is defined independently from specific UI implementation details.
- The specification is ready to drive technical design and planning without unresolved blocking questions.