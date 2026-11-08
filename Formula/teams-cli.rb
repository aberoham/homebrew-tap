class TeamsCli < Formula
  desc "Microsoft Teams CLI for AI agents and automation"
  homepage "http://msteamscli.com/"
  version "0.12.0"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aberoham/ms-teams-cli/releases/download/upstream-v0.12.0/teams-v0.12.0-aarch64-apple-darwin.tar.gz"
      sha256 "8b172b9e1a4c9d2f6fe06562f0b54529e92a3f59640d50a5f65395e6ecb8b9b7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aberoham/ms-teams-cli/releases/download/upstream-v0.12.0/teams-v0.12.0-x86_64-apple-darwin.tar.gz"
      sha256 "57324c998ae01b7ff6d16836622a9eed72cfd78f73a36c3e054bbb5081c65a80"
    end
  end

  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aberoham/ms-teams-cli/releases/download/upstream-v0.12.0/teams-v0.12.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "30afae9c5ff8530192d20111cc744be039e881d9d606bef7c376f3c2201deaee"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aberoham/ms-teams-cli/releases/download/upstream-v0.12.0/teams-v0.12.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "0c3d9b702a02fad37da600cce3feb970f534cd3fbf116139af6de57dbb489c01"
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
