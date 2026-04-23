#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_SLUG="${REPO_SLUG:-apiasak/opbstack}"
TMP_DIRS=()

cleanup() {
  for dir in "${TMP_DIRS[@]:-}"; do
    rm -rf "$dir"
  done
}

trap cleanup EXIT

section() {
  printf '\n== %s ==\n' "$1"
}

pass() {
  printf 'OK: %s\n' "$1"
}

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

make_tmp_dir() {
  local dir
  dir="$(mktemp -d)"
  TMP_DIRS+=("$dir")
  printf '%s\n' "$dir"
}

assert_file() {
  local path="$1"
  [[ -f "$path" ]] || fail "missing file: $path"
}

assert_dir() {
  local path="$1"
  [[ -d "$path" ]] || fail "missing directory: $path"
}

assert_symlink() {
  local path="$1"
  [[ -L "$path" ]] || fail "missing symlink: $path"
}

check_assets() {
  section "Assets"
  assert_file "$ROOT_DIR/assets/cover/opbstack-cover.png"
  assert_file "$ROOT_DIR/assets/logos/claude.svg"
  assert_file "$ROOT_DIR/assets/logos/openclaw.svg"
  assert_file "$ROOT_DIR/assets/logos/hermes-agent.png"
  assert_file "$ROOT_DIR/assets/opbstack-hero.svg"
  pass "required cover and logo assets exist"
}

check_branding() {
  section "Branding"
  if git -C "$ROOT_DIR" grep -n -E 'thaismestack|THAISTACK' -- . >/dev/null; then
    git -C "$ROOT_DIR" grep -n -E 'thaismestack|THAISTACK' -- . >&2 || true
    fail "legacy branding still present in tracked files"
  fi
  pass "no legacy thaismestack strings remain in tracked files"
}

check_setup_syntax() {
  section "Shell Syntax"
  bash -n "$ROOT_DIR/setup"
  pass "setup script parses cleanly"
}

run_setup_mode_test() {
  local mode="$1"
  local home_dir
  home_dir="$(make_tmp_dir)"

  case "$mode" in
    opencode)
      HOME="$home_dir" OPENCODE_CONFIG_DIR="$home_dir/.config/opencode" "$ROOT_DIR/setup" opencode >/dev/null
      assert_file "$home_dir/.config/opencode/opbstack-example.json"
      assert_symlink "$home_dir/.config/opencode/skills/opbstack"
      ;;
    claude)
      HOME="$home_dir" "$ROOT_DIR/setup" claude >/dev/null
      assert_dir "$home_dir/.claude/skills/opbstack"
      assert_file "$home_dir/.claude/CLAUDE.md"
      ;;
    paperclip)
      HOME="$home_dir" "$ROOT_DIR/setup" paperclip >/dev/null
      assert_dir "$home_dir/.paperclip/skills/thaistrategist"
      assert_file "$home_dir/.paperclip/opbstack-example.yaml"
      ;;
    openclaw)
      HOME="$home_dir" "$ROOT_DIR/setup" openclaw >/dev/null
      assert_dir "$home_dir/.openclaw/skills/opbstack-strategist"
      assert_file "$home_dir/.openclaw/CLAUDE.md"
      ;;
    hermes)
      HOME="$home_dir" "$ROOT_DIR/setup" hermes >/dev/null
      assert_dir "$home_dir/.hermes/skills/opbstack-strategist"
      assert_file "$home_dir/.hermes/CLAUDE.md"
      ;;
    *)
      fail "unknown setup test mode: $mode"
      ;;
  esac

  pass "setup $mode"
}

check_setup_outputs() {
  section "Setup Dry Runs"
  run_setup_mode_test opencode
  run_setup_mode_test claude
  run_setup_mode_test paperclip
  run_setup_mode_test openclaw
  run_setup_mode_test hermes
}

check_github_readme() {
  section "GitHub README"

  if ! command -v gh >/dev/null 2>&1; then
    pass "skipped GitHub check because gh is unavailable"
    return
  fi

  if ! command -v curl >/dev/null 2>&1; then
    pass "skipped GitHub check because curl is unavailable"
    return
  fi

  local download_url
  local readme_body

  download_url="$(gh api "repos/$REPO_SLUG/contents/README.md" --jq '.download_url')"
  readme_body="$(curl -fsSL "$download_url")"

  grep -q './assets/cover/opbstack-cover.png' <<<"$readme_body" || fail "GitHub README does not reference the repo-local cover image"
  gh api "repos/$REPO_SLUG/contents/assets/cover/opbstack-cover.png" --jq '.path' >/dev/null
  pass "GitHub README and cover asset are reachable for $REPO_SLUG"
}

main() {
  section "Smoke Test"
  printf 'repo: %s\n' "$ROOT_DIR"
  printf 'remote: %s\n' "$REPO_SLUG"

  check_assets
  check_branding
  check_setup_syntax
  check_setup_outputs
  check_github_readme

  section "Summary"
  pass "all smoke checks passed"
}

main "$@"
