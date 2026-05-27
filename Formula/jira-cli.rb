class JiraCli < Formula
  desc "Fast, agent-friendly CLI for Atlassian Jira Cloud"
  homepage "https://github.com/osodevops/jira-cli"
  license "MIT"

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/osodevops/jira-cli/releases/download/v0.1.0/jira-aarch64-apple-darwin.tar.gz"
    sha256 "18eb4ea02544d3f47ffe7006fa118f1b50676481f6d85805d4cdbacddd714206"
  elsif OS.mac?
    url "https://github.com/osodevops/jira-cli/releases/download/v0.1.0/jira-x86_64-apple-darwin.tar.gz"
    sha256 "c52b29c26aa5ac8dc6bd2e2df52406b0aaf1de8dfdef7695326ab25fbecdbd47"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/osodevops/jira-cli/releases/download/v0.1.0/jira-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "57e9bad7f3018b2a6136ccd1420d04a54cfbd1b04bb9f4e09dd92e2c065bbb41"
  end

  def install
    package = Dir["jira-*"].first || "."
    bin.install "#{package}/bin/jira"
    bash_completion.install "#{package}/completions/jira.bash" => "jira"
    zsh_completion.install "#{package}/completions/_jira"
    fish_completion.install "#{package}/completions/jira.fish"
    man1.install Dir["#{package}/man/*.1"]
    doc.install "#{package}/README.md", "#{package}/CHANGELOG.md", "#{package}/LICENSE"
  end

  test do
    assert_match "jira #{version}", shell_output("#{bin}/jira --version")
    assert_match "Usage:", shell_output("#{bin}/jira --help")
  end
end
