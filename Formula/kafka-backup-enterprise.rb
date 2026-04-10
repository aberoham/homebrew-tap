class KafkaBackupEnterprise < Formula
  desc "Enterprise Kafka backup — Schema Registry, RBAC, encryption. 14-day free trial."
  homepage "https://kafkabackup.com/enterprise"
  version "0.2.1"
  license "LicenseRef-Proprietary"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/kafka-backup-enterprise-releases/releases/download/v0.2.1/kafka-backup-aarch64-macos.tar.gz"
      sha256 "becee1e0bf1a394dc90bf8d4f0e4361f377423add6d5e51f1ac4238c3fb7829f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/osodevops/kafka-backup-enterprise-releases/releases/download/v0.2.1/kafka-backup-x86_64-macos.tar.gz"
      sha256 "5ac8ee8f83f74dccea629f76196f4401826fbaa8d9289cc42a4cea2ec0241919"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/osodevops/kafka-backup-enterprise-releases/releases/download/v0.2.1/kafka-backup-x86_64-linux.tar.gz"
    sha256 "c0d9fe5afb8b9229c83fa71b2d5e78bcec1bc83ae255ff56d2b7f576e996f07c"
  end

  def install
    bin.install "kafka-backup" => "kafka-backup-enterprise"
  end

  test do
    assert_match "kafka-backup 0.2.1", shell_output("#{bin}/kafka-backup-enterprise --version")
  end
end
