class RabbitmqBackup < Formula
  desc "CLI tool for RabbitMQ backup and restore operations"
  homepage "https://rabbitmqbackup.com/"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/rabbitmq-backup/releases/download/v0.1.0/rabbitmq-backup-cli-aarch64-apple-darwin.tar.xz"
      sha256 "735fa9b8edb4cc1eb5398bc4a1eb1aa5269cf66cc0ef134135d0bd50e4d25d38"
    end
    if Hardware::CPU.intel?
      url "https://github.com/osodevops/rabbitmq-backup/releases/download/v0.1.0/rabbitmq-backup-cli-x86_64-apple-darwin.tar.xz"
      sha256 "a1a8f36754e959cb0d380f4f2e07e01615ddc8d0b192d7f1f255825d84295c09"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/osodevops/rabbitmq-backup/releases/download/v0.1.0/rabbitmq-backup-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "3bc8e4c29991fbb23d2ae2f816aeb6934e216257bbd486f33880bccbfd9bc782"
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
    bin.install "rabbitmq-backup" if OS.mac? && Hardware::CPU.arm?
    bin.install "rabbitmq-backup" if OS.mac? && Hardware::CPU.intel?
    bin.install "rabbitmq-backup" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
