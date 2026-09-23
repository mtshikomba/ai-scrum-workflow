# task-002: Deploy the landing page with Docker Compose

**Author:** @product-owner
**Status:** in progress
**Branch (when approved):** `task-002/production-compose-deployment`
**Target host:** `ai-scrum-workflow.shikomba.me`

## User Story

As the project owner, I want the landing page deployed as a production-ready Docker Compose service at `ai-scrum-workflow.shikomba.me`, so that visitors can access the site reliably through the existing proxy and deployment infrastructure.

## Problem Statement

The repository currently contains a static landing page but no container or deployment definition. The deployment must serve `index.html` and its static assets consistently in production, connect to the existing reverse-proxy network, and avoid introducing infrastructure that this static site does not need.

## Scope

- Add a production Docker Compose definition for the static landing page.
- Add the minimal container build and web-server configuration required to serve `index.html`, `styles.css`, and any referenced assets.
- Connect the web service to the externally managed `proxy-tier` Docker network used by the production reverse proxy.
- Use the host's existing Docker reverse-proxy convention, with the exact routing mechanism and required labels or configuration documented before implementation.
- Document required environment, DNS, proxy, TLS, and deployment assumptions.
- Ensure the service restarts automatically and can be deployed without a database.

## Functional Requirements

- The Compose service must build from this repository and serve the landing page on the container’s HTTP port.
- For local access, Compose must publish host port `8001` to container port `8080` using `8001:8080`; Nginx and its health check must continue to use container port `8080`.
- The repository must include a documented Dockerfile/build target using a pinned production-grade static web-server image.
- The container must run as a non-root user where supported by the selected image and must not require application secrets.
- The service must be attached to the external `proxy-tier` network without creating or managing the proxy itself.
- The service must use a stable production container name or Compose service identity and `restart: unless-stopped` (or an equivalent restart policy).
- The deployment documentation must identify the hostname `ai-scrum-workflow.shikomba.me` and describe how the reverse proxy routes traffic to the service.
- The deployment documentation must identify the proxy mechanism, internal service name, container port, required network alias, and any required proxy labels or configuration.
- The deployment must not require MySQL, Django, application migrations, static/media volumes, or application secrets.
- The configuration must support graceful replacement or restart without losing application data; the site is static and should not require persistent volumes.

## Acceptance Criteria

- [x] A production Docker Compose file exists at a clearly documented repository path and passes `docker compose config` with the required environment or defaults.
- [x] The Dockerfile uses a pinned web-server image, serves only the required site files, and runs as a non-root user where supported.
- [x] A clean deployment from the repository passes `docker compose build` and starts the web service.
- [x] The running service returns a successful HTTP response for `/` and serves the landing page content.
- [x] `styles.css` and every asset referenced by the page load successfully from the deployed service.
- [x] The local Compose port mapping is `8001:8080`, and the landing page, stylesheet, and `/healthz` endpoint respond successfully through `http://localhost:8001` when tested without the external proxy network.
- [x] The service is connected to the externally managed `proxy-tier` network and does not attempt to create it.
- [ ] The deployment documentation identifies the existing reverse-proxy mechanism and explains the route for `ai-scrum-workflow.shikomba.me`, including the internal service name, port, network alias, and labels or equivalent configuration.
- [ ] DNS and TLS prerequisites are documented, including which components remain outside this repository.
- [x] The Compose configuration contains no unnecessary database, Django, or persistent application-data services.
- [ ] The service restarts automatically after a normal container failure or host restart according to the configured policy.
- [x] The local validation procedure includes `docker compose config`, `docker compose build`, a container HTTP check for `/`, and checks for all referenced assets.
- [ ] The deployment can be validated at desktop and mobile viewport widths, and the existing landing-page content remains usable after deployment.
- [ ] Existing repository files and local development workflow remain unaffected.

## Out of Scope

- Provisioning or configuring the production host.
- Creating DNS records or issuing TLS certificates.
- Implementing or managing the reverse proxy, load balancer, or external `proxy-tier` network.
- Authentication, application APIs, databases, CMS functionality, or user data.
- Replacing the existing landing-page design.
- CI/CD pipeline automation unless it is required to make the Compose deployment reproducible.

## Technical Notes

- The supplied sister-project Compose file contains Django, MySQL, static/media volumes, and an initialization job. Those services are not applicable to this static landing page and should not be copied into this deployment.
- Prefer a minimal immutable web image with the repository content copied into the server’s document root. Pin the image version or digest so production builds are reproducible.
- The reverse proxy is expected to terminate TLS and forward HTTP traffic over `proxy-tier`; implementation must first confirm the production host's existing proxy convention and record the required labels, configuration, service name, and port.
- Add a container health check when supported by the chosen web-server image and configure it to verify that the site responds locally.
- Docker-specific validation is required for this task. Django tests, migrations, Black, and Flake8 do not apply unless Python/Django code is introduced.

## Deployment Assumptions and Validation Boundaries

- Local repository checks cover Compose syntax, image build, container startup, HTTP response, and referenced asset availability.
- Local testing may bypass the external `proxy-tier` network with `docker run --publish 8001:8080`; this does not replace production network validation.
- Production-host checks cover the existence of the external `proxy-tier` network, reverse-proxy routing, DNS resolution, TLS certificate issuance, and the final public hostname.
- The implementer must document any unavailable production-host prerequisite as a deployment blocker rather than weakening the local acceptance criteria.

## UX and Release Validation

- Confirm the deployed page renders at the production hostname on desktop and mobile widths.
- Confirm there are no mixed-content, missing-asset, console, or horizontal-overflow errors.
- Confirm the production hostname presents a valid TLS certificate once DNS and proxy configuration are in place.

## Next Step

Implementation is complete locally. Production-host routing, DNS, TLS, responsive browser validation, and restart behavior remain to be verified before moving the ticket to `.tasks/done/`.

## Developer Handoff

`@developer`: update the branch with the latest `8001:8080` Compose mapping, verify the Dockerfile and Nginx listener remain aligned on container port `8080`, run the network-independent Docker smoke test, commit and push the changes, then recreate or update PR #2 into `main`. Include the latest validation results in the PR description.

---

**Approval:** Approved
