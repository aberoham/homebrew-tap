class Chukei < Formula
  desc "Open-source cost optimization engine for Snowflake — verified caching, auto-suspend, SQL rewriting, attribution; deploys as a transparent proxy"
  homepage "https://chukei.dev"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/chukei/releases/download/v0.2.1/chukei-cli-aarch64-apple-darwin.tar.xz"
      sha256 "c4c2d26f25f1f4a9ab78d497d7a78d8170d9b87a3c871dd25dffbf9d7ec4f003"
    end
    if Hardware::CPU.intel?
      url "https://github.com/osodevops/chukei/releases/download/v0.2.1/chukei-cli-x86_64-apple-darwin.tar.xz"
      sha256 "fe09faf353c20d024edd201f1309dd7f3a7adf289fbbc4412a67fe9b01265b54"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/osodevops/chukei/releases/download/v0.2.1/chukei-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "24c09c121b67f616779c4cb707574f70cd6fa0f4a2e64482553252c2b275a3a6"
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
