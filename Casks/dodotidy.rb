cask "dodotidy" do
  version "1.0.1"
  sha256 "3fc3ed8753f82a9254cdd99c5068c727be76d964ff1d2460ddbb9d8682ae5118"

  url "https://github.com/bluewave-labs/DodoTidy/releases/download/v#{version}/DodoTidy-#{version}.dmg"
  name "DodoTidy"
  desc "macOS system cleaner and disk analyzer"
  homepage "https://github.com/bluewave-labs/DodoTidy"

  # Requires macOS 14.0 Sonoma or later
  depends_on macos: ">= :sonoma"

  app "DodoTidy.app"

  zap trash: [
    "~/Library/Preferences/com.dodotidy.app.plist",
  ]

  caveats <<~EOS
    DodoTidy is not notarized. On first launch, you may need to:
    1. Right-click the app and select "Open"
    2. Click "Open" in the security dialog

    Or run: xattr -cr /Applications/DodoTidy.app
  EOS
end
