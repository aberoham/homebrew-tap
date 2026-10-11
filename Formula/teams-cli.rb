class TeamsCli < Formula
  desc "Microsoft Teams CLI for AI agents and automation"
  homepage "http://msteamscli.com/"
  version "0.9.0"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aberoham/ms-teams-cli/releases/download/upstream-v0.9.0/teams-v0.9.0-aarch64-apple-darwin.tar.gz"
      sha256 "6ccae6006ec98e8eeb89a6b432281b5b25b93600198a3ad1f05a5c9deae73220"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aberoham/ms-teams-cli/releases/download/upstream-v0.9.0/teams-v0.9.0-x86_64-apple-darwin.tar.gz"
      sha256 "39d48a693305469042e82b397b8c7174a110b3b16b5b45089297e774499376a9"
    end
  end

  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aberoham/ms-teams-cli/releases/download/upstream-v0.9.0/teams-v0.9.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "595f5d39ef2a00924cea15b1ec5fbb2bf6f2b796810ccea3fea0f66e31e6a590"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aberoham/ms-teams-cli/releases/download/upstream-v0.9.0/teams-v0.9.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "2adcdb87d0737244750358b58bb2f4cc79caf342f45bf6ccb40932be57537636"
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
