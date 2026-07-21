#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
image=pica-ci-local

docker build --file "$repo_root/Dockerfile.test" --tag "$image" "$repo_root"
docker run --rm "$image" sh -c 'cp -a /workspace-base/. /workspace && cd /workspace && npm run build && npm run check && npm test'
