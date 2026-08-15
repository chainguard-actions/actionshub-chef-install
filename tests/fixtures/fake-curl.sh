#!/bin/sh
# Fake curl: intercepts omnitruck.chef.io install.sh requests.
# Supports both pipe form (stdout) and hardened form (-o FILE).
# Falls through to real curl for all other URLs.

out=""
prev=""
for arg in "$@"; do
  case "$prev" in
    -o|--output) out="$arg" ;;
  esac
  prev="$arg"
done

case "$*" in
  *omnitruck*install.sh*)
    PAYLOAD="$GITHUB_WORKSPACE/tests/fixtures/fake-install.sh"
    if [ -n "$out" ]; then
      cat "$PAYLOAD" > "$out"
    else
      cat "$PAYLOAD"
    fi
    exit 0
    ;;
esac

# Fall through to real curl for anything else
exec /usr/bin/curl "$@"
