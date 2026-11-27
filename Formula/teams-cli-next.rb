class TeamsCliNext < Formula
  desc "Microsoft Teams CLI for AI agents and automation (fork prereleases)"
  homepage "http://msteamscli.com/"
  version "0.13.1-alpha.1"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aberoham/ms-teams-cli/releases/download/v0.13.1-alpha.1/teams-v0.13.1-alpha.1-aarch64-apple-darwin.tar.gz"
      sha256 "71ad622794f643d92c06962f24bd175d82c42b0ed53850d5048543894b379144"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aberoham/ms-teams-cli/releases/download/v0.13.1-alpha.1/teams-v0.13.1-alpha.1-x86_64-apple-darwin.tar.gz"
      sha256 "9b2d898d090d754c01fb6db480ecab6f5ae1eb529cb42b507731499f28cc506c"
    end
  end

  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aberoham/ms-teams-cli/releases/download/v0.13.1-alpha.1/teams-v0.13.1-alpha.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "833900f0093d237ada71a947ca92a6673071d420165c4b797872aa038beb92b1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aberoham/ms-teams-cli/releases/download/v0.13.1-alpha.1/teams-v0.13.1-alpha.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "ff4e3435287a243bac10ed0bdc04bbe2c6eb187dec61e62498d88a476cd93733"
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
