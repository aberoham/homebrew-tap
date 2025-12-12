class KafkaBackup < Formula
  desc "CLI tool for Kafka backup and restore operations"
  homepage "https://github.com/osodevops/kafka-backup"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/kafka-backup/releases/download/v0.2.1/kafka-backup-cli-aarch64-apple-darwin.tar.xz"
      sha256 "d272ae508f8e66195c4dbe14ab817a1fcd9128bbad676481795a202d99e1dfac"
    end
    if Hardware::CPU.intel?
      url "https://github.com/osodevops/kafka-backup/releases/download/v0.2.1/kafka-backup-cli-x86_64-apple-darwin.tar.xz"
      sha256 "de5d17211b4786383ed01b20410093bc4c247eefa032eac4257dedcedee0d9a7"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/osodevops/kafka-backup/releases/download/v0.2.1/kafka-backup-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "3f62da32e46499577c6d4da74111c8f5310e86df3f7c2337fcac7f0a7933405e"
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
