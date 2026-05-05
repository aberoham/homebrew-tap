class K2i < Formula
  desc "CLI tool for Kafka to Iceberg streaming ingestion"
  homepage "https://github.com/osodevops/k2i"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/k2i/releases/download/v0.2.0/k2i-cli-aarch64-apple-darwin.tar.xz"
      sha256 "6bb15286eced7fc683d1e285469003681e7237a11eb69fcd7646cec52fe9c982"
    end
    if Hardware::CPU.intel?
      url "https://github.com/osodevops/k2i/releases/download/v0.2.0/k2i-cli-x86_64-apple-darwin.tar.xz"
      sha256 "914e355860e9c1847a45daef473b42394ec8859f031fee272601d9fd297f2089"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/osodevops/k2i/releases/download/v0.2.0/k2i-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "acdf6f77407d3440da71ab409e91c84dacb3dda4e164ee9bd9ec346e1fd94af8"
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
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
    bin.install "k2i" if OS.mac? && Hardware::CPU.arm?
    bin.install "k2i" if OS.mac? && Hardware::CPU.intel?
    bin.install "k2i" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
