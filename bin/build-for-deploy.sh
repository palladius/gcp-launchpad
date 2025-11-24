#!/bin/bash
set -e

# This script prepares the site for deployment by consolidating the two presentations
# into a single directory.

# Create a clean directory for the site
rm -rf _site
mkdir -p _site/images

# Copy the main presentation to the root of the site
cp -r onramp-new/* _site/

# Copy the image-only presentation to the /images subdirectory
cp -r onramp-images/* _site/images/
