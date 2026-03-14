class Instagramix < Formula
  desc "A terminal user interface (TUI) for Instagram built in Rust"
  homepage "https://github.com/osodevops/instagramix"
  version "0.1.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/instagramix/releases/download/v0.1.0/instagramix-0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 ""
    else
      url "https://github.com/osodevops/instagramix/releases/download/v0.1.0/instagramix-0.1.0-x86_64-apple-darwin.tar.gz"
      sha256 ""
    end
  end

  on_linux do
    url "https://github.com/osodevops/instagramix/releases/download/v0.1.0/instagramix-0.1.0-x86_64-unknown-linux-gnu.tar.gz"
    sha256 ""
  end

  def install
    bin.install "instagramix"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/instagramix --version")
  end
end
