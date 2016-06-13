#!/bin/sh

set -e

if [ ! -d "./node_modules" ]; then
  apk --no-cache add tar gcc make libc-dev libgcc libstdc++ python
	npm install --production
	apk --no-cache del tar gcc make libc-dev libgcc libstdc++
else
	npm update --production
fi

if [[ "$*" == npm*start* ]]; then
	baseDir="$GHOST_SOURCE/content"
	for dir in "$baseDir"/*/ "$baseDir"/themes/*/; do
		targetDir="$GHOST_CONTENT/${dir#$baseDir/}"
		mkdir -p "$targetDir"
		if [ -z "$(ls -A "$targetDir")" ]; then
			tar -c --one-file-system -C "$dir" . | tar xC "$targetDir"
		fi
	done

	if [ ! -e "$GHOST_CONTENT/config.js" ]; then
		sed -r '
			s/127\.0\.0\.1/0.0.0.0/g;
			s!path.join\(__dirname, (.)/content!path.join(process.env.GHOST_CONTENT, \1!g;
		' "$GHOST_SOURCE/config.example.js" > "$GHOST_CONTENT/config.js"
	fi
  rm -f $GHOST_SOURCE/config.js
	ln -sf "$GHOST_CONTENT/config.js" "$GHOST_SOURCE/config.js"
fi

exec "$@"
