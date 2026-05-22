# API Contract Standards

## Scope

Applies to HTTP/RPC API request-response contracts between frontend and backend.
Default protocol style: REST JSON over HTTP for Vue + Java services.

## Mandatory Rules

- Define contract before implementation for new endpoints.
- Keep request/response schema versionable and explicit.
- Use stable field names; avoid breaking changes by default.
- Standardize error model (code, message, details, trace id).
- Document auth requirements and rate limits where applicable.
- Keep timestamp/timezone fields explicit (ISO-8601 with timezone).

## Contract Change Policy

- Non-breaking change: additive fields with backward compatibility.
- Breaking change: requires version bump or migration plan.
- Deprecation must include timeline and fallback path.

## Validation

- Contract examples must include success and failure cases.
- Add automated contract tests where feasible.
- FE and BE task acceptance must reference same contract file.

## REST Conventions

- Path naming uses plural resources, e.g. `/api/v1/orders`.
- Use HTTP methods semantically: `GET/POST/PUT/PATCH/DELETE`.
- Pagination response should include `page`, `pageSize`, `total`, `items`.
- Idempotency should be considered for retryable write operations.
- Version breaking changes via `/v2` or equivalent explicit versioning plan.

## Error Response Baseline

```json
{
  "code": "ORDER_NOT_FOUND",
  "message": "Order does not exist",
  "details": {},
  "traceId": "..."
}
```

## Suggested Contract Template

```md
# Endpoint: <method> <path>

## Auth
## Request Schema
## Response Schema
## Error Model
## Examples (success/failure)
## Compatibility Notes
```
