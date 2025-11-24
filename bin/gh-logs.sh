#!/bin/bash
set -e

WORKFLOW_NAME=${1:-"[Gemini] Deploy static content to Pages"}

# Use the specific workflow name for the image-only deployment based on the deploy-images.yml file.
# The exact name is: "[Gemini] Deploy Image-Only Presentation to a Separate Repository"
WORKFLOW_NAME="[Gemini] Deploy Image-Only Presentation to a Separate Repository"

echo "Fetching the latest run ID for workflow: '$WORKFLOW_NAME'..."
RUN_ID=$(gh run list --workflow "$WORKFLOW_NAME" --limit 1 --json databaseId --jq '.[0].databaseId')

if [ -z "$RUN_ID" ]; then
  echo "Could not find any runs for workflow: '$WORKFLOW_NAME'."
  exit 1
fi

echo "Latest run ID is: $RUN_ID"
echo "Fetching logs..."
echo "----------------------------------------"

gh run view "$RUN_ID" --log