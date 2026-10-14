# task-003: Align Compose service identity and container health check

**Author:** @product-owner
**Status:** done
**Branch (when approved):** `task-003/compose-service-identity-healthcheck`
**Related ticket:** task-002 (production Compose deployment)

## User Story

As the project maintainer, I want the Compose service name and container health
check to use the deployment's canonical service identity and local hostname, so
that the static site is consistently identifiable and its health can be checked
inside the container.

## Current Updates to Track

- Rename the Compose service from `web` to `ai-scrum-workflow-web`.
- Change the Nginx container health-check URL from
  `http://127.0.0.1:8080/` to `http://localhost:8080/`.

## Scope

- Track the Compose service identity and Dockerfile health-check URL changes.
- Preserve the existing container port, published host port, external proxy
  network, network alias, and restart policy.
- Validate the resolved Compose configuration and the container health check.

## Acceptance Criteria

- [x] The Compose service is named `ai-scrum-workflow-web`.
- [x] The Dockerfile health check requests `http://localhost:8080/` and reports
      failure when the request fails.
- [x] The service continues to publish host port `8001` to container port
      `8080` and remains attached to the external `proxy-tier` network.
- [x] The service identity remains consistent with its configured container name
      and network alias.
- [x] `docker compose config` succeeds.
- [x] A built and running container reports healthy when the site responds, and
      the health check fails when the site is unavailable.

## Out of Scope

- Changes to the landing page, Nginx routing behavior, proxy configuration, DNS,
  or TLS.
- Changes to the production deployment requirements already tracked by task-002.

## Validation

- `docker compose config` — passed; service identity, port mapping, external
      network, and alias resolve as expected.
- `docker compose build` — passed.
- Container smoke test — passed using temporary host port `18001`; the landing
      page responded, the in-container `localhost:8080` probe succeeded, and Docker
      reported `healthy`.
- Image health-check configuration uses `wget ... http://localhost:8080/ || exit 1`.

---

**Please review and respond: [Approve / Refine]**