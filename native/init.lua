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

vim.keymap.set("n", "<leader>o", ":update<CR> :source<CR>")
vim.keymap.set("n", "<leader>w", ":write<CR>")
vim.keymap.set("n", "<leader>q", ":quit<CR>")

vim.keymap.set({ "n", "v", "x" }, "<leader>y", '"+y<CR>')
vim.keymap.set({ "n", "v", "x" }, "<leader>p", '"+p<CR>')
vim.keymap.set({ "n", "v", "x" }, "<leader>d", '"+d<CR>')

vim.pack.add({
	{ src = "https://github.com/vague2k/vague.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
	{ src = "https://github.com/numToStr/Comment.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/ibhagwan/fzf-lua" },
	{ src = "https://github.com/kevinhwang91/nvim-bqf",                    { ft = "qf" } },
	{ src = "https://github.com/iamcco/markdown-preview.nvim",             { ft = "markdown" } },
	{ src = "https://github.com/cappyzawa/trim.nvim" },
	{ src = "https://github.com/kg8m/vim-simple-align" },
	{
		src = "https://github.com/Wansmer/treesj",
		{ keys = { "<space>m", "<space>j", "<space>s" } },
	},
	{ src = "https://github.com/ahmedkhalf/project.nvim" },
	{ src = "https://github.com/kelly-lin/ranger.nvim",                    { opt = false } },
	{ src = "https://github.com/echasnovski/mini.pairs" },
	{ src = "https://github.com/echasnovski/mini.ai" },
	{ src = "https://github.com/echasnovski/mini.surround" },
	{ src = "https://github.com/folke/flash.nvim" },
	{ src = "https://github.com/echasnovski/mini.statusline" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/kdheepak/lazygit.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvimtools/none-ls-extras.nvim" },
	{ src = "https://github.com/nvimtools/none-ls.nvim" },
	{ src = "https://github.com/3rd/image.nvim" },
	{ src = "https://github.com/HakonHarnes/img-clip.nvim" },
	{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
})

vim.cmd("set completeopt+=noselect")

require("nvim-treesitter.configs").setup({
	build = ":TSUpdate",
	event = { "BufReadPost", "BufNewFile" },
	ensure_installed = {
		"html",
		"css",
		"javascript",
		"typescript",
		"tsx",
		"json",
		"python",
		"go",
		"rust",
		"lua",
		"bash",
		"yaml",
		"toml",
		"dockerfile",
		"json",
		"csv",
		"markdown",
		"markdown_inline",
		"gitcommit",
		"git_rebase",
		"gitattributes",
		"gitignore",
		"make",
		"cmake",
		"sql",
		"regex",
		"vim",
		"vimdoc",
		"lua",
		"query",
	},
	highlight = { enable = true },
})

require("oil").setup({
	restore_win_config = true, -- keeps your window layout when opening/closing Oil
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
require("Comment").setup()
require("render-markdown").setup()
require("treesj").setup({
	max_join_length = 2400,
})
require("project_nvim").setup()
require("mini.pairs").setup()
require("mini.ai").setup()

require("mini.surround").setup({
	mappings = {
		add = "gsa", -- add surrounding
		delete = "gsd", -- delete surrounding
		replace = "gsr", -- replace surrounding
		find = "gsf", -- find surrounding
		find_left = "gsl", -- find left
		highlight = "gsh", -- highlight surrounding
		update_n_lines = "gsu",
		-- operator = "gs"  -- original s operator; comment it out if using s for flash
	},
})
require("flash").setup()
-- require('feline').setup()
require("mini.statusline").setup()

local null_ls = require("null-ls")
null_ls.setup({
	sources = {
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.completion.spell,
		-- require("none-ls.diagnostics.eslint"), -- requires none-ls-extras.nvim
	},
})

require("render-markdown").setup({ latex = { enabled = false } })

require("image").setup()
require("img-clip").setup({
	default = {
		dir_path = "imgs",
		relative_to_current_file = true,
	},
})

require('gitsigns').setup {
    signs = {
        add          = {hl = 'GitGutterAdd',    text = '+'},
        change       = {hl = 'GitGutterChange', text = '~'},
        delete       = {hl = 'GitGutterDelete', text = '_'},
        topdelete    = {hl = 'GitGutterDeleteChange', text = '‾'},
        changedelete = {hl = 'GitGutterChange', text = '~'},
    },
    current_line_blame = true,  -- enable inline blame
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol',    -- show at end of line
        delay = 500,              -- delay in ms
    },
    current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
}
vim.keymap.set("n", "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<CR>")


vim.keymap.set("n", "<leader>f", ":FzfLua files<CR>")
vim.keymap.set("n", "<leader>z", ":FzfLua grep_curbuf<CR>")
vim.keymap.set("n", "<leader>b", ":FzfLua buffers<CR>")
vim.keymap.set("n", "<leader>h", ":FzfLua helptags<CR>")
vim.keymap.set("n", "<leader>r", ":FzfLua resume<CR>")
vim.keymap.set("n", "<leader>cj", ":FzfLua jumps<CR>")
vim.keymap.set("n", "<leader>cm", ":FzfLua marks<CR>")
vim.keymap.set("n", "<leader>g", ":FzfLua grep<CR>")
vim.keymap.set("n", "<leader>w", ":FzfLua grep_cword<CR>")
vim.keymap.set("v", "<leader>w", ":FzfLua grep_visual<CR>")
vim.keymap.set("n", "-", ":Oil<CR>")
vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format)
vim.keymap.set("n", "<leader>lg", ":LazyGit<CR>")
vim.keymap.set("n", "<leader>pi", ":PasteImage<CR>")

vim.keymap.set("n", "s", function()
	require("flash").jump()
end, { noremap = true, silent = true, desc = "Flash jump" })

vim.keymap.set("n", "<leader>cd", function()
	local diagnostics = vim.diagnostic.get(0)
	local qf_items = vim.diagnostic.toqflist(diagnostics, { title = "Buffer Diagnostics" })
	vim.fn.setqflist({}, " ", { items = qf_items })
	vim.cmd("copen")
end, { desc = "Populate quickfix with buffer diagnostics" })

vim.api.nvim_set_keymap("n", "<leader>ef", "", {
	noremap = true,
	callback = function()
		-- Load the plugin
		vim.cmd("packadd ranger.nvim")

		-- Setup only once (optional)
		if not vim.g.ranger_nvim_loaded then
			require("ranger-nvim").setup({
				replace_netrw = true,
			})
			vim.g.ranger_nvim_loaded = true
		end

		-- Open ranger
		require("ranger-nvim").open(true)
	end,
	desc = "Open Ranger File Explorer",
})

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
					cwd = path, -- set cwd to the project path
					prompt = "Files> ",
				})
			end,
		},
	})
end
-- Keymap to open recent projects picker
vim.keymap.set("n", "<leader>pr", recent_projects_picker, { desc = "Recent Projects" })

local actions = require("fzf-lua.actions")
require("fzf-lua").setup({
	winopts = { backdrop = 85 },
	keymap = {
		builtin = {
			["<C-f>"] = "preview-page-down",
			["<C-b>"] = "preview-page-up",
			["<C-v>"] = "toggle-preview",
		},
		fzf = {
			["ctrl-a"] = "toggle-all",
			["ctrl-t"] = "first",
			["ctrl-g"] = "last",
			["ctrl-d"] = "half-page-down",
			["ctrl-u"] = "half-page-up",
		},
	},
	actions = {
		files = {
			-- ["ctrl-q"] = actions.file_sel_to_qf,
			-- ["ctrl-q"] = actions.files_to_qf,
			["ctrl-q"] = function(_, query, items)
				-- items contains all results, not just selected
				local qf_items = {}
				for _, file in ipairs(items) do
					table.insert(qf_items, { filename = file })
				end
				vim.fn.setqflist({}, " ", { title = "FzfLua Files", items = qf_items })
				vim.cmd("copen")
			end,
			-- ["ctrl-n"] = actions.toggle_ignore,
			["ctrl-h"] = actions.toggle_hidden,
			["enter"] = actions.file_edit_or_qf,
		},
	},
})

-- vim.api.nvim_create_autocmd('LspAttach', {
--     callback = function(ev)
--         local client = vim.lsp.get_client_by_id(ev.data.client_id)
--         if client:supports_method('textDocument/completion') then
--             vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
--         end
--     end,
-- })

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
			vim.opt.completeopt = { "menu", "menuone", "noinsert", "fuzzy", "popup" }
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
			vim.keymap.set("i", "<C-Space>", function()
				vim.lsp.completion.get()
			end)
		end
	end,
})

require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
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
	},
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

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = {
					"vim",
					"require",
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
	virtual_text = { current_line = false },
	-- virtual_lines = true
})

vim.cmd(":colorscheme zaibatsu")
-- vim.cmd(":hi statusline guibg=NONE")

