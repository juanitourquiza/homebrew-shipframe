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


## Optional: Herdr plugin

Homebrew installs the base ShipFrame toolkit only. Install the Herdr surface separately:

```bash
herdr plugin install juanitourquiza/shipframe/herdr-plugin --yes
```

Docs: https://github.com/juanitourquiza/shipframe#herdr-local-workflow-plugin

## Optional: concise agent responses with Caveman

Homebrew installs ShipFrame only. If you want shorter internal agent responses,
add Caveman separately:

```bash
npx skills add JuliusBrussee/caveman
```

Caveman is opt-in: activate it with `/caveman` when concise responses help, and
return to normal wording with `normal mode` for release evidence, customer copy,
security work, or destructive actions.

## Usage

```bash
shipframe install --claude
shipframe install --opencode
shipframe install --codex
shipframe install --all
```

ShipFrame v0.4.8 also exposes installer maintenance commands through the same
wrapper:

```bash
shipframe install --doctor --repo-only
shipframe install --doctor
shipframe install --repair --opencode --yes
shipframe install --uninstall --all --yes --purge
```

## Optional: cross-host prompt fast path

ShipFrame v0.4.8 adds an advisory prompt fast path for Claude Code, Codex CLI, and OpenCode. It can bypass, suggest, or route to a matching workflow; it does not replace explicit user direction. Codex hooks require user trust, and OpenCode plugin registration stays under your control.

## Optional: Live Docs with Context MCP

ShipFrame recommends Context MCP when you want versioned local library docs for the optional `live-docs` workflow. ShipFrame works without it; Homebrew installs only ShipFrame and never runs npm or edits Claude Code, Codex CLI, or OpenCode configuration for you.

```bash
npm install -g @neuledge/context
claude mcp add context -- context serve
codex mcp add context -- context serve
# OpenCode v2: add command ["context", "serve"] under mcp.servers.context in ~/.config/opencode/opencode.json
shipframe install --doctor
```
