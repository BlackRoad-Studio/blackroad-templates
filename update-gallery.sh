#!/bin/bash
# BlackRoad Template Gallery - Auto-Update Script
# Scans all template folders and generates manifest.json

TEMPLATE_DIR=~/blackroad-templates
MANIFEST="$TEMPLATE_DIR/manifest.json"

echo "["

first=true

# Function to add template entry
add_template() {
    local file="$1"
    local category="$2"
    local name=$(basename "$file" .html)
    local date=$(date -r "$file" "+%Y-%m-%d" 2>/dev/null || echo "Today")
    local path
    
    if [ "$category" = "root" ]; then
        path="$name.html"
    else
        path="$category/$name.html"
    fi
    
    if [ "$first" = true ]; then
        first=false
    else
        echo ","
    fi
    
    # Clean up name for display
    display_name=$(echo "$name" | sed 's/-/ /g' | sed 's/_/ /g' | sed 's/^[0-9]*[ -]*//')
    
    printf '  {"name": "%s", "path": "%s", "category": "%s", "date": "%s"}' \
        "$display_name" "$path" "$category" "$date"
}

# Scan root directory for .html files (excluding gallery.html and index.html)
for file in "$TEMPLATE_DIR"/*.html; do
    [ -f "$file" ] || continue
    basename=$(basename "$file")
    [[ "$basename" == "gallery.html" || "$basename" == "index.html" ]] && continue
    add_template "$file" "root"
done

# Scan each category folder
for category in landing-pages dashboards components layouts animations forms specialty assets; do
    dir="$TEMPLATE_DIR/$category"
    [ -d "$dir" ] || continue
    for file in "$dir"/*.html; do
        [ -f "$file" ] || continue
        add_template "$file" "$category"
    done
done

echo ""
echo "]"
