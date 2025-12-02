#!/bin/bash

# Script to check and resize screenshots to App Store requirements
# Usage: ./check_and_resize_screenshots.sh <folder_path>

FOLDER="${1:-~/Desktop}"

# Required dimensions for iPhone 6.5" Display
REQUIRED_WIDTH=1242
REQUIRED_HEIGHT=2688

# Alternative dimensions (iPhone 14 Pro Max)
ALT_WIDTH=1284
ALT_HEIGHT=2778

echo "📸 Checking screenshots in: $FOLDER"
echo "Required dimensions: ${REQUIRED_WIDTH}x${REQUIRED_HEIGHT} or ${ALT_WIDTH}x${ALT_HEIGHT}"
echo ""

# Check if sips is available
if ! command -v sips &> /dev/null; then
    echo "❌ Error: sips command not found. This script requires macOS."
    exit 1
fi

# Find image files (1.png, 2.png, 3.png, etc.)
found=0
for img in "$FOLDER"/{1,2,3}.{png,jpg,PNG,JPG} 2>/dev/null; do
    if [ -f "$img" ]; then
        found=1
        filename=$(basename "$img")
        
        # Get current dimensions
        width=$(sips -g pixelWidth "$img" 2>/dev/null | grep pixelWidth | awk '{print $2}')
        height=$(sips -g pixelHeight "$img" 2>/dev/null | grep pixelHeight | awk '{print $2}')
        
        echo "📷 File: $filename"
        echo "   Current size: ${width}x${height}px"
        
        # Check if dimensions are correct
        if [ "$width" = "$REQUIRED_WIDTH" ] && [ "$height" = "$REQUIRED_HEIGHT" ]; then
            echo "   ✅ Correct dimensions!"
        elif [ "$width" = "$ALT_WIDTH" ] && [ "$height" = "$ALT_HEIGHT" ]; then
            echo "   ✅ Correct dimensions (iPhone 14 Pro Max)!"
        else
            echo "   ⚠️  Wrong dimensions! Resizing..."
            
            # Create output filename
            output="${img%.*}_resized.${img##*.}"
            
            # Resize to required dimensions (maintain aspect ratio and crop if needed)
            sips -z $REQUIRED_HEIGHT $REQUIRED_WIDTH "$img" --out "$output" > /dev/null 2>&1
            
            if [ $? -eq 0 ]; then
                # Verify new dimensions
                new_width=$(sips -g pixelWidth "$output" 2>/dev/null | grep pixelWidth | awk '{print $2}')
                new_height=$(sips -g pixelHeight "$output" 2>/dev/null | grep pixelHeight | awk '{print $2}')
                echo "   ✅ Resized to: ${new_width}x${new_height}px"
                echo "   📁 Saved as: $(basename "$output")"
            else
                echo "   ❌ Failed to resize"
            fi
        fi
        echo ""
    fi
done

if [ $found -eq 0 ]; then
    echo "⚠️  No screenshots found (1.png, 2.png, 3.png) in $FOLDER"
    echo ""
    echo "Please provide the folder path:"
    echo "  ./check_and_resize_screenshots.sh ~/Desktop"
    echo "  ./check_and_resize_screenshots.sh ~/Downloads"
fi

