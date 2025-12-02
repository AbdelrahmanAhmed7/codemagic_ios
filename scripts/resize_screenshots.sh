#!/bin/bash

# Script to resize screenshots to App Store requirements
# Usage: ./resize_screenshots.sh <input_folder> <output_folder>

INPUT_FOLDER="${1:-./screenshots}"
OUTPUT_FOLDER="${2:-./screenshots_resized}"

# Create output folder if it doesn't exist
mkdir -p "$OUTPUT_FOLDER"

# Required dimensions for iPhone 6.5" Display
WIDTH=1242
HEIGHT=2688

echo "📸 Resizing screenshots to ${WIDTH}x${HEIGHT}px..."
echo "Input: $INPUT_FOLDER"
echo "Output: $OUTPUT_FOLDER"
echo ""

# Check if sips (macOS built-in tool) is available
if ! command -v sips &> /dev/null; then
    echo "❌ Error: sips command not found. This script requires macOS."
    exit 1
fi

# Process all images in input folder
count=0
for img in "$INPUT_FOLDER"/*.{png,jpg,jpeg,PNG,JPG,JPEG} 2>/dev/null; do
    if [ -f "$img" ]; then
        filename=$(basename "$img")
        output_path="$OUTPUT_FOLDER/$filename"
        
        echo "Processing: $filename"
        
        # Resize using sips (macOS built-in)
        sips -z $HEIGHT $WIDTH "$img" --out "$output_path" > /dev/null 2>&1
        
        if [ $? -eq 0 ]; then
            echo "✅ Resized: $filename"
            count=$((count + 1))
        else
            echo "❌ Failed: $filename"
        fi
    fi
done

if [ $count -eq 0 ]; then
    echo ""
    echo "⚠️  No images found in $INPUT_FOLDER"
    echo "Usage: ./resize_screenshots.sh <input_folder> <output_folder>"
else
    echo ""
    echo "✅ Done! Resized $count image(s)"
    echo "📁 Output folder: $OUTPUT_FOLDER"
fi

