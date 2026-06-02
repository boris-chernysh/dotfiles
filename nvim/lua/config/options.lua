vim.g.mapleader = ';'

vim.opt.encoding = 'utf-8'
vim.opt.backspace = 'indent,eol,start'
vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.showtabline = 2
vim.opt.scrolloff = 5
vim.opt.laststatus = 2
vim.opt.colorcolumn = '81'
vim.opt.clipboard = 'unnamedplus'
vim.opt.mouse = 'a'
vim.opt.hidden = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.list = true
vim.opt.listchars = 'tab:⇥ ,trail:·,extends:⋯,precedes:⋯,nbsp:~'
vim.opt.suffixesadd = '.js,.jsx,.ts,.tsx'
vim.opt.expandtab = true
vim.opt.updatetime = 300
vim.opt.shortmess:append('c')
vim.opt.background = 'dark'

local swpdir = vim.fn.stdpath('data') .. '/swapfiles'
vim.fn.mkdir(swpdir, 'p')
vim.opt.directory = swpdir

vim.opt.statusline = '%{v:lua.require("config.utils").statusline()}'

vim.g.pencil_higher_contrast_ui = 1

vim.g.netrw_liststyle = 0
vim.g.netrw_browse_split = 0
vim.g.netrw_localrmdir = 'rm -r'

vim.opt.langmap = 'ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz'
