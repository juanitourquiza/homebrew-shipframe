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

Pull requests run the formula style check, strict online audit, release livecheck, source install, and formula smoke test on macOS.


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
shipframe install --openwork
shipframe install --opencode
shipframe install --codex
shipframe install --all
```

ShipFrame v0.7.3 adds a dedicated OpenWork skills target and exposes installer
maintenance commands through the same wrapper:

```bash
shipframe install --doctor --repo-only
shipframe install --doctor
shipframe install --repair --opencode --yes
shipframe install --uninstall --all --yes --purge
```

For OpenWork, `shipframe install --openwork` links the shared skill catalog into
`~/.claude/skills`; OpenWork Library lists the skills individually, rather than
as a single `shipframe` item. The Homebrew formula installs the toolkit; these
per-tool skill links are created only when you run the installer.

## Optional: cross-host prompt fast path

ShipFrame v0.7.2 adds CI validation for skill and agent metadata contracts and formalizes the QA `small` path as reduced test depth only; it never skips final review. It also includes the bilingual preventive security-hardening workflow, evidence-based security review, optional technology packs, and the advisory prompt fast path. These are workflow/review guides, not installed libraries. Explicit user direction takes precedence. Codex hooks require user trust, and OpenCode plugin registration stays under your control.

## Optional: Live Docs with Context MCP

ShipFrame recommends Context MCP when you want versioned local library docs for the optional `live-docs` workflow. ShipFrame works without it; Homebrew installs only ShipFrame and never runs npm or edits Claude Code, Codex CLI, or OpenCode configuration for you.

```bash
npm install -g @neuledge/context
claude mcp add context -- context serve
codex mcp add context -- context serve
# OpenCode v2: add command ["context", "serve"] under mcp.servers.context in ~/.config/opencode/opencode.json
shipframe install --doctor
```
