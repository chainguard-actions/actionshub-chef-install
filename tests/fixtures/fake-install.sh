#!/bin/sh
# Fake omnitruck install.sh — records the args it was called with and creates a dummy binary
# Usage: bash -s -- -c <channel> -P <project> [-v <version>]
CHANNEL=""
PROJECT=""
VERSION=""

while [ $# -gt 0 ]; do
  case "$1" in
    -c) CHANNEL="$2"; shift 2 ;;
    -P) PROJECT="$2"; shift 2 ;;
    -v) VERSION="$2"; shift 2 ;;
    *) shift ;;
  esac
done

echo "FAKE_INSTALL: channel=${CHANNEL} project=${PROJECT} version=${VERSION}"

# Write the recorded args to a temp file so tests can inspect them
echo "channel=${CHANNEL}" > /tmp/chef-install-args.txt
echo "project=${PROJECT}" >> /tmp/chef-install-args.txt
echo "version=${VERSION}" >> /tmp/chef-install-args.txt

# Create a dummy binary so PATH checks work
mkdir -p /usr/local/bin
cat > /usr/local/bin/chef-workstation << 'EOF'
#!/bin/sh
echo "fake chef-workstation"
EOF
chmod +x /usr/local/bin/chef-workstation

echo "Fake Chef install complete."
