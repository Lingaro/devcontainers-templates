#!/bin/bash
set -euo pipefail

echo '🚀 Dev Container Started!'

echo 'Fixing sbt/coursier cache permissions if needed...'
# Directories to ensure exist and are writable by the container user
CACHE_DIRS=(
	/samanta/.cache
	/samanta/.cache/coursier
	/samanta/.cache/sbt
	/home/user/.cache
	/home/user/.cache/sbt
	/home/user/.cache/coursier
	/home/user/.sbt
	/home/user/.ivy2
)

for d in "${CACHE_DIRS[@]}"; do
	if [ ! -d "$d" ]; then
		mkdir -p "$d" 2>/dev/null || true
	fi
	if [ ! -w "$d" ]; then
		sudo chown -R "$(id -u):$(id -g)" "$d" 2>/dev/null || true
	fi
done

echo 'Permissions ensured.'

exec "$@"
