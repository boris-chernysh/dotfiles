local keymap = vim.keymap.set

keymap('v', '<', '<gv')
keymap('v', '>', '>gv')

keymap('n', '<leader>c', ':echo expand("%:p")<CR>', { desc = 'Full path' })

keymap('n', '<leader>T', ':tabnew<CR>', { desc = 'New tab' })
keymap('n', '<leader>wq', function() require('config.utils').bdelete() end, { desc = 'Delete buffer (keep window)' })
keymap('n', '<leader>wa', function() require('config.utils').buf_only() end, { desc = 'Close all except current' })

keymap('n', '<leader>q', ':quit<CR>', { desc = 'Quit' })
keymap('n', '<leader>bq', ':bd<CR>', { desc = 'Delete buffer' })

keymap('n', '<leader>ev', function() vim.cmd.tabnew(vim.env.MYVIMRC) end, { desc = 'Edit config' })
keymap('n', '<leader>sv', function() dofile(vim.env.MYVIMRC) vim.notify('Config reloaded') end, { desc = 'Source config' })

keymap('n', '<leader>.', ':Explore<CR>', { desc = 'Netrw' })

keymap('n', '<leader>yp', ':let @+ = expand("%")<CR>', { desc = 'Yank file path' })
keymap('n', '<leader>yn', ':let @+ = expand("%:t:r")<CR>', { desc = 'Yank filename' })

keymap({ 'n', 'v' }, ':', 'q:i', { desc = 'Command window' })

keymap('n', '<leader>bg', function() require('config.utils').toggle_background() end, { desc = 'Toggle background' })

keymap('n', 'K', function() require('config.utils').show_documentation() end, { silent = true, desc = 'Documentation' })

keymap('n', 'gd', vim.lsp.buf.definition, { silent = true, desc = 'Go to definition' })
keymap('n', 'gy', vim.lsp.buf.type_definition, { silent = true, desc = 'Go to type definition' })
keymap('n', 'gi', vim.lsp.buf.implementation, { silent = true, desc = 'Go to implementation' })
keymap('n', 'gr', vim.lsp.buf.references, { silent = true, desc = 'References' })
keymap('n', '<leader>rn', vim.lsp.buf.rename, { silent = true, desc = 'Rename' })

-- fzf-lua
keymap('n', '<leader>f', function() require('fzf-lua').live_grep() end, { desc = 'Live grep' })
keymap('n', '<leader>F', function()
	require('fzf-lua').live_grep({ query = vim.fn.expand('<cword>') })
end, { desc = 'Grep word under cursor' })
keymap('n', '<c-p>', function()
	if pcall(vim.fn.FugitiveHead) and vim.fn.FugitiveHead() ~= '' then
		require('fzf-lua').git_files()
	else
		require('fzf-lua').files()
	end
end, { desc = 'Find files' })
keymap('n', '<c-g>p', function() require('fzf-lua').git_status() end, { desc = 'Git status' })
keymap('n', '<leader>/', function() require('fzf-lua').blines() end, { desc = 'Search buffer' })
keymap('n', '<c-b>', function() require('fzf-lua').buffers() end, { desc = 'Buffers' })

-- easymotion
vim.g.EasyMotion_do_mapping = 0
vim.g.EasyMotion_smartcase = 1
vim.g.EasyMotion_startofline = 0
vim.g.EasyMotion_use_smartsign_us = 1

keymap({ 'n', 'v', 'o' }, '/', '<Plug>(easymotion-sn)')
keymap({ 'n', 'v', 'o' }, 'n', '<Plug>(easymotion-next)')
keymap({ 'n', 'v', 'o' }, 'N', '<Plug>(easymotion-prev)')
keymap({ 'n', 'v', 'o' }, '<leader>l', '<Plug>(easymotion-lineforward)')
keymap({ 'n', 'v', 'o' }, '<leader>j', '<Plug>(easymotion-j)')
keymap({ 'n', 'v', 'o' }, '<leader>k', '<Plug>(easymotion-k)')
keymap({ 'n', 'v', 'o' }, '<leader>h', '<Plug>(easymotion-linebackward)')
