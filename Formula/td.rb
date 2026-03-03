class Td < Formula
  desc "Todoist CLI - fast, offline-capable task management"
  homepage "https://github.com/osodevops/todoist-agent-cli"
  version "0.1.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/todoist-agent-cli/releases/download/v0.1.1/td-aarch64-apple-darwin.tar.gz"
      sha256 "d52b366868147a3af62cb96ed7fcb5287827f5481a294e7ea22ae61bc57df5fe"
    else
      url "https://github.com/osodevops/todoist-agent-cli/releases/download/v0.1.1/td-x86_64-apple-darwin.tar.gz"
      sha256 "088817883a59f507b63a6d249fc116b2a18a5898626ebf52f12dfe43263b6aa0"
    end
  end

  on_linux do
    url "https://github.com/osodevops/todoist-agent-cli/releases/download/v0.1.1/td-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "f37bfd4bd2c5155f3085165fda1446693de0e04f944bc9ac7b8db03caab8dacb"
  end

  def install
    bin.install "td"
  end

  test do
    assert_match "td", shell_output("#{bin}/td --version")
  end
end
