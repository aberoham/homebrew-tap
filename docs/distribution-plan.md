# Personal Homebrew distribution for Teams, Outlook and Entra

Updated: 2026-09-28.
Status: all three packages are published; see the status table in the README.

## Outcome

Use one public repository, `aberoham/homebrew-tap`, installed as `aberoham/tap`.
It is my distribution point for tools I contribute to and tools I maintain.
Each source repository builds and publishes its own versioned release archives.
The tap holds the small Homebrew recipes that select those archives and verify
checksums. It does not contain the source repositories or build a combined release.

| Tool | Release source | Tap entry | Installed command | Release policy |
| --- | --- | --- | --- | --- |
| Teams | `aberoham/ms-teams-cli` (`upstream-vX.Y.Z`) | `Formula/teams-cli.rb` | `teams` | Upstream's stable releases, rebuilt from upstream's commit and signed |
| Teams, next | `aberoham/ms-teams-cli` (`vX.Y.Z-alpha.N`) | `Formula/teams-cli-next.rb` | `teams` | My tested `next` integration builds |
| Outlook | `aberoham/olkcli` | `Casks/olk.rb` | `olk` | My tested `next` integration builds |
| Entra | `aberoham/ms-entra-cli` | `Formula/entra.rb` | `entra` | My stable releases; optional prereleases |

Teams and Entra formulas target macOS and Linux. Outlook initially keeps its
existing macOS cask packaging; its Linux archives remain direct downloads.
A Linux Outlook formula is a separate addition, not a prerequisite for this tap.
Scoop, npm and Model Context Protocol registry publishing are outside this
Homebrew phase.

Fresh installs:

```sh
brew install aberoham/tap/teams-cli        # or aberoham/tap/teams-cli-next
brew install --cask aberoham/tap/olk
brew install aberoham/tap/entra
```

Use fully qualified names to select this tap explicitly. Adding a tap alone does
not switch an existing installation. Homebrew documents that selection in
[its taps guide](https://docs.brew.sh/Taps). Since Homebrew 6.0.0 it
ignores packages from taps it does not trust; installing by fully qualified
name trusts that one package, so no separate `brew trust` step is needed. See
[Homebrew's tap trust guide](https://docs.brew.sh/Tap-Trust).

## Current evidence

- The tap began as a fork of OSO's tap. The inherited OSO formulas have been
  removed; it now carries only Teams, Outlook and Entra, with updater
  workflows for each.
- Teams is Rust, released as prereleases from the fork's `next`, which carries
  upstream plus selected pull requests.
- Outlook is Go, released as prereleases from the fork's `next`, which carries
  upstream main plus selected open pull requests. GoReleaser builds the
  archives but no longer publishes anything; see the Outlook paragraph below.
- Entra is Rust, binary `entra`, published from the public
  `aberoham/ms-entra-cli`. Its release workflow builds macOS, Linux and Windows
  archives; the tap's `update-entra-formula.yml` publishes the formula.
- Every macOS binary is Developer ID signed and notarized from a per-tool
  cutover release onward. Earlier releases predate the cutover and remain
  unsigned. See [macOS release verification](macos-release-verification.md).
- The versions currently published are the ones in `Formula/` and `Casks/`.

## Ownership and maintenance

Retain `aberoham/homebrew-tap`: the existing address is suitable and does not
require a new repository merely because it was created as a fork. Rebrand it as
personal and credit inherited code; this is done, and the inherited formulas
have been removed. Do not blindly synchronize the upstream tap in future, as
that could undo package URLs, branding and workflows.

Keep the shared distribution guide in the tap. Keep build details in each source
repository. Each tool releases independently, so an Outlook build failure cannot
prevent a Teams or Entra upgrade. Each recipe records a specific version, archive
URL and SHA-256; never point a recipe at a mutable `next` archive or a moving
`latest/download` URL.

## Replacement now, coexistence later

The first version keeps the ordinary commands `teams` and `olk`. It replaces the
user's selected upstream installation through an explicit package switch. It
does not force-overwrite arbitrary files on PATH.

For Teams, inspect the installed formula's source, uninstall that formula, then
install `aberoham/tap/teams-cli`. For Outlook, uninstall the installed upstream
cask and install `aberoham/tap/olk`. Do not use cask `--zap`: auth/config data should
not be removed as part of a package switch. Confirm the actual installed names
before issuing uninstall commands. Returning to upstream is the reverse process.
After switching, inspect `command -v teams` or `command -v olk` as well as
`--version`; an unrelated `~/.local/bin` installation may precede Homebrew on PATH.

Advantages: existing scripts, skill instructions, man pages and completions keep
working; only one version of each command is selected. Costs: comparing upstream
and my build requires switching packages, and config/keyring state remains
shared. Shared state can complicate rollback if an alpha changes its format.

Future coexistence should use distinct package and executable names, such as
`teams-next` and `olk-next`. Homebrew can rename the installed binary; this does
not inherently require a second Rust binary target or separate release builds.
Man pages and completions also need distinct install names. Renaming an executable
alone does not isolate profiles, credentials or configuration. Profile selection
and storage behavior must be checked before claiming isolation.

A distinct formula can alternatively be keg-only, with the original binary run
by its full path. That avoids executable renaming but is less convenient for
scripts. Using two taps with the same formula name is not a dependable coexistence
strategy. Do not make rolling `@next` versioned formulas the default design.

Relevant operations are described in the [Homebrew manual](https://docs.brew.sh/Manpage.html).
The extra work is packaging and verification; it does not automatically double
all project maintenance or require duplicate build pipelines.

## Branches and versions

Teams and Outlook use `next` to combine selected pull requests. Upstream-tracking
`main` remains useful, but the release workflow must be guarded against publishing
from an upstream synchronization. Prefer merging current upstream into a published
integration branch to preserve history; rebasing an individual unpublished pull
request branch remains fine. Released tags are immutable.

Synchronizing Git history and choosing a package version are separate steps.
A rebase does not change package versions or upgrade installed users by itself.
For example, after upstream Teams 0.7.0, a candidate might be
`0.7.1-alpha.1`, then `0.7.1-alpha.2`. Choose the final base after reviewing the
included changes and previous releases. Semantic Versioning orders 0.7.0 below
0.7.1-alpha.1, which is below 0.7.1. It does not make 0.7.0-alpha.1 newer than
0.7.0. Test Homebrew's interpretation independently and set explicit versions.

Entra has no external maintainer to wait for: release from its own `main` with
ordinary stable versions when ready. Add a `next` channel only if one is needed.
The stable Entra formula must not silently move to prereleases; use an explicit
future `entra-next` entry if both channels need to be installable.

## Publishing responsibilities

1. Each source repository validates the commit it builds, builds the supported
   targets, and publishes archives plus checksums to its own GitHub Release.
   That is the tagged commit, except for a Teams mirror, described below.
2. The tap's own updater then reads the published release; no source repository
   writes to the tap.
3. Tap validation checks source allowlists, explicit version, asset names, archive
   layout and hashes; installs the package on supported runners; and runs the
   tool's version and help commands (`teams --version`, `olk version`,
   `entra version`) without touching live Microsoft accounts. The reported
   version must match the release exactly. On macOS, releases from each tool's
   signing cutover must also pass the Developer ID and notarization check in
   `scripts/verify-macos-release.rb` before the binary is run.
4. Publish the recipe only after checks pass. Confirm the committed recipe matches
   all expected release assets. A GitHub prerelease badge alone proves none of this.

For Teams, a tag push on the fork runs its release workflow over the tagged
commit: the full CI matrix, the tag equal to the `Cargo.toml` version, and only
the same three prerelease forms as the tap.
Its Homebrew, Scoop and documentation jobs run only upstream, and `next` has no
auto-tag workflow. The fork's `mirror-upstream.yml` also calls that release
workflow, from `next` on weekdays at 08:47 UTC, for each new stable upstream
release. That run builds upstream's tagged commit, checked out from upstream's
own repository, with the fork's CI, signing, notarization and provenance
attestation. It publishes the result as `upstream-vX.Y.Z` with archives named
`teams-vX.Y.Z-<target>`. The `upstream-vX.Y.Z` tag marks the fork's `next`
commit that ran the workflow, not the source; `teams-vX.Y.Z-source.txt`,
attested in the same statement as the archives, names the upstream commit, and
the tap checks both before publishing.

The tap's `teams-formula.yml` serves both Teams formulas; one caller per
channel names its channel. `update-teams-formula.yml` publishes
`upstream-vX.Y.Z` releases to `teams-cli`, and
`update-teams-next-formula.yml` publishes `-alpha.N`, `-beta.N` and `-rc.N`
tags, for which RubyGems and Homebrew agree on ordering, to `teams-cli-next`.
`scripts/teams_channel.rb` holds each channel's tag rule, formula and
attestation cutover. By default each updater takes the highest version of its
own channel among all of the fork's published releases, since the fork
publishes both. Each channel writes only its own formula. The updater refuses
to lower the version unless a tag is named explicitly.
It verifies the build provenance attestation of every mirrored release and of
fork prereleases from 0.8.1-alpha.1, requiring the fork's `release.yml` as the
signer and `next` (mirror) or the release tag (prerelease) as the source ref.
For a mirrored release it also checks the attested source manifest names
upstream's commit for that tag, and that the one signed statement covering the
manifest also covers each archive at the checksum the formula pins. It
installs and tests the candidate on macOS Arm and Intel and Linux x86-64 and
Arm. It commits to `main` only from `main`'s own workflow, and only if `main`'s
formula has not
changed since the candidate was prepared; otherwise the run fails and asks to
be re-run. Runs of one channel are serialized, and so are all publishes.

The two Teams formulas declare `conflicts_with` each other rather than
coexisting: both install `teams`, so scripts, skills and man pages keep one
name, and switching channels is an uninstall and an install.

For Outlook, the fork's release runs CI first and accepts the same three
prerelease forms. GoReleaser builds the Linux and Windows archives in one job
and the macOS archives in another, with publishing skipped in both. A third job
signs and notarizes the macOS binaries, and a final job without Apple
credentials writes `checksums.txt` over the signed archives and creates the
GitHub prerelease with `gh release create`. GoReleaser therefore uploads no
cask, and the fork holds no tap credential. The tap's `update-olk-cask.yml`
writes `Casks/olk.rb` from the release's `checksums.txt` under the same rules as
the Teams updater, and installs and runs the candidate on macOS Arm and Intel
before committing. The existing Go module path stays, for version ldflags. npm
and Model Context Protocol registry publishing stay off on the fork because its
`PUBLISH_NPM` variable is unset.

For Entra, the release workflow runs CI, requires the tag to equal the
`Cargo.toml` version, and marks a release as a prerelease only when its version
carries a hyphen. It builds all five targets natively, including Arm Linux on
GitHub's Arm runner, and runs each packaged binary before the macOS binaries
are signed and notarized. The tap's
`update-entra-formula.yml` mirrors the Teams updater, with two differences. It
accepts stable tags, and its unattended run takes only the newest stable
release; a prerelease reaches the formula only when named. It compares versions
with Homebrew's own `Version` class by running under `brew ruby`, so the
RubyGems ordering caveat above does not apply to it.

## Credentials

No long-lived personal access token is used anywhere in this design. Each source
workflow's own `GITHUB_TOKEN` publishes releases in that source repository; it
does not grant write access to the separate tap, and a tag pushed using it
generally does not trigger another push workflow. Keep manual tag pushes or
explicitly design workflow dispatch/reuse. See
[GitHub's trigger documentation](https://docs.github.com/en/actions/how-tos/write-workflows/choose-when-workflows-run/trigger-a-workflow).

The Apple signing certificate and notarization key are the one exception to
short-lived credentials. They are stored only in each source repository's
`release` environment, which requires my approval for every run and admits only
release tags, plus the Teams fork's `next` branch for its upstream mirror. They
never reach the tap. See
[Shipping a new project as a signed macOS binary](signing-a-new-project.md).

The tap updaters need only public release URLs plus a push to their own
repository, which its own `GITHUB_TOKEN` already permits, so no source
repository triggers them or holds a credential for them. The Teams updaters run
each weekday, `teams-cli` at 09:17 UTC and `teams-cli-next` at 09:27 UTC, and
pick up the newest release of their channel. Either can also be run at once,
optionally naming a tag:

    gh workflow run update-teams-formula.yml --repo aberoham/homebrew-tap -f tag=upstream-v0.8.0
    gh workflow run update-teams-next-formula.yml --repo aberoham/homebrew-tap -f tag=v0.8.1-alpha.1

The Entra and Outlook updaters run the same way, at 09:47 UTC, from
`update-entra-formula.yml` and `update-olk-cask.yml`.

A public repository's scheduled workflows are disabled after 60 days without
repository activity; GitHub's notice email is the prompt to re-enable them.

## Implementation sequence and acceptance

1. Rebrand the existing tap, add this guide, and make its current incomplete state
   visible. The inherited formulas have since been removed.
2. Repair Teams `next`, validate on all three CI operating systems, remove the
   stored `HOMEBREW_TAP_TOKEN` from the fork, and publish one current prerelease.
   Verify all four Homebrew architecture URLs and hashes, installation, upgrade
   and rollback.
3. Prepare Outlook publisher changes in an isolated checkout, preserving existing
   local edits. Verify macOS Intel/Arm archives, fork release URLs, cask installation
   and upgrade. Publish its first tested integration release and cask.
4. Publish Entra's first stable release, then add `Formula/entra.rb` generated
   from that release's checksums. Never commit a formula whose download URLs
   point at a release that does not exist; `test/fixtures/entra-0.0.1.rb` is the
   template, not a formula.
5. Keep the three-tool status table current. Completion means all eligible tools
   install from this tap and upgrade to a subsequent release, not merely that the
   tap repository exists or an alpha tag was pushed.

Steps 1 and 4 are complete. Each tool now has a later, signed release in the
tap, but the updater workflows test fresh installs only. Steps 2 and 3 stay
open until an upgrade from the first release, and a rollback to it, have been
checked on a real machine.
