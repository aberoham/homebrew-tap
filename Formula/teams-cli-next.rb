class TeamsCliNext < Formula
  desc "Microsoft Teams CLI for AI agents and automation (fork prereleases)"
  homepage "http://msteamscli.com/"
  version "0.7.1-alpha.3"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aberoham/ms-teams-cli/releases/download/v0.7.1-alpha.3/teams-v0.7.1-alpha.3-aarch64-apple-darwin.tar.gz"
      sha256 "4ab1277467325ba99ffc6fea46a32d5e91a24a5cb30187ba2b84f8e437bf381a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aberoham/ms-teams-cli/releases/download/v0.7.1-alpha.3/teams-v0.7.1-alpha.3-x86_64-apple-darwin.tar.gz"
      sha256 "d4ab6c51ad1cb5720dd2e5c1d1ef9f1c66bf8ad9a51b5996d1e06af627a3aad1"
    end
  end

  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aberoham/ms-teams-cli/releases/download/v0.7.1-alpha.3/teams-v0.7.1-alpha.3-aarch64-unknown-linux-musl.tar.gz"
      sha256 "b0a366cf45fe8f87b45f521b5b1bc4b269e741148c4d12a0d2798d831e0cdd4e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aberoham/ms-teams-cli/releases/download/v0.7.1-alpha.3/teams-v0.7.1-alpha.3-x86_64-unknown-linux-musl.tar.gz"
      sha256 "7634f1b6f043ee38548a5a4a53b7ddb079c4fbf3db2c8cefce24d3156b14786d"
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
