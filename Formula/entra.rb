class Entra < Formula
  desc "Read-only Microsoft Entra ID directory lookups from the command line"
  homepage "https://github.com/aberoham/ms-entra-cli"
  license "MIT"
  version "0.3.0"

  on_macos do
    on_arm do
      url "https://github.com/aberoham/ms-entra-cli/releases/download/v0.3.0/entra-v0.3.0-aarch64-apple-darwin.tar.gz"
      sha256 "971a33dbd5a08afbbad2a19fa0dfbd50d884dd7175362a0ff4ab63e497ca8890"
    end
    on_intel do
      url "https://github.com/aberoham/ms-entra-cli/releases/download/v0.3.0/entra-v0.3.0-x86_64-apple-darwin.tar.gz"
      sha256 "9a2b052a1b622062eeaf2e0e1c2e2c7e4c86c4c5b4b7365ff1816735f0e64f3f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aberoham/ms-entra-cli/releases/download/v0.3.0/entra-v0.3.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "a4e0a5a319930d7cf32c6821217ca458740ce1b0ec66d8df1efdb9c8e1576924"
    end
    on_intel do
      url "https://github.com/aberoham/ms-entra-cli/releases/download/v0.3.0/entra-v0.3.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "4aeb520cfc9dcffa4876389219435cd4a8166f5f14a216d8a48eea4027d887fb"
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
