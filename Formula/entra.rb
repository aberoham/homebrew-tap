class Entra < Formula
  desc "Read-only Microsoft Entra ID directory lookups from the command line"
  homepage "https://github.com/aberoham/ms-entra-cli"
  license "MIT"
  version "0.5.0"

  on_macos do
    on_arm do
      url "https://github.com/aberoham/ms-entra-cli/releases/download/v0.5.0/entra-v0.5.0-aarch64-apple-darwin.tar.gz"
      sha256 "026573afd59a60cde28331b4c63a87a3ec39e5d36e934849831b09c4815f462e"
    end
    on_intel do
      url "https://github.com/aberoham/ms-entra-cli/releases/download/v0.5.0/entra-v0.5.0-x86_64-apple-darwin.tar.gz"
      sha256 "3759d1af7f6866b366180ca2fab6b38b1ff3fb9b63dbe5413fc588a26f4d6791"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aberoham/ms-entra-cli/releases/download/v0.5.0/entra-v0.5.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "d5f01da3318a190afad37ad084e07aa8e7e92c1e5315f9e835f06b4247db2ee6"
    end
    on_intel do
      url "https://github.com/aberoham/ms-entra-cli/releases/download/v0.5.0/entra-v0.5.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "af9915135912c5ac704d64c3ff20a635c585dc42fea480a084963aa5b56fb9a8"
    end
  end

  def install
    bin.install "bin/entra"
    doc.install Dir["share/doc/entra/*"]
  end

  def caveats
    <<~EOS
      entra needs an app registration in your own Microsoft Entra ID directory.
      Setup: #{doc}/docs/auth.md

      From 0.1.1, macOS releases are Developer ID signed, so the Keychain's
      "Always Allow" persists across upgrades. Expect one more prompt on the
      first upgrade from an earlier release. Do not re-sign the installed
      binary. See "macOS keychain prompts after every upgrade" in
      #{doc}/docs/troubleshooting.md
    EOS
  end

  test do
    assert_match "entra #{version}", shell_output("#{bin}/entra version")
    assert_match "Microsoft Entra ID", shell_output("#{bin}/entra --help")
  end
end
