class Purview < Formula
  desc "Microsoft Purview eDiscovery (Premium) searches and exports from the command line"
  homepage "https://github.com/aberoham/ms-purview-cli"
  license "MIT"
  version "0.0.1"

  on_macos do
    on_arm do
      url "https://github.com/aberoham/ms-purview-cli/releases/download/v0.0.1/purview-v0.0.1-aarch64-apple-darwin.tar.gz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
    on_intel do
      url "https://github.com/aberoham/ms-purview-cli/releases/download/v0.0.1/purview-v0.0.1-x86_64-apple-darwin.tar.gz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aberoham/ms-purview-cli/releases/download/v0.0.1/purview-v0.0.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
    on_intel do
      url "https://github.com/aberoham/ms-purview-cli/releases/download/v0.0.1/purview-v0.0.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
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
