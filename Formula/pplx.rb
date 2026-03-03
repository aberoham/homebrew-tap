class Pplx < Formula
  desc "A fast Perplexity API CLI built in Rust"
  homepage "https://github.com/osodevops/perplexity-cli"
  version "0.3.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/osodevops/perplexity-cli/releases/download/v0.3.2/pplx-aarch64-apple-darwin.tar.gz"
      sha256 "d297b5c36c305d648941458297a284dfa23517e77624b59ea9fecc9693f8ff8e"
    else
      url "https://github.com/osodevops/perplexity-cli/releases/download/v0.3.2/pplx-x86_64-apple-darwin.tar.gz"
      sha256 "0667dd97ab0da7315a9ad5423a325bc8247db798b628b8f955dac57160cf59c9"
    end
  end

  on_linux do
    url "https://github.com/osodevops/perplexity-cli/releases/download/v0.3.2/pplx-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "9f557e855d3ae2cce33b7d5a6fd2fc069e48a4082f9e1aad9a6cdf3a19901863"
  end

  def install
    bin.install "pplx"
  end

  test do
    assert_match "pplx #{version}", shell_output("#{bin}/pplx --version")
  end
end
