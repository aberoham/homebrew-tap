class KafkaRemapperCli < Formula
  desc "CLI for Kafka partition remapping proxy"
  homepage "https://github.com/osodevops/kafka-partition-remapper"
  version "0.5.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/kafka-partition-remapper/releases/download/v0.5.3/kafka-remapper-cli-aarch64-apple-darwin.tar.xz"
      sha256 "8e8b30e0dea285e50efc8c5d512ae9107f9dcfb5ac26e74cdf190a8742d6c2e7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/osodevops/kafka-partition-remapper/releases/download/v0.5.3/kafka-remapper-cli-x86_64-apple-darwin.tar.xz"
      sha256 "92b4e006932d4193dd9b2cce82f7fb0b3429514e1d0e90a58237de669d7d8afa"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/osodevops/kafka-partition-remapper/releases/download/v0.5.3/kafka-remapper-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "8c8e112e08d336ac1769033b15a6c976f9ef525e1fb186e06570bcf43c8a4f3b"
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
