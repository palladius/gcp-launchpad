# User Manual

This document explains how to configure and use the dynamic features of the Onramp presentation.

## Dynamic Configuration via Query String

The presentation can be customized at runtime by providing parameters in the URL's query string. This allows you to generate unique presentation links for different events or locations.

### Available Parameters

*   `onramp_url` (Required)
    *   **Purpose:** Sets the URL for the credit reclaim link.
    *   **Behavior:** If this parameter is present, the "Credit Link" status will be "ACTIVE" (green), and the links will point to this URL. If it is omitted, the status will be "INACTIVE" (red), and the credit links will be hidden.
    *   **Example:** `?onramp_url=https://trygcp.dev/claim/h2-labs-milano25`

*   `location` (Optional)
    *   **Purpose:** Displays a location name on the introductory slide.
    *   **Example:** `?location=Milan, Italy`

*   `emoji` (Optional)
    *   **Purpose:** Displays an emoji on the introductory slide, next to the location.
    *   **Example:** `?emoji=🇮🇹`

### Combining Parameters

You can combine these parameters using the `&` symbol.

#### Geneva Example

To create a link for an event in Geneva, Switzerland, with a Swiss flag emoji and a specific reclaim URL, you would construct the URL like this:

Text Version:

* PROD GitHub Pages: https://palladius.github.io/gcp-launchpad/?onramp_url=https://trygcp.dev/claim/h2-labs-geneva&location=Geneva&emoji=🇨🇭
* Dev (localhost): http://localhost:8081/?onramp_url=https://trygcp.dev/claim/h2-labs-geneva&location=Geneva&emoji=🇨🇭

Or for the image-only version:

* GH Pages: https://palladius.github.io/gcp-launchpad-images/?onramp_url=https://trygcp.dev/claim/h2-labs-geneva&location=Geneva,CH&emoji=🇨🇭

This will result in a presentation with a green "ACTIVE" status, a credit link pointing to the Geneva URL, and "Geneva, CH 🇨🇭" displayed on the first slide.

**Note**. Netlify links have been removed as they are currently broken. GitHub Pages (GHP) works fine!

Result:

![Version with credits](image-1.png)

![Version without credits](image-2.png)

## Server-Side Configuration (Cloud Run)

For deployments in environments like Cloud Run, the `onramp_url` can also be set via a `data-onramp-url` attribute on the `<body>` tag of the HTML. A server-side process can read an environment variable (e.g., `ONRAMP_URL`) and inject its value into the HTML before serving it.

**Note:** The query string parameter `?onramp_url=` will always take precedence over the `data-onramp-url` attribute if both are present.
