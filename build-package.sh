#!/bin/bash
#
# Build script for Grafana 12.3.0-mod
# Creates a standalone Linux amd64 package
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VERSION="12.3.0-mod"
PKG_NAME="grafana-${VERSION}"
TMP_DIR="/tmp/grafana-pkg"
OUTPUT_FILE="${SCRIPT_DIR}/grafana-${VERSION}.linux-amd64.tar.gz"

echo "=== Building Grafana ${VERSION} package ==="

# Clean up
rm -f "${OUTPUT_FILE}"
rm -rf "${TMP_DIR}"

# Create package directory structure
mkdir -p "${TMP_DIR}/${PKG_NAME}/bin"
mkdir -p "${TMP_DIR}/${PKG_NAME}/plugins-bundled"

# Copy binaries
cp "${SCRIPT_DIR}/bin/linux-amd64/grafana" "${TMP_DIR}/${PKG_NAME}/bin/"
cp "${SCRIPT_DIR}/bin/linux-amd64/grafana-server" "${TMP_DIR}/${PKG_NAME}/bin/"
cp "${SCRIPT_DIR}/bin/linux-amd64/grafana-cli" "${TMP_DIR}/${PKG_NAME}/bin/"

# Copy directories
cp -r "${SCRIPT_DIR}/conf" "${TMP_DIR}/${PKG_NAME}/"
cp -r "${SCRIPT_DIR}/public" "${TMP_DIR}/${PKG_NAME}/"

# Copy files
cp "${SCRIPT_DIR}/LICENSE" "${TMP_DIR}/${PKG_NAME}/"
cp "${SCRIPT_DIR}/NOTICE.md" "${TMP_DIR}/${PKG_NAME}/"
cp "${SCRIPT_DIR}/README.md" "${TMP_DIR}/${PKG_NAME}/"

# Create VERSION file
echo "${VERSION}" > "${TMP_DIR}/${PKG_NAME}/VERSION"

# Create tarball
cd "${TMP_DIR}"
tar -czf "${OUTPUT_FILE}" "${PKG_NAME}"

# Show results
echo ""
echo "=== Package contents ==="
tar -tzf "${OUTPUT_FILE}" | grep -E "^${PKG_NAME}/[^/]+/?$" | sort

echo ""
echo "=== Package size ==="
ls -lah "${OUTPUT_FILE}"

# Cleanup
rm -rf "${TMP_DIR}"

echo ""
echo "=== Done! ==="
echo "Package: ${OUTPUT_FILE}"
