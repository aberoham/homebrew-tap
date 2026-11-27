class TeamsCli < Formula
  desc "Microsoft Teams CLI for AI agents and automation"
  homepage "http://msteamscli.com/"
  version "0.13.0"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aberoham/ms-teams-cli/releases/download/upstream-v0.13.0/teams-v0.13.0-aarch64-apple-darwin.tar.gz"
      sha256 "4ae51f1fce55108a2e3aa61f6a82039372d0e123132cecb2f8d7e088b70b275d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aberoham/ms-teams-cli/releases/download/upstream-v0.13.0/teams-v0.13.0-x86_64-apple-darwin.tar.gz"
      sha256 "4ad6de02e49de88c349baafe70bec81d61a46abf610c789afe02cab912ffe4d8"
    end
  end

  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aberoham/ms-teams-cli/releases/download/upstream-v0.13.0/teams-v0.13.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "f18ffb6f0250e40878b2ee0850be024d174b440a0db3518251a7cc38b60aee71"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aberoham/ms-teams-cli/releases/download/upstream-v0.13.0/teams-v0.13.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "8fcd6ec54628a003474167c7a17a6f3277d0704c311ebb0c1900262a78c8a5a9"
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
