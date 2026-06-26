#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$REPO_ROOT"
git pull --ff-only
exec "$REPO_ROOT/scripts/install-pica-local.sh"
