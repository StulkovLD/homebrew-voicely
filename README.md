# Homebrew tap for Voicely

[Voicely](https://voicely.art) is free, open-source, offline dictation and transcription for macOS, with a local MCP server for Claude Code, Codex and Cursor. Source: [StulkovLD/Voicely](https://github.com/StulkovLD/Voicely).

```bash
brew install --cask stulkovld/voicely/voicely
```

Requires macOS 14+ on Apple Silicon. The cask installs `Voicely.app` and puts the `voicely` CLI on your PATH; then run `voicely connect` to register the MCP server with your agents.

The build is ad-hoc signed and not notarized. Like the official installer (`curl -fsSL https://voicely.art/install.sh | sh`), the cask pins the DMG by SHA-256, clears the quarantine flag on that bundle only and resets Voicely's own permission grants, so macOS asks for Microphone and Accessibility again after each upgrade.

Upgrade: `brew upgrade --cask voicely`. Remove: `brew uninstall --cask voicely` (add `--zap` to also delete settings; transcripts in `~/Documents/Voicely` are always kept).
