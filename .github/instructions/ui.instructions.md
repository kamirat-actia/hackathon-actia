---
description: "Use when designing, styling, or reviewing the automotive cockpit UI, responsive layout, dashboard instruments, interaction states, motion, or accessibility."
applyTo: "index.html,src/css/**/*.css,src/js/components/**/*.js,src/js/ui/**/*.js"
---
# Dashboard UI Instructions

## Product Experience

- Build the working cockpit as the first screen; do not add a landing page or feature tour.
- Keep current speed as the primary visual signal. Keep battery, active warning, GPS state, and controls visible or one direct action away.
- Use a quiet, operational automotive aesthetic with clear hierarchy and dense but readable information.
- Use actual instrument behavior or relevant vehicle imagery when an asset is needed; avoid decorative stock imagery, gradient-only art, and ornamental blobs.

## Components And Layout

- Give each instrument one semantic root, one CSS file, and stable dimensions or aspect ratio.
- Do not nest cards or style full-width page sections as floating cards.
- Keep card corner radii at `8px` or less.
- Use design tokens from `src/css/base/variables.css`; do not introduce isolated color or spacing values without a reason.
- Use mobile-first layout rules and verify `360x800`, `768x1024`, and `1440x900`.
- Prevent text overlap, clipping, horizontal page scrolling, and value-induced layout shift.
- Do not scale font size directly with viewport width or use negative letter spacing.

## Controls And Feedback

- Use native buttons, checkboxes/toggles, sliders, and menus according to their interaction semantics.
- Use Lucide icons when an approved icon exists; keep an accessible name and tooltip for unfamiliar icon-only controls.
- Provide pointer/touch parity for keyboard commands and at least `44x44 CSS px` targets.
- Show pressed, disabled, busy, offline, and failure states where the user can act on them.
- Keep high-frequency updates visually smooth without announcing each update to assistive technology.

## Accessibility

- Preserve logical DOM and focus order independent of visual grid placement.
- Use visible `:focus-visible` styles and native semantics before ARIA.
- Use `aria-pressed` for toggles and one polite live region for priority warning changes.
- Never communicate charge, severity, GPS status, or control state by color alone.
- Meet WCAG 2.2 AA contrast for text, icons, focus indicators, and meaningful graphical objects.
- Respect `prefers-reduced-motion` and retain a non-animated state cue.
- Verify keyboard-only operation, `200%` zoom, long fallback messages, and missing external assets.

## Visual Quality Gate

- Capture desktop, tablet, and mobile screenshots after material layout changes.
- Check dynamic extremes: speed `0` and `300`, battery `0%` and `100%`, multiple warnings, long offline text, and GPS fallback.
- Confirm no element occludes controls or preceding/following content.
- Confirm themes and status colors form a balanced palette rather than a one-hue interface.
