# Demonstration scenarios

Each fixture starts from the SBOM committed to `main`. Use one scenario per pull
request so that the review signal stays obvious.

## Normal dependency upgrade

Updates one direct dependency's version and hashes. It should be visible but
allowed: changing hashes are expected when the version changes.

## Same-version hash change

Changes a component hash without changing its name or version. The
`deny_integrity_drift` policy fails this because it can indicate republishing or
tampering and needs an explicit investigation.

## New deep transitive dependency

Adds a dependency chain whose deepest new component is at depth 4. The
`max_depth` policy fails it and the report shows why the package is transitive.

## Disallowed license

Adds a package declared as `GPL-3.0-only`. The demo policy denies that license.
This is test data, not a statement about whether that license is suitable for
another project.

## Compliance-score regression

Removes supplier metadata from one component. The resulting NTIA score drops
below the policy threshold of 90, demonstrating that metadata quality can be a
reviewed regression just like a dependency change.
