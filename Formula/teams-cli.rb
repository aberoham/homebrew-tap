class TeamsCli < Formula
  desc "Microsoft Teams CLI for AI agents and automation"
  homepage "http://msteamscli.com/"
  license "MIT"
  version "0.7.1-alpha.1"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aberoham/ms-teams-cli/releases/download/v0.7.1-alpha.1/teams-v0.7.1-alpha.1-aarch64-apple-darwin.tar.gz"
      sha256 "27b56d8d5314fbceafbfca622f78f6410efdac7b680bb948ae373cb9df18cf16"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aberoham/ms-teams-cli/releases/download/v0.7.1-alpha.1/teams-v0.7.1-alpha.1-x86_64-apple-darwin.tar.gz"
      sha256 "c0d94112088896cb7cf94adf03c9f8d1d9f395eabc6b6a982d051ff372e6a878"
    end
  end

  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aberoham/ms-teams-cli/releases/download/v0.7.1-alpha.1/teams-v0.7.1-alpha.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "e9d47a6cf014ca8369e48402d297ff7a80c7d2b6901ece62066a4f6e0375be8c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aberoham/ms-teams-cli/releases/download/v0.7.1-alpha.1/teams-v0.7.1-alpha.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "9bd454417e912477520a7618cb3db64c84ade0c9a17f2cd3f76954951f51df31"
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
