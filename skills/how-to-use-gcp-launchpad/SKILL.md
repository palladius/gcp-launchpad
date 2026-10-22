---
name: how-to-use-gcp-launchpad
description: Comprehensive operational guide and skill for AI agents to master, build, test, run, and extend gcp-launchpad.
metadata:
  creator: sumaron v0.3.0
  date: 2026-09-11
---

# How to Use and Develop `gcp-launchpad`

## 🎯 Overview & Architecture

`gcp-launchpad` is a customized **reveal.js** presentation engine designed for Google Cloud DevRel workshop onboarding
 ("Onramp"). Its primary mission is to distribute ephemeral GCP credit claim links (e.g. `https://trygcp.dev/claim/h2-labs-...`), guide attendees through Gemini CLI / ADK / API key setup, and adapt presentation content dynamically per event without rebuilding.

### Mental Model & Architectural Split

The codebase hosts two presentation variants running side-by-side:

1. **`onramp-images/` (Active, visual-first)**:
   - Built for workshop attendees. Uses screenshots of official Google slides with an overlayed DOM, interactive menus, and client-side dynamic QR code generation.
   - Served on port **8082** (via npm) or **8081** (via custom scripts).
2. **`onramp-new/` (Semantic, HTML/text-first)**:
   - Markdown/HTML-driven slides without heavy imagery.
   - Served on port **8080**.
3. **Core reveal.js engine (Root)**:
   - Root files (`dist/`, `css/`, `plugin/`, `gulpfile.js`) contain the underlying Reveal.js library and Gulp build pipeline.

### Dynamic Runtime Injection

The app is deployed as a static GitHub Pages site or containerized into Cloud Run. It avoids build-time environment injection (see `docs/WHY_ENV_WONT_WORK.md`). Instead, presentation state is governed dynamically at runtime via:
- **URL Query Parameters** (Highest precedence): `?onramp_url=...&location=...&emoji=...&show_workshop=true`
- **Body Attribute** (Cloud Run container fallback): `<body data-onramp-url="...">`

---

## ⚡ Essential Commands

The project uses `npm` along with a `justfile` task runner and `gulp`.

### Running Locally

```bash
# Start standard presentation (onramp-new / root reveal instance) on port 8000/8080
npm start

# Start the images presentation (onramp-images/) on port 8082
npm run start-images

# Task runner equivalents (if 'just' is installed):
just onramp          # Runs text-only version (port 8080)
just onramp-images   # Runs images version (port 8081)
```

### Building & Testing

```bash
# Full build: rollup JS bundles + Sass CSS themes compilation
npm run build
# Or via just:
just build

# Compile CSS themes only
npx gulp css-themes

# Run reveal.js test suite (Puppeteer + QUnit)
npm test
# Or via just:
just test

# Linting
npx gulp eslint
```

---

## 🔑 Key Entry Points & Structure

| File / Path | Role & Salience |
| :--- | :--- |
| `onramp-images/index.html` | **Primary production deck**. Contains DOM logic, `qrcodejs` integration, query param parsing, menu jumps, and Reveal config. |
| `onramp-new/index.html` | Semantic HTML version with dynamic credit activation checks. |
| `onramp-images/images/milano-pages/` | Extracted slide images rendered sequentially across presentation slides. |
| `gulpfile.js` & `package.json` | Build orchestrator. Handles Rollup bundles (`dist/reveal.esm.js`), Sass compilation, and live reload server via `gulp-connect`. |
| `.github/workflows/deploy.yml` | GitHub Actions deployment pipeline targeting GitHub Pages (`_site` directory consolidation). |
| `GEMINI.md` | Core project requirements, architectural history, and target user journeys. |
| `docs/USER_MANUAL.md` | Reference for query string parameters and production link formatting. |

---

## 🛡️ Operational Constraints & Gotchas

### 1. Client vs. Server Environment (.env Pitfall)
- **Do not** introduce `.env` files for client-side JavaScript. 
- GitHub Pages is strictly static. All dynamic runtime parameters must come from URL search params (`window.location.search`).
- For Cloud Run, runtime injection is supported solely through reading `<body data-onramp-url="...">`. The query parameter `?onramp_url=` **always** overrides `data-onramp-url`.

### 2. QR Code Scannability & Background Styling
- `qrcode.js` creates an SVG/Canvas inside designated container elements (e.g. `#qrcode-self-link`, `#qrcode-slide8`).
- Slide 1 has a self-referencing QR code that points to `window.location.href`.
  - On `localhost` or `127.0.0.1`, its background automatically changes to **gray**.
  - In production / non-localhost environments, the container styles to Google Blue (`#4285F4`).
- When styling QR containers, ensure sufficient white padding (`padding: 10px; background: white;`) or smartphone cameras will fail to scan inverted/colored backgrounds.

### 3. Sub-chapter Toggling & Reveal Anchors
- Internal cross-slide jumps rely on Reveal hash anchors (e.g., `<a href="#/workshop">`, `<a href="#/credits">`, `<a href="#/gemini-cli">`).
- Sections must have corresponding IDs (`<section id="gemini-cli">`).
- Up arrow (`keyCode: 38`) is globally intercepted in `onramp-images/index.html` to jump back to the `#main-menu` slide automatically. Preserve this binding when modifying Reveal keyboard configuration.

### 4. Broken External Platforms
- Netlify links (`onramp-images.netlify.app`) are deprecated and broken (HTTP 503). Do not restore them in documentation or footer templates. GitHub Pages is the authoritative deployment target.

---

## 🛠️ Development Recipes

### Recipe 1: Adding or Modifying Query Parameters

When adding new dynamic fields (e.g., `event_name` or `speaker_handle`):

1. Edit `onramp-images/index.html`:
   ```javascript
   const urlParams = new URLSearchParams(window.location.search);
   const eventName = urlParams.get('event_name');
   ```
2. Locate the DOM target and apply conditional rendering with fallbacks:
   ```javascript
   const eventEl = document.getElementById('event-banner');
   if (eventEl && eventName) {
       eventEl.textContent = eventName;
       eventEl.style.display = 'block';
   }
   ```
3. Test locally with varying query strings:
   ```
   http://localhost:8082/?onramp_url=https://trygcp.dev/claim/test-event&location=Zurich&emoji=🇨🇭&event_name=CloudSummit
   ```

### Recipe 2: Adding a New Sub-chapter Slide Section

1. In `onramp-images/index.html`, add a button to the `#main-menu` grid:
   ```html
   <a href="#/new-topic" class="qr-box" style="background-color: #4285F4; color: white !important;">
       <strong style="font-size: 1.2em;">🚀 New Topic</strong>
   </a>
   ```
2. Add the corresponding `<section>` with the anchor ID:
   ```html
   <section class="center" id="new-topic">
       <h2>New Topic Title</h2>
       <img src="images/milano-pages/page-XX.png" style="max-width: 80%;">
       <p class="tip">End of "New Topic". Press up arrow ⬆️ to return to the menu.</p>
   </section>
   ```
3. Verify keyboard navigation: Navigate into the slide, then hit the `UP` arrow key to return to `#main-menu`.

### Recipe 3: Updating Reveal Themes or CSS Overrides

1. Reveal SASS source files are located in `css/theme/source/`.
2. Do not edit `dist/theme/*.css` directly; they will be overwritten during build.
3. Add custom styles inside the `<style>` tag of `onramp-images/index.html` for presentation-specific overrides, or compile global theme updates:
   ```bash
   npm run build -- css-themes
   ```
