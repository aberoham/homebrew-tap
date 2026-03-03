class KafkaBackupMonitor < Formula
  desc "Real-time TUI dashboard for kafka-backup monitoring"
  homepage "https://github.com/osodevops/kafka-backup-cli"
  version "0.1.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/kafka-backup-cli/releases/download/v0.1.1/kafka-backup-monitor-aarch64-apple-darwin.tar.gz"
      sha256 "3ec51a9f3698483390e225dcb386c46bdd21e4d640ee22ef517d5d9b076ea480"
    else
      url "https://github.com/osodevops/kafka-backup-cli/releases/download/v0.1.1/kafka-backup-monitor-x86_64-apple-darwin.tar.gz"
      sha256 "18e7ab5fb2d162ef6a0341c4c2a721eeec9e5f4e4caf824590eb44f797e7a874"
    end
  end

  on_linux do
    url "https://github.com/osodevops/kafka-backup-cli/releases/download/v0.1.1/kafka-backup-monitor-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "550aafbf4b9c21ab2f8dd3a4508d89a44a5df79e8d1a4022376ae7d2790f5979"
  end

  def install
    bin.install "kafka-backup-monitor"
  end

  test do
    assert_match "kafka-backup-monitor", shell_output("#{bin}/kafka-backup-monitor --version")
  end
end
