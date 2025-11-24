#!/bin/bash
set -e


SITE_NAME="onramp-images"
SITE_ID="7f419d2e-4589-46da-b48e-e7efba1751e1" # onramp-images site ID

# This script deploys the onramp-images directory to the 'onramp-images' Netlify site.

# Get the directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_ROOT="$SCRIPT_DIR/.."

cd "$PROJECT_ROOT"

# Move the state.json file to a temporary location
if [ -f ".netlify/state.json" ]; then
    mv .netlify/state.json .netlify/state.json.tmp
fi

echo "Deploying 'onramp-images' directory to site 'onramp-images' on Netlify..."
netlify deploy --dir=onramp-images --prod --site 7f419d2e-4589-46da-b48e-e7efba1751e1

# Move the state.json file back
if [ -f ".netlify/state.json.tmp" ]; then
    mv .netlify/state.json.tmp .netlify/state.json
fi
