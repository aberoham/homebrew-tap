# Personal Homebrew distribution for Teams, Outlook and Entra

Updated: 2026-09-09.
Status: current design and implementation checklist; packages are not yet published.

## Outcome

Use one public repository, `aberoham/homebrew-tap`, installed as `aberoham/tap`.
It is my distribution point for tools I contribute to and tools I maintain.
Each source repository builds and publishes its own versioned release archives.
The tap holds the small Homebrew recipes that select those archives and verify
checksums. It does not contain the source repositories or build a combined release.

| Tool | Release source | Tap entry | Installed command | Release policy |
| --- | --- | --- | --- | --- |
| Teams | `aberoham/ms-teams-cli` | `Formula/teams-cli.rb` | `teams` | My tested `next` integration builds |
| Outlook | `aberoham/olkcli` | `Casks/olk.rb` | `olk` | My tested `next` integration builds |
| Entra | Public repository to be established | `Formula/entra.rb` | `entra` | My stable releases; optional prereleases |

Teams and Entra formulas target macOS and Linux. Outlook initially keeps its
existing macOS cask packaging; its Linux archives remain direct downloads.
A Linux Outlook formula is a separate addition, not a prerequisite for this tap.
Scoop, npm and Model Context Protocol registry publishing are outside this
Homebrew phase.

Once the corresponding entries are ready, the intended fresh-install commands are:

```sh
brew tap aberoham/tap
brew install aberoham/tap/teams-cli
brew install --cask aberoham/tap/olk
brew install aberoham/tap/entra
```

These are target commands, not a claim that all three packages exist today.
Use fully qualified names to select this tap explicitly. Adding a tap alone does
not switch an existing installation. Homebrew documents that selection in
[its taps guide](https://docs.brew.sh/Taps).

## Current evidence

- The tap is a fork of OSO's tap. Its README, repository description and
  homepage have been rewritten to describe personal ownership. It contains
  21 inherited formulas, only one Teams updater workflow, and no Casks directory.
- The Teams formula still downloads upstream v0.2.7. The updater accepts my
  fork and can insert an explicit prerelease version, but no fork releases exist.
- Teams `next` remains at `5bff6b1`; its last CI run failed on Windows with main
  thread stack overflows. Upstream v0.7.0 includes a Windows stack fix. Refreshing
  `next` must retain unmerged work, including message soft deletion, while taking
  upstream improvements. The stale local `v0.5.0-alpha.1` checkout must not be
  tagged or released.
- Outlook is Go, with a two-stage GoReleaser build. Its configuration publishes
  a cask to the upstream maintainer's tap. My fork is public and has no releases.
- Entra is Rust, version 0.1.0, binary `entra`, and already has CI. A public
  release source remains a prerequisite; moving code into that public repository
  is out of scope for this plan.

## Ownership and maintenance

Retain `aberoham/homebrew-tap`: the existing address is suitable and does not
require a new repository merely because it was created as a fork. Rebrand it as
personal, credit inherited code, and stop describing inherited formulas as tools
I actively support. Audit their consumers before removing them; removal is not
needed to onboard these three tools. Do not blindly synchronize the upstream tap
in future, as that could undo package URLs, branding and workflows.

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

1. Each source repository validates the exact tagged commit, builds the supported
   targets, and publishes archives plus checksums to its own GitHub Release.
2. Only after successful publication does its publisher update the personal tap.
3. Tap validation checks source allowlists, explicit version, asset names, archive
   layout and hashes; installs the package on supported runners; and runs
   `--version` and `--help` without touching live Microsoft accounts.
4. Publish the recipe only after checks pass. Confirm the committed recipe matches
   all expected release assets. A GitHub prerelease badge alone proves none of this.

For Teams, retain the existing dispatch/updater pattern and repair it. Restrict
its automatic source to my fork so an upstream event cannot replace my
channel. Add a CI dependency inside the release workflow, a tag/package version
check, a fork prerelease-tag guard, and an upstream-only docs notification guard.
Keep Scoop disabled. Serialize releases to avoid competing tap updates.

For Outlook, keep the two-stage build and change GoReleaser's tap destination to
`aberoham/homebrew-tap`. Configure prerelease handling explicitly and verify the
cask publisher does not skip alpha tags. Keep the existing Go module path for
version ldflags. Disable fork npm and Model Context Protocol registry publishing
independently of Homebrew.
[GoReleaser cask configuration](https://goreleaser.com/customization/publish/homebrew_casks/)
and [release configuration](https://goreleaser.com/customization/publish/scm/)
are separate settings; do not assume marking a release as prerelease publishes a cask.

For Entra, extend its existing Rust CI with release packaging after its public
source is settled. Reuse the Teams packaging approach where appropriate, without
copying Teams-specific paths, documentation filenames or dependency assumptions.

## Credentials

No long-lived personal access token is used anywhere in this design. Each source
workflow's own `GITHUB_TOKEN` publishes releases in that source repository; it
does not grant write access to the separate tap, and a tag pushed using it
generally does not trigger another push workflow. Keep manual tag pushes or
explicitly design workflow dispatch/reuse. See
[GitHub's trigger documentation](https://docs.github.com/en/actions/how-tos/write-workflows/choose-when-workflows-run/trigger-a-workflow).

The tap updater needs only public release URLs plus a push to its own repository,
which its own `GITHUB_TOKEN` already permits. The cross-repository credential
exists solely to trigger that updater from a source release. Two options avoid a
stored secret for it:

- Trigger the tap's `workflow_dispatch` from the publisher's interactive session
  after a release is verified. This is the phase-one approach.
- Install a GitHub App on both repositories and mint a short-lived installation
  token inside the source workflow to send the `repository_dispatch`. Use this
  once releases are frequent enough that a manual trigger is a burden.

Outlook's GoReleaser cask publisher expects a `TAP_GITHUB_TOKEN` secret with write
access to the tap. Supply it from a GitHub App installation token minted in the
same job, or leave the cask publisher disabled and have the tap updater generate
the cask from the published release instead.

If eliminating cross-repository triggers entirely becomes a priority, the tap can
instead fetch public releases on a schedule and update itself with its own token.
That trades immediate publishing for polling and centralized release selection.
It is an alternative architecture, not required for phase one.

## Implementation sequence and acceptance

1. Rebrand the existing tap, add this guide, and make its current incomplete state
   visible. Preserve inherited formulas pending a separate inventory decision.
2. Repair Teams `next`, validate on all three CI operating systems, remove the
   need for a stored publishing credential, and publish one current prerelease.
   Verify all four Homebrew architecture URLs and hashes, installation, upgrade
   and rollback.
3. Prepare Outlook publisher changes in an isolated checkout, preserving existing
   local edits. Verify macOS Intel/Arm archives, fork release URLs, cask installation
   and upgrade. Publish its first tested integration release and cask.
4. After the Entra public repository prerequisite is satisfied, publish its first
   supported stable release and formula. Do not move private code as part of this
   work or create a nonfunctional formula with placeholder download URLs.
5. Keep the three-tool status table current. Completion means all eligible tools
   install from this tap and upgrade to a subsequent release, not merely that the
   tap repository exists or an alpha tag was pushed.
