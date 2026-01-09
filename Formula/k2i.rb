class K2i < Formula
  desc "CLI tool for Kafka to Iceberg streaming ingestion"
  homepage "https://github.com/osodevops/k2i"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/k2i/releases/download/v0.1.0/k2i-cli-aarch64-apple-darwin.tar.xz"
      sha256 "a732005d0edd4ae3512e805685119bc99824e3f7ff2950578acac2cb03db8d8f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/osodevops/k2i/releases/download/v0.1.0/k2i-cli-x86_64-apple-darwin.tar.xz"
      sha256 "040decef23c252376b84b9d80bf2ae53ab1bef4dd0b1e8a71c14c1cf0155a4bb"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/osodevops/k2i/releases/download/v0.1.0/k2i-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a6c1c0cb644844c7ce6860c31ebd40c5751eb928e9adbc28ea001948e4a6a2b7"
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
