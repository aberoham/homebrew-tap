# Shipping a new project as a signed macOS binary through this tap

This is the recipe for taking any command-line tool you write or fork and publishing it here signed with your Apple **Developer ID** and **notarized** by Apple, as `teams`, `entra` and `olk` are. It follows the setup already used for `teams`, `entra` and `olk`, so copy from those rather than starting fresh.

## The terms, briefly

- **Code signing (Developer ID):** `codesign` stamps the binary with your certificate, `Developer ID Application: ABRAHAM ABEL INGERSOLL (2VLHJGU477)`. macOS can then tell it comes from the real aberoham, and that it hasn't changed since. A **stable identifier** (for example `com.aberoham.entra`) plus the same certificate lets Keychain "Always Allow" grants survive upgrades.
- **Hardened runtime and timestamp:** both are required for notarization. The shared helper always adds them.
- **Notarization:** Apple scans the signed binary and records a ticket. Gatekeeper checks that ticket, online for a bare CLI, when a file carries the `com.apple.quarantine` flag. **Casks** and browser downloads get that flag; Homebrew **formulae** do not. A bare Mach-O file can't have the ticket stapled to it.
- There's no separate "attestation" step for this. Developer ID signing plus notarization is the whole thing.

| Distribution path | Sign? | Notarize? |
| --- | --- | --- |
| Homebrew formula (`Formula/*.rb`) | Yes | Yes. Formula installs aren't quarantined, but direct downloads of the same tarball are, and the tap verifier requires a ticket |
| Homebrew cask (`Casks/*.rb`) | Yes | **Required.** Otherwise Gatekeeper kills the binary, and the old fix was stripping quarantine, which we no longer do |
| Direct download from GitHub Releases | Yes | Yes |

## What already exists (reuse it, don't recreate it)

| Thing | Where |
| --- | --- |
| Certificate, private key, `.p12` bundle | Password vault: the `.p12` bundle, its password, and the public certificate are stored there as separate items |
| Signing identity (SHA-1) | `1262E82DFBF51C7712475B9E2E0D0E589DEF5DAB`, Team ID `2VLHJGU477`, expires **2031-09-17** |
| Notarization API key (team key) | Password vault (the `.p8` key file), Key ID `5QHQNSU465`, Issuer `98ea42bb-746a-43fb-9374-327d0360f6d5` |
| Signing helper and tests | `aberoham/ms-entra-cli`: `.github/scripts/macos-signing.py`, `.github/scripts/test_macos_signing.py` |
| Apple's public G2 intermediate | `.github/certificates/DeveloperIDG2CA.pem` in any of the three repos (the source is https://www.apple.com/certificateauthority/DeveloperIDG2CA.cer) |
| Reference workflows | Rust tarballs: `ms-entra-cli/.github/workflows/release.yml`. GoReleaser with notarization: `olkcli/.github/workflows/release.yml` |
| Tap-side verifier | `scripts/verify-macos-release.rb` and `scripts/macos-release-policy.rb` in this repo |

Don't make a new certificate per project. Apple limits how many Developer ID certificates you can have, and one identity keeps things simple.

## Checklist for a new project `NAME`

### 1. Repository hygiene (forks especially)

1. Look at the fork relationship (`gh api repos/aberoham/NAME --jq .parent.full_name`). Treat upstream workflows as untrusted.
2. List every workflow in `.github/workflows/`. For anything that pushes tags, publishes, or uses upstream secrets such as tap tokens, dispatch tokens or personal access tokens, either delete it from your fork or guard it with `if: github.repository == 'upstream/NAME'`. Then disable it in the Actions tab anyway.
3. Choose your integration branch and tag scheme. Forks should publish only `vX.Y.Z-alpha.N`, `-beta.N` or `-rc.N`, so they never shadow an upstream stable version. Copy the `verify-tag` job from Teams or olk.

### 2. Add the signing pieces to the source repo

1. Copy `macos-signing.py` and `test_macos_signing.py` into `.github/scripts/`, and `DeveloperIDG2CA.pem` into `.github/certificates/`.
2. If `.gitignore` contains `*.pem`, add this exception and check it with `git check-ignore -v`:
   ```gitignore
   !/.github/certificates/DeveloperIDG2CA.pem
   ```
3. Pick the identifier `com.aberoham.NAME` and **never change it**. Changing it costs every user one more Keychain prompt.

### 3. Release workflow shape

Keep three separate jobs, so that build tools and dependencies never run on a machine that holds your keys:

```
build (no secrets, no caches) ──► sign-macos (environment: release) ──► release (contents: write, no Apple secrets)
```

The signing job, adapted from Entra:

```yaml
  sign-macos:
    name: Sign macOS ${{ matrix.target }}
    needs: build
    runs-on: macos-latest
    # Defense in depth; the environment reviewer and tag ruleset are the boundary.
    if: github.repository_owner_id == 586805 && github.actor == 'aberoham' && github.triggering_actor == 'aberoham'
    environment: release
    timeout-minutes: 60            # each matrix job waits once for notarization (up to 45m)
    strategy:
      matrix:
        target: [aarch64-apple-darwin, x86_64-apple-darwin]
    env:
      RELEASE_TAG: ${{ github.ref_name }}
      TARGET: ${{ matrix.target }}
    steps:
      - uses: actions/checkout@<full-sha> # pin; copy the SHA from Entra
        with:
          persist-credentials: false
      - uses: actions/download-artifact@<full-sha>
        with:
          name: NAME-${{ matrix.target }}
      - name: Prepare signing identity
        env:
          MACOS_CERTIFICATE_P12_BASE64: ${{ secrets.MACOS_CERTIFICATE_P12_BASE64 }}
          MACOS_CERTIFICATE_PASSWORD: ${{ secrets.MACOS_CERTIFICATE_PASSWORD }}
          MACOS_SIGNING_IDENTITY: ${{ vars.MACOS_SIGNING_IDENTITY }}
          APPLE_TEAM_ID: ${{ vars.APPLE_TEAM_ID }}
        run: python3 .github/scripts/macos-signing.py prepare
      - name: Sign, notarize and verify the packaged binary
        env:
          APPLE_NOTARY_KEY_P8_BASE64: ${{ secrets.APPLE_NOTARY_KEY_P8_BASE64 }}
          APPLE_NOTARY_KEY_ID: ${{ vars.APPLE_NOTARY_KEY_ID }}
          APPLE_NOTARY_ISSUER_ID: ${{ vars.APPLE_NOTARY_ISSUER_ID }}
        shell: bash
        run: |
          set -euo pipefail
          package="NAME-${RELEASE_TAG}-${TARGET}"
          unpacked="$RUNNER_TEMP/signed-package"
          mkdir -p "$unpacked"
          tar xzf "${package}.tar.gz" -C "$unpacked"
          python3 .github/scripts/macos-signing.py sign "$unpacked/$package/bin/NAME" com.aberoham.NAME --notarize
          tar czf "${package}.tar.gz" -C "$unpacked" "$package"
      - uses: actions/upload-artifact@<full-sha>
        with:
          name: NAME-${{ matrix.target }}
          path: NAME-${{ github.ref_name }}-${{ matrix.target }}.tar.gz
          if-no-files-found: error
          overwrite: true
      - name: Remove signing credentials
        if: always()
        run: python3 .github/scripts/macos-signing.py cleanup
```

Rules that matter:

- The `release` job must have `needs: [build, sign-macos]` and must **compute checksums after signing**, from the downloaded signed artifacts.
- Don't use build caches (`Swatinem/rust-cache`, `setup-go` cache, npm cache) in release workflows.
- Pin every action to a full commit SHA.
- **GoReleaser projects:** build with `--skip=publish` in an unprivileged job, sign the packaged binaries in the signing job, then publish with `gh release create` from a third job. Copy olk. Don't sign inside a GoReleaser hook, because the hook runs the build and your credentials on the same runner.

### 4. GitHub settings (you run these; an agent can't)

Replace `NAME` with the repo name. The tag patterns below suit a fork; an original project uses `v*`.

```bash
R=aberoham/NAME
# Environment, restricted to release tags
gh api --method PUT repos/$R/environments/release --input - <<'JSON'
{"wait_timer":0,"prevent_self_review":false,"can_admins_bypass":false,
 "reviewers":[{"type":"User","id":586805}],
 "deployment_branch_policy":{"protected_branches":false,"custom_branch_policies":true}}
JSON
for p in 'v*.*.*-alpha.*' 'v*.*.*-beta.*' 'v*.*.*-rc.*'; do   # original projects: just 'v*'
  gh api --method POST repos/$R/environments/release/deployment-branch-policies -f name="$p" -f type=tag
done

# Secrets and variables, piped straight from the password vault so nothing is written to disk.
# Replace each <...> placeholder with the matching vault item reference.
op document get <P12_BUNDLE_ITEM> | base64 | tr -d '\n' | gh secret set MACOS_CERTIFICATE_P12_BASE64 --env release -R $R
op read "<P12_PASSWORD_REFERENCE>" | gh secret set MACOS_CERTIFICATE_PASSWORD --env release -R $R
gh variable set MACOS_SIGNING_IDENTITY --env release -R $R -b 1262E82DFBF51C7712475B9E2E0D0E589DEF5DAB
gh variable set APPLE_TEAM_ID --env release -R $R -b 2VLHJGU477

# Notarization key (every project notarizes)
op document get <NOTARY_KEY_ITEM> | base64 | tr -d '\n' | gh secret set APPLE_NOTARY_KEY_P8_BASE64 --env release -R $R
gh variable set APPLE_NOTARY_KEY_ID --env release -R $R -b 5QHQNSU465
gh variable set APPLE_NOTARY_ISSUER_ID --env release -R $R -b 98ea42bb-746a-43fb-9374-327d0360f6d5
```

Then protect the repository the same way as the other three:

```bash
# Only a repo admin (you) may create, move or delete release tags
gh api --method POST repos/$R/rulesets --input - <<'JSON'
{"name":"Owner-controlled release tags","target":"tag","enforcement":"active",
 "bypass_actors":[{"actor_id":5,"actor_type":"RepositoryRole","bypass_mode":"always"}],
 "conditions":{"ref_name":{"include":["refs/tags/v*"],"exclude":[]}},
 "rules":[{"type":"creation"},{"type":"update"},{"type":"deletion"}]}
JSON
# No force-push or deletion of the integration branch (add refs/heads/next for forks that use it)
gh api --method POST repos/$R/rulesets --input - <<'JSON'
{"name":"Preserve integration branch history","target":"branch","enforcement":"active",
 "bypass_actors":[],"conditions":{"ref_name":{"include":["refs/heads/main"],"exclude":[]}},
 "rules":[{"type":"non_fast_forward"},{"type":"deletion"}]}
JSON
# Only admins may update the integration branch
gh api --method POST repos/$R/rulesets --input - <<'JSON'
{"name":"Admin-only source branch updates","target":"branch","enforcement":"active",
 "bypass_actors":[{"actor_id":5,"actor_type":"RepositoryRole","bypass_mode":"always"}],
 "conditions":{"ref_name":{"include":["refs/heads/main"],"exclude":[]}},
 "rules":[{"type":"update","parameters":{"update_allows_fetch_and_merge":false}}]}
JSON
# Require SHA-pinned actions and approval for outside contributors' pull request runs
gh api --method PUT repos/$R/actions/permissions -F enabled=true -f allowed_actions=all -F sha_pinning_required=true
gh api --method PUT repos/$R/actions/permissions/fork-pr-contributor-approval -f approval_policy=all_external_contributors
```

The environment reviewer means every signing run waits for you to click **Approve** in the Actions tab. Read the settings back afterwards (`gh api repos/$R/environments/release`, `gh api repos/$R/rulesets`).

Never put these secrets at repository or organization level, and never in this tap.

### 5. Notarization

- Pass `--notarize` to `macos-signing.py sign`, and give **only that step** `APPLE_NOTARY_KEY_P8_BASE64`, `APPLE_NOTARY_KEY_ID` and `APPLE_NOTARY_ISSUER_ID`. The helper submits, waits up to 45 minutes, and fails unless Apple returns `Accepted`.
- The matrix template above signs one architecture per job, so 60 minutes covers its single wait. A job that signs both architectures in sequence waits twice and needs a longer timeout; olk's single signing job uses 105 minutes.

### 6. Tap side

1. Add the formula or cask, and an updater workflow copied from `update-entra-formula.yml` (formula) or `update-olk-cask.yml` (cask).
2. Add the project to `MacOSReleasePolicy::CUTOVERS` in `scripts/macos-release-policy.rb`: the first signed version and the identifier. Releases from that version on must pass `scripts/verify-macos-release.rb` on both macOS runners before the updater can publish. The verifier checks the Developer ID identity and the notarization ticket for every product.
3. Casks: **don't** add a quarantine-stripping `postflight` for signed and notarized releases.
4. Extend `test/verify_macos_release_test.rb` for the new product and run every test file: `for t in test/*_test.rb; do ruby "$t"; done`. A bare `ruby test/*.rb` runs only the first file.

### 7. First signed release: verify it yourself

```bash
b="$(realpath "$(brew --prefix)/bin/NAME")"
codesign --verify --strict --verbose=2 "$b"
codesign -dvvv "$b" 2>&1 | grep -E '^(Identifier|TeamIdentifier|Authority|Timestamp)|runtime'
codesign --verify --strict --check-notarization "$b"
```

Expect `Identifier=com.aberoham.NAME`, `TeamIdentifier=2VLHJGU477`, the three Authority lines, a timestamp, and `flags=0x10000(runtime)`. A fresh install should never prompt: the Keychain item the tool creates already trusts the tool's signature, so later signed upgrades read it silently. Check that by upgrading to the next signed release. The only prompt is one-time, for items written by an earlier unsigned or differently signed build; choose **Always Allow** and it won't return.

## Gotchas already hit

- `codesign -R` needs `=` in front of an inline requirement (`-R '=anchor apple generic and …'`). Without it, codesign reads the argument as a file path and every check fails.
- A blanket `*.pem` ignore rule silently drops the public G2 PEM, and signing then fails in CI.
- Build the temporary keychain under `RUNNER_TEMP`. A keychain under `~/Desktop` failed in local testing.
- Don't re-sign a Developer ID release locally, for example with an old `resign.sh`. That replaces your signature and brings back a Keychain prompt on every upgrade.
- A tag runs the workflow and signing script **from the tagged commit**. Review what you're tagging before you approve the deployment.
- Renew the certificate before **2031-09-17**. Then, in every repo's `release` environment, update both the `.p12` and password secrets **and** the `MACOS_SIGNING_IDENTITY` variable, because a new certificate has a new SHA-1 and `prepare` fails closed on a mismatch. Existing signed releases stay valid because they're timestamped.
