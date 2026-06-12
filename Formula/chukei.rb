class Chukei < Formula
  desc "Open-source cost optimization engine for Snowflake — verified caching, auto-suspend, SQL rewriting, attribution; deploys as a transparent proxy"
  homepage "https://chukei.dev"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/chukei/releases/download/v0.2.1/chukei-cli-aarch64-apple-darwin.tar.xz"
      sha256 "3e0a24806dbc88dc90934ee00b0fa398ee8f2447e0bc07d3efb39f320e00d077"
    end
    if Hardware::CPU.intel?
      url "https://github.com/osodevops/chukei/releases/download/v0.2.1/chukei-cli-x86_64-apple-darwin.tar.xz"
      sha256 "08f6108d6173ed2a22636d03c4381447f423628d90ef3a03c72bf2d3a1081b27"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/osodevops/chukei/releases/download/v0.2.1/chukei-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "bdb914af6cf1f226ab5be350fde6f9d80d556eaffc51d49ab0abe5881906c4af"
  end
  license "MIT"

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
