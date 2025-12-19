class KafkaRemapperCli < Formula
  desc "CLI for Kafka partition remapping proxy"
  homepage "https://github.com/osodevops/kafka-partition-remapper"
  version "0.5.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/kafka-partition-remapper/releases/download/v0.5.5/kafka-remapper-cli-aarch64-apple-darwin.tar.xz"
      sha256 "809e52f17a3708b620a9539595fde9b76d16858bbb9d2bdbe7b8e80c53020733"
    end
    if Hardware::CPU.intel?
      url "https://github.com/osodevops/kafka-partition-remapper/releases/download/v0.5.5/kafka-remapper-cli-x86_64-apple-darwin.tar.xz"
      sha256 "52b17e1362b07662d6aea866df1f64ffc6f0660a2db0f6d8cf2d1cadddb1dd5a"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/osodevops/kafka-partition-remapper/releases/download/v0.5.5/kafka-remapper-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "887681d0ae8949648d39a3145797ed4422434e77e19c1d67be982d30cb38656b"
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
