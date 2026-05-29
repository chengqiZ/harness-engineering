# Backend Standards

## Scope

Applies to service logic, data access, background jobs, and backend testing.
Default stack: Java 17+ + Spring Boot + MySQL 8.

## Mandatory Rules

- Keep business logic out of transport/controller layer.
- Validate inputs at boundary; return explicit error semantics.
- Do not mix unrelated responsibilities in one module.
- Keep functions deterministic where possible; isolate side effects.
- All behavior changes must include tests.
- Add detailed comments for complex business rules, branching decisions, external integration assumptions, transactional constraints, and risk-sensitive logic; comments should explain why the code exists and what must not be broken.

## Data And Persistence

- Schema/migration changes require rollback plan.
- Use transactions for multi-step critical writes.
- Avoid N+1 query patterns; batch where possible.
- Introduce indexes with clear query-path justification.

## Reliability

- Add timeout/retry/circuit controls for external dependencies.
- Log with structured fields; avoid sensitive payload logging.
- Preserve backward compatibility unless explicitly planned otherwise.

## Java/Spring Boot Rules

- Use layered architecture: `controller -> service -> repository`.
- Keep controllers thin; no business decision logic in controllers.
- Use DTOs for API boundaries; avoid exposing persistence entities directly.
- Validate request DTOs via Bean Validation (`@Valid` etc.).
- Use unified exception handling (`@ControllerAdvice`) and stable error payloads.
- Keep transaction boundaries explicit (`@Transactional`) at service layer.
- Use constructor injection; avoid field injection.

## MySQL Rules

- Use InnoDB by default.
- Every table should have primary key and explicit charset/collation policy.
- Add indexes based on query paths; record why each new index exists.
- Avoid `SELECT *` in critical paths; project required columns.
- For schema migration, provide forward and rollback scripts.
- For large data changes, use batched updates and backfill plans.

## Backend PR Checklist

- [ ] Input validation and error handling are explicit
- [ ] Migration/rollback considered (if data model changed)
- [ ] External calls have timeout/retry strategy
- [ ] Structured logging used without sensitive data
- [ ] Complex logic, business rules, and risk-sensitive paths have detailed comments
- [ ] Backend tests updated for behavior change
- [ ] Transaction and migration impact are explicitly reviewed
