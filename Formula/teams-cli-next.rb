class TeamsCliNext < Formula
  desc "Microsoft Teams CLI for AI agents and automation (fork prereleases)"
  homepage "http://msteamscli.com/"
  version "0.8.1-alpha.1"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aberoham/ms-teams-cli/releases/download/v0.8.1-alpha.1/teams-v0.8.1-alpha.1-aarch64-apple-darwin.tar.gz"
      sha256 "2d9184f419d20f42d4f3d05d8ac14211fd15d26da5ac2d3cf407e05c998ad868"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aberoham/ms-teams-cli/releases/download/v0.8.1-alpha.1/teams-v0.8.1-alpha.1-x86_64-apple-darwin.tar.gz"
      sha256 "837e6c1afaeae781c49611b54af0b0341154fc4e0b2aee96585853c633feb2d4"
    end
  end

  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aberoham/ms-teams-cli/releases/download/v0.8.1-alpha.1/teams-v0.8.1-alpha.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "bf07173d853e9bf8849f57a7514cee52e39fcb881078f2efb2a08cda0252b4c5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aberoham/ms-teams-cli/releases/download/v0.8.1-alpha.1/teams-v0.8.1-alpha.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "d04a4de51e6692d428e1900807b60060e85a1b38c32dae6b2320bd3ba773cfaa"
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
