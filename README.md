# Scrum Workflow

Scrum Workflow is an open-source delivery framework for turning product ideas into clear, reviewable work. It combines a disciplined scrum workflow with a structured team model, task lifecycle, and quality gates so teams can move from concept to shipped work with less drift and more accountability.

This repository serves as the project foundation and working example for a product-driven engineering workflow. The structure is designed to help teams define requirements, implement work through tracked tasks, validate user experience, and review technical quality before release.

## What this project includes

- A product-owner workflow for turning rough requests into groomed tickets
- A developer workflow for implementation, validation, and task tracking
- A UX review model focused on accessibility, responsiveness, and user experience
- A tech-lead review model focused on architecture, quality, and release risk
- A clear lifecycle from ticket creation through review and completion

## Repository Instructions

`AGENTS.md` is the canonical source for repository instructions, agent responsibilities, workflow gates, ticket lifecycle rules, and the Definition of Done. `.github/copilot-instructions.md` is the sole Copilot discovery entry point and links to `AGENTS.md`; keep it as a pointer rather than maintaining a second copy of the policy. More-specific instruction files apply alongside `AGENTS.md` and take precedence when they address the same path or concern.

## Agent Workflow

This project uses four agents to move work from an idea to reviewed code:

### `@product-owner`

Turns a loose request into a groomed Markdown ticket. The ticket should include a user story, scope, acceptance criteria, out-of-scope items, and implementation notes. The product owner pauses for human approval or refinement before implementation begins.

### `@developer`

Implements an approved ticket, writes the required Django tests, and validates the change. The developer moves the ticket through the task lifecycle and prepares the feature branch and pull request.

### `@ux-developer`

Translates approved requirements into user flows, screen and component states, responsive behavior, accessible interactions, and user-facing copy. The UX developer reviews user-facing implementations in a browser at desktop and mobile widths before technical review.

### `@tech-lead`

Reviews the pull request after it is created. The review checks architecture, authorization, CSRF/XSS risks, query performance, migrations, tests, and adherence to the acceptance criteria before merge.

## End-to-End Process

1. Ask `@product-owner` to run `#groom-ticket` for the feature request.
2. Review the generated ticket and reply **Approve** or **Refine**.
3. For user-facing work, ask `@ux-developer` to define the UX specification and acceptance criteria.
4. Ask `@developer` to implement the approved ticket and UX handoff. The ticket moves from `.tasks/todo/` to `.tasks/in-progress/`.
5. The developer writes tests first where practical, implements the smallest complete change, and runs the project checks.
6. Ask `@ux-developer` to validate the implemented UI at desktop and mobile widths.
7. The developer moves the completed ticket to `.tasks/done/`, pushes the feature branch, and creates a pull request into `main`.
8. Ask `@tech-lead` to review the pull request and address any findings.
9. Merge only after UX validation, tech-lead review, and the Definition of Done checks are green.

## Task and Git Conventions

Use one task ID across the ticket, branch, and pull request:

- Tickets: `.tasks/{status}/task-NNN-{kebab-case-summary}.md`
- Lifecycle: `.tasks/todo/` -> `.tasks/in-progress/` -> `.tasks/done/`
- Branches: `task-NNN/{kebab-case-summary}`
- Pull request titles: `[task-NNN] Imperative summary`
- Pull request bodies: include the ticket ID, implementation summary, acceptance-criteria status, tests and validation, and migration notes when applicable.

Use three-digit sequential IDs that are never reused. Keep summaries concise, lowercase ASCII, and kebab-case. Preserve the same ticket filename while moving it between lifecycle folders.

Each ticket must have exactly one canonical copy. Agents must move the file rather than copy or recreate it, then verify that the source is absent and the destination exists. Before starting work, check all three lifecycle folders for duplicates; after completing work, remove any stale `todo` or `in-progress` copy so only the current status remains.

Example:

```text
Ticket: .tasks/todo/task-006-add-task-filters.md
Branch: task-006/add-task-filters
Pull request: [task-006] Add task filters
```

## Definition of Done

Before a ticket is complete:

- Django unit or integration tests pass.
- `python manage.py check` passes.
- `python manage.py makemigrations --check --dry-run` passes.
- Black formatting passes.
- Flake8 linting passes.
- New models and views have concise Google-style docstrings.
- A migration is generated and included when models change.
- Acceptance criteria are checked off in the completed ticket.
- User-facing changes pass UX validation for responsive layout, accessibility, and relevant UI states.

## Example Prompts

Groom a request:

```text
@product-owner run #groom-ticket: Add [feature description].
```

Implement an approved ticket:

```text
@developer implement task-006-add-task-filters.md.
```

Create a pull request:

```text
@developer create a PR into main for task-006.
```

Review a pull request:

```text
@tech-lead review PR #123.
```

Define UX before implementation:

```text
@ux-developer define the UX specification for task-012, including user flow, states, responsive behavior, accessibility, and browser validation.
```

Validate implemented UI:

```text
@ux-developer review the implemented UI for task-012 at desktop and mobile widths.
```

## Setup

This repository currently includes the project marketing landing page and the workflow framework documentation. It is designed to be extended into a Django-based implementation later, but the core project intent is already documented in the repository structure and task flow.

For a Python/Django setup, this project targets Python 3.9 or newer within the supported Django 4.2 range.

```bash
python3 -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
cp .env.example .env
python manage.py migrate
```

The settings module reads environment variables from the shell. Load `.env` with your preferred environment manager when needed; Django does not read `.env` files automatically.
