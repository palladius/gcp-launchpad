This page aims at publicizing onramp credits page, parametric in some fields,

Idea:

```bash
just onramp
open http://localhost:8080/?event=milan
```

More info: b/425877073

## Publish

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
