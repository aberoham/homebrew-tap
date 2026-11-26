class Purview < Formula
  desc "Microsoft Purview eDiscovery (Premium) searches and exports from the command line"
  homepage "https://github.com/aberoham/ms-purview-cli"
  license "MIT"
  version "0.1.0-rc.1"

  on_macos do
    on_arm do
      url "https://github.com/aberoham/ms-purview-cli/releases/download/v0.1.0-rc.1/purview-v0.1.0-rc.1-aarch64-apple-darwin.tar.gz"
      sha256 "56e0558520c1472a42fd07bd990a73864d37d6693c361932f62f207072e690ab"
    end
    on_intel do
      url "https://github.com/aberoham/ms-purview-cli/releases/download/v0.1.0-rc.1/purview-v0.1.0-rc.1-x86_64-apple-darwin.tar.gz"
      sha256 "7a614abf78812287759c369d1ff46932ebd6a0c337c35348e1d1dfc3f27a5819"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aberoham/ms-purview-cli/releases/download/v0.1.0-rc.1/purview-v0.1.0-rc.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "3061b5212b2d36c96873ecd9155a179f525024137abace0c5ad8d4cc8090054f"
    end
    on_intel do
      url "https://github.com/aberoham/ms-purview-cli/releases/download/v0.1.0-rc.1/purview-v0.1.0-rc.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "508a66feea6ee369962e0d02c8405410db1e8d735f81d9549c092d4589d1b3e8"
    end
  end

  def install
    bin.install "bin/purview"
    doc.install Dir["share/doc/purview/*"]
  end

  def caveats
    <<~EOS
      purview needs an app registration in your own Microsoft Entra ID tenant
      and a Microsoft Purview eDiscovery role.
      Setup: #{doc}/README.md
    EOS
  end

  test do
    assert_match "purview #{version} ", shell_output("#{bin}/purview version")
    assert_match "Microsoft Purview eDiscovery", shell_output("#{bin}/purview --help")
  end
end
