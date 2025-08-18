vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
vim.o.termguicolors = true
vim.o.wrap = false
vim.o.tabstop = 4
vim.o.swapfile = false
vim.g.mapleader = " "
vim.o.winborder = "rounded"
vim.o.clipboard = "unnamedplus"
vim.env.NODE_OPTIONS = "--openssl-legacy-provider" -- for markdown-preview

vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>')
vim.keymap.set('n', '<leader>w', ':write<CR>')
vim.keymap.set('n', '<leader>q', ':quit<CR>')

vim.keymap.set({ 'n', 'v', 'x' }, '<leader>y', '"+y<CR>')
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>d', '"+d<CR>')

vim.pack.add({
	{ src = "https://github.com/vague2k/vague.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
	{ src = "https://github.com/numToStr/Comment.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/ibhagwan/fzf-lua" },
	{ src = "https://github.com/kevinhwang91/nvim-bqf",                    { ft = "qf" } },
	{ src = "https://github.com/iamcco/markdown-preview.nvim",             { ft = "markdown" } },
	{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
	{ src = "https://github.com/cappyzawa/trim.nvim" },
	{ src = "https://github.com/kg8m/vim-simple-align" },
	{ src = "https://github.com/Wansmer/treesj",                           { keys = { '<space>m', '<space>j', '<space>s' } } },
	{ src = "https://github.com/ahmedkhalf/project.nvim" }

})

vim.cmd("set completeopt+=noselect")

require "mini.pick".setup()
require "nvim-treesitter.configs".setup({
	build = ":TSUpdate",
	event = { "BufReadPost", "BufNewFile" },
	ensure_installed = {
		"html", "css", "javascript", "typescript", "tsx", "json", "python", "go", "rust", "lua", "bash", "yaml",
		"toml", "dockerfile", "json", "csv", "markdown", "markdown_inline", "gitcommit", "git_rebase",
		"gitattributes", "gitignore", "make", "cmake", "sql", "regex", "vim", "vimdoc", "lua", "query",
	},
	highlight = { enable = true }
})
require "oil".setup({
	restore_win_config = true,              -- keeps your window layout when opening/closing Oil
	skip_confirm_for_simple_edits = true,
	--
	-- Respect the buffer’s cwd
	-- Oil automatically updates the working directory based on navigation
	float = {
		-- optional: open Oil in a floating window
		win_options = {
			winblend = 10,
		},
	},

	-- Focused file tracking
	-- Oil automatically updates the root when you open or navigate to a file
	keymaps = {
		["<CR>"] = "actions.select",
		["-"] = "actions.parent",
	},
})
require "Comment".setup()
require "render-markdown".setup()
require "treesj".setup({
	max_join_length = 2400,
})
require "project_nvim".setup()


-- vim.keymap.set('n', '<leader>f', ":Pick files<CR>")
vim.keymap.set('n', '<leader>f', ":FzfLua files<CR>")
vim.keymap.set('n', '<leader>z', ":FzfLua grep_curbuf<CR>")
vim.keymap.set('n', '<leader>b', ":FzfLua buffers<CR>")
vim.keymap.set('n', '<leader>h', ":FzfLua helptags<CR>")
vim.keymap.set('n', '<leader>r', ":FzfLua resume<CR>")
vim.keymap.set('n', '<leader>cj', ":FzfLua jumps<CR>")
vim.keymap.set('n', '<leader>cm', ":FzfLua marks<CR>")
vim.keymap.set('n', '<leader>g', ":FzfLua grep<CR>")
vim.keymap.set('n', '<leader>w', ":FzfLua grep_cword<CR>")
vim.keymap.set('v', '<leader>w', ":FzfLua grep_visual<CR>")
vim.keymap.set('n', '-', ":Oil<CR>")
vim.keymap.set('n', '<leader>cf', vim.lsp.buf.format)
vim.keymap.set("n", "<leader>cd", function()
	local diagnostics = vim.diagnostic.get(0)
	local qf_items = vim.diagnostic.toqflist(diagnostics, { title = "Buffer Diagnostics" })
	vim.fn.setqflist({}, " ", { items = qf_items })
	vim.cmd("copen")
end, { desc = "Populate quickfix with buffer diagnostics" })

local fzf = require("fzf-lua")
local project = require("project_nvim")
-- Create a custom picker for recent projects
local function recent_projects_picker()
	-- Get recent projects from project_nvim
	local projects = project.get_recent_projects() or {}
	print(projects)
	-- FzfLua picker
	fzf.fzf_exec(projects, {
		prompt = "Recent Projects> ",
		actions = {
			["default"] = function(selected)
				local path = selected[1]
				-- Change directory to the selected project
				vim.cmd("cd " .. path)
				print("Switched to project: " .. path)
				fzf.files({
                    cwd = path,          -- set cwd to the project path
                    prompt = "Files> ",
                })
			end,
		},
	})
end
-- Keymap to open recent projects picker
vim.keymap.set("n", "<leader>pr", recent_projects_picker, { desc = "Recent Projects" })


-- vim.api.nvim_create_autocmd('LspAttach', {
--     callback = function(ev)
--         local client = vim.lsp.get_client_by_id(ev.data.client_id)
--         if client:supports_method('textDocument/completion') then
--             vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
--         end
--     end,
-- })

vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
			vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', 'fuzzy', 'popup' }
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
			vim.keymap.set('i', '<C-Space>', function()
				vim.lsp.completion.get()
			end)
		end
	end,
})

require('mason').setup()
require('mason-lspconfig').setup()
require('mason-tool-installer').setup({
	ensure_installed = {
		"lua_ls",
		"stylua",
		"biome",
		"pyright",
		"rust-analyzer",
		"gopls",
		"jsonls",
		"marksman",
		"dockerls",
		"helm_ls",
		"ts_ls",
		"yamlls",
	}
})

vim.lsp.enable({
	"lua_ls",
	"stylua",
	"biome",
	"pyright",
	"rust-analyzer",
	"gopls",
	"jsonls",
	"marksman",
	"dockerls",
	"helm_ls",
	"ts_ls",
	"yamlls",
})

vim.lsp.config('lua_ls', {
	settings = {
		Lua = {
			runtime = {
				version = 'LuaJIT',
			},
			diagnostics = {
				globals = {
					'vim',
					'require'
				},
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
			telemetry = {
				enable = false,
			},
		},
	},
})

vim.diagnostic.config({
	virtual_text = { current_line = false }
	-- virtual_lines = true
})


vim.cmd(":colorscheme zaibatsu")
vim.cmd(":hi statusline guibg=NONE")
