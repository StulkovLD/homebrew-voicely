cask "voicely" do
  version "1.4.4,76daae3718df,4bc1c044508b99deecef0942f8b1dc181fdae5bf146a6eb140cc20c6fabcca86"
  sha256 "4bc1c044508b99deecef0942f8b1dc181fdae5bf146a6eb140cc20c6fabcca86"

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
  depends_on macos: :sonoma

  app "Voicely.app"
  binary "#{appdir}/Voicely.app/Contents/Helpers/voicely"

  # The public build is ad-hoc signed and not notarized. As the official
  # installer (https://voicely.art/install.sh) does, the sha256 above pins the
  # exact DMG and the quarantine flag is cleared on that bundle only.
  postflight_steps do
    run "/usr/bin/xattr",
        args:         ["-dr", "com.apple.quarantine", "{{appdir}}/Voicely.app"],
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
    downloaded once, on-device.

    The ad-hoc code identity changes with every release. After an upgrade,
    reset the old grants so macOS asks again cleanly:
      tccutil reset All art.voicely.app

    Connect it to your AI agents (Claude Code, Codex, Cursor, ...):
      voicely connect
  EOS
end
