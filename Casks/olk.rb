cask "olk" do
  version "1.14.1-alpha.2"

  on_macos do
    on_arm do
      sha256 "c6a7a082585b0b6d974b49a618917f9fba7112b1e0ecfb30f614745e7b45afbd"
      url "https://github.com/aberoham/olkcli/releases/download/v#{version}/olk_#{version}_darwin_arm64.tar.gz"
    end
    on_intel do
      sha256 "fe7e084f35db6c7fb7b75fec94d4f28306a7c94c4a551723bf1e34088d44b2f3"
      url "https://github.com/aberoham/olkcli/releases/download/v#{version}/olk_#{version}_darwin_amd64.tar.gz"
    end
  end

  name "olk"
  desc "CLI for Microsoft Outlook via Microsoft Graph API"
  homepage "https://github.com/aberoham/olkcli"

  livecheck do
    skip "Updated by this tap's update-olk-cask workflow"
  end

  binary "olk"
end
