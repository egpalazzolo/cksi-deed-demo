#!/bin/bash

# run with command ./make_derivatives.sh

# Ensure derivative directories exist
mkdir -p objects/small
mkdir -p objects/thumbs

# Loop through all PDFs in objects/
for file in objects/*.pdf; do
    base=$(basename "$file" .pdf)

    echo "Processing $file ..."

    # Small derivative (800px wide)
    magick "${file}[0]" \
        -resize 800x \
        -quality 85 \
        "objects/small/${base}_sm.jpg"

    # Thumb derivative (450px wide)
    magick "${file}[0]" \
        -resize 450x \
        -quality 85 \
        "objects/thumbs/${base}_th.jpg"
done

echo "All derivatives created!"