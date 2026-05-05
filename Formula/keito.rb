class Keito < Formula
  desc "CLI for AI agents and humans to track billable time against Keito"
  homepage "https://github.com/osodevops/keito-cli"
  version "0.1.3"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/keito-cli/releases/download/v0.1.3/keito-aarch64-apple-darwin.tar.gz"
      sha256 "b79aecd3e81e127adda24a3d1a22b6fca84542104254d5b87f73b7eea3ee8577"
    else
      url "https://github.com/osodevops/keito-cli/releases/download/v0.1.3/keito-x86_64-apple-darwin.tar.gz"
      sha256 "e998dbbceecfe6b20f5470efffab6aa690fe864073fdd9da0e57b8080a6bf23b"
    end
  end

  on_linux do
    url "https://github.com/osodevops/keito-cli/releases/download/v0.1.3/keito-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "66c0ac847980590aade4346cf36176de3d44024c3756c5dc541c93d5ad6cdb2b"
  end

  def install
    bin.install "keito"
  end

  test do
    assert_match "keito #{version}", shell_output("#{bin}/keito --version")
  end
end
