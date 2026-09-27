# Aberoham's Homebrew tap

A personal distribution point for command-line tools I contribute to or maintain.
This tap is independent of the upstream projects' official release channels.

## Distribution status

| Tool | Intended package | Status |
| --- | --- | --- |
| Microsoft Teams | `aberoham/tap/teams-cli` | Available; follows prereleases of [aberoham/ms-teams-cli](https://github.com/aberoham/ms-teams-cli) `next` |
| Microsoft Outlook (`olk`) | `aberoham/tap/olk` (macOS cask) | Available; follows prereleases of [aberoham/olkcli](https://github.com/aberoham/olkcli) `next` |
| Microsoft Entra (`entra`) | `aberoham/tap/entra` | Available; follows stable releases of [aberoham/ms-entra-cli](https://github.com/aberoham/ms-entra-cli) |

Teams and Outlook distribute my tested integration builds. Entra follows my own
stable releases. See the [distribution plan](docs/distribution-plan.md) for
packaging, versioning, upgrades and implementation status.

## Using this tap

```sh
brew install aberoham/tap/teams-cli
brew install --cask aberoham/tap/olk
brew install aberoham/tap/entra
```

Use fully qualified package names when selecting this tap; that also trusts the
one package under Homebrew's tap trust rules. Installing from here does not
replace a tool already installed from another tap: uninstall that one first.
Afterwards check `command -v` for the tool, since an older copy elsewhere on
`PATH` can still run first.

## Signed macOS releases

From the cutover versions listed in `scripts/macos-release-policy.rb`, macOS binaries are
Developer ID signed by `2VLHJGU477` and notarized by Apple. The updater
workflows refuse to publish a release whose installed binary fails that check.
[docs/macos-release-verification.md](docs/macos-release-verification.md) describes the gate.
[docs/signing-a-new-project.md](docs/signing-a-new-project.md) walks through adding signing
to another project you create or fork.

## License

MIT — see [LICENSE](LICENSE).
