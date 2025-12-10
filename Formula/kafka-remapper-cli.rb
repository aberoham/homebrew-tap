class KafkaRemapperCli < Formula
  desc "CLI for Kafka partition remapping proxy"
  homepage "https://github.com/osodevops/kafka-partition-remapper"
  version "0.5.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/kafka-partition-remapper/releases/download/v0.5.2/kafka-remapper-cli-aarch64-apple-darwin.tar.xz"
      sha256 "b2424880339ec00736562dfc2f129d03c42ca35215e3c564d5ffab909133d85c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/osodevops/kafka-partition-remapper/releases/download/v0.5.2/kafka-remapper-cli-x86_64-apple-darwin.tar.xz"
      sha256 "c6a0db61d41ada4dea6028471eeec01a2d0a59be6e609e7357cad10b256374d3"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/osodevops/kafka-partition-remapper/releases/download/v0.5.2/kafka-remapper-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "cf75f6054d4ade84f8f3309db89e07e9bc295e775843325eeef613787bce2b3a"
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
    bin.install "kafka-partition-proxy" if OS.mac? && Hardware::CPU.arm?
    bin.install "kafka-partition-proxy" if OS.mac? && Hardware::CPU.intel?
    bin.install "kafka-partition-proxy" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
