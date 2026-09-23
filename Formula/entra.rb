class Entra < Formula
  desc "Read-only Microsoft Entra ID directory lookups from the command line"
  homepage "https://github.com/aberoham/ms-entra-cli"
  license "MIT"
  version "0.1.0"

  on_macos do
    on_arm do
      url "https://github.com/aberoham/ms-entra-cli/releases/download/v0.1.0/entra-v0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "6e85ae86e3c7ee744ae7f49234f41258c4d298f182d7562a5d8876668c6a5833"
    end
    on_intel do
      url "https://github.com/aberoham/ms-entra-cli/releases/download/v0.1.0/entra-v0.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "7cf2f8965de3ffd72432fd655f227e969febd011ab42af5cdc8c1ecb54232bbb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aberoham/ms-entra-cli/releases/download/v0.1.0/entra-v0.1.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "76bc7f1f6f7f579a681c5540cfb2f7f3386b13b8025cb6ad3f71b47c7722e674"
    end
    on_intel do
      url "https://github.com/aberoham/ms-entra-cli/releases/download/v0.1.0/entra-v0.1.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "7b5a5bd9f04d23dd34ffb4ea95cb4143c78c49ec263644ebc84dc644a4396725"
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

      On macOS the Keychain asks again after every upgrade, because Homebrew's
      binary is ad-hoc signed. To make "Always Allow" persist, see
      "macOS keychain prompts after every upgrade" in
      #{doc}/docs/troubleshooting.md
    EOS
  end

  test do
    assert_match "entra #{version}", shell_output("#{bin}/entra version")
    assert_match "Microsoft Entra ID", shell_output("#{bin}/entra --help")
  end
end
