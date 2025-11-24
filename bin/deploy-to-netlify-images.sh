#!/bin/bash
set -e

# This script deploys the onramp-images directory to the 'onramp-images' Netlify site.
# The first time you run this, you will be prompted to create the new site.

# Get the directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_ROOT="$SCRIPT_DIR/.."

cd "$PROJECT_ROOT"

echo "Deploying 'onramp-images' directory to site 'onramp-images' on Netlify..."
netlify deploy --dir=onramp-images --prod --site onramp-images
