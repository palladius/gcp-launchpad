#!/bin/bash
set -e

SITE_NAME="onramp-new"
SITE_ID="5fe90bd5-5158-422e-a162-cef927f0e8ca" # onramp-new site ID

# This script deploys the onramp-new directory to the 'onramp-new' Netlify site.

# Get the directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_ROOT="$SCRIPT_DIR/.."

cd "$PROJECT_ROOT"

# Move the state.json file to a temporary location
if [ -f ".netlify/state.json" ]; then
    mv .netlify/state.json .netlify/state.json.tmp
fi

echo "Deploying 'onramp-new' directory to site 'onramp-new' on Netlify..."
netlify deploy --dir=onramp-new --prod --site onramp-new

# Move the state.json file back
if [ -f ".netlify/state.json.tmp" ]; then
    mv .netlify/state.json.tmp .netlify/state.json
fi
