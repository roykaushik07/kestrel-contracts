#!/usr/bin/env bash
# Regenerate language bindings from schemas/*.schema.json.
# Requires: npx (quicktype), python3 with datamodel-code-generator.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCHEMAS="$ROOT/schemas"

echo "==> TypeScript"
npx quicktype --src-lang schema --lang typescript --just-types \
  --top-level Mission --src "$SCHEMAS" \
  -o "$ROOT/src/generated.ts"

echo "==> Go"
npx quicktype --src-lang schema --lang go --package contracts \
  --src "$SCHEMAS" -o "$ROOT/go/contracts.go"

echo "==> Rust"
npx quicktype --src-lang schema --lang rust --density dense \
  --visibility public --src "$SCHEMAS" -o "$ROOT/rust/src/generated.rs"

echo "==> Python"
for f in "$SCHEMAS"/*.schema.json; do
  name="$(basename "$f" .schema.json | tr '-' '_')"
  datamodel-codegen --input "$f" --input-file-type jsonschema \
    --output-model-type pydantic_v2.BaseModel \
    --output "$ROOT/python/kestrel_contracts/${name}.py"
done

echo "done"
