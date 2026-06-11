# Testing Standards

## Scope

Applies to unit, integration, API, and end-to-end verification for behavior changes.
Default stack baseline: Vue (Vitest + Vue Test Utils), Java (JUnit 5 + Spring Boot Test), MySQL integration with isolated test DB.

## Mandatory Rules

- Behavior change requires test updates/additions.
- Bug fix requires at least one regression test.
- Tests should be deterministic and isolated.
- If tests cannot run, provide blocker, manual steps, expected results.
- Test files, fixtures, helper methods, complex setup, non-obvious assertions, regression cases, and mocked boundary behavior must include comments or test names that explain the intent being verified.
- Avoid comments that only restate test syntax or obvious arrange/act/assert structure.

## Test Strategy

- Unit tests: core logic and edge cases.
- Integration tests: critical module interactions.
- API tests: schema and error handling consistency.
- E2E tests: only for critical user journeys.

## Stack-Specific Baseline

- Frontend unit/component tests:
- Prefer Vitest for unit tests and Vue Test Utils for component behavior.
- Cover composables, store actions/getters, and key interaction states.

- Backend unit/integration tests:
- Use JUnit 5 as baseline.
- Use Spring Boot slice/full integration tests where interaction matters.
- Mock external dependencies at service boundary when appropriate.

- Data layer tests:
- Validate repository/query behavior against representative MySQL test data.
- Keep migrations testable on clean schema bootstrap.

## Quality Gates

- New logic paths must have positive + negative assertions.
- Flaky tests must be fixed or quarantined with owner and due date.
- No merge when critical-path tests are failing.
- High-risk changes (auth/billing/data migration) require at least one integration test.
- Tests covering subtle business rules must document the scenario and expected invariant.

## Verification Output Format

- Command(s) executed
- Environment/context
- Pass/fail summary
- Failure details and next action
