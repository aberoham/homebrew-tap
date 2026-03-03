class XeroCli < Formula
  desc "A fast, intelligent command-line interface for the Xero Accounting API"
  homepage "https://github.com/osodevops/xero-cli"
  version "0.4.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/xero-cli/releases/download/v0.4.1/xero-aarch64-apple-darwin.tar.gz"
      sha256 "cd28da1b2e0fa99c6e8aee13a99de5bf057a9e3923444f6eca3c144ee115d43e"
    else
      url "https://github.com/osodevops/xero-cli/releases/download/v0.4.1/xero-x86_64-apple-darwin.tar.gz"
      sha256 "5012dbbad46442f94172454cb13020bc98d707e39f15af1a75cfec7bfa6d6c22"
    end
  end

  on_linux do
    url "https://github.com/osodevops/xero-cli/releases/download/v0.4.1/xero-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "0618a0469d41345c0df09eed41e2002a68a5a8ce79bbd31bb052f6113c1ba4b8"
  end

  def install
    bin.install "xero"
  end

  test do
    assert_match "xero", shell_output("#{bin}/xero --version")
  end
end
