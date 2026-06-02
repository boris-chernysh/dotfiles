local group = vim.api.nvim_create_augroup('dotfiles', { clear = true })

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
	group = group,
	pattern = 'Vagrantfile',
	callback = function()
		vim.bo.filetype = 'ruby'
	end,
})

vim.api.nvim_create_autocmd('FileType', {
	group = group,
	pattern = 'vim',
	callback = function()
		vim.wo.foldmethod = 'marker'
	end,
})

if vim.env.TMUX then
	vim.api.nvim_create_autocmd({ 'VimEnter', 'DirChanged' }, {
		group = group,
		command = 'silent !tmux rename-window $(basename "$PWD")',
	})
end

vim.api.nvim_create_autocmd('CursorHold', {
	group = group,
	callback = function()
		vim.lsp.buf.document_highlight()
	end,
})

vim.api.nvim_create_autocmd('CursorMoved', {
	group = group,
	buffer = 0,
	callback = function()
		vim.lsp.buf.clear_references()
	end,
})
