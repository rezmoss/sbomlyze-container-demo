# SBOMlyze container SBOM demo

A minimal Alpine-based container example whose CycloneDX SBOM includes both operating-system and application packages.

This repository is a deliberately small, realistic dogfood project for the
[SBOMlyze Diff GitHub Action](https://github.com/marketplace/actions/sbomlyze-diff).
It commits a CycloneDX 1.6 JSON SBOM at `sbom/image.cdx.json` and compares each pull request
with the file at the PR base commit. SBOM generation remains a separate concern;
the Action only reviews dependency, integrity, license, and compliance drift.

## Try the five demonstration PRs

First commit and push the repository's initial state to `main`. Create each
scenario from a fresh `main` branch:

```sh
git switch main
git switch -c demo/normal-dependency-upgrade
./scripts/apply-scenario.sh normal-dependency-upgrade
git add .
git commit -m "demo: upgrade a dependency"
git push -u origin demo/normal-dependency-upgrade
```

Open a pull request, inspect the SBOMlyze Job Summary, then repeat with another
scenario name:

| Scenario | Expected check | What a reviewer should see |
|---|---|---|
| `normal-dependency-upgrade` | Pass | An intentional version upgrade with new hashes |
| `same-version-hash-change` | Fail | Hash changed while name and version stayed fixed |
| `new-deep-transitive-dependency` | Fail | New dependency at policy depth 4 or deeper |
| `disallowed-license` | Fail | A newly introduced `GPL-3.0-only` package |
| `compliance-score-regression` | Fail | Supplier metadata removal drops NTIA below 90 |

The script accepts only those five names. It copies reviewed fixtures; it does
not run package-manager or PR-provided commands. Scenario details live in
[`DEMO_SCENARIOS.md`](DEMO_SCENARIOS.md).

## How this example is wired

- `.github/workflows/sbom-review.yml` pins SBOMlyze v0.5.1 by its full commit SHA.
- `.github/sbom-policy.json` contains the intentionally strict demo policy.
- `sbom/image.cdx.json` is the head SBOM and `baseline: git` is implicit.
- PR comments are disabled, so fork PRs remain useful through the Job Summary.
- SARIF uploads are skipped for fork PRs because their token is read-only.

The image fixture distinguishes APK packages (`alpine-baselayout`, `musl`) from the bundled Node application and npm dependency, so reviewers see both package ecosystems in one report. The Dockerfile is illustrative; production images should pin a reviewed base-image digest.

This project exists for demonstration and beta testing, not as a production
application template.
