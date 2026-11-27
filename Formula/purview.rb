class Purview < Formula
  desc "Microsoft Purview eDiscovery (Premium) searches and exports from the command line"
  homepage "https://github.com/aberoham/ms-purview-cli"
  license "MIT"
  version "0.1.0"

  on_macos do
    on_arm do
      url "https://github.com/aberoham/ms-purview-cli/releases/download/v0.1.0/purview-v0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "2e0b67db2cbddc5dddab6f17fdecbb5d1e5ee81a751f73d3b83df54fa474ea21"
    end
    on_intel do
      url "https://github.com/aberoham/ms-purview-cli/releases/download/v0.1.0/purview-v0.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "25ae9da22bbcc1aad774a8e1e0b15644b2aa7a424c2250c45a938d9bdd4c5eee"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aberoham/ms-purview-cli/releases/download/v0.1.0/purview-v0.1.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "388b326db7af64f5811b454eee9ead5503aecc21bde7fae4e543ecc392c43638"
    end
    on_intel do
      url "https://github.com/aberoham/ms-purview-cli/releases/download/v0.1.0/purview-v0.1.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "e9f3d8971e0aa059f7d8376bb3837cba21c6bc1cfda799ad83fccd82dddc60b0"
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
