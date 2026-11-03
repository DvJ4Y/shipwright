#!/usr/bin/env bash
# Guard a folder against edits by an external reviewer (another model or tool).
# Usage:
#   bash scripts/review-guard.sh snapshot <folder>   # record hashes and keep a copy
#   bash scripts/review-guard.sh verify <folder>     # list changed, added and removed files
#   bash scripts/review-guard.sh restore <folder>    # put the snapshot back
# The snapshot lives in /tmp/review-guard/<folder-name>/. Exit 1 if verify finds any change.
set -euo pipefail

cmd="${1:-}"; dir="${2:-}"
[ -n "$cmd" ] && [ -d "$dir" ] || { echo "usage: $0 snapshot|verify|restore <folder>" >&2; exit 2; }
dir="$(cd "$dir" && pwd)"
store="/tmp/review-guard/$(echo "$dir" | tr '/ &' '___')"

hashes() { (cd "$1" && find . -type f ! -name .DS_Store -print0 | sort -z | xargs -0 shasum -a 256); }

case "$cmd" in
  snapshot)
    rm -rf "$store"; mkdir -p "$store/copy"
    hashes "$dir" > "$store/manifest"
    cp -R "$dir/." "$store/copy/"
    echo "snapshot: $(wc -l < "$store/manifest" | tr -d ' ') files -> $store" ;;
  verify)
    [ -f "$store/manifest" ] || { echo "no snapshot for $dir" >&2; exit 2; }
    hashes "$dir" > "$store/now"
    if diff -q "$store/manifest" "$store/now" >/dev/null; then echo "verify: no changes"; exit 0; fi
    echo "verify: CHANGED"
    diff <(awk '{print $2" "$1}' "$store/manifest" | sort) <(awk '{print $2" "$1}' "$store/now" | sort) \
      | awk '/^< /{print "  before: "$2} /^> /{print "  after:  "$2}' | sort -u -k2
    exit 1 ;;
  restore)
    [ -d "$store/copy" ] || { echo "no snapshot for $dir" >&2; exit 2; }
    rsync -a --delete "$store/copy/" "$dir/"
    echo "restored $dir from snapshot" ;;
  *) echo "unknown command $cmd" >&2; exit 2 ;;
esac
