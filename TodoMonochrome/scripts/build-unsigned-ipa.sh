#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="${ROOT_DIR}/build"
IPA_PATH="${BUILD_DIR}/TodoMonochrome-unsigned.ipa"
DERIVED_DATA_PATH="${BUILD_DIR}/DerivedData"

mkdir -p "${BUILD_DIR}"

echo "==> Building (unsigned) ..."
xcodebuild \
  -project "${ROOT_DIR}/TodoMonochrome.xcodeproj" \
  -scheme "TodoMonochrome" \
  -configuration "Release" \
  -sdk "iphoneos" \
  -destination "generic/platform=iOS" \
  -derivedDataPath "${DERIVED_DATA_PATH}" \
  CODE_SIGNING_ALLOWED=NO \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGN_IDENTITY="" \
  DEVELOPMENT_TEAM="" \
  PROVISIONING_PROFILE_SPECIFIER="" \
  build

APP_PATH="${DERIVED_DATA_PATH}/Build/Products/Release-iphoneos/TodoMonochrome.app"
if [[ ! -d "${APP_PATH}" ]]; then
  echo "Could not find built app at: ${APP_PATH}"
  exit 1
fi

echo "==> Packaging IPA ..."
TMP_DIR="$(mktemp -d)"
mkdir -p "${TMP_DIR}/Payload"
cp -R "${APP_PATH}" "${TMP_DIR}/Payload/"

(cd "${TMP_DIR}" && /usr/bin/zip -qry "${IPA_PATH}" "Payload")
rm -rf "${TMP_DIR}"

echo "Wrote: ${IPA_PATH}"
