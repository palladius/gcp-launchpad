#!/bin/bash
PDF="rag/public-slides/milano/[PUBLIC][Milano2511] Canonical Onramp + Gemini API Key v2.5.1.pdf"
OUTPUT_DIR="onramp-new/images/milano-pages"

mkdir -p "$OUTPUT_DIR"

# Get the number of pages in the PDF
NUM_PAGES=$(mutool info "$PDF" | grep -o 'Pages: [0-9]*' | awk '{print $2}')

for i in $(seq 1 $NUM_PAGES); do
    PAGE_DIR="$OUTPUT_DIR/page-$(printf "%02d" $i)"
    mkdir -p "$PAGE_DIR"
    mutool draw -o "$PAGE_DIR/image-%d.png" "$PDF" $i
    echo "Extracted images from page $i to $PAGE_DIR"
done
