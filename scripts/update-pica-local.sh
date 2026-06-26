#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$REPO_ROOT"
"$REPO_ROOT/scripts/sync-pica-upstream.sh"
exec "$REPO_ROOT/scripts/install-pica-local.sh"
