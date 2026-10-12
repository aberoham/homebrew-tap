cask "olk-next" do
  version "1.16.2-alpha.1"

  on_macos do
    on_arm do
      sha256 "9117804de5159122561b86b1fc9b661c16b34e572fbdeb1c224c401f8d5e29d5"
      url "https://github.com/aberoham/olkcli/releases/download/v#{version}/olk_#{version}_darwin_arm64.tar.gz"
    end
    on_intel do
      sha256 "c5215f0aba85e751dd34049c92e191e412d44a3210b3d82a460ac8695cc174f5"
      url "https://github.com/aberoham/olkcli/releases/download/v#{version}/olk_#{version}_darwin_amd64.tar.gz"
    end
  end

  name "olk"
  desc "CLI for Microsoft Outlook via Microsoft Graph API (fork prereleases)"
  homepage "https://github.com/aberoham/olkcli"

  livecheck do
    skip "Updated by this tap's olk-cask workflow"
  end

  conflicts_with cask: "olk"

  binary "olk"
end
