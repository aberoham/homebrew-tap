class KafkaBackupEnterprise < Formula
  desc "Enterprise Kafka backup — Schema Registry, RBAC, encryption. 14-day free trial."
  homepage "https://kafkabackup.com/enterprise"
  version "0.3.1"
  license "LicenseRef-Proprietary"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/kafka-backup-enterprise-releases/releases/download/v0.3.1/kafka-backup-aarch64-macos.tar.gz"
      sha256 "40cc28d79b89c7f4d652584495e9530093e17d61b95e689e798755f3932ac897"
    end
    if Hardware::CPU.intel?
      url "https://github.com/osodevops/kafka-backup-enterprise-releases/releases/download/v0.3.1/kafka-backup-x86_64-macos.tar.gz"
      sha256 "af67b816edc3aa19d6cbc450b2f95c9735c258db56ffe5c5fa6755d380991c4c"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/osodevops/kafka-backup-enterprise-releases/releases/download/v0.3.1/kafka-backup-x86_64-linux.tar.gz"
    sha256 "a73a6edad404467b4de15ea43d6931d0032465a4402edfc971966040b46eb395"
  end

  def install
    bin.install "kafka-backup" => "kafka-backup-enterprise"
  end

  test do
    assert_match "kafka-backup 0.3.1", shell_output("#{bin}/kafka-backup-enterprise --version")
  end
end
