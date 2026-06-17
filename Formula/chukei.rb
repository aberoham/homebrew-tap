class Chukei < Formula
  desc "Snowflake cost optimization proxy with verified caching"
  homepage "https://chukei.dev"
  version "0.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/chukei/releases/download/v0.2.2/chukei-cli-aarch64-apple-darwin.tar.xz"
      sha256 "a32ceca9a4a2006c2a1721e523e228abb8a54271b59038b56376b35e0d8558ca"
    end
    if Hardware::CPU.intel?
      url "https://github.com/osodevops/chukei/releases/download/v0.2.2/chukei-cli-x86_64-apple-darwin.tar.xz"
      sha256 "e7c1ed32c52ada987b404864ab545f01ceb9e5c43c653c0efec9cbaa429e6893"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/osodevops/chukei/releases/download/v0.2.2/chukei-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "ca25ab04b48ab8783239635923acedb2d273e46860ec6cd0b9d89c8dc7471a99"
  end
  license "Apache-2.0"

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
