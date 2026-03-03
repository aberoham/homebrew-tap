class KafkaBackupMonitor < Formula
  desc "Real-time TUI dashboard for kafka-backup monitoring"
  homepage "https://github.com/osodevops/kafka-backup-cli"
  version "0.1.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/kafka-backup-cli/releases/download/v0.1.1/kafka-backup-monitor-aarch64-apple-darwin.tar.gz"
      sha256 "f2fa52b005ff40ae52913be04ad41f2d76e1291d143c58658e2bd1a52620c234"
    else
      url "https://github.com/osodevops/kafka-backup-cli/releases/download/v0.1.1/kafka-backup-monitor-x86_64-apple-darwin.tar.gz"
      sha256 "056723e6b3074b7815cd6a1a612fc6f6b6c5a6bc5da3e4cda6e49215fad3876f"
    end
  end

  on_linux do
    url "https://github.com/osodevops/kafka-backup-cli/releases/download/v0.1.1/kafka-backup-monitor-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "3cb39ab96dbe765ef8f92491f4afa10bf1139b5dd19f374e674921a147a7df86"
  end

  def install
    bin.install "kafka-backup-monitor"
  end

  test do
    assert_match "kafka-backup-monitor", shell_output("#{bin}/kafka-backup-monitor --version")
  end
end
