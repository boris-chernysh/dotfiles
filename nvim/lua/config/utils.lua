local M = {}

function M.statusline()
	local ok, git = pcall(vim.fn['fugitive#statusline'])
	local git_str = ok and git or ''
	local path = vim.fn.expand('%:.:h')
	return string.format(' %s <%s>%%= %d:%d %d ',
		git_str, path,
		vim.fn.col('.'), vim.fn.line('.'), vim.fn.line('$'))
end

function M.buf_only()
	local current = vim.api.nvim_get_current_buf()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if buf ~= current and vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
			vim.api.nvim_buf_delete(buf, {})
		end
	end
end

function M.bdelete()
	local buf = vim.api.nvim_get_current_buf()
	local wins = vim.tbl_filter(function(w)
		return vim.api.nvim_win_get_buf(w) == buf
	end, vim.api.nvim_list_wins())
	if #wins > 1 then
		vim.api.nvim_win_close(0, false)
		return
	end
	vim.cmd.buffer('#')
	vim.api.nvim_buf_delete(buf, {})
end

function M.get_file_path()
	return vim.fn.expand('%:.:h')
end

function M.show_documentation()
	local ft = vim.bo.filetype
	if ft == 'vim' or ft == 'help' then
		vim.cmd('h ' .. vim.fn.expand('<cword>'))
	else
		vim.lsp.buf.hover()
	end
end

function M.toggle_background()
	if vim.o.background == 'dark' then
		vim.o.background = 'light'
	else
		vim.o.background = 'dark'
	end
end

return M
