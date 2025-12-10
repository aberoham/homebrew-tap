class KafkaRemapperCli < Formula
  desc "CLI for Kafka partition remapping proxy"
  homepage "https://github.com/osodevops/kafka-partition-remapper"
  version "0.5.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/kafka-partition-remapper/releases/download/v0.5.4/kafka-remapper-cli-aarch64-apple-darwin.tar.xz"
      sha256 "e703ac8efbaa57daae5975cbc6d49b8cf51b7475ecf9626ebc7f2f55d581b803"
    end
    if Hardware::CPU.intel?
      url "https://github.com/osodevops/kafka-partition-remapper/releases/download/v0.5.4/kafka-remapper-cli-x86_64-apple-darwin.tar.xz"
      sha256 "abfeb48978339e901c8a9ec0af0682b06f4862fe7a4c5ba553ac5d145587edd7"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/osodevops/kafka-partition-remapper/releases/download/v0.5.4/kafka-remapper-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "83fd8829556a2047e17521aa784237db9a127f995af24fe50bca4337883910dd"
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
