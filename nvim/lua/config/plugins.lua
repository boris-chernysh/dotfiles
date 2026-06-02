return {
	{
		'reedes/vim-colors-pencil',
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd.colorscheme('pencil')
		end,
	},
	{
		'jonathanfilip/vim-lucius',
		lazy = false,
	},

	{
		'tpope/vim-fugitive',
		lazy = false,
	},
	{
		'tpope/vim-surround',
		event = 'VeryLazy',
	},
	{
		'tpope/vim-eunuch',
		cmd = { 'Remove', 'Rename', 'Chmod', 'Mkdir', 'SudoWrite', 'SudoEdit', 'Wall', 'W' },
	},

	{
		'kshenoy/vim-signature',
		event = 'VeryLazy',
	},
	{
		'mattn/emmet-vim',
		ft = { 'html', 'css', 'scss', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
	},
	{
		'editorconfig/editorconfig-vim',
		event = 'BufReadPre',
	},
	{
		'ap/vim-css-color',
		ft = { 'css', 'scss', 'less', 'html' },
	},
	{
		'vim-scripts/textutil.vim',
		ft = { 'rtf', 'doc' },
	},

	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		config = function()
			require('nvim-treesitter.configs').setup({
				ensure_installed = {
					'javascript', 'typescript', 'tsx',
					'html', 'css', 'scss',
					'markdown', 'markdown_inline',
					'vim', 'vimdoc', 'lua', 'query',
					'json', 'yaml', 'bash',
				},
				auto_install = true,
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
		event = { 'BufReadPre', 'BufNewFile' },
	},

	{
		'ibhagwan/fzf-lua',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		cmd = 'FzfLua',
	},

	{
		'lewis6991/gitsigns.nvim',
		config = function()
			require('gitsigns').setup()
		end,
		event = { 'BufReadPre', 'BufNewFile' },
	},

	{
		'neovim/nvim-lspconfig',
		dependencies = {
			'hrsh7th/cmp-nvim-lsp',
		},
		config = function()
			local lspconfig = require('lspconfig')
			local capabilities = require('cmp_nvim_lsp').default_capabilities()

			local servers = {
				ts_ls = {},
				jsonls = {},
				html = {},
				cssls = {},
				eslint = {},
				yamlls = {},
				marksman = {},
				vimls = {},
				lua_ls = {
					settings = {
						Lua = { diagnostics = { globals = { 'vim' } } },
					},
				},
			}

			for name, opts in pairs(servers) do
				opts.capabilities = capabilities
				lspconfig[name].setup(opts)
			end
		end,
		event = { 'BufReadPre', 'BufNewFile' },
	},

	{
		'stevearc/conform.nvim',
		config = function()
			require('conform').setup({
				formatters_by_ft = {
					javascript = { 'prettierd' },
					typescript = { 'prettierd' },
					javascriptreact = { 'prettierd' },
					typescriptreact = { 'prettierd' },
					json = { 'prettierd' },
					html = { 'prettierd' },
					css = { 'prettierd' },
					scss = { 'prettierd' },
					markdown = { 'prettierd' },
					yaml = { 'prettierd' },
					lua = { 'stylua' },
				},
				format_on_save = {
					timeout_ms = 500,
					lsp_fallback = true,
				},
			})
		end,
		event = 'BufWritePre',
	},

	{
		'hrsh7th/nvim-cmp',
		event = 'InsertEnter',
		dependencies = {
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'L3MON4D3/LuaSnip',
			'saadparwaiz1/cmp_luasnip',
		},
		config = function()
			local cmp = require('cmp')

			cmp.setup({
				snippet = {
					expand = function(args)
						require('luasnip').lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					['<Tab>'] = cmp.mapping.select_next_item(),
					['<S-Tab>'] = cmp.mapping.select_prev_item(),
					['<CR>'] = cmp.mapping.confirm({ select = true }),
					['<C-e>'] = cmp.mapping.abort(),
					['<C-Space>'] = cmp.mapping.complete(),
				}),
				sources = cmp.config.sources({
					{ name = 'nvim_lsp' },
					{ name = 'luasnip' },
					{ name = 'buffer' },
					{ name = 'path' },
				}),
			})
		end,
	},
}
