class Keito < Formula
  desc "CLI for AI agents and humans to track billable time against Keito"
  homepage "https://github.com/osodevops/keito-cli"
  version "0.1.5"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/keito-cli/releases/download/v0.1.5/keito-aarch64-apple-darwin.tar.gz"
      sha256 "443797192dc46941f9edf9b55cfb7523859a9fcf045da50719e015b9fce526c2"
    else
      url "https://github.com/osodevops/keito-cli/releases/download/v0.1.5/keito-x86_64-apple-darwin.tar.gz"
      sha256 "468cf9ebd5879ca16da85b95d2c86c1229d762af400c83919fb07434324a392e"
    end
  end

  on_linux do
    url "https://github.com/osodevops/keito-cli/releases/download/v0.1.5/keito-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "3406a00e4cee354f8afe6de6b8b439709e67cc173e9097230e9a44420c2afc63"
  end

  def install
    bin.install "keito"
  end

  test do
    assert_match "keito #{version}", shell_output("#{bin}/keito --version")
  end
end
