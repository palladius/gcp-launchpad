---
sumaron_version: 0.3.0
created_at: 2026-09-11T09:20:41+02:00
target_repo: gcp-launchpad
type: defect_and_improvement_audit
---

# How To Make This Better: gcp-launchpad

## Executive Summary

A comprehensive architectural and security review was conducted on the **gcp-launchpad** repository (`/Users/riccardo/git/gcp-launchpad`). The repository serves as an interactive Reveal.js presentation engine designed for Google Cloud Developer Relations workshops to distribute Google Cloud Platform (GCP) trial credits via dynamic URLs and display onboarding collateral.

The project currently operates as a modified clone of Reveal.js with multiple divergent presentation tracks (`onramp-new`, `onramp-images`, `rag/gemini-canvas`, and upstream `rusko/demo` artifacts). While the core functionality is functional for presentations, the codebase exhibits critical security gaps—specifically **DOM-based Cross-Site Scripting (XSS)** and **arbitrary protocol execution (`javascript:`)** via unvalidated query string parameters. Furthermore, internal corporate references are exposed in public documentation, dead code and broken DOM element selectors exist, and versioning across files is severely out of sync.

The codebase needs immediate remediation of client-side injection surfaces, consolidation of divergent presentation code into a single DRY structure, and removal of internal Google identifiers.

---

## 🛡️ Security Vulnerabilities

### 1. DOM-Based Cross-Site Scripting (XSS) via Query Parameters
* **Severity**: **High**
* **Affected Files**:
  * `onramp-images/index.html` (Lines 240, 246, 257, 269, 276)
  * `onramp-new/index.html` (Lines 196, 209)
* **Description**:
  Both presentation versions extract parameters (`onramp_url`, `location`, `emoji`) from `window.location.search` and interpolate them directly into the DOM using `innerHTML` without validation or sanitization:
  ```javascript
  // onramp-images/index.html
  statusBox.innerHTML = `<a href="${onrampUrl}" target="_blank" ...>Click here to claim your credits!</a>`;
  mainTitle.innerHTML = `${displayEmoji} Welcome, developer!`;
  locationInfo.innerHTML = `🗺️ ${location}`;
  ```
  An attacker can craft a malicious workshop URL (e.g., `?emoji=<img src=x onerror=alert(document.cookie)>` or `?location=<svg onload=fetch(...)>`) and distribute it to attendees. Because the payload executes within the origin of the hosting domain (e.g., `palladius.github.io`), this allows arbitrary script execution in attendees' browsers.
* **Remediation**:
  * Avoid `innerHTML` for plain text or emoji injection; use `textContent` or `document.createTextNode()`.
  * For dynamic anchor links, construct DOM elements programmatically and set attributes via `element.setAttribute()` or `.textContent`.

```javascript
// Safe pattern
const claimLink = document.createElement('a');
claimLink.href = safeUrl;
claimLink.target = '_blank';
claimLink.rel = 'noopener noreferrer';
claimLink.textContent = 'Click here to claim your credits!';
statusBox.replaceChildren(claimLink);

if (mainTitle) {
    mainTitle.textContent = `${displayEmoji} Welcome, developer!`;
}
```

---

### 2. Protocol Injection / Untrusted URL Execution (`javascript:`, `data:`)
* **Severity**: **High**
* **Affected Files**:
  * `onramp-images/index.html` (Lines 237–254)
  * `onramp-new/index.html` (Lines 189–198)
* **Description**:
  The `onramp_url` parameter is assigned directly to `<a href>` attributes:
  ```javascript
  onrampUrlTextSlide8.href = onrampUrl;
  ```
  If an attacker supplies `?onramp_url=javascript:/*payload*/` or `?onramp_url=data:text/html,...`, clicking any credit redemption link executes arbitrary JavaScript in the user's session context. Furthermore, this URL is passed unsanitized into the `QRCode` generator, which can be weaponized against QR code scanner applications.
* **Remediation**:
  Validate that `onramp_url` strictly begins with an authorized HTTP/HTTPS protocol before rendering links or generating QR codes:

```javascript
function isValidHttpUrl(string) {
    try {
        const url = new URL(string);
        return url.protocol === 'https:' || url.protocol === 'http:';
    } catch (_) {
        return false;
    }
}

if (onrampUrl && isValidHttpUrl(onrampUrl)) {
    // Proceed with safe assignment
} else {
    // Flag invalid or malicious URL
}
```

---

### 3. Exposure
 of Internal Corporate Identifiers & Confidential Shortlinks
* **Severity**: **Medium**
* **Affected Files**:
  * `README.md` (Lines 11–13)
  * `onramp-images/index.html` (Line 92)
* **Description**:
  The public `README.md` and HTML source disclose internal Google corporate metadata:
  ```markdown
  Internal info:
  * Bug: More info: b/425877073
  * PRD: go/onramp-autobahn
  ```
  Leaking internal Buganizer IDs (`b/XXXXX`) and internal go-links (`go/XXXXX`) violates standard security practices for public open-source repositories and provides threat actors with internal infrastructure and naming conventions.
* **Remediation**:
  Purge all internal corporate tracking IDs, bug references, and Google intranet go-links from public markdown and HTML files. Move internal references to private internal trackers or Google-internal documentation.

---

### 4. Missing Subresource Integrity (SRI) on Third-Party CDN Scripts
* **Severity**: **Medium**
* **Affected Files**:
  * `onramp-images/index.html` (Lines 8, 9, 10, 222, 223, 224)
  * `onramp-new/index.html` (Lines 8, 9, 10, 172, 173)
  * `onramp-images/images/images-only.html` (Lines 7, 8, 9, 87, 88)
* **Description**:
  Scripts and stylesheets (`reveal.min.js`, `highlight.min.js`, `qrcode.min.js`) are loaded from `cdnjs.cloudflare.com` without `integrity` attributes or `crossorigin="anonymous"`. If the CDN account or CDN edge cache is compromised, malicious code can be injected directly into client presentation sessions without detection.
* **Remediation**:
  Include cryptographic hashes and CORS flags on external resources, or bundle them locally via npm:
  ```html
  <script 
    src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"
    integrity="sha512-CNgIRecGo7nphbeZ04Sc13ka07paqdeTu0WRUv4izV75IE8ndgnv64WFawP9EwHlXYkcpsIrQmbfVAF6+mfxzQ=="
    crossorigin="anonymous"
    referrerpolicy="no-referrer">
  </script>
  ```

---

### 5. Insecure PostMessage Target Origin and Reverse Tab-Nabbing
* **Severity**: **Low**
* **Affected Files**:
  * `plugin/notes/speaker-view.html` (Lines 448, 461, 470, 502)
  * `onramp-new/index.html` (Lines 52, 56, 60, 64, 114, 151)
* **Description**:
  1. In `plugin/notes/speaker-view.html`, multiple calls to `window.opener.postMessage(..., '*')` and `currentSlide.contentWindow.postMessage(..., '*')` use the wildcard `'*'` target origin. If another malicious window gains a reference or if an iframe changes location, state data could be leaked to an arbitrary origin.
  2. Multiple hyperlinks using `target="_blank"` lack `rel="noopener noreferrer"`. Older browsers or edge-case implementations could allow target destinations to access `window.opener`.
* **Remediation**:
  * Specify `window.location.origin` instead of `'*'` when calling `postMessage`.
  * Ensure all dynamic and static anchors with `target="_blank"` include `rel="noopener noreferrer"`.

---

## 🐛 Defects & Bugs

### 1. Broken Slide Toggling Feature (`riccardo-workshop` vs `workshop`)
* **File**: `onramp-images/index.html` (Lines 288–294)
* **Bug**:
  ```javascript
  if (showWorkshop === 'true') {
      const workshopSection = document.getElementById('riccardo-workshop');
      if (workshopSection) {
          workshopSection.style.display = 'block';
      }
  }
  ```
  The DOM element with id `riccardo-workshop` does not exist in `onramp-images/index.html`. The actual workshop slide has `id="workshop"`, and none of the workshop slides are set to `display: none` by default. As a result, the `?show_workshop=true|false` query parameter does nothing, leaving workshop slides visible at all times.
* **Fix**:
  Ensure workshop slides are marked with a uniform class or attribute (e.g., `<section class="workshop-slide" hidden>`) and show/hide all associated slides conditionally in the DOM before `Reveal.initialize()` is invoked.

---

### 2. Dead Code / Null Reference Handling in `self-link`
* **File**: `onramp-images/index.html` (Lines 233, 262–265)
* **Bug**:
  The script queries `document.getElementById('self-link')` and sets `selfLink.href`. However, CHANGELOG entry `[0.1.7]` notes: *"Removed the debug link from the footer"*, and the element was indeed removed from the HTML markup. The query selector returns `null` every execution.
* **Fix**:
  Remove the unused `selfLink` references from `onramp-images/index.html`.

---

### 3. Server Port Discrepancies Across Configuration and Documentation
* **Files**: `package.json`, `GEMINI.md`, `README.md`, `docs/USER_MANUAL.md`
* **Bug**:
  * `package.json` specifies:
    ```json
    "start-images": "gulp serve --cwd onramp-images/ --port 8082"
    ```
  * `GEMINI.md` specifies:
    ```text
    "I'm also maintaining a SECOND `just onramp-images` on port 8081."
    ```
  * `README.md` instructs users to open `http://localhost:8081/?onramp_url=...`.
  * `docs/USER_MANUAL.md` references `http://localhost:8081/`.
  This creates confusion where developers running `npm run start-images` cannot connect to the port documented in the manual and README.
* **Fix**:
  Align on a consistent port configuration (e.g., port `8081`) across `package.json`, Justfile, and all documentation.

---

### 4. Dependency on Deprecated Google Chart API for QR Codes
* **Files**: `onramp-new/index.html` (Line 160), `rag/gemini-canvas/index.html` (Line 183)
* **Bug**:
  Both files still generate feedback QR codes using the legacy Google Chart Infographics API:
  `https://chart.googleapis.com/chart?chs=150x150&cht=qr&chl=...`
  Google deprecated this service in 2012 and has periodically disabled endpoints. The presentation will render broken image placeholders when offline or when the deprecated endpoint terminates.
* **Fix**:
  Migrate `onramp-new` and `rag/` to use client-side SVG QR code generation (e.g., `qrcodejs` or `qrcode-svg`) or generate static SVG assets at build time.

---

### 5. Missing Error Handling in Dynamic QR Code Generation
* **File**: `onramp-images/index.html` (Lines 249–254, 280–285)
* **Bug**:
  `new QRCode(qrcodeSlide8Container, { text: onrampUrl, ... })` is called without checking whether `qrcodeSlide8Container` already contains rendered canvas/image elements (e.g., if re-initialized or updated via hash navigation). Furthermore, `qrcodejs` throws an unhandled exception if `onrampUrl` exceeds the maximum alphanumeric character limit for the configured version/matrix size (e.g., long URLs with tracking parameters).
* **Fix**:
  Wrap QRCode construction in a `try...catch` block and clear previous inner elements before instantiating:
  ```javascript
  qrcodeSlide8Container.replaceChildren();
  try {
      new QRCode(qrcodeSlide8Container, { text: onrampUrl, width: 256, height: 256 });
  } catch (err) {
      console.error('Failed to render QR Code:', err);
  }
  ```

---

## 🏗️ Architectural Improvements

```
Current Split-Brain State:
┌─────────────────────────────────────────────────────────────────┐
│                       gcp-launchpad (Repo)                      │
│                                                                 │
│   ├── onramp-images/  ─── (Standalone Reveal.js deck #1)        │
│   ├── onramp-new/     ─── (Standalone Reveal.js deck #2)        │
│   ├── rag/gemini-...  ─── (Standalone Reveal.js deck #3)        │
│   ├── rusko/          ─── (Upstream Reveal.js example tests)    │
│   └── demo.html       ─── (Upstream Reveal.js demo)             │
└─────────────────────────────────────────────────────────────────┘

Recommended Modular Architecture:
┌─────────────────────────────────────────────────────────────────┐
│                       gcp-launchpad (Repo)                      │
│                                                                 │
│   ├── src/                                                      │
│   │    ├── slides/          ─── (Markdown or Component Slides)  │
│   │    ├── js/config.js     ─── (URL params & sanitization)    │
│   │    └── styles/          ─── (Shared Google Theme SCSS)      │
│   ├── dist/                 ─── (Compiled unified artifact)     │
│   ├── scripts/build.js      ─── (Build pipeline for GH Pages)   │
│   └── tests/                ─── (E2E & Unit validation)         │
└─────────────────────────────────────────────────────────────────┘
```

### 1. Eliminate the "Split-Brain" Presentation Implementations
* **Observation**:
  The repository maintains three divergent implementations of the exact same workshop presentation:
  * `onramp-new/index.html` (text + DOM structure, missing recent fixes)
  * `onramp-images/index.html` (screenshot-based image deck with dynamic header/footer)
  * `onramp-images/images/images-only.html` (static non-dynamic version)
  * `rag/gemini-canvas/index.html` (prototype canvas deck)
* **Impact**:
  Bug fixes (such as escaping, QR code rendering, and keyboard shortcuts) made in `onramp-images` are omitted from `onramp-new`, and vice-versa.
* **Recommendation**:
  Consolidate into a single presentation source file. Use Reveal.js fragments or a single slide deck where each slide can toggle between text mode and image mode via CSS classes or presentation parameters, rather than duplicating entire directory structures.

### 2. Upstream Reveal.js Fork Drift vs. Application Wrapper
* **Observation**:
  The repo root is a raw clone of `hakimel/reveal.js` version 5.2.1, containing test suites, legacy build gulpfiles, and multiple example files (`rusko/`, `demo.html`). The actual application code resides in subdirectories (`onramp-images`, `onramp-new`).
* **Impact**:
  Dependency auditing is cluttered with upstream Reveal.js devDependencies (such as `gulp-connect`, `marked 4.3.0`, `node-qunit-puppeteer`), making security scans noisy and obfuscating real application vulnerabilities.
* **Recommendation**:
  Separate the presentation app from the engine. Treat Reveal.js as a clean npm package dependency (`npm install reveal.js`) and run a streamlined Vite or Rollup build rather than maintaining a monolithic fork of the Reveal.js core repository.

### 3. Version Desynchronization Across Artifacts
* **Observation**:
  Version numbers are tracked inconsistently across the repository:
  * `package.json`: `"version": "5.2.1"` (Inherited from Reveal.js)
  * `CHANGELOG.md`: Latest release is `[0.1.8] - 2025-12-05`
  * `onramp-images/index.html`: Footer displays `v0.1.7`; Title displays `v2.5.1`
  * `onramp-new/index.html`: Footer displays `v0.0.3`; Title displays `v2.5.1`
* **Recommendation**:
  Single-source the application version. Read the version from `package.json` (or a single `version.json` file) and inject it into the footer and page title during build/render time.

---

## 🍏 Low-Hanging Fruits & Quick Wins

1. **Fix Insecure `target="_blank"` Links**:
   Add `rel="noopener noreferrer"` across all external links in `onramp-images/index.html` and `onramp-new/index.html`.
2. **Harmonize Port Configurations**:
   Change `"start-images"` in `package.json` from `--port 8082` to `--port 8081` to match `README.md`, `GEMINI.md`, and documentation.
3. **Clean Up Dead `self-link` DOM References**:
   Remove `const selfLink = document.getElementById('self-link')` and its mutation block in `onramp-images/index.html`.
4. **Remove Unused Upstream Bloat**:
   Remove unneeded test fixtures and demo directories (`rusko/`, `rag/`, `demo.html`) if they are not actively deployed, reducing attack surface and repository footprint.
5. **Add Automated Linting and Dependency Auditing in CI**:
   Introduce a lightweight GitHub Actions workflow running `npm audit` and an HTML/JS linter (e.g., ESLint with `eslint-plugin-security`) to catch unsafe `innerHTML` assignments before code is pushed to `gh-pages`.
