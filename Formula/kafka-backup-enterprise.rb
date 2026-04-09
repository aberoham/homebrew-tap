class KafkaBackupEnterprise < Formula
  desc "Enterprise Kafka backup — Schema Registry, RBAC, encryption. 14-day free trial."
  homepage "https://kafkabackup.com/enterprise"
  version "0.2.0"
  license "LicenseRef-Proprietary"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/kafka-backup-enterprise-releases/releases/download/v0.2.0/kafka-backup-aarch64-macos.tar.gz"
      sha256 "03090b0a884d694617720504da7a2119197f0e9aa149bcec80f7ce8d2fe7f194"
    end
    if Hardware::CPU.intel?
      url "https://github.com/osodevops/kafka-backup-enterprise-releases/releases/download/v0.2.0/kafka-backup-x86_64-macos.tar.gz"
      sha256 "acfbb9ec4678573ecaa22b049622dcbe5dd7c9d7cd41362c28bc8c17ca91b66d"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/osodevops/kafka-backup-enterprise-releases/releases/download/v0.2.0/kafka-backup-x86_64-linux.tar.gz"
    sha256 "54fe327989f1bee92cbeab0382a3c3a345c421b97108bef2feb8d9b6151687f7"
  end

  def install
    bin.install "kafka-backup" => "kafka-backup-enterprise"
  end

  test do
    assert_match "kafka-backup 0.2.0", shell_output("#{bin}/kafka-backup-enterprise --version")
  end
end
