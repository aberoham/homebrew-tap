cask "olk" do
  version "1.15.2-alpha.2"

  on_macos do
    on_arm do
      sha256 "1fa7694c587268f90be5b1e3cd9794b2d5b75ea5b7d3a94c68a49607d4e7b0cb"
      url "https://github.com/aberoham/olkcli/releases/download/v#{version}/olk_#{version}_darwin_arm64.tar.gz"
    end
    on_intel do
      sha256 "c512274531b40d521c9f2a4c4ba557488a826f4007cde8a151502643bbb2c57d"
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
