# Install LSP servers for Neovim's native LSP client.
# Run this script once from bash (not from inside nvim).

set -e

npm_install() {
	npm ls -g --depth=0 "$1" 2>/dev/null | grep -q "$1" || npm install -g "$1"
}

pip_install() {
	pip3 show "$1" >/dev/null 2>&1 || pip3 install "$1"
}

echo "=== typescript-language-server (JS/TS/TSX) ==="
npm_install typescript-language-server
npm_install typescript

echo "=== vscode-langservers-extracted (HTML/CSS/JSON/ESLint) ==="
npm_install vscode-langservers-extracted

echo "=== yaml-language-server ==="
npm_install yaml-language-server

echo "=== bash-language-server ==="
npm_install bash-language-server

echo "=== lua-language-server ==="
npm_install lua-language-server

echo "=== marksman (Markdown) ==="
if command -v marksman >/dev/null 2>&1; then
	echo "marksman already installed"
else
	echo "Install marksman from https://github.com/artempyanykh/marksman or your system package manager"
fi

echo "=== vim-language-server ==="
npm_install vim-language-server

echo ""
echo "Done. Verify with: nvim --headless +'lua for k,v in pairs(vim.lsp.get_clients()) do print(k,v.name) end' +q"
