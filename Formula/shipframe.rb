class Shipframe < Formula
  desc "AI coding workflows for teams that plan, prove, and ship"
  homepage "https://shipframe.hackeruna.com/"
  url "https://github.com/juanitourquiza/shipframe/archive/refs/tags/v0.4.8.tar.gz"
  sha256 "e9042430b4f6fdfaad715a743c5f28088e4ff875cfb187eef6c1b20dac2a7948"
  license "MIT"

  depends_on "node"

  resource "readme" do
    url "https://raw.githubusercontent.com/juanitourquiza/shipframe/v0.4.8/README.md"
    sha256 "ab0b88a06cc58113ea93f5c29a24c94ee6a0b95851d4c274836f76b788cc0047"
  end

  def install
    libexec.install Dir["*"]
    resource("readme").stage { (libexec/"SHIPFRAME_README.md").write File.read("README.md") }
    libexec.install ".claude-plugin" if File.directory?(".claude-plugin")

    (bin/"shipframe").write <<~BASH
      #!/usr/bin/env bash
      set -euo pipefail

      usage() {
        cat <<'USAGE'
      Usage: shipframe <command> [options]

      Commands:
        install --claude       Install for Claude Code.
        install --opencode     Install for OpenCode (skills + converted agents + prompt router).
        install --codex        Install for Codex CLI (skills + workflow + optional prompt hook).
        install --all          Install for Claude Code, OpenCode, and Codex.
        install --doctor       Run diagnostics. Use --repo-only for CI-safe checks.
        install --repair       Repair ShipFrame-owned artifacts. Dry-run unless --yes is passed.
        install --uninstall    Remove ShipFrame-owned artifacts. Dry-run unless --yes is passed.

      Examples:
        shipframe install --codex
        shipframe install --doctor --repo-only
        shipframe install --doctor
        shipframe install --repair --opencode --yes
        shipframe install --uninstall --all --yes --purge
      USAGE
      }

      case "${1:-}" in
        install)
          shift
          doctor=false
          repo_only=false
          for arg in "$@"; do
            [ "$arg" = "--doctor" ] && doctor=true
            [ "$arg" = "--repo-only" ] && repo_only=true
          done
          if [ "$doctor" = true ] && [ "$repo_only" = true ] && [ ! -e "#{libexec}/README.md" ]; then
            source_tmp="$(mktemp -d "${TMPDIR:-/tmp}/shipframe-homebrew-source.XXXXXX")"
            for path in "#{libexec}"/* "#{libexec}"/.claude-plugin; do
              [ -e "$path" ] || continue
              name="$(basename "$path")"
              [ "$name" = "README.md" ] && continue
              if [ -d "$path" ]; then
                cp -R "$path" "$source_tmp/$name"
              else
                ln -s "$path" "$source_tmp/$name"
              fi
            done
            ln -s "#{libexec}/SHIPFRAME_README.md" "$source_tmp/README.md"
            "$source_tmp/install.sh" "$@"
            exit $?
          fi
          cd "#{libexec}"
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
    assert_match "--doctor", shell_output("#{bin}/shipframe install --help")
    assert_match "Doctor summary:", shell_output("#{bin}/shipframe install --doctor --repo-only")
  end
end
