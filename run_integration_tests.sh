#!/bin/bash

# Integration Test Runner Script for BACKDRP.FM
# This script helps run integration tests with proper configuration

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}🧪 BACKDRP.FM Integration Test Runner${NC}\n"

# Check if Firebase emulators are running
check_emulators() {
    if ! lsof -i :9099 > /dev/null 2>&1; then
        echo -e "${RED}❌ Firebase Emulators are not running!${NC}"
        echo -e "${YELLOW}Please start them in another terminal:${NC}"
        echo -e "   firebase emulators:start\n"
        exit 1
    fi
    echo -e "${GREEN}✅ Firebase Emulators detected${NC}"
}

# Get available devices
get_device() {
    echo -e "\n${YELLOW}Available devices:${NC}"
    flutter devices

    echo -e "\n${YELLOW}Enter device ID (or press Enter for default):${NC}"
    read -r device_id

    if [ -z "$device_id" ]; then
        # Try to find iOS simulator or macOS
        device_id=$(flutter devices | grep -i "iphone\|macos" | head -1 | awk '{print $NF}' | tr -d '()')
    fi

    echo "$device_id"
}

# Main script
echo "Checking Firebase Emulators..."
check_emulators

DEVICE=$(get_device)

if [ -z "$DEVICE" ]; then
    echo -e "${RED}❌ No device selected${NC}"
    exit 1
fi

echo -e "\n${GREEN}Running integration tests on device: $DEVICE${NC}\n"

# Run tests
flutter test integration_test/ \
    -d "$DEVICE" \
    --dart-define=USE_FIREBASE_EMULATORS=true \
    --dart-define=ENVIRONMENT=development

echo -e "\n${GREEN}✅ Tests completed!${NC}"
echo -e "${YELLOW}View emulator data at: http://localhost:4000${NC}"
