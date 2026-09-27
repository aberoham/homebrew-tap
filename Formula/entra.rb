class Entra < Formula
  desc "Read-only Microsoft Entra ID directory lookups from the command line"
  homepage "https://github.com/aberoham/ms-entra-cli"
  license "MIT"
  version "0.1.1"

  on_macos do
    on_arm do
      url "https://github.com/aberoham/ms-entra-cli/releases/download/v0.1.1/entra-v0.1.1-aarch64-apple-darwin.tar.gz"
      sha256 "e7f7d7ca41b97aa984582798e6fe4050046360bd2974cd6e488f10c980e3d86d"
    end
    on_intel do
      url "https://github.com/aberoham/ms-entra-cli/releases/download/v0.1.1/entra-v0.1.1-x86_64-apple-darwin.tar.gz"
      sha256 "f3c1f8e3b717a32ba8481f50d1457d45572fcedbccb0a08f0784ce89a075b557"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aberoham/ms-entra-cli/releases/download/v0.1.1/entra-v0.1.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "d4bbfda22c73f19c5bf62e36a347a911f4d37bd664e874d5b94786eb48945ead"
    end
    on_intel do
      url "https://github.com/aberoham/ms-entra-cli/releases/download/v0.1.1/entra-v0.1.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "5186126d46943e86a83788f9797ec7bb0bb615c3136acda3a5b8e9cb9c7d0163"
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
