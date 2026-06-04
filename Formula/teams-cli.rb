class TeamsCli < Formula
  desc "Microsoft Teams CLI for AI agents and automation"
  homepage "http://msteamscli.com/"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/ms-teams-cli/releases/download/v0.2.4/teams-v0.2.4-aarch64-apple-darwin.tar.gz"
      sha256 "0d734a32f6d06550893f6b67e93b283a24f59532070af4f5288866d7d5505248"
    end
    if Hardware::CPU.intel?
      url "https://github.com/osodevops/ms-teams-cli/releases/download/v0.2.4/teams-v0.2.4-x86_64-apple-darwin.tar.gz"
      sha256 "dffa5da20444bfa33fc240021c8dbad312665acc41a0a71409cd0226af88274e"
    end
  end

  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/ms-teams-cli/releases/download/v0.2.4/teams-v0.2.4-aarch64-unknown-linux-musl.tar.gz"
      sha256 "f0b3712f10a500df7204462f9025473b23986cc66d821d29ffd77479c9c9593b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/osodevops/ms-teams-cli/releases/download/v0.2.4/teams-v0.2.4-x86_64-unknown-linux-musl.tar.gz"
      sha256 "6e5937d8877ea396b4042ba83e3fe34db5fc3f8df85c6bce1c6b30a80f649935"
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
