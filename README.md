# kestrel-contracts

Shared wire contracts for the Kestrel medical drone delivery platform. The JSON Schemas in `schemas/` are the source of truth; bindings for TypeScript, Go, Python and Rust are generated from them.

| Schema | Used by |
| --- | --- |
| `Mission` | gateway, dispatch, console |
| `TelemetryFrame` | telemetry, gateway, console |
| `CustodyEvent` | compliance, gateway, console |
| `AirspaceCheck` | dispatch, gateway |

## Layout

- `schemas/` JSON Schema (2020-12)
- `src/` TypeScript bindings (`@kestrel/contracts`, published to GitHub Packages)
- `go/` Go module
- `python/` `kestrel-contracts` wheel (pydantic v2 models)
- `rust/` `kestrel-contracts` crate (`publish = false`; consumers depend on it through this repo's git tag, e.g. `git = "…/kestrel-contracts", tag = "v<version>"`)

## Changing a contract

1. Edit the schema. Additive changes only on a minor version; removals need a major.
2. `./scripts/generate.sh`
3. Bump the version in `package.json`, `python/pyproject.toml` and `rust/Cargo.toml` together.
4. Merge and tag `v<version>`. The publish workflow does the rest.

## Release

Tagging `vX.Y.Z` runs `.github/workflows/publish.yml`: npm publish to GitHub Packages, a `go/vX.Y.Z` tag for the Go module, and a Python wheel attached to the release.
