class Slk < Formula
  desc "A Rust-based Slack CLI for humans and AI agents"
  homepage "https://github.com/osodevops/slack-cli"
  version "0.1.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/slack-cli/releases/download/v0.1.2/slk-aarch64-apple-darwin.tar.gz"
      sha256 "b3cae3db3c18b30e2a1b3e2a7d9a93358b919472f64e0b57c02321a73326a30c"
    else
      url "https://github.com/osodevops/slack-cli/releases/download/v0.1.2/slk-x86_64-apple-darwin.tar.gz"
      sha256 "44d25c1b135d1a520e4cfca9892c1308e429666f2007a77a1db03ccdb67c777d"
    end
  end

  on_linux do
    url "https://github.com/osodevops/slack-cli/releases/download/v0.1.2/slk-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "98c65667469041734314fe70fedd8a4d82afe2ceaa9652ef44b811fa11925d43"
  end

  def install
    bin.install "slk"
  end

  test do
    assert_match "slk", shell_output("#{bin}/slk --version")
  end
end
