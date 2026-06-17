class Chukei < Formula
  desc "Snowflake cost optimization proxy with verified caching"
  homepage "https://chukei.dev"
  version "0.2.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/chukei/releases/download/v0.2.3/chukei-cli-aarch64-apple-darwin.tar.xz"
      sha256 "76302bd1ccc153f8a1eb75109d4996cdeab6474b3e1a8e818e81809b2b269fe3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/osodevops/chukei/releases/download/v0.2.3/chukei-cli-x86_64-apple-darwin.tar.xz"
      sha256 "379955a611dcc450bee9db523f7103cfd27d477f813e7f3a4ffd40716d3bdea8"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/osodevops/chukei/releases/download/v0.2.3/chukei-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "293bc053aca59b16d4b94f11cb83eb5472d666c7aa6af03f750b26f94522f4dc"
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "chukei" if OS.mac? && Hardware::CPU.arm?
    bin.install "chukei" if OS.mac? && Hardware::CPU.intel?
    bin.install "chukei" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
