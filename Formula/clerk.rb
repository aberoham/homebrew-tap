class Clerk < Formula
  desc "A fast, intelligent CLI for the Clerk authentication platform"
  homepage "https://github.com/osodevops/clerk-cli"
  version "0.1.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/clerk-cli/releases/download/v0.1.0/clerk-aarch64-apple-darwin.tar.gz"
      sha256 "668569d029d2552078f347fe6ad626b7b0dd702cbe7f394a473e8caaee57c454"
    else
      url "https://github.com/osodevops/clerk-cli/releases/download/v0.1.0/clerk-x86_64-apple-darwin.tar.gz"
      sha256 "3cbbe9ae04fe35033b559f86fa519bab81f6e74067c7072e424748cb63d497fc"
    end
  end

  on_linux do
    url "https://github.com/osodevops/clerk-cli/releases/download/v0.1.0/clerk-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "c43ca00a725d160381964e7265bc878c1b6d6a2434abf551b076f4647d841716"
  end

  def install
    bin.install "clerk"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/clerk --version")
  end
end
