class KafkaBackup < Formula
  desc "CLI tool for Kafka backup and restore operations"
  homepage "https://github.com/osodevops/kafka-backup"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/kafka-backup/releases/download/v0.1.5/kafka-backup-cli-aarch64-apple-darwin.tar.xz"
      sha256 "501e2619ebd13a89d2735f8ca0c51e8d56aa7fccd2319c56556e73a6e7064e14"
    end
    if Hardware::CPU.intel?
      url "https://github.com/osodevops/kafka-backup/releases/download/v0.1.5/kafka-backup-cli-x86_64-apple-darwin.tar.xz"
      sha256 "180c2b25d970f6590a414a3184b93a21b9953577f4f887e90299693dc610e10a"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/osodevops/kafka-backup/releases/download/v0.1.5/kafka-backup-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "8ad9e8377d5ed9d179df601788029c29642c0ebeea9d7684c654120fdd134fec"
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
