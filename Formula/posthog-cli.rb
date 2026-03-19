class PosthogCli < Formula
  desc "Agent-first CLI for the PostHog analytics API"
  homepage "https://github.com/osodevops/posthog-cli"
  version "0.10.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/posthog-cli/releases/download/v0.10.0/posthog-cli-aarch64-apple-darwin.tar.xz"
      sha256 "d85c0b728d468869350e054f6ca906f25668c97a7a2d64d63d34738c22b15a9f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/osodevops/posthog-cli/releases/download/v0.10.0/posthog-cli-x86_64-apple-darwin.tar.xz"
      sha256 "64b8e23b0666685f0a4d28a24bc2787be435cf64d47b298dfeb1be848bec858b"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/osodevops/posthog-cli/releases/download/v0.10.0/posthog-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "67bf96e6ffd4ac71b47d87ed56bde66215fecaff83ab4506f3bfabc41d9d2eb5"
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
