cask "voicely" do
  version "1.4.2,92c58814c0ba,7ac3d947ff943e0816253c786058b9a07b94151bfb3c0fe696cc6929ec64b2be"
  sha256 "7ac3d947ff943e0816253c786058b9a07b94151bfb3c0fe696cc6929ec64b2be"

  url "https://voicely.art/Voicely-#{version.csv.first}-#{version.csv.second}-#{version.csv.third}.dmg"
  name "Voicely"
  desc "Offline dictation and transcription with an MCP server for AI agents"
  homepage "https://voicely.art/"

  livecheck do
    url "https://voicely.art/install.sh"
    regex(/Voicely[._-]v?(\d+(?:\.\d+)+)[._-](\h+)[._-](\h+)\.dmg/i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| "#{match[0]},#{match[1]},#{match[2]}" }
    end
  end

  depends_on arch: :arm64
  depends_on macos: ">= :sonoma"

  app "Voicely.app"
  binary "#{appdir}/Voicely.app/Contents/Helpers/voicely"

  # The public build is ad-hoc signed and not notarized. This mirrors the
  # official installer (https://voicely.art/install.sh): the hash above pins
  # the exact DMG, then the quarantine flag is cleared on that bundle only and
  # Voicely's own permission grants are reset, because the ad-hoc code
  # identity changes between releases.
  postflight do
    system_command "/usr/bin/xattr",
                   args:         ["-dr", "com.apple.quarantine", "#{appdir}/Voicely.app"],
                   must_succeed: false
    system_command "/usr/bin/tccutil",
                   args:         ["reset", "All", "art.voicely.app"],
                   must_succeed: false
  end

  uninstall quit: "art.voicely.app"

  # Transcripts in ~/Documents/Voicely are user data and are never removed.
  zap trash: [
    "~/Library/Application Support/Voicely",
    "~/Library/Caches/art.voicely.app",
    "~/Library/HTTPStorages/art.voicely.app",
    "~/Library/Preferences/art.voicely.app.plist",
    "~/Library/Saved Application State/art.voicely.app.savedState",
  ]

  caveats <<~EOS
    Voicely is ad-hoc signed and not notarized by Apple. On first launch,
    approve Microphone and Accessibility; the speech model (~470 MB) is
    downloaded once, on-device. After each upgrade macOS asks for those
    permissions again.

    Connect it to your AI agents (Claude Code, Codex, Cursor, ...):
      voicely connect
  EOS
end
