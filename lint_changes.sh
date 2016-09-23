if test -f package.json && grep \"lintChanges\": package.json > /dev/null; then
  if [ -f node_modules/.bin/nrun ]; then
    node_modules/.bin/nrun lintChanges
  else
    echo "make 'npm install' first!"
    exit 1
  fi
else
  exit 0
fi
