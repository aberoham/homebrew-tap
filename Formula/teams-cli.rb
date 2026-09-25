class TeamsCli < Formula
  desc "Microsoft Teams CLI for AI agents and automation"
  homepage "http://msteamscli.com/"
  license "MIT"
  version "0.7.1-alpha.2"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aberoham/ms-teams-cli/releases/download/v0.7.1-alpha.2/teams-v0.7.1-alpha.2-aarch64-apple-darwin.tar.gz"
      sha256 "f254ff381d67ee9fd6eaf8313a0d0a07f300c10fb292975a565c6220db67b883"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aberoham/ms-teams-cli/releases/download/v0.7.1-alpha.2/teams-v0.7.1-alpha.2-x86_64-apple-darwin.tar.gz"
      sha256 "054e5cb0448dab67f2a6e106b7c930ef13fba80af5ec026fe0143621aeb396fc"
    end
  end

  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aberoham/ms-teams-cli/releases/download/v0.7.1-alpha.2/teams-v0.7.1-alpha.2-aarch64-unknown-linux-musl.tar.gz"
      sha256 "340faa9022b41416f24481ac4e7aea6e6f826d0f3dcca306db6a956ec2df9ee7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aberoham/ms-teams-cli/releases/download/v0.7.1-alpha.2/teams-v0.7.1-alpha.2-x86_64-unknown-linux-musl.tar.gz"
      sha256 "5bf86b34a0af50365b28c0e90b0b24ff28ea23702d18bbe9e2b0e8acee7e484f"
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
