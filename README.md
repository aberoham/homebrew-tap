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

## Repository history

This repository began as a fork of [OSO's Homebrew tap](https://github.com/osodevops/homebrew-tap).
Its inherited formulas remain present while their future maintenance is reviewed.
Their presence does not make this the official OSO tap or indicate that they track
my own releases. For OSO's official packages, use the upstream tap's instructions.

## License

MIT, as declared by the upstream tap. Neither repository ships a LICENSE file.
