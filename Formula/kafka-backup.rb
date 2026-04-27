class KafkaBackup < Formula
  desc "CLI tool for Kafka backup and restore operations"
  homepage "https://github.com/osodevops/kafka-backup"
  version "0.15.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/kafka-backup/releases/download/v0.15.3/kafka-backup-cli-aarch64-apple-darwin.tar.xz"
      sha256 "ab944f12d47aabdf7a11c09c1e22c64d9a099a03128872bb3ff0ff2f4fdf2cd0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/osodevops/kafka-backup/releases/download/v0.15.3/kafka-backup-cli-x86_64-apple-darwin.tar.xz"
      sha256 "5a0f35ab2f6c499ab73431def8c3da1d1acf822f98496115ebb00d61abaa2263"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/osodevops/kafka-backup/releases/download/v0.15.3/kafka-backup-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "51441fe77d3bbb1bfa92e4000da0e78a857b7533b984bcaa476361829eabf983"
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
