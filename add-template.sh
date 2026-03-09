#!/bin/bash
# Quick add template to gallery
# Usage: ./add-template.sh <category> <name> [source-file]
# Example: ./add-template.sh landing-pages hero-section
#          ./add-template.sh dashboards analytics ~/Downloads/template.html

TEMPLATE_DIR=~/blackroad-templates
CATEGORY="$1"
NAME="$2"
SOURCE="$3"

if [ -z "$CATEGORY" ] || [ -z "$NAME" ]; then
    echo "Usage: ./add-template.sh <category> <name> [source-file]"
    echo ""
    echo "Categories: landing-pages, dashboards, components, layouts, animations, forms, specialty, assets"
    echo ""
    echo "Examples:"
    echo "  ./add-template.sh landing-pages hero-section"
    echo "  ./add-template.sh dashboards analytics ~/Downloads/template.html"
    exit 1
fi

TARGET_DIR="$TEMPLATE_DIR/$CATEGORY"
TARGET_FILE="$TARGET_DIR/$NAME.html"

mkdir -p "$TARGET_DIR"

if [ -n "$SOURCE" ] && [ -f "$SOURCE" ]; then
    cp "$SOURCE" "$TARGET_FILE"
    echo "✅ Copied $SOURCE → $TARGET_FILE"
else
    # Create placeholder
    cat > "$TARGET_FILE" << 'HTML_EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TEMPLATE_NAME - BlackRoad</title>
    <style>
        :root {
            --amber: #F5A623;
            --hot-pink: #FF1D6C;
            --black: #000000;
            --white: #FFFFFF;
        }
        body {
            margin: 0;
            background: var(--black);
            color: var(--white);
            font-family: -apple-system, BlinkMacSystemFont, sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        h1 {
            background: linear-gradient(135deg, var(--hot-pink), var(--amber));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
    </style>
</head>
<body>
    <h1>TEMPLATE_NAME Template</h1>
</body>
</html>
HTML_EOF
    sed -i '' "s/TEMPLATE_NAME/$NAME/g" "$TARGET_FILE"
    echo "✅ Created placeholder: $TARGET_FILE"
fi

# Regenerate manifest
$TEMPLATE_DIR/update-gallery.sh > $TEMPLATE_DIR/manifest.json
echo "📋 Gallery manifest updated!"
echo ""
echo "Open gallery: open $TEMPLATE_DIR/gallery.html"
