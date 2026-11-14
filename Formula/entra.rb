class Entra < Formula
  desc "Read-only Microsoft Entra ID directory lookups from the command line"
  homepage "https://github.com/aberoham/ms-entra-cli"
  license "MIT"
  version "0.6.0"

  on_macos do
    on_arm do
      url "https://github.com/aberoham/ms-entra-cli/releases/download/v0.6.0/entra-v0.6.0-aarch64-apple-darwin.tar.gz"
      sha256 "5febaaab2739d18b67cde594837c6da8e5530f53abf4f4422d9804166a9fae80"
    end
    on_intel do
      url "https://github.com/aberoham/ms-entra-cli/releases/download/v0.6.0/entra-v0.6.0-x86_64-apple-darwin.tar.gz"
      sha256 "c46b9f99624f43658f12d80a177d095ee0186049b27a1dfcfaef364e55dea2cd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aberoham/ms-entra-cli/releases/download/v0.6.0/entra-v0.6.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "00c32f2b90ced55b32f49f89819fcba9ac7ae8e9738a3d21293c0b487b5566cc"
    end
    on_intel do
      url "https://github.com/aberoham/ms-entra-cli/releases/download/v0.6.0/entra-v0.6.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "3f15e02080f4e8d1fe70ec00d7eaf87e4ae40c9cef641a5a97261c975e0d205b"
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
