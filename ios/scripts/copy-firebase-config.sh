#!/bin/bash

# Script to copy the correct GoogleService-Info.plist based on the build configuration
# This script should be added as a "Run Script" build phase in Xcode

set -e

ENVIRONMENT=${CONFIGURATION,,}  # Convert to lowercase

# Extract just the environment name (dev, staging, prod) from configuration like "Debug-Dev"
if [[ $ENVIRONMENT == *"dev"* ]]; then
  ENV="Dev"
elif [[ $ENVIRONMENT == *"staging"* ]]; then
  ENV="Staging"
elif [[ $ENVIRONMENT == *"prod"* ]] || [[ $ENVIRONMENT == "release" ]]; then
  ENV="Prod"
else
  ENV="Dev"  # Default to dev
fi

SOURCE_PATH="${SRCROOT}/Runner/Firebase/${ENV}/GoogleService-Info.plist"
DEST_PATH="${SRCROOT}/Runner/GoogleService-Info.plist"

echo "📱 Copying Firebase config for ${ENV} environment"
echo "   Source: ${SOURCE_PATH}"
echo "   Destination: ${DEST_PATH}"

if [ ! -f "$SOURCE_PATH" ]; then
  echo "❌ ERROR: Firebase config file not found at ${SOURCE_PATH}"
  echo "   Please download the Firebase configuration files. See docs/FIREBASE_SETUP.md"
  exit 1
fi

cp "${SOURCE_PATH}" "${DEST_PATH}"
echo "✅ Firebase config copied successfully"
