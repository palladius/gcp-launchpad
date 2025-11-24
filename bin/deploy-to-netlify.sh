#!/bin/bash
set -e

# This script deploys the onramp-new directory to Netlify.

# The first time you run this, you will be prompted to create a new site.
# Subsequent runs will deploy to the same site.

echo "Deploying to Netlify..."
netlify deploy --dir=onramp-new --prod
