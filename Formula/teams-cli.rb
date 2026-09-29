class TeamsCli < Formula
  desc "Microsoft Teams CLI for AI agents and automation"
  homepage "http://msteamscli.com/"
  version "0.8.0"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aberoham/ms-teams-cli/releases/download/upstream-v0.8.0/teams-v0.8.0-aarch64-apple-darwin.tar.gz"
      sha256 "90e8fb7128446203a2565f03dab933941d564d7376254418651394a906321c1a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aberoham/ms-teams-cli/releases/download/upstream-v0.8.0/teams-v0.8.0-x86_64-apple-darwin.tar.gz"
      sha256 "edcd3927df0a92013bf8b5e4ee212f5855d93c2984f913979d13003fdc80ebaf"
    end
  end

  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aberoham/ms-teams-cli/releases/download/upstream-v0.8.0/teams-v0.8.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "9ea347ccd9ad0383693564d517ac41c95518a026c00c721d7bf0fc341147055a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aberoham/ms-teams-cli/releases/download/upstream-v0.8.0/teams-v0.8.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "10f52959c7eeaeff472aa6732f003b2651c3604a2b2e3cf521a9b65589f17ac7"
    end
  end

  conflicts_with "teams-cli-next", because: "both install a `teams` executable"

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
