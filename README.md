This page aims at publicizing onramp credits page, parametric in some fields,

Idea:

```bash
just onramp
open http://localhost:8080/?event=milan
```

Internal info:
* Bug: More info: b/425877073
* PRD: go/onramp-autobahn

Real case example: https://palladius.github.io/gcp-launchpad-images/?onramp_url=https://trygcp.dev/claim/h2-labs-geneva&location=Geneva,CH&emoji=%F0%9F%87%A8%F0%9F%87%AD

## Publish

We enabled a GHA now: https://github.com/palladius/gcp-launchpad/actions/workflows/deploy.yml

To publish this presentation as a GitHub Project Page (e.g., `https://palladius.github.io/reveal.js`), follow these steps:

1.  **Prepare for Deployment:** Ensure your presentation is ready. You may need to run build commands if the project has them (e.g., `npm run build` or `just build`).
2.  **Create `gh-pages` branch:**
    ```bash
    git checkout -b gh-pages
    ```
3.  **Clean up working directory (optional but recommended):** Remove any files not needed for the live presentation, keeping only the `dist` folder, `index.html`, `css`, `js`, `plugin` directories, and any assets.
4.  **Add all necessary files and commit:**
    ```bash
    git add .
    git commit -m 'Publishing presentation to GitHub Pages'
    ```
5.  **Push the `gh-pages` branch to GitHub:**
    ```bash
    git push origin gh-pages
    ```
6.  **Enable GitHub Pages:** Go to your repository settings on GitHub, navigate to the "Pages" section, and select the `gh-pages` branch as the source for GitHub Pages.

## Published on

Code: https://github.com/palladius/gcp-launchpad/

1. **Text version**: https://onramp-new.netlify.app/ for the TEXT version
   1. Now also published on https://palladius.github.io/gcp-launchpad/
2. **Images version**: `npm run start-images` on https://onramp-images.netlify.app/
   1.

## Features

This website allows you to attach a few interesting variables:

* `http://localhost:8081/?onramp_url=https://YOUR-NEW-URL.com` (or same from https://onramp-images.netlify.app/)
*
