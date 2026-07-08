#!/bin/bash
set -euo pipefail

# Run from anywhere — always targets this ios folder.
IOS_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$IOS_DIR/.." && pwd)"

cd "$PROJECT_DIR"
flutter pub get

cd "$IOS_DIR"
export COCOAPODS_CURL_OPTIONS="--http-version 1.1"

if [[ "${1:-}" == "--fresh" ]]; then
  rm -rf Pods Podfile.lock
  pod install --repo-update
else
  pod install
fi

echo "Done. Pod installation complete."
