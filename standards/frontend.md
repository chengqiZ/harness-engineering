# Frontend Standards

## Scope

Applies to UI, interaction logic, state management, and frontend testing.
Default stack: Vue 3 + TypeScript + Pinia + Vue Router.

## Mandatory Rules

- Follow existing design system and component patterns first.
- Do not introduce new UI libraries without explicit approval.
- Keep components focused; avoid monolithic page components.
- Separate view logic from data fetching side effects.
- Handle loading, empty, error, and success states explicitly.
- Avoid hardcoded strings for user-facing copy when i18n exists.
- Add meaningful comments where needed for components, composables, public functions, important state, non-obvious state transitions, edge-case handling, and business rules; comments should explain intent, constraints, and UI/business meaning.
- Avoid comments that only restate obvious syntax, simple computed values, or trivial event forwarding.
- Accessibility baseline: semantic HTML, keyboard reachable controls, labeled inputs.

## Styling

- Reuse existing tokens/variables before adding new ones.
- Avoid one-off inline styles unless temporary and justified.
- Preserve responsive behavior for common desktop/mobile breakpoints.

## Performance

- Avoid unnecessary rerenders and oversized client bundles.
- Lazy-load heavy modules/routes when applicable.
- Optimize large lists with pagination/windowing if needed.

## Vue-Specific Rules

- Prefer Vue 3 Composition API with `script setup`.
- Keep page-level components under `views/`, reusable UI in `components/`.
- Keep business state in Pinia stores; avoid deep prop drilling across views.
- API calls must be isolated in `services/` layer, not mixed into base UI components.
- Use route-level code splitting for non-core pages.
- Form validation rules should be centralized and reusable.
- Avoid direct mutation of complex props; use emits/store actions.

## Vue Frontend Structure (Recommended)

```text
src/
  views/
  components/
  stores/
  services/
  router/
  composables/
  utils/
```

## Frontend PR Checklist

- [ ] UI states covered: loading/empty/error/success
- [ ] Existing component/style patterns reused
- [ ] Accessibility baseline checked
- [ ] Responsive behavior verified
- [ ] Components, functions, state, complex branches, and business rules have meaningful comments where needed
- [ ] Frontend tests updated for behavior change
- [ ] Vue store and service boundaries are respected
