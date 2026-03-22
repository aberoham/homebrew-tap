class QuickbooksCli < Formula
  desc "A fast, intelligent command-line interface for the QuickBooks Online API"
  homepage "https://github.com/osodevops/quickbooks-cli"
  version "0.1.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/quickbooks-cli/releases/download/v0.1.0/qb-aarch64-apple-darwin.tar.gz"
      sha256 "23c67a97b3afb39b694a4a5c1771709a1c03a7b1a2d50f36fd7869890ad8cf7b"
    else
      url "https://github.com/osodevops/quickbooks-cli/releases/download/v0.1.0/qb-x86_64-apple-darwin.tar.gz"
      sha256 "73e6f464ad81a97f3dbcdd7bce273df37d62dc2a09cce7962c4e31c41cde692e"
    end
  end

  on_linux do
    url "https://github.com/osodevops/quickbooks-cli/releases/download/v0.1.0/qb-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "92209b6814aadaee557c677ef51bb0b61e04310977111c2d37a3d09ff5881eb1"
  end

  def install
    bin.install "qb"
  end

  test do
    assert_match "qb", shell_output("#{bin}/qb --version")
  end
end
