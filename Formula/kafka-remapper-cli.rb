class KafkaRemapperCli < Formula
  desc "CLI for Kafka partition remapping proxy"
  homepage "https://github.com/osodevops/kafka-partition-remapper"
  version "0.5.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/kafka-partition-remapper/releases/download/v0.5.1/kafka-remapper-cli-aarch64-apple-darwin.tar.xz"
      sha256 "dc9a3914da18e6d3f5ccd6d4cb24348af52cabdd548b78b2aa0f6f9b99089ba4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/osodevops/kafka-partition-remapper/releases/download/v0.5.1/kafka-remapper-cli-x86_64-apple-darwin.tar.xz"
      sha256 "52d57cc78ba32c00485155f3f550fc056e5a5e3fcbacd6facedf905e77de590a"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/osodevops/kafka-partition-remapper/releases/download/v0.5.1/kafka-remapper-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "b6d579b892f0b167237140bdf86bf5f38bd49bae7cd28f33baebc5de82538dac"
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
