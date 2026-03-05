class Semrush < Formula
  desc "A high-performance CLI for the Semrush API built in Rust"
  homepage "https://github.com/osodevops/semrush-cli"
  version "0.1.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/semrush-cli/releases/download/v0.1.1/semrush-aarch64-apple-darwin.tar.gz"
      sha256 "c09d091902430184a30c7f765ccfd94316232287353d2a2e7d01491c4a7e7eda"
    else
      url "https://github.com/osodevops/semrush-cli/releases/download/v0.1.1/semrush-x86_64-apple-darwin.tar.gz"
      sha256 "38191a7b90f97f621ae424adb443675157e15c60a431c9c43e59ce5781d9d311"
    end
  end

  on_linux do
    url "https://github.com/osodevops/semrush-cli/releases/download/v0.1.1/semrush-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "fd15e33e4367a1862a1c3f23591506e4754d597d3ef7eca61ae13ec1bd1290a8"
  end

  def install
    bin.install "semrush"
  end

  test do
    assert_match "semrush #{version}", shell_output("#{bin}/semrush --version")
  end
end
