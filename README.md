# Homebrew Tap for ShipFrame

Install ShipFrame on macOS with Homebrew:

```bash
brew tap juanitourquiza/shipframe
brew install shipframe
shipframe install --codex
```

If your Homebrew version requires tap trust, run the exact trust command it
prints, then install again:

```bash
brew trust --formula juanitourquiza/shipframe/shipframe
brew install shipframe
```

Other supported install targets:

```bash
shipframe install --claude
shipframe install --opencode
shipframe install --all
```
