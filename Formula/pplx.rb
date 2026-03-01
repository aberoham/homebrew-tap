class Pplx < Formula
  desc "A fast Perplexity API CLI built in Rust"
  homepage "https://github.com/osodevops/perplexity-cli"
  version "0.2.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/perplexity-cli/releases/download/v#{version}/pplx-aarch64-apple-darwin.tar.gz"
      sha256 "91b041daaf3e0587c80ac6580d23ea0cb062b89897667f17638c244ab6568d1a"
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
