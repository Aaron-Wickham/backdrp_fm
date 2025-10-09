#!/bin/bash

# Start Firebase Emulators for BACKDRP.FM development

echo "🚀 Starting Firebase Emulators..."
echo ""
echo "Emulator UI will be available at: http://localhost:4000"
echo "Auth Emulator: http://localhost:9099"
echo "Firestore Emulator: http://localhost:8080"
echo "Storage Emulator: http://localhost:9199"
echo ""
echo "Press Ctrl+C to stop emulators"
echo ""

firebase emulators:start
