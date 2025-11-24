#!/bin/bash
set -e

# Netlify-specific ENV vars
# You can get these from your Netlify dashboard
# NETLIFY_AUTH_TOKEN: Your personal access token
# NETLIFY_SITE_ID: The ID of the site you want to deploy to

SITE_NAME="onramp-new"
SITE_ID="5fe90bd5-5158-422e-a162-cef927f0e8ca" # onramp-new site ID

# This script deploys the onramp-new directory to the 'onramp-new' Netlify site.

# Get the directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_ROOT="$SCRIPT_DIR/.."

cd "$PROJECT_ROOT"

echo "Deploying 'onramp-new' directory to site '$SITE_NAME' on Netlify..."
SITE_ID="5fe90bd5-5158-422e-a162-cef927f0e8ca" # onramp-new site ID
netlify deploy --prod --site "$SITE_NAME"
