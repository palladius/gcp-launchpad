# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.7] - 2025-11-28

### Changed

- [images] Added a direct link to the `WORKSHOP.md` on GitHub in the workshop section.
- [images] Updated the footer with a "made with 💛" message and credit.
- [images] Removed the debug link from the footer.

## [0.1.6] - 2025-11-28

### Changed

- [images] Refactored the "Start Here" menu (Slide 4) with a modern, colorful grid layout using Google colors (Blue, Red, Yellow, Green) and emojis.
- [images] Added the Gemini logo to the "Install Gemini CLI" button for better branding.
- [images] Implemented "UP" arrow key navigation to quickly return to the main menu from any slide.
- [images] Updated internal links to use Reveal.js anchors (`#/workshop`, `#/credits`, `#/gemini-cli`, etc.) for seamless navigation.
- [images] Renamed the `cli` section ID to `gemini-cli` to follow kebab-case URL conventions.
- [images] Prettified the "Install Gemini CLI" slide with a code block and direct documentation link.
- [images] Added a `.tip` CSS class for stylish, consistent hints with a lightbulb emoji.
- [images] Fixed the API Key code block (Slide 24) to use proper syntax highlighting.
- [images] Left-aligned the main menu items for better visual flow.

## [0.1.5] - 2025-11-28

### Changed

- [images] Re-implemented the default hand salutation emoji ('👋') to ensure a warm welcome even when no emoji is specified in the URL.

## [0.1.4] - 2025-11-28

### Changed

- [images] Refactored QR code styling to CSS, making the self-referencing QR code 2x larger, centered, and framed in a perfectly proportioned square for a stronger visual impact and improved scannability.

## [0.1.3] - 2025-11-28

### Changed

- [images] Added a default hand salutation emoji ('👋') if no emoji is provided in the URL parameters, ensuring a warm welcome for all users.

## [0.1.2] - 2025-11-28

### Added

- [images] Added date and optional location information with emojis to the first slide for a more personalized and robust welcome.

## [0.1.1] - 2025-11-28

### Added

- [images] Added a self-referencing QR code to the first slide, allowing users to easily capture the presentation URL.

### Changed

- [images] Updated the self-referencing QR code background to be gray on localhost and official Google Blue on other environments for clear visual distinction.
- Bumped version to 0.1.1.

## [0.1.0] - 2025-11-28

### Added

- [images] Added slide numbers for easy navigation.
- [images] Implemented optional slide sections, toggled by a `show_workshop` URL parameter.
- [images] Created a dynamic credit redemption slide (slide 8) with a status box, scannable QR code, and a clickable URL with emojis.

### Changed

- **Major Version Bump to 0.1.0**: This release marks a significant milestone in features and interactivity.
- [images] Refined the UI on the credit redemption slide for better visual hierarchy and usability.

### Fixed

- [images] Corrected QR code scannability issues by adding a white background and padding.

## [0.0.3] - 2025-11-24

### Added

- Deployment of `onramp-images` to a separate GitHub Pages site (`gcp-launchpad-images`).
- Documentation of GitHub Pages deployment requirements (PAT, repository initialization).
- `bin/gh-logs.sh` script for checking GitHub Actions workflow logs.

### Changed

- Updated GitHub Actions workflow (`.github/workflows/deploy.yml`) to deploy `_site` (containing both `onramp-new` and `onramp-images` content).
- Modified GitHub Actions deployment to target the `gcp-launchpad` repository only, consolidating deployments.
- Refactored deployment strategy to avoid cross-repository PAT issues for main deployment.
- Ensured `gcp-launchpad-images` repository is initialized with a `gh-pages` branch for deployment target.
- Updated `bin/gh-logs.sh` to handle workflow name variations and fetch specific logs.
- [images] Ricc Removed two Italian-only slides from Images version.

### Fixed

- Resolved persistent GitHub Actions deployment failures related to `Resource not accessible by integration` and `Invalid username or token` errors by providing detailed PAT setup instructions and repository initialization steps.
- Corrected Netlify CLI deployment scripts (`bin/deploy-to-netlify.sh`, `bin/deploy-to-netlify-images.sh`) to explicitly use site IDs and programmatically configure build settings, resolving `npm build` failures and incorrect publish directories.

## [0.0.2] - 2025-11-24

### Added

- Dynamic `onramp_url` handling via query string or `data-onramp-url` attribute.
- Dynamic `location` and `emoji` handling via query string.
- A status indicator on the first slide to show if the credit link is active.
- A personalized welcome message on the first slide that uses the `location` and `emoji`.
- A self-referencing debug link in the footer.
- A version number in the footer.
- A `docs/USER_MANUAL.md` file to document the dynamic features.
- A `docs/WHY_ENV_WONT_WORK.md` file to explain the client-server environment separation.
- `netlify.toml` file to configure Netlify deployments.
- `bin/deploy-to-netlify.sh` and `bin/deploy-to-netlify-images.sh` scripts for deploying to Netlify.

### Changed

- The main presentation is now in the `onramp-new/` directory.
- The image-only presentation is now in the `onramp-images/` directory.
- The `justfile` has been updated to reflect the new directory structure.

### Removed

- The `generate-env.sh` script and the `env.js` files.
- The old PHP-based presentation has been moved to `old-php-slides/`.
