class Chukei < Formula
  desc "Fair-source cost optimization engine for Snowflake — verified caching, auto-suspend, SQL rewriting, attribution; deploys as a transparent proxy"
  homepage "https://chukei.dev"
  version "0.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/chukei/releases/download/v0.2.2/chukei-cli-aarch64-apple-darwin.tar.xz"
      sha256 "b431b24c3e2bd03c7106a6eeaed0cf6ecfd7cd6369957869fe6f2110fa0acc20"
    end
    if Hardware::CPU.intel?
      url "https://github.com/osodevops/chukei/releases/download/v0.2.2/chukei-cli-x86_64-apple-darwin.tar.xz"
      sha256 "bd257b5a9dcda9068aae7cc1eff9b7528897e7dc6732add7a065aea84a20413a"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/osodevops/chukei/releases/download/v0.2.2/chukei-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "849346a4660ae9f659c25c5bf6de9a425ed9be950c76cf2e3143f87870842355"
  end
  license "FSL-1.1-ALv2"

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
    bin.install "chukei" if OS.mac? && Hardware::CPU.arm?
    bin.install "chukei" if OS.mac? && Hardware::CPU.intel?
    bin.install "chukei" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
