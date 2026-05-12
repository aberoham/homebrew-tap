class Keito < Formula
  desc "CLI for AI agents and humans to track billable time against Keito"
  homepage "https://github.com/osodevops/keito-cli"
  version "0.1.4"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/keito-cli/releases/download/v0.1.4/keito-aarch64-apple-darwin.tar.gz"
      sha256 "d1c2c3ccddfd4616d7e5f3b8704526ab1608e3db267924d62e7e05caa973a566"
    else
      url "https://github.com/osodevops/keito-cli/releases/download/v0.1.4/keito-x86_64-apple-darwin.tar.gz"
      sha256 "5ee7dc9a4d5c5692aa8b0f4b6055f5206f02fa8fb12413b88676278dde9ef355"
    end
  end

  on_linux do
    url "https://github.com/osodevops/keito-cli/releases/download/v0.1.4/keito-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "d4694e78ccbfad51c4581e33ed1e24e277d0b05f8322a80a00078d2e0833ef7e"
  end

  def install
    bin.install "keito"
  end

  test do
    assert_match "keito #{version}", shell_output("#{bin}/keito --version")
  end
end
