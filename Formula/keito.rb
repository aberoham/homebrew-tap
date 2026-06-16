class Keito < Formula
  desc "CLI for AI agents and humans to track billable time against Keito"
  homepage "https://github.com/osodevops/keito-cli"
  version "0.1.7"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/keito-cli/releases/download/v0.1.7/keito-aarch64-apple-darwin.tar.gz"
      sha256 "d3cee0a6fa806e0538a74bb40314ec2a0b882b0b742df9f8e5f57d91c7f060ec"
    else
      url "https://github.com/osodevops/keito-cli/releases/download/v0.1.7/keito-x86_64-apple-darwin.tar.gz"
      sha256 "1a6a6dca65493d8e1cdaa9450661f4e3c17ef68d67133ffa8099e7a66c14234a"
    end
  end

  on_linux do
    url "https://github.com/osodevops/keito-cli/releases/download/v0.1.7/keito-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "99a579eac9ca462763ad86752ad6f1fa601b4e99b3d2173d6684cd05b2ce70d5"
  end

  def install
    bin.install "keito"
  end

  test do
    assert_match "keito #{version}", shell_output("#{bin}/keito --version")
  end
end
