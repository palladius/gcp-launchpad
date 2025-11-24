#!/bin/bash
set -e

# This script deploys the onramp-new directory to the 'onramp-new' Netlify site.

# Get the directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_ROOT="$SCRIPT_DIR/.."

cd "$PROJECT_ROOT"

echo "Deploying 'onramp-new' directory to site 'onramp-new' on Netlify..."
netlify deploy --dir=onramp-new --prod --site onramp-new