class Shipframe < Formula
  desc "AI coding workflows for teams that plan, prove, and ship"
  homepage "https://github.com/juanitourquiza/shipframe"
  url "https://github.com/juanitourquiza/shipframe/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "d5de834fa7b2d39c3fd5fd9b2debb980163d464bbf1b7535d70852a639811443"
  license "MIT"

  depends_on "node"

  def install
    libexec.install Dir["*"]

    (bin/"shipframe").write <<~BASH
      #!/usr/bin/env bash
      set -euo pipefail

      usage() {
        cat <<'USAGE'
      Usage: shipframe <command> [options]

      Commands:
        install --claude     Install for Claude Code.
        install --opencode   Install for OpenCode (skills + converted agents).
        install --codex      Install for Codex CLI (skills + orchestrator workflow).
        install --all        Install for Claude Code, OpenCode, and Codex.

      Examples:
        shipframe install --codex
        shipframe install --claude
        shipframe install --opencode
        shipframe install --all
      USAGE
      }

      case "${1:-}" in
        install)
          shift
          exec "#{libexec}/install.sh" "$@"
          ;;
        -h|--help|help|"")
          usage
          ;;
        *)
          echo "Unknown command: $1" >&2
          usage >&2
          exit 1
          ;;
      esac
    BASH
  end

  test do
    assert_match "Usage: shipframe", shell_output("#{bin}/shipframe --help")
    assert_match "Usage: install.sh", shell_output("#{bin}/shipframe install --help")
  end
end
