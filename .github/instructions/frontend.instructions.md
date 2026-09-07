---
description: "Use when implementing or reviewing HTML and JavaScript frontend behavior, ES modules, vehicle state, input controllers, services, or dashboard components."
applyTo: "index.html,src/js/**/*.js"
---
# Frontend Implementation Instructions

## Before Editing

- Identify the relevant `REQ-###`, backlog ticket, owning module, and focused test.
- Explain any change to state ownership, event contracts, commands, or external adapters before implementation.
- Read the nearest existing module and test; preserve established exports and dependency direction.

## Architecture

- Keep mutable vehicle data exclusively in `src/js/core/vehicle-state.js`.
- Pass immutable snapshots to renderers; components must not calculate physics or mutate state.
- Keep flow unidirectional: input/service command -> vehicle state -> event bus -> renderer.
- Put thresholds, rates, warning metadata, event names, and command bindings in `src/js/config/`.
- Keep DOM access in the composition root, components, or UI controllers; core and utility modules stay browser-independent.
- Keep network and browser APIs behind `src/js/services/` adapters.
- Prefer a direct module or function over a new base class, registry, or framework-like abstraction.

## JavaScript

- Use native ES modules, named exports, `const` by default, double quotes, and trailing commas.
- Use `KeyboardEvent.code` for physical command mappings.
- Distinguish held actions from one-shot commands; suppress repeated one-shot keydown events.
- Clear held state on keyup, blur, visibility change, pointer cancellation, and controller destruction.
- Base simulation on bounded elapsed seconds, not frame count or timers hidden inside the model.
- Validate and clamp values before publication; return explicit results for rejected commands.
- Use `textContent`, attributes, classes, and CSS custom properties for rendering; do not insert remote strings with `innerHTML`.
- Clean up every global listener, animation frame, and subscription created by a module.

## Integration And Failure Behavior

- Render the initial snapshot before starting the simulation loop.
- External map, tile, geolocation, route, icon, or font failure must not stop speed, battery, warnings, controls, coordinates, or heading.
- Normalize expected service outcomes such as denied, unavailable, timeout, aborted, and invalid response.
- Abort or ignore stale route requests.
- Keep location in memory and request it only after explicit user action.

## Validation

- Add or update the narrowest native Node test for deterministic behavior.
- Check rejected transitions and boundary values, not only the happy path.
- Run the focused test before the full `npm test` suite.
- For browser-facing changes, verify no uncaught console errors and confirm offline fallback behavior.
