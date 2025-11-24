# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
