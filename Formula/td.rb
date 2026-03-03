class Td < Formula
  desc "Todoist CLI - fast, offline-capable task management"
  homepage "https://github.com/osodevops/todoist-agent-cli"
  version "0.1.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/todoist-agent-cli/releases/download/v0.1.1/td-aarch64-apple-darwin.tar.gz"
      sha256 "ed5fad7c5e3e57db83de9c3c02b500de20181c3e34ffe9e2d7d9a358cc04602b"
    else
      url "https://github.com/osodevops/todoist-agent-cli/releases/download/v0.1.1/td-x86_64-apple-darwin.tar.gz"
      sha256 "dcbfea286516b7775cd5f2c3832ede804bbb83206d3264c4e386697a1ab7bfd8"
    end
  end

  on_linux do
    url "https://github.com/osodevops/todoist-agent-cli/releases/download/v0.1.1/td-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "84604e0b722314d3d1e482f2de4a79e21dd03fdb8ff3af80a0b560d9826a62ca"
  end

  def install
    bin.install "td"
  end

  test do
    assert_match "td", shell_output("#{bin}/td --version")
  end
end
