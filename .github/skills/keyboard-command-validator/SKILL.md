---
name: keyboard-command-validator
description: "Add, change, audit, or validate keyboard and on-screen vehicle commands from the central key map. Use for shortcuts, key bindings, HOLD/PRESS behavior, repeat suppression, stuck-key cleanup, pointer parity, command legends, conflicts, or command documentation."
argument-hint: "Command or key mapping to add, change, or audit"
user-invocable: true
disable-model-invocation: false
---
# Keyboard Command Validator

## Purpose

Keep the command catalog, keyboard controller, on-screen controls, visible legend, tests, and documentation synchronized from one source of truth.

## Trigger Conditions

Use this skill when asked to:

- add, remove, remap, or review a keyboard shortcut;
- implement acceleration, braking, steering, ignition, charging, or another command;
- diagnose repeated toggles, stuck keys, browser scrolling, or pointer cancellation;
- verify `WASD` and arrow-key parity;
- validate command conflicts or documentation drift;
- generate on-screen controls from keyboard metadata.

Do not use it to change the physical effect of a command. Vehicle behavior belongs to `VehicleState` and must have its own requirement and state tests.

## Folder Structure

```text
.github/skills/keyboard-command-validator/
`-- SKILL.md
```

Likely target files:

```text
src/js/config/keymap.js
src/js/input/keyboard-controller.js
src/js/components/controls-legend.js
src/css/components/controls-legend.css
test/keyboard-controller.test.js
README.md
.github/spec/functional-specification.md
```

## Binding Contract

Each command binding must contain:

| Field | Meaning | Rule |
| --- | --- | --- |
| `action` | Stable domain-facing action ID | Unique and written in uppercase snake case |
| `codes` | Accepted `KeyboardEvent.code` values | At least one; no collision with another action |
| `display` | Compact visible key label | Understandable in the controls legend |
| `label` | Human-readable action name | Suitable for button accessible name |
| `mode` | `HOLD` or `PRESS` | Matches continuous or one-shot behavior |

- `HOLD` starts on down and ends on up, blur, visibility loss, pointer cancel, lost capture, or teardown.
- `PRESS` executes once on the down transition and ignores native key repeat.

## Required Inputs

- Approved action and user outcome.
- Requested key codes and alternatives.
- `HOLD` or `PRESS` semantics.
- State preconditions and invalid-transition behavior.
- On-screen control label and expected accessibility state.
- Mapped requirement, acceptance criterion, and ticket.

If two requested actions need the same code or the interaction mode is ambiguous, stop and report the conflict with alternatives.

## Procedure

### 1. Inventory Current Commands

1. Read `src/js/config/keymap.js` and list every action, code, label, and mode.
2. Search for hard-coded `KeyboardEvent` codes outside the catalog.
3. Trace catalog consumers in the keyboard controller, control legend, tests, and documentation.
4. Compare the implementation with the functional shortcut table.

Report duplicate codes, missing labels, unconsumed actions, undocumented bindings, and hard-coded drift before editing.

### 2. Validate The Proposed Command

Confirm:

- the action is required and belongs to the current scope;
- every key uses `KeyboardEvent.code`, not locale-dependent `key` text;
- no code collision exists;
- mode matches the user's mental model;
- domain preconditions are enforced by `VehicleState`, not only by the controller;
- an equivalent native on-screen button can represent the action;
- focus and browser-default behavior remain appropriate.

### 3. Implement From The Catalog Outward

1. Add or update the action and binding in `src/js/config/keymap.js`.
2. Update generic controller logic only when the binding schema or lifecycle requires it.
3. Keep command dispatch explicit; do not embed vehicle calculations in the controller.
4. Generate or update the visible legend and on-screen button from the same binding.
5. Add CSS only for genuine new interaction states, not for each key.
6. Reconcile the shortcut table and operator documentation.

After the first substantive edit, run the focused keyboard test before making further changes.

## Required Test Matrix

For each affected binding, cover:

| Case | Expected result |
| --- | --- |
| Recognized key down | Correct action becomes active or fires once |
| Alternative code | Produces equivalent action |
| Native key repeat | Ignored for `PRESS`; harmless for `HOLD` |
| Key up | Clears only the corresponding `HOLD` action |
| Simultaneous compatible holds | Both intents remain represented |
| Opposing holds | Domain/controller rule is deterministic and documented |
| Window blur | Clears all held actions |
| Visibility hidden | Clears all held actions |
| Pointer up/cancel/lost capture | Clears the on-screen hold |
| Unrecognized key | No state change and no default prevention |
| Controller destruction | Removes listeners and clears intent |
| Invalid domain precondition | Command is rejected without state corruption |

## Validation Commands

```powershell
node --test test/keyboard-controller.test.js
npm test
```

Then verify in a browser:

1. Arrow and `WASD` alternatives.
2. Rapid and held `E`/`C` presses.
3. Simultaneous keyboard and pointer use.
4. Focus loss during acceleration.
5. Touch/pointer cancellation.
6. Visible focus, control names, pressed state, and `44x44 CSS px` targets.
7. No page scroll from handled arrow keys while the dashboard is active.

## Completion Checklist

- [ ] Binding schema is complete and immutable.
- [ ] No code collision or hard-coded duplicate exists.
- [ ] Mode and domain preconditions are explicit.
- [ ] Keyboard and on-screen controls have parity.
- [ ] Repeat and stuck-input cleanup are tested.
- [ ] Unsupported keys retain normal browser behavior.
- [ ] Specification, legend, README, and tests agree.
- [ ] Focused and full test suites pass.

## Output Format

Return:

- **Command matrix:** action, codes, mode, label, preconditions, and on-screen parity.
- **Findings:** collisions, drift, lifecycle gaps, or none found.
- **Changes:** affected catalog, controller, control, test, and documentation files.
- **Validation:** focused/full commands and browser results.
- **Decision needed:** any unresolved key conflict or interaction ambiguity.
