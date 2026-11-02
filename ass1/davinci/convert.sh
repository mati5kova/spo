#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Usage: $0 <image>"
    exit 1
fi

# ali datoteka obstaja
if [ ! -f "$1" ]; then
    echo "Error: File '$1' does not exist."
    exit 1
fi

# Naredi sivinsko sliko:
# vsak piksel je 8-bitni
# velikost 128x128
# ne ohrani prvotnega razmerja stranic

magick "$1" -resize 128x128! -colorspace Gray -depth 8 gray:CA.dev

echo "Image converted to CA.dev"