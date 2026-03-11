class PosthogCli < Formula
  desc "Agent-first CLI for the PostHog analytics API"
  homepage "https://github.com/osodevops/posthog-cli"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/posthog-cli/releases/download/v0.7.0/posthog-cli-aarch64-apple-darwin.tar.xz"
      sha256 "b0760293230d4aad45393fd80ffc32c466a6ec4e79a940bf00cc96b9fb2e4fb5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/osodevops/posthog-cli/releases/download/v0.7.0/posthog-cli-x86_64-apple-darwin.tar.xz"
      sha256 "1f91a3a3ac04c95e44357408b1959554d1feb1564f3cfdc64c1eff5e7e285101"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/osodevops/posthog-cli/releases/download/v0.7.0/posthog-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ff62463ff47c989b954606abea657dc744e193ae424665bd9e5f1f254ae0fcd7"
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
