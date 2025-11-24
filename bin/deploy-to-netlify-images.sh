#!/bin/bash
set -e

# Netlify-specific ENV vars
# You can get these from your Netlify dashboard
# NETLIFY_AUTH_TOKEN: Your personal access token
# NETLIFY_SITE_ID: The ID of the site you want to deploy to (for onramp-images this is 7f419d2e-4589-46da-b48e-e7efba1751e1)

SITE_ID="7f419d2e-4589-46da-b48e-e7efba1751e1"
SITE_NAME="onramp-images"

# This script deploys the onramp-images directory to the 'onramp-images' Netlify site.

# Get the directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_ROOT="$SCRIPT_DIR/.."

cd "$PROJECT_ROOT"

echo "Updating build settings for site '$SITE_NAME' ($SITE_ID) on Netlify..."
netlify api updateSite --data '{ "site_id": "'$SITE_ID'", "body": { "build_settings": { "cmd": "", "dir": "onramp-images" } } }'

echo "Deploying 'onramp-images' directory to site '$SITE_NAME' on Netlify..."
netlify deploy --dir=onramp-images --prod --site $SITE_ID