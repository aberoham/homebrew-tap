class KafkaBackup < Formula
  desc "CLI tool for Kafka backup and restore operations"
  homepage "https://github.com/osodevops/kafka-backup"
  version "0.15.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/kafka-backup/releases/download/v0.15.7/kafka-backup-cli-aarch64-apple-darwin.tar.xz"
      sha256 "6d15e6c655413bd72a5c638b2a6cb2d587608a7bc426fe1dbe9933a6b1e1b8a3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/osodevops/kafka-backup/releases/download/v0.15.7/kafka-backup-cli-x86_64-apple-darwin.tar.xz"
      sha256 "8a3c706c3582679f1d935a80fb301a11541320fbf63babc127f5184414f410be"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/osodevops/kafka-backup/releases/download/v0.15.7/kafka-backup-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "3c1abfa7e643ab4773d6e8fde169c11663942f2e936413e69cbd85db403631e8"
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
    bin.install "kafka-backup" if OS.mac? && Hardware::CPU.arm?
    bin.install "kafka-backup" if OS.mac? && Hardware::CPU.intel?
    bin.install "kafka-backup" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
