#!/bin/bash

# Export PlantUML Diagrams to SVG
# Run this script to generate SVG files from all PlantUML diagrams

echo "🎨 Exporting PlantUML diagrams to SVG..."
echo ""

# Check if PlantUML is installed
if ! command -v plantuml &> /dev/null; then
    echo "❌ Error: PlantUML is not installed!"
    echo ""
    echo "Install it with:"
    echo "  macOS:    brew install plantuml"
    echo "  Ubuntu:   sudo apt install plantuml"
    echo "  Windows:  choco install plantuml"
    echo ""
    exit 1
fi

# Create exports directory if it doesn't exist
mkdir -p ../exports

# Export all .puml files to SVG
count=0
for file in *.puml; do
    if [ -f "$file" ]; then
        echo "📝 Processing $file..."
        plantuml -tsvg "$file"
        count=$((count + 1))
    fi
done

# Move SVG files to exports directory
if [ $count -gt 0 ]; then
    mv *.svg ../exports/ 2>/dev/null
    echo ""
    echo "✅ Successfully exported $count diagram(s) to ../exports/"
    echo ""
    echo "Files created:"
    ls -1 ../exports/*.svg
    echo ""
    echo "💡 Tip: Commit these SVG files to Git for GitBook embedding:"
    echo "   git add ../exports/*.svg"
    echo "   git commit -m \"Add PlantUML diagram exports\""
    echo "   git push"
else
    echo ""
    echo "⚠️  No .puml files found to export"
fi

echo ""
echo "Done! 🎉"

