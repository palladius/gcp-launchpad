#!/bin/bash
PDF="rag/public-slides/milano/[PUBLIC][Milano2511] Canonical Onramp + Gemini API Key v2.5.1.pdf"
OUTPUT_DIR="onramp-new/images/milano-pages"

mkdir -p "$OUTPUT_DIR"

pdftoppm -png "$PDF" "$OUTPUT_DIR/page"
