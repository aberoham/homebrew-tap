class XeroCli < Formula
  desc "A fast, intelligent command-line interface for the Xero Accounting API"
  homepage "https://github.com/osodevops/xero-cli"
  version "0.5.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/xero-cli/releases/download/v0.5.1/xero-aarch64-apple-darwin.tar.gz"
      sha256 "f22a6562b121f0698232da92b6f851a808c57653f0ffbbf42079bfc3b95b52af"
    else
      url "https://github.com/osodevops/xero-cli/releases/download/v0.5.1/xero-x86_64-apple-darwin.tar.gz"
      sha256 "2f583af6f77ce5d105e44371bef76909b6c28cf135ff7200d96f922b9dc35da7"
    end
  end

  on_linux do
    url "https://github.com/osodevops/xero-cli/releases/download/v0.5.1/xero-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "fc43e99a483f2bd29c0a4e3c5df20a71cf9f860688c7671fe8b73d1c685e2994"
  end

  def install
    bin.install "xero"
  end

  test do
    assert_match "xero", shell_output("#{bin}/xero --version")
  end
end
