class TeamsCli < Formula
  desc "Microsoft Teams CLI for AI agents and automation"
  homepage "http://msteamscli.com/"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/ms-teams-cli/releases/download/v0.2.7/teams-v0.2.7-aarch64-apple-darwin.tar.gz"
      sha256 "11d9cac40cfc3552a85da3a482774302735b648eeb01f161dc34e6ac61a99a14"
    end
    if Hardware::CPU.intel?
      url "https://github.com/osodevops/ms-teams-cli/releases/download/v0.2.7/teams-v0.2.7-x86_64-apple-darwin.tar.gz"
      sha256 "8c7f79ff118144ecbd2f76d5cbd2a11e3297433d8cb831e453d2ce0b799e726c"
    end
  end

  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/ms-teams-cli/releases/download/v0.2.7/teams-v0.2.7-aarch64-unknown-linux-musl.tar.gz"
      sha256 "3c0611cd38299a864cadf3d5ebbbca03cb9815b174a4535fc8529524147b0ead"
    end
    if Hardware::CPU.intel?
      url "https://github.com/osodevops/ms-teams-cli/releases/download/v0.2.7/teams-v0.2.7-x86_64-unknown-linux-musl.tar.gz"
      sha256 "4a7c527c56c634d1fe9d59b0bf333cfd8e2b2ff55ece0fc429a9afcc97b36c55"
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
