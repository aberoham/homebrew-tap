class KafkaBackupEnterprise < Formula
  desc "Enterprise Kafka backup — Schema Registry, RBAC, encryption. 14-day free trial."
  homepage "https://kafkabackup.com/enterprise"
  version "0.3.2"
  license "LicenseRef-Proprietary"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/kafka-backup-enterprise-releases/releases/download/v0.3.2/kafka-backup-aarch64-macos.tar.gz"
      sha256 "0684bddeacddcb8e5ea79fc9be2acbd1da459d90adb9ce6a87eda4e9ffd3c619"
    end
    if Hardware::CPU.intel?
      url "https://github.com/osodevops/kafka-backup-enterprise-releases/releases/download/v0.3.2/kafka-backup-x86_64-macos.tar.gz"
      sha256 "80e37edcc27144d62a71f3377396babfd8379a470a55a150b539e58b98a2c0be"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/osodevops/kafka-backup-enterprise-releases/releases/download/v0.3.2/kafka-backup-x86_64-linux.tar.gz"
    sha256 "5542dbdb2f45e75e43d473e3e95062808f757c9c29c0ebba9d89176c3c78581d"
  end

  def install
    bin.install "kafka-backup" => "kafka-backup-enterprise"
  end

  test do
    assert_match "kafka-backup 0.3.2", shell_output("#{bin}/kafka-backup-enterprise --version")
  end
end
