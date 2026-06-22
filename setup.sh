#!/bin/bash

# Function to apply boilerplate changes
apply_boilerplate() {
  echo "🚀 Applying boilerplate to $(pwd)..."

  # Download boilerplate from GitHub repo
  echo "📥 Downloading boilerplate files..."
  TEMP_DIR=$(mktemp -d)
  git clone --depth 1 https://github.com/wakhidrf/boilerplate.git "$TEMP_DIR" >/dev/null 2>&1

  if [ ! -d "$TEMP_DIR/guides" ] || [ ! -d "$TEMP_DIR/scripts" ]; then
    echo "❌ Failed to download boilerplate files."
    rm -rf "$TEMP_DIR"
    exit 1
  fi

  cp -r "$TEMP_DIR/guides" .
  cp -r "$TEMP_DIR/scripts" .
  rm -rf "$TEMP_DIR"

  # Update package.json scripts
  echo "📦 Updating package.json scripts..."
  if command -v npm >/dev/null 2>&1; then
    npm pkg set scripts.gen-tree="tsx scripts/generate-tree.ts"
    echo "⚙️ Added 'gen-tree' script to package.json."
    
    echo "📥 Installing tsx as a dev dependency..."
    npm install -D tsx
  else
    echo "❌ npm not found. Please manually add 'gen-tree': 'tsx scripts/generate-tree.ts' to your package.json and install 'tsx'."
  fi

  echo "✅ Boilerplate applied successfully!"
}

# Main logic - Only run inside existing Next.js project
[ -f "package.json" ] && grep -q '"next":' "package.json" || { echo "❌ Script hanya bisa dijalankan di dalam proyek Next.js."; exit 1; }

apply_boilerplate
