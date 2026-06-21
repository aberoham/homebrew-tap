class TeamsCli < Formula
  desc "Microsoft Teams CLI for AI agents and automation"
  homepage "http://msteamscli.com/"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/ms-teams-cli/releases/download/v0.2.5/teams-v0.2.5-aarch64-apple-darwin.tar.gz"
      sha256 "6c57d853c863fe16fe51af5e3ab9aa50e1769fe94f6ed94ce86f57a97e0b6a1c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/osodevops/ms-teams-cli/releases/download/v0.2.5/teams-v0.2.5-x86_64-apple-darwin.tar.gz"
      sha256 "0cecce62666f3b2fc6dbdd6269805f694152962dba800f1dee005e62e004755c"
    end
  end

  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/ms-teams-cli/releases/download/v0.2.5/teams-v0.2.5-aarch64-unknown-linux-musl.tar.gz"
      sha256 "6fee978f7c8f46d93de3373b6b8bc435a88dbbb62e5f0703802516465092bb53"
    end
    if Hardware::CPU.intel?
      url "https://github.com/osodevops/ms-teams-cli/releases/download/v0.2.5/teams-v0.2.5-x86_64-unknown-linux-musl.tar.gz"
      sha256 "4ed02f06089ec31f1e15f05460fd94ad689621fb6b8edb5d471e549022a795f9"
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
