cask "olk" do
  version "1.15.2-alpha.1"

  on_macos do
    on_arm do
      sha256 "d1767634cb079afc7a9810e6d7110f1dc37eeb36728fdbd54ff82083e092ac0f"
      url "https://github.com/aberoham/olkcli/releases/download/v#{version}/olk_#{version}_darwin_arm64.tar.gz"
    end
    on_intel do
      sha256 "3e1c0c5e6236cc2b95fafe5cf93cec33ad6a82b1dd771012e6b09ed2412e5a4e"
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
