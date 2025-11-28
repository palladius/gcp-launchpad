# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
