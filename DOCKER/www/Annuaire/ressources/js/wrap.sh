#!/bin/bash
echo "document.addEventListener('DOMContentLoaded', function() {" > temp.js
sed 's/^/    /' scripts-maires.js >> temp.js
echo "});" >> temp.js
mv temp.js scripts-maires.js
echo "✅ Wrapped"
