# task-002: Modernize site UI/UX with brand color scheme

**Author:** @product-owner
**Status:** todo (awaiting approval)
**Branch (when approved):** `task-002/modernize-ui-ux-brand-colors`
**Depends on:** task-001 (site scaffold, currently in-progress)

## User Story

As a visitor to **peshiko.com.na**, I want the site to look modern and reflect the
Peshiko Investments brand so that the company is perceived as professional and
trustworthy.

## Source material

Brand logo (attached by user): "PESHIKO Investments" wordmark — deep red/maroon
brush-stroke ring mark, grey dotted "P" monogram, on a white background.

## Assumptions (flag for @tech-lead / @ux-developer review)

- Suggested palette derived from the logo (final values to be confirmed by
  @ux-developer during #ux-review, using the actual logo asset for exact hex
  sampling):
  - Primary (brand red): a deep maroon/brick red, approx. `#8C2A2A`–`#A3342E`.
  - Secondary (accent grey): approx. `#9A9A9A`–`#B5B5B5` (from the dotted monogram).
  - Background: white / near-white, approx. `#FFFFFF`–`#FAFAFA`.
  - Text: dark neutral, approx. `#1A1A1A`, for accessible contrast against white.
- This is a visual/UX refresh of the existing six pages (Home, News, About, Related
  Brands, Careers, Contact) delivered in task-001 — no new pages, models, or backend
  business logic are introduced.
- The logo asset itself will be added to `static/` and used in the site header
  (replacing the current text-only brand link) and favicon.

## Scope

- Define and apply a consistent design system (color tokens, typography scale,
  spacing, buttons, cards, form styling) sitewide via `static/css/site.css` (or a
  restructured stylesheet), driven by the brand palette above.
- Update `templates/base.html` header/nav/footer to use the new visual identity and
  include the logo.
- Refresh per-page templates (home hero, news list/detail, about, related brands
  cards, careers cards, contact form) to the new visual style.
- No changes to models, views, URLs, or business logic.

## Acceptance Criteria

- [ ] A documented color palette (primary/secondary/background/text/state colors)
      is defined as CSS custom properties and used consistently across all six pages.
- [ ] Logo image is added to `static/` and displayed in the site header, with
      appropriate `alt` text.
- [ ] Favicon updated to use the brand mark.
- [ ] Typography, spacing, and component styles (buttons, links, cards, form fields)
      are visually consistent across all pages.
- [ ] Color contrast between text and background meets WCAG AA (>= 4.5:1 for body
      text).
- [ ] All interactive elements (nav links, buttons, form fields) have visible focus
      states for keyboard navigation.
- [ ] Layout is responsive and verified at desktop and mobile widths on all six
      pages (Home, News list/detail, About, Related Brands, Careers, Contact).
- [ ] Loading/empty states (e.g. "no news yet", "no open positions") are styled, not
      left as unstyled default text.
- [ ] No regressions to existing Django tests (`python manage.py test apps` still
      passes) — this is a styling/template change only.
- [ ] Must not restrict, remove, or alter any authentication/permission logic
      (guardrail carried over from task-001).

## Out of scope (for this ticket)

- New pages, models, or content types.
- Copy/content changes beyond what's needed to fit the new visual design.
- Backend/business logic changes.

## Next steps

Awaiting **@ux-developer** to run #ux-review (define exact palette from the logo
asset, screen/component states, responsive behavior, accessibility criteria) before
**@developer** implements the CSS/template changes (#tdd-implement scoped to
template/static changes; existing test suite serves as the regression check).

---

**Please review and respond: [Approve / Refine]**

---

## UX Specification (@ux-developer, #ux-review)

**Reviewed:** current implementation in [templates/base.html](../../templates/base.html)
and [static/css/site.css](../../static/css/site.css) (task-001 baseline: navy header
`#0b3d59`, gold accent `#d4a017`, no logo asset in use).

**⚠️ Blocker:** the logo file itself was shared inline in chat only — it has not been
saved into the repo. Before implementation, the logo must be exported (SVG preferred,
PNG fallback @2x) and added at `static/img/logo.svg` (+ `static/img/favicon.png`).
Palette below is sampled visually from the shared logo and should be re-verified with
a color picker against the final exported asset.

### 1. Color tokens (CSS custom properties)

| Token | Hex | Usage |
|---|---|---|
| `--color-primary` | `#8F2A28` | Brand red (wordmark/ring stroke) — header bg, headings, primary buttons, links |
| `--color-primary-dark` | `#6E1F1E` | Hover/active state for primary elements |
| `--color-accent` | `#A8A6A2` | Grey monogram dots — secondary accents, muted icons, dividers |
| `--color-surface` | `#FFFFFF` | Page background |
| `--color-surface-alt` | `#F7F5F3` | Card/section alt background |
| `--color-text` | `#211C1C` | Body text (on white, ratio ≈ 15.8:1) |
| `--color-text-muted` | `#5C5652` | Secondary text (dates, captions) |
| `--color-border` | `#E4E0DC` | Card/input borders |
| `--color-success` | `#2E7D32` | Success messages (contact form) |
| `--color-error` | `#B3261E` | Form validation errors |
| `--color-focus` | `#1A6FB0` | Focus outline (kept distinct from brand red so it's visibly a focus ring, not decoration) |

Contrast check: `--color-primary` (#8F2A28) on white = 6.7:1 (passes AA for normal
text); `--color-text` on white = 15.8:1. White text on `--color-primary` header =
6.7:1 (passes AA).

### 2. Typography & spacing

- Headings: existing system font stack, but establish a scale: `h1` 2rem/2.5rem
  desktop, `h2` 1.5rem, `h3` 1.125rem, body 1rem, line-height 1.5.
- Spacing scale: 4/8/16/24/32/48px, applied via existing rem-based paddings.
- Buttons: solid `--color-primary` bg, white text, 8px radius, `--color-primary-dark`
  on hover/active, 2px `--color-focus` outline on keyboard focus.
- Cards (brand/job/news items): white surface, 1px `--color-border`, 8px radius,
  subtle shadow on hover only (not on touch devices).

### 3. Primary user flow (unchanged from task-001, visual only)

Home → (News teaser / Brand teaser / CTA) → News list → News detail, and
Home → Careers → (external apply or mailto), Home → Contact → success message.
No navigation/IA changes in this ticket.

### 4. Screen/component states to style explicitly

- **Home:** hero (heading/subheading/body), latest-news teaser list, featured-brand
  teaser list, CTA buttons row.
- **News list:** populated list (title + date), **empty state** ("No news articles
  yet…" styled as a centered muted card, not plain text), pagination controls with
  visible current-page and disabled prev/next states.
- **News detail:** article with optional image, back link.
- **Related Brands:** card grid (logo, name, description, "Visit site" link),
  **empty state** styled.
- **Careers:** card list (title, location, description, apply link/mailto),
  **empty state** ("no open positions") styled.
- **Contact:** form default state, **field error state** (red border + inline error
  text under each field), **success state** (Django message banner styled as a
  success card, not a bare `<li>`), submit button **disabled/loading** state while
  submitting (progressive enhancement, optional if no JS is introduced).
- **Nav:** current-page link gets a visible active/underline state.

### 5. Responsive behavior

- Desktop (≥1024px): horizontal nav, 3-column card grids (brands/careers), max
  content width 1100px (unchanged).
- Tablet (641–1023px): 2-column card grids, nav stays horizontal but wraps.
- Mobile (≤640px): stacked nav (existing behavior — keep), single-column cards,
  buttons full-width, tap targets ≥ 44px.

### 6. Accessibility requirements

- All text/background pairs meet WCAG AA (4.5:1 normal text, 3:1 large text/UI
  components) — see token table above.
- Every interactive element (nav links, buttons, form inputs, card links) has a
  visible `:focus-visible` outline using `--color-focus`.
- Logo `<img>` requires descriptive `alt="Peshiko Investments Holdings"`.
- Form fields keep associated `<label>` elements (Django `form.as_p` already emits
  these — must not be stripped in the redesign).
- Color must not be the only means of conveying form errors — pair red border with
  inline error text (already returned by Django form errors).

### 7. Copy adjustments

- Header brand text/logo alt: "Peshiko Investments Holdings" (unchanged).
- Empty-state copy: News → "No news articles yet — check back soon."; Careers →
  "There are no open positions right now. Check back soon." (existing copy, just
  needs visual treatment, no wording change needed).

## UX Acceptance Criteria (added to task-002 handoff)

- [ ] Color tokens above implemented as CSS custom properties in
      `static/css/site.css`, replacing the current navy/gold placeholder palette.
- [ ] Logo asset added to `static/img/` and used in header + favicon (blocked until
      asset file is provided — see blocker above).
- [ ] Empty states (News, Careers) are visually styled, not default browser text.
- [ ] Contact form shows inline field errors and a styled success message.
- [ ] All interactive elements have a visible focus-visible state distinct from
      hover.
- [ ] Verified at desktop (≥1024px), tablet (641–1023px), and mobile (≤640px)
      widths on all six pages once implemented.
- [ ] Verified color contrast ratios meet WCAG AA using the final token values.

**Handoff:** ready for **@developer** to implement per #tdd-implement (styling/template
only — no model/view/URL changes). @ux-developer will re-review the live implementation
in-browser at desktop/mobile widths per step 4–6 of #ux-review once implemented, and
report findings before final @tech-lead sign-off (#review-pr).

## Implementation notes (@developer, #tdd-implement)

- Replaced the navy/gold placeholder palette in
  [static/css/site.css](../../static/css/site.css) with the brand token set from the
  UX spec above (CSS custom properties: primary red, accent grey, surfaces, text,
  success/error/focus colors).
- Added typography scale, `.btn`, `.card` / `.card-grid`, `.empty-state`,
  `.message--success` / `.message--error`, form field + `.errorlist` error-border
  styling, and `:focus-visible` outlines.
- [templates/base.html](../../templates/base.html) nav links now set
  `aria-current="page"` for the active section (styled with an underline).
- Updated all six page templates (home, about, news list/detail, related brands,
  careers, contact) to use the new `.card` / `.card-grid` / `.btn` / `.empty-state`
  classes instead of bare lists/paragraphs.
- Regression check: `python manage.py test apps` — 19/19 tests still pass (no
  model/view/URL changes made). `black --check` and `flake8` clean.
- Manually verified in-browser (desktop viewport) via the dev server: Home, Contact
  (default + validation-error state), and Careers (empty state) all render with the
  new palette, active-nav underline, and styled empty/error states as specified.

