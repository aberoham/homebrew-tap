class PosthogCli < Formula
  desc "Agent-first CLI for the PostHog analytics API"
  homepage "https://github.com/osodevops/posthog-cli"
  version "0.8.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/posthog-cli/releases/download/v0.8.0/posthog-cli-aarch64-apple-darwin.tar.xz"
      sha256 "fd0cb5c898926a2f258893b6459fdf6995b6e91aff93c58011eb4310f811b344"
    end
    if Hardware::CPU.intel?
      url "https://github.com/osodevops/posthog-cli/releases/download/v0.8.0/posthog-cli-x86_64-apple-darwin.tar.xz"
      sha256 "db916fb2feee7ab58269e3a8bcf99ead9d5ebc6df820ab7e3cb77b250ecda914"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/osodevops/posthog-cli/releases/download/v0.8.0/posthog-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e197951f62faa4d1bcc25d73b12b360c5d7bb96cddde625398b7b690df7e9d00"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "posthog" if OS.mac? && Hardware::CPU.arm?
    bin.install "posthog" if OS.mac? && Hardware::CPU.intel?
    bin.install "posthog" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
