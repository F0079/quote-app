#!/bin/sh
#
# Install a project-local gitleaks binary into .tools/.
#
#   sh scripts/install-gitleaks.sh
#
# The binary is pinned and checksum-verified. .tools/ is gitignored, so this
# script — not the binary — is what lives in Git. The pre-commit hook uses
# .tools/gitleaks when it exists, and falls back to a gitleaks on PATH.
set -eu

VERSION=8.30.1
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
DEST="$ROOT/.tools"
BASE="https://github.com/gitleaks/gitleaks/releases/download/v$VERSION"

case "$(uname -s)" in
  Linux)  os=linux ;;
  Darwin) os=darwin ;;
  *) echo "unsupported OS: $(uname -s)" >&2; exit 1 ;;
esac

case "$(uname -m)" in
  x86_64|amd64)   arch=x64 ;;
  arm64|aarch64)  arch=arm64 ;;
  *) echo "unsupported architecture: $(uname -m)" >&2; exit 1 ;;
esac

asset="gitleaks_${VERSION}_${os}_${arch}.tar.gz"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

echo "downloading $asset"
curl -sSfL "$BASE/$asset" -o "$tmp/$asset"
curl -sSfL "$BASE/gitleaks_${VERSION}_checksums.txt" -o "$tmp/checksums.txt"

( cd "$tmp" && grep " $asset\$" checksums.txt | sha256sum -c - ) \
  || { echo "checksum verification failed" >&2; exit 1; }

mkdir -p "$DEST"
tar -xzf "$tmp/$asset" -C "$DEST" gitleaks
chmod +x "$DEST/gitleaks"

echo "installed $("$DEST/gitleaks" version) -> ${DEST#"$ROOT"/}/gitleaks"
