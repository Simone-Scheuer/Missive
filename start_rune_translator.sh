#!/bin/bash
# Simple server to run the Rune Translator

echo "✨ Starting Rune Translator Server..."
echo "📡 Server running at http://localhost:8000"
echo "🌐 Open http://localhost:8000/rune_translator.html in your browser"
echo ""
echo "Press Ctrl+C to stop the server"
echo ""

# Try Python 3 first, then Python 2, then Node.js serve
if command -v python3 &> /dev/null; then
    python3 -m http.server 8000
elif command -v python &> /dev/null; then
    python -m SimpleHTTPServer 8000
elif command -v npx &> /dev/null; then
    npx serve -l 8000
else
    echo "❌ Error: No server found. Please install Python or Node.js"
    exit 1
fi

