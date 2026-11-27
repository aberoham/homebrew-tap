class TeamsCliNext < Formula
  desc "Microsoft Teams CLI for AI agents and automation (fork prereleases)"
  homepage "http://msteamscli.com/"
  version "0.13.1-alpha.2"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aberoham/ms-teams-cli/releases/download/v0.13.1-alpha.2/teams-v0.13.1-alpha.2-aarch64-apple-darwin.tar.gz"
      sha256 "e3a810697fa34e14ed341cb1bcacf1dbfb33da7e0961f3e54b13ef8f8c6f99b3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aberoham/ms-teams-cli/releases/download/v0.13.1-alpha.2/teams-v0.13.1-alpha.2-x86_64-apple-darwin.tar.gz"
      sha256 "852f9f3fc0fa9944ddf33cc70c95eae2809ab7ca6a947ae315e7db249bdbb519"
    end
  end

  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aberoham/ms-teams-cli/releases/download/v0.13.1-alpha.2/teams-v0.13.1-alpha.2-aarch64-unknown-linux-musl.tar.gz"
      sha256 "ca6a4d227beafa23b083e170181c4e430810a4059916506a1924cd39a1e6aea5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aberoham/ms-teams-cli/releases/download/v0.13.1-alpha.2/teams-v0.13.1-alpha.2-x86_64-unknown-linux-musl.tar.gz"
      sha256 "d3a9660ab92b050dd66dcef6c93f3733a1f80a87d15c025f911e1f059cd64cf0"
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
