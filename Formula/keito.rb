class Keito < Formula
  desc "CLI for AI agents and humans to track billable time against Keito"
  homepage "https://github.com/osodevops/keito-cli"
  version "0.1.6"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/keito-cli/releases/download/v0.1.6/keito-aarch64-apple-darwin.tar.gz"
      sha256 "15d1f24a917bb27c011727c7e977b4efafdbca3ff1a3792972fbfb3ffe2a32de"
    else
      url "https://github.com/osodevops/keito-cli/releases/download/v0.1.6/keito-x86_64-apple-darwin.tar.gz"
      sha256 "5d552402a01641b7212714d81de520be45ea26530650a86ef03369243a5ee090"
    end
  end

  on_linux do
    url "https://github.com/osodevops/keito-cli/releases/download/v0.1.6/keito-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "0cad20cd67b1feda0e84ea42e4e7aaf396104159fc76fbbffc2af871cafdf130"
  end

  def install
    bin.install "keito"
  end

  test do
    assert_match "keito #{version}", shell_output("#{bin}/keito --version")
  end
end
