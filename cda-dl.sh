#!/usr/bin/env bash

temp="cda-dl.temp"
ids="cda-dl-ids.temp"

URL="$1"

while true; do
  echo "Downloading $URL..."

  curl -s "$URL"  > "$temp"

  pcregrep -o1 'href="/video/(\w+)' "$temp" | sort | uniq >> "$ids"

  URL=$(pcregrep -o1 'href="(.+)" class="next"' "$temp" | head -n1)

  if [[ $URL ]]; then
    echo "Has next page..."
  else
    echo "Done downloading list..."

    break
  fi
done

while read -r id; do
  echo "Downloading $id"

  yt-dlp "https://www.cda.pl/video/$id"
done < "$ids"

echo "Clean up!"
rm "$ids" "$temp"

echo "All done!"
