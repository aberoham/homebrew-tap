class TeamsCli < Formula
  desc "Microsoft Teams CLI for AI agents and automation"
  homepage "http://msteamscli.com/"
  version "0.2.3"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/ms-teams-cli/releases/download/v0.2.3/teams-v0.2.3-aarch64-apple-darwin.tar.gz"
      sha256 "55812508c22f0319f2ca5c059678196892d1ba3cc7e655fa21166ac035eb48a2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/osodevops/ms-teams-cli/releases/download/v0.2.3/teams-v0.2.3-x86_64-apple-darwin.tar.gz"
      sha256 "ddecb523958b84a3a10621d6b96667f0c44bac6f75667e6de37b1b223f39a940"
    end
  end

  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/ms-teams-cli/releases/download/v0.2.3/teams-v0.2.3-aarch64-unknown-linux-musl.tar.gz"
      sha256 "566612398570dc722a3cb185d24858ed4f935a0d12f22537faa0afcf121452cc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/osodevops/ms-teams-cli/releases/download/v0.2.3/teams-v0.2.3-x86_64-unknown-linux-musl.tar.gz"
      sha256 "cbb8f5480a7e99cdfd621712999c2a843bc06ab57b6b212dbcc3439a6788dcd0"
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
