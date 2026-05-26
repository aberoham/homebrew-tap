class TeamsCli < Formula
  desc "Microsoft Teams CLI for AI agents and automation"
  homepage "https://github.com/osodevops/ms-teams-cli"
  version "0.2.2"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/ms-teams-cli/releases/download/v0.2.2/teams-v0.2.2-aarch64-apple-darwin.tar.gz"
      sha256 "4a994a06bf31a07c70cd5a334d2e0561f48ff4bdf4f219f849528d97163b5d5f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/osodevops/ms-teams-cli/releases/download/v0.2.2/teams-v0.2.2-x86_64-apple-darwin.tar.gz"
      sha256 "4c6fc03ce3c4f09742630983f2e3ba9e9c8bc4598c13781976be230dd2e53455"
    end
  end

  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/ms-teams-cli/releases/download/v0.2.2/teams-v0.2.2-aarch64-unknown-linux-musl.tar.gz"
      sha256 "9c264899b8c979d980125eb877a27963bae5ca4311a47882aa223a03e8b5f706"
    end
    if Hardware::CPU.intel?
      url "https://github.com/osodevops/ms-teams-cli/releases/download/v0.2.2/teams-v0.2.2-x86_64-unknown-linux-musl.tar.gz"
      sha256 "6f329bfdd40c3de768089f9566da5f9a0b357655966ccfe72a88c7be0bf57dc5"
    end
  end

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
