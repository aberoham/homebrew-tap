class Semrush < Formula
  desc "A high-performance CLI for the Semrush API built in Rust"
  homepage "https://github.com/osodevops/semrush-cli"
  version "0.1.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/semrush-cli/releases/download/v0.1.2/semrush-aarch64-apple-darwin.tar.gz"
      sha256 "debf59a2bc47acff9dd7efe5756a91cf389ee98b49dbc43269aea1e20230091c"
    else
      url "https://github.com/osodevops/semrush-cli/releases/download/v0.1.2/semrush-x86_64-apple-darwin.tar.gz"
      sha256 "7bfd442c632cee4b06fd7f0a31bd57682c638726be1178da47e496c252a6c8dc"
    end
  end

  on_linux do
    url "https://github.com/osodevops/semrush-cli/releases/download/v0.1.2/semrush-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "989cc9e5f6cb000cac54c70cef95683026091855e789124e84e2e05a1e7b6f9e"
  end

  def install
    bin.install "semrush"
  end

  test do
    assert_match "semrush #{version}", shell_output("#{bin}/semrush --version")
  end
end
