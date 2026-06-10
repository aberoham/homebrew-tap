class KafkaBackup < Formula
  desc "CLI tool for Kafka backup and restore operations"
  homepage "https://github.com/osodevops/kafka-backup"
  version "0.15.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/kafka-backup/releases/download/v0.15.8/kafka-backup-cli-aarch64-apple-darwin.tar.xz"
      sha256 "204b853eb0509a655253bc8129765a9f8edf0d647e85dc1ded772fdfca36ac15"
    end
    if Hardware::CPU.intel?
      url "https://github.com/osodevops/kafka-backup/releases/download/v0.15.8/kafka-backup-cli-x86_64-apple-darwin.tar.xz"
      sha256 "bb0c57841d2be39547efda8a9b9b6898bfd1eb0d5f8acf5d6f6271b492861696"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/osodevops/kafka-backup/releases/download/v0.15.8/kafka-backup-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "98d60b487987701b10c52209650bfb91e9218275035a1c64f0df338c9ad11904"
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
