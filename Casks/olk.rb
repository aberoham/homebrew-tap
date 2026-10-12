cask "olk" do
  version "1.16.1"

  on_macos do
    on_arm do
      sha256 "4b07f51024a6f4dd04afb4d90b7bda49d66b6fedbe15c9c6725eb6eddd72d7c1"
      url "https://github.com/aberoham/olkcli/releases/download/upstream-v#{version}/olk_#{version}_darwin_arm64.tar.gz"
    end
    on_intel do
      sha256 "09c94d61c6071a64e1d37bc9cf38d80ea25c7c75fde0ac0a345ba76b6af90ea9"
      url "https://github.com/aberoham/olkcli/releases/download/upstream-v#{version}/olk_#{version}_darwin_amd64.tar.gz"
    end
  end

  name "olk"
  desc "CLI for Microsoft Outlook via Microsoft Graph API"
  homepage "https://github.com/rlrghb/olkcli"

  livecheck do
    skip "Updated by this tap's olk-cask workflow"
  end

  conflicts_with cask: "olk-next"

  binary "olk"
end
