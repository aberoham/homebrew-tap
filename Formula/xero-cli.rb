class XeroCli < Formula
  desc "A fast, intelligent CLI for the Xero Accounting API"
  homepage "https://github.com/osodevops/xero-cli"
  version "0.4.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/xero-cli/archive/refs/tags/v0.4.0.tar.gz"
      sha256 "2952b0bc7fe30cfff031cbc2ce15e29cf520642d305d45fa8c972781b7c8e79b"
    else
      url "https://github.com/osodevops/xero-cli/releases/download/v0.3.0/xero-x86_64-apple-darwin.tar.gz"
      sha256 "23464759e52ee20fecac6c85a86d802f14522a7658b5bfc6ac9600d364756c1d"
    end
  end

  on_linux do
    url "https://github.com/osodevops/xero-cli/releases/download/v0.3.0/xero-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "04b41530b161f469c3d8ba9bd2daecd56f9b9dda08de3a8d38ea46bb90732949"
  end

  def install
    bin.install "xero"
  end

  test do
    assert_match "xero #{version}", shell_output("#{bin}/xero --version")
  end
end
