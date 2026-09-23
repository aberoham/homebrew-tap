cask "olk" do
  version "1.14.1-alpha.1"

  on_macos do
    on_arm do
      sha256 "34c5a18d138a835f47df2272d6b8ea29b7e971a9dbeded1062a679fdbd9f4833"
      url "https://github.com/aberoham/olkcli/releases/download/v#{version}/olk_#{version}_darwin_arm64.tar.gz"
    end
    on_intel do
      sha256 "621bb87263f9ef4b1761b2d2d402b1ad16159d5c0dd67691e482a2b374a31c6c"
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

  postflight do
    system_command "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "#{staged_path}/olk"]
  end
end
