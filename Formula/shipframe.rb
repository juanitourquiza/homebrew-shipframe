class Shipframe < Formula
  desc "AI coding workflows for teams that plan, prove, and ship"
  homepage "https://shipframe.hackeruna.com/"
  url "https://github.com/juanitourquiza/shipframe/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "fca869d30b049e61ddba50a8cb52cb885a6b52cc4ca7d90f3f37d6178c0049a3"
  license "MIT"

  depends_on "node"
  depends_on "python@3.14"

  resource "readme" do
    url "https://raw.githubusercontent.com/juanitourquiza/shipframe/v1.1.0/README.md"
    sha256 "ffcbf271201aa5d278246ae6e6f7031617131149e68111563fcbd88689682846"
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
        install --claude       Install for Claude Code (plugin + shared skills).
        install --openwork     Install physical shared skills for OpenWork Library discovery.
        install --opencode     Install for OpenCode (skills + converted agents + prompt router).
        install --codex        Install for Codex CLI (skills + workflow + optional prompt hook).
        install --codex-agents Install optional native Codex explorer/reviewer roles (use with --codex).
        install --all          Install for Claude Code, OpenCode, and Codex.
        install --pr-review   Install optional AI PR review (requires a target + provider).
        install --doctor       Run diagnostics. Use --repo-only for CI-safe checks.
        install --repair       Repair ShipFrame-owned artifacts. Dry-run unless --yes is passed.
        install --uninstall    Remove ShipFrame-owned artifacts. Dry-run unless --yes is passed.

      Examples:
        shipframe install --codex
        shipframe install --codex --codex-agents
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
          project_dir_set=false
          project_dir="$PWD"
          for arg in "$@"; do
            [ "$arg" = "--doctor" ] && doctor=true
            [ "$arg" = "--repo-only" ] && repo_only=true
            [ "$arg" = "--project-dir" ] && project_dir_set=true
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
          if [ "$project_dir_set" = false ]; then
            set -- --project-dir "$project_dir" "$@"
          fi
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
    assert_match "--codex-agents", shell_output("#{bin}/shipframe install --help")
    assert_match "--pr-review", shell_output("#{bin}/shipframe install --help")
    assert_match "Doctor summary:", shell_output("#{bin}/shipframe install --doctor --repo-only")

    home = testpath/"home"
    with_env("HOME" => home.to_s, "XDG_STATE_HOME" => (testpath/"state").to_s) do
      shell_output("#{bin}/shipframe install --openwork")
      skill = home/".claude/skills/code-review"
      assert_predicate skill, :directory?
      assert_path_exists skill/"SKILL.md"
      assert_path_exists skill/".shipframe-openwork.json"
      shell_output("#{bin}/shipframe install --uninstall --openwork --yes")
      refute_path_exists skill
    end

    # The wrapper must keep project artifacts out of Homebrew's read-only libexec.
    assert_path_exists libexec/"scripts/sf_pr_review.py"
  end
end
