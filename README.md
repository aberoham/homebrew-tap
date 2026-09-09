# Aberoham's Homebrew tap

A personal distribution point for command-line tools I contribute to or maintain.
This tap is independent of the upstream projects' official release channels.

## Distribution status

| Tool | Intended package | Status |
| --- | --- | --- |
| Microsoft Teams | `aberoham/tap/teams-cli` | Existing formula still points to upstream v0.2.7; personal release publishing is being completed |
| Microsoft Outlook (`olk`) | `aberoham/tap/olk` (macOS cask) | Planned; not yet available in this tap |
| Microsoft Entra (`entra`) | `aberoham/tap/entra` | Planned; requires a public release source |

Teams and Outlook will distribute my tested integration builds. Entra will
follow my own stable releases. See the [distribution plan](docs/distribution-plan.md)
for packaging, versioning, upgrades and implementation status.

## Using this tap

```sh
brew tap aberoham/tap
```

Use fully qualified package names when selecting this tap. Adding it does not
replace a tool already installed from another tap. Wait for the status table to
mark a personal package available before using it as that tool's release channel.
Switching an existing installation will require explicit package replacement;
future packages with distinct executable names may support side-by-side use.

## Repository history

This repository began as a fork of [OSO's Homebrew tap](https://github.com/osodevops/homebrew-tap).
Its inherited formulas remain present while their future maintenance is reviewed.
Their presence does not make this the official OSO tap or indicate that they track
my own releases. For OSO's official packages, use the upstream tap's instructions.

## License

MIT, as declared by the upstream tap. Neither repository ships a LICENSE file.
