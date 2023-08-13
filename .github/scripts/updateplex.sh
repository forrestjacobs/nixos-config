#!/usr/bin/env bash

# Run by Github Actions to update Plex Pass version in hosts/boimler/plexpass.json
# Thanks to https://gist.github.com/iamevn/11952b966c05ca799f4910e02c2ffe4a

set -euo pipefail

versionInfo=$(curl -s -H "X-Plex-Token: ${PLEX_TOKEN}" "https://plex.tv/api/downloads/5.json?channel=plexpass" | jq '{
  version: .computer.Linux.version,
  release: .computer.Linux.releases | map(select(.build == "linux-x86_64" and .distro == "debian"))[0],
}')

hashed=$(nix-hash --to-base32 "$(echo "$versionInfo" | jq -r '.release.checksum')" --type sha1)

echo "$versionInfo" | jq '.sha1 = "'"$hashed"'"' > ./hosts/boimler/plexpass.json

git add ./hosts/boimler/plexpass.json
git diff --staged --quiet || git commit -m "Updated plexpass.json"
