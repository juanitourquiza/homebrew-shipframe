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

## Usage

```bash
shipframe install --claude
shipframe install --opencode
shipframe install --codex
shipframe install --all
```

ShipFrame v0.4.1 also exposes installer maintenance commands through the same
wrapper:

```bash
shipframe install --doctor --repo-only
shipframe install --repair --opencode --yes
shipframe install --uninstall --all --yes --purge
```
