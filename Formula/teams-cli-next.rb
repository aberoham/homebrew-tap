class TeamsCliNext < Formula
  desc "Microsoft Teams CLI for AI agents and automation (fork prereleases)"
  homepage "http://msteamscli.com/"
  version "0.9.1-alpha.2"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aberoham/ms-teams-cli/releases/download/v0.9.1-alpha.2/teams-v0.9.1-alpha.2-aarch64-apple-darwin.tar.gz"
      sha256 "6b84b893a4463504cba0ffdea82fa4056df1bfeecd90cfa3be9f61d2b2018091"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aberoham/ms-teams-cli/releases/download/v0.9.1-alpha.2/teams-v0.9.1-alpha.2-x86_64-apple-darwin.tar.gz"
      sha256 "ba8d671a4588a8763fda141bbbf5ee92c45a3996f76d154eea659a95dadc0e23"
    end
  end

  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aberoham/ms-teams-cli/releases/download/v0.9.1-alpha.2/teams-v0.9.1-alpha.2-aarch64-unknown-linux-musl.tar.gz"
      sha256 "7ec38ebc9a48cf0ed058686c400f93a5ee6fc64b15dc3a15b543de1afbb40846"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aberoham/ms-teams-cli/releases/download/v0.9.1-alpha.2/teams-v0.9.1-alpha.2-x86_64-unknown-linux-musl.tar.gz"
      sha256 "fb99168558749c9fe1794c502d28a6b06de9c9a983b31d080fa1de95336fab74"
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
