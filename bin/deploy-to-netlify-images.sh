#!/bin/bash
set -e

# This script deploys the onramp-new directory to Netlify, with images-only.html as the main page.

# The first time you run this, you will be prompted to create a new site.
# Subsequent runs will deploy to the same site.

# Get the directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_ROOT="$SCRIPT_DIR/.."

cd "$PROJECT_ROOT"

# Temporarily rename images-only.html to index.html for deployment
#cp onramp-new/images-only.html onramp-new/index.html

echo "Deploying to Netlify from $PWD"
netlify deploy --dir=onramp-new --prod

# Revert the rename
rm onramp-new/index.html
