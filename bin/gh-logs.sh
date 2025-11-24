#!/bin/bash
set -e

WORKFLOW_NAME="[Gemini] Deploy static content to Pages"

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
