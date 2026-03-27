class XeroCli < Formula
  desc "A fast, intelligent command-line interface for the Xero Accounting API"
  homepage "https://github.com/osodevops/xero-cli"
  version "0.5.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/xero-cli/releases/download/v0.5.0/xero-aarch64-apple-darwin.tar.gz"
      sha256 "8c9fb2f70b35767c08d7d758aa11a81ac53472d8af7d78b25a9f0ee7a76d9706"
    else
      url "https://github.com/osodevops/xero-cli/releases/download/v0.5.0/xero-x86_64-apple-darwin.tar.gz"
      sha256 "21c82be5c321981c064c4a21c85a0d68c3235dfe808636465242b9e06e2b5dc0"
    end
  end

  on_linux do
    url "https://github.com/osodevops/xero-cli/releases/download/v0.5.0/xero-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "b9675217b7d0c2c53f90f345aff9229eea41ea5416236e8393d107f5d9fadb84"
  end

  def install
    bin.install "xero"
  end

  test do
    assert_match "xero", shell_output("#{bin}/xero --version")
  end
end
