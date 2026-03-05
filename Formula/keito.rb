class Keito < Formula
  desc "CLI for AI agents and humans to track billable time against Keito"
  homepage "https://github.com/osodevops/keito-cli"
  version "0.1.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/keito-cli/releases/download/v0.1.2/keito-aarch64-apple-darwin.tar.gz"
      sha256 "63332c15b746caea47c4d3403e4f23e235c17d7683a941093017e7563e437ce6"
    else
      url "https://github.com/osodevops/keito-cli/releases/download/v0.1.2/keito-x86_64-apple-darwin.tar.gz"
      sha256 "3acbb43c219b9c8a838bcb19d0fc656f3e12b07ca36266b41b2a6e52d45e2212"
    end
  end

  on_linux do
    url "https://github.com/osodevops/keito-cli/releases/download/v0.1.2/keito-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "8da609ec0f0a69dc3f7506bbfc6bfc9fa62c5fcbabde7a8461502fb763caddb4"
  end

  def install
    bin.install "keito"
  end

  test do
    assert_match "keito-cli #{version}", shell_output("#{bin}/keito --version")
  end
end
