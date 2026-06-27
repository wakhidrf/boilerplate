#!/bin/bash

# Function to remove boilerplate changes
remove_boilerplate() {
  echo "🗑️ Removing boilerplate from $(pwd)..."

  # Remove guides directory
  if [ -d "guides" ]; then
    echo "📁 Removing guides directory..."
    rm -rf "guides"
  fi

  # Remove scripts directory
  if [ -d "scripts" ]; then
    echo "📁 Removing scripts directory..."
    rm -rf "scripts"
  fi

  # Update package.json scripts
  echo "📦 Updating package.json scripts..."
  if [ -f "package.json" ] && command -v npm >/dev/null 2>&1; then
    if npm pkg get scripts.gen-tree >/dev/null 2>&1; then
      npm pkg delete scripts.gen-tree
      echo "⚙️ Removed 'gen-tree' script from package.json."
    else
      echo "ℹ️ 'gen-tree' script not found in package.json."
    fi

    # Remove tsx dev dependency
    echo "📥 Removing tsx dev dependency..."
    npm uninstall tsx --save-dev 2>/dev/null
  else
    echo "❌ npm not found or package.json not found. Please manually remove 'gen-tree' from package.json and uninstall 'tsx'."
  fi

  echo "✅ Boilerplate removed successfully!"
}

# Main logic - Only run inside existing Next.js project
[ -f "package.json" ] && grep -q '"next":' "package.json" || { echo "❌ Script hanya bisa dijalankan di dalam proyek Next.js."; exit 1; }

remove_boilerplate
