#!/bin/bash
for img in onramp/images/slide-*.png; do
  if [ -f "$img" ]; then
    filename=$(basename -- "$img")
    filenumber_extension="${filename#slide-}"
    filenumber="${filenumber_extension%.png}"
    mkdir -p "onramp/images/slide-$filenumber"
    mv "$img" "onramp/images/slide-$filenumber/image.png"
    echo "Moved $img to onramp/images/slide-$filenumber/image.png"
  fi
done
