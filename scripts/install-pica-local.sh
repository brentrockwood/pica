#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BIN_DIR="${PICA_BIN_DIR:-$HOME/bin}"

if ! command -v node >/dev/null 2>&1; then
  echo "node is required" >&2
  exit 1
fi

if ! command -v npm >/dev/null 2>&1; then
  echo "npm is required" >&2
  exit 1
fi

node -e 'const [major, minor] = process.versions.node.split(".").map(Number); if (major < 22 || (major === 22 && minor < 19)) process.exit(1);' || {
  echo "node >=22.19.0 is required" >&2
  exit 1
}

cd "$REPO_ROOT"
npm install --ignore-scripts
npm run build

mkdir -p "$BIN_DIR"

cat > "$BIN_DIR/pica" <<EOF
#!/usr/bin/env bash
set -euo pipefail

exec node "$REPO_ROOT/packages/coding-agent/dist/cli.js" "\$@"
EOF

cat > "$BIN_DIR/pica-dev" <<EOF
#!/usr/bin/env bash
set -euo pipefail

exec "$REPO_ROOT/pi-test.sh" "\$@"
EOF

chmod +x "$BIN_DIR/pica" "$BIN_DIR/pica-dev"

echo "Installed pica and pica-dev to $BIN_DIR"
echo "pica runs built dist; pica-dev runs source via pi-test.sh"
