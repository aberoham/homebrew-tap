class Entra < Formula
  desc "Read-only Microsoft Entra ID directory lookups from the command line"
  homepage "https://github.com/aberoham/ms-entra-cli"
  license "MIT"
  version "0.4.0"

  on_macos do
    on_arm do
      url "https://github.com/aberoham/ms-entra-cli/releases/download/v0.4.0/entra-v0.4.0-aarch64-apple-darwin.tar.gz"
      sha256 "78141f9b3e3776b8227cf6c550aad2426ee89ea4fecba9737c76db5b6de92963"
    end
    on_intel do
      url "https://github.com/aberoham/ms-entra-cli/releases/download/v0.4.0/entra-v0.4.0-x86_64-apple-darwin.tar.gz"
      sha256 "4f9577525dfcfd0d6378a069ee348cf6ce97a34c310f8a63de2e0837ef6e7bc0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aberoham/ms-entra-cli/releases/download/v0.4.0/entra-v0.4.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "6ec0f1e0b640066ea001cb7ab921d3b636f0fbe1f8b0f96190948f10f2571bff"
    end
    on_intel do
      url "https://github.com/aberoham/ms-entra-cli/releases/download/v0.4.0/entra-v0.4.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "cc79e2aac957dfc675438c56fe0dc07e4b0871642643ece39f107e524c424be3"
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
