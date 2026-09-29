# macOS release verification

The updater test jobs verify Developer ID signatures before running installed
binaries, on both Apple Silicon and Intel. Publication depends on all test jobs.
The required Team ID is `2VLHJGU477`; identifiers and inclusive cutovers are:

| Binary | Identifier | First release requiring verification |
| --- | --- | --- |
| teams | com.aberoham.teams-cli | 0.7.1-alpha.3 |
| entra | com.aberoham.entra | 0.1.1 |
| olk | com.aberoham.olk | 1.14.1-alpha.2 |

Each release from its cutover also needs an online notarization ticket, checked with
`codesign --verify --strict --check-notarization`. A network failure or missing
ticket blocks publication. The generated olk cask keeps quarantine from the
cutover onward.

Older versions intentionally remain available for explicit rollback, with the
legacy olk quarantine hook preserved. Scheduled updates cannot downgrade the
version. The signature gate does not authenticate Linux or Windows artifacts;
the source repository's release controls remain necessary for those assets.

The gate proves the binary's signing identity, not that its code is harmless.
Protect the tap's workflows and source release authorization. A user with write
access to this tap could otherwise bypass the updater by editing recipes.

Both Teams formulas use the same gate. For `teams-cli` the version checked is
upstream's `vX.Y.Z`, not the `upstream-vX.Y.Z` release tag, because that is
what the binary reports. Every mirrored `teams-cli` release, and every
`teams-cli-next` release from 0.8.1-alpha.1, also carries a build provenance
attestation. The test jobs run `gh attestation verify` on the downloaded
archive before publishing, requiring the fork's `release.yml` as the signer;
older fork prereleases remain installable for rollbacks without that check.
