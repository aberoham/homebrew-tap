class Pplx < Formula
  desc "A fast Perplexity API CLI built in Rust"
  homepage "https://github.com/osodevops/perplexity-cli"
  version "0.3.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/perplexity-cli/archive/refs/tags/v0.3.0.tar.gz"
      sha256 "e5c1ed1c94b94e1ab27e43c7c21c219d98604c47561009157b59e7b5b060d6f9"
    else
      url "https://github.com/osodevops/perplexity-cli/releases/download/v#{version}/pplx-x86_64-apple-darwin.tar.gz"
      sha256 "69f2c54d71dd7799280ba7e7f791e9a04af6c5235e23924e801336ccc71babb5"
    end
  end

  on_linux do
    url "https://github.com/osodevops/perplexity-cli/releases/download/v#{version}/pplx-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "28a1299659903b3305145a40b509b59cfee23f8888f74d9bd9d15fd9b5cf4f9b"
  end

  def install
    bin.install "pplx"
  end

  test do
    assert_match "pplx #{version}", shell_output("#{bin}/pplx --version")
  end
end
