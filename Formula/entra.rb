class Entra < Formula
  desc "Read-only Microsoft Entra ID directory lookups from the command line"
  homepage "https://github.com/aberoham/ms-entra-cli"
  license "MIT"
  version "0.2.0"

  on_macos do
    on_arm do
      url "https://github.com/aberoham/ms-entra-cli/releases/download/v0.2.0/entra-v0.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "88da4966ea72f04b4c52fdb117b1f2458fbfca060db3f7e737af05a26323d718"
    end
    on_intel do
      url "https://github.com/aberoham/ms-entra-cli/releases/download/v0.2.0/entra-v0.2.0-x86_64-apple-darwin.tar.gz"
      sha256 "77ccb207d06ddb97cbcbe1bb42622fed1c18f547f50a301ec885b6e4e915d946"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aberoham/ms-entra-cli/releases/download/v0.2.0/entra-v0.2.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "d309ff523ad5e21a7e54a23cadd6bd23b1e3e9e1e536230388b02c613400beda"
    end
    on_intel do
      url "https://github.com/aberoham/ms-entra-cli/releases/download/v0.2.0/entra-v0.2.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "e4ca61f73024eceadc182d155fb04c22bd77ee955f174883e7af1ddecdc3cc86"
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
