class TeamsCliNext < Formula
  desc "Microsoft Teams CLI for AI agents and automation (fork prereleases)"
  homepage "http://msteamscli.com/"
  version "0.9.1-alpha.1"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aberoham/ms-teams-cli/releases/download/v0.9.1-alpha.1/teams-v0.9.1-alpha.1-aarch64-apple-darwin.tar.gz"
      sha256 "76880bdb23a8c84b81e3cdd7f3f5cf25e2e73f092a533e58c93259e9204c9854"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aberoham/ms-teams-cli/releases/download/v0.9.1-alpha.1/teams-v0.9.1-alpha.1-x86_64-apple-darwin.tar.gz"
      sha256 "b2d844388f658a4ce610a101cbd2cd901187924613e7c0ee6973474e996e2bf8"
    end
  end

  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aberoham/ms-teams-cli/releases/download/v0.9.1-alpha.1/teams-v0.9.1-alpha.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "871d3f587622b67d886345a10330f8a2aa034eea563a296774ccfe75503d62a5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aberoham/ms-teams-cli/releases/download/v0.9.1-alpha.1/teams-v0.9.1-alpha.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "0e67513d25aed89998cf3107bc4c93d33d5a3fd4aad1b90b9506397161f65c8d"
    end
  end

  conflicts_with "teams-cli", because: "both install a `teams` executable"

  def install
    bin.install "bin/teams"
    man1.install "share/man/man1/teams.1"
    man5.install "share/man/man5/teams-config.5"
    man7.install Dir["share/man/man7/*.7"]
    doc.install Dir["share/doc/teams/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/teams --version")
    assert_match "Microsoft Teams CLI", shell_output("#{bin}/teams --help")
  end
end
