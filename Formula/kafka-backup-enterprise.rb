class KafkaBackupEnterprise < Formula
  desc "Enterprise Kafka backup — Schema Registry, RBAC, encryption. 14-day free trial."
  homepage "https://kafkabackup.com/enterprise"
  version "0.3.0"
  license "LicenseRef-Proprietary"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/kafka-backup-enterprise-releases/releases/download/v0.3.0/kafka-backup-aarch64-macos.tar.gz"
      sha256 "1f1e54ec50532f40af19890282a31bc52ad8519d2f90eb6d1238d88f18037b0c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/osodevops/kafka-backup-enterprise-releases/releases/download/v0.3.0/kafka-backup-x86_64-macos.tar.gz"
      sha256 "4cf5b521c0aef9b83548c0c562407bc74651ce0ece8dec74fe6c072bc35b6411"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/osodevops/kafka-backup-enterprise-releases/releases/download/v0.3.0/kafka-backup-x86_64-linux.tar.gz"
    sha256 "1a7a76cf2546199d7a8cc492960f56c409e73490cb57a46192527c6bca0da618"
  end

  def install
    bin.install "kafka-backup" => "kafka-backup-enterprise"
  end

  test do
    assert_match "kafka-backup 0.3.0", shell_output("#{bin}/kafka-backup-enterprise --version")
  end
end
