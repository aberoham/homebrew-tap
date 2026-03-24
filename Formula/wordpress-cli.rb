class WordpressCli < Formula
  desc "Rust-native WordPress CLI for AI agents & humans"
  homepage "https://github.com/osodevops/wordpress-cli"
  version "0.2.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/wordpress-cli/releases/download/v0.2.1/wpx-aarch64-apple-darwin.tar.gz"
      sha256 "7a8dc684654598e341ab6e7d6fefded7a6ed39f1c9abfa67a356e71e22318be2"
    else
      url "https://github.com/osodevops/wordpress-cli/releases/download/v0.2.1/wpx-x86_64-apple-darwin.tar.gz"
      sha256 "adb0fc624fd97b798dad91f8a05560b54ce9d85038c9fc408426615fdecb6653"
    end
  end

  on_linux do
    url "https://github.com/osodevops/wordpress-cli/releases/download/v0.2.1/wpx-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "53d485b287155345fd25a2a1a809bcf5260345b7d4384982cb5e5fae14ad6869"
  end

  def install
    bin.install "wpx"
  end

  test do
    assert_match "wpx", shell_output("#{bin}/wpx --version")
  end
end
