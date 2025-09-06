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

vim.o.cursorline = true
vim.api.nvim_set_hl(0, "CursorLine", { underline = true })

vim.keymap.set("n", "<leader>o", ":update<CR> :source<CR>")
vim.keymap.set("n", "<leader>w", ":write<CR>")
vim.keymap.set("n", "<leader>q", ":quit<CR>")

vim.keymap.set({ "n", "v", "x" }, "<leader>y", '"+y<CR>')
vim.keymap.set({ "n", "v", "x" }, "<leader>p", '"+p<CR>')
vim.keymap.set({ "n", "v", "x" }, "<leader>d", '"+d<CR>')

vim.keymap.set("n", "[q", "<cmd>cnext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "]q", "<cmd>cprev<CR>", { noremap = true, silent = true })


vim.pack.add({
	{ src = "https://github.com/vague2k/vague.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
	{ src = "https://github.com/junnplus/lsp-setup.nvim" },
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
	{ src = "https://github.com/norcalli/nvim-colorizer.lua" },
	{ src = "https://github.com/nvim-tree/nvim-tree.lua" },
	{ src = "https://github.com/SmiteshP/nvim-navic" },
	{ src = "https://github.com/utilyre/barbecue.nvim",                    { name = "barbecue" } },
	{ src = "https://github.com/itchyny/calendar.vim" },
	{ src = "https://github.com/mhinz/vim-startify" },

}) --plugin end

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
	-- Oil automatically updates the working directory based on navigation
	float = {
		win_options = {
			winblend = 10,
		},
	},
	-- Focused file tracking Oil automatically updates the root when you open or navigate to a file
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
		-- null_ls.builtins.formatting.stylua,
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

require("gitsigns").setup({
	signs = {
		add = { hl = "GitGutterAdd", text = "+" },
		change = { hl = "GitGutterChange", text = "~" },
		delete = { hl = "GitGutterDelete", text = "_" },
		topdelete = { hl = "GitGutterDeleteChange", text = "‾" },
		changedelete = { hl = "GitGutterChange", text = "~" },
	},
	current_line_blame = true, -- enable inline blame
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = "eol", -- show at end of line
		delay = 500, -- delay in ms
	},
	current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
})

require("colorizer").setup()
require("nvim-tree").setup()

vim.opt.updatetime = 200
require("barbecue").setup()

require("fzf-lua").setup({
	winopts = {
		fullscreen = false,
		preview = {
			layout = "vertical",
			vertical = "up:70%"
		}
	},
	keymap = {
		fzf = {
			["ctrl-q"] = "select-all+accept"
		}
	}
})


vim.keymap.set("n", "-", ":Oil<CR>")
vim.keymap.set("n", "<leader><space>", ":FzfLua buffers<CR>")
vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format)
vim.keymap.set("n", "<leader>ff", ":FzfLua files<CR>")
vim.keymap.set("n", "<leader>fg", ":FzfLua grep<CR>")
vim.keymap.set("n", "<leader>fh", ":FzfLua helptags<CR>")
vim.keymap.set("n", "<leader>fj", ":FzfLua jumps<CR>")
vim.keymap.set("n", "<leader>fm", ":FzfLua marks<CR>")
vim.keymap.set("n", "<leader>fq", ":FzfLua quickfix<CR>")
vim.keymap.set("n", "<leader>gw", ":FzfLua grep_cword<CR>")
vim.keymap.set("n", "<leader>fc", ":FzfLua command_history<CR>")
vim.keymap.set("n", "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<CR>")
vim.keymap.set("n", "<leader>lg", ":LazyGit<CR>")
vim.keymap.set("n", "<leader>pi", ":PasteImage<CR>")
vim.keymap.set("n", "<leader>r", ":FzfLua resume<CR>")
vim.keymap.set("n", "<leader>cc", ":Calendar<CR>")
vim.keymap.set("n", "<leader>z", ":FzfLua grep_curbuf<CR>")
vim.keymap.set("v", "<leader>gv", ":FzfLua grep_visual<CR>")
vim.keymap.set("n", "<leader>fz", ":find **/")
vim.keymap.set("n", "<leader>km", ":FzfLua keymaps<CR>")

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
		vim.cmd("packadd ranger.nvim")
		if not vim.g.ranger_nvim_loaded then
			require("ranger-nvim").setup({
				replace_netrw = true,
			})
			vim.g.ranger_nvim_loaded = true
		end
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
vim.keymap.set("n", "<leader>fp", recent_projects_picker, { desc = "Recent Projects" })

vim.keymap.set("n", "<leader>fn", function()
	require("fzf-lua").files({
		cwd = vim.fn.expand("%:p:h"),
		prompt = "Files in current dir> ",
	})
end, { desc = "Find files in current file's directory" })

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
			-- vim.opt.completeopt = { "menu", "menuone", "noinsert", "fuzzy", "popup" }
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
			vim.keymap.set("i", "<C-Space>", function()
				vim.lsp.completion.get()
			end)
		end
	end,
})

require("mason").setup()
require("mason-lspconfig").setup()
-- require("mason-tool-installer").setup({
-- 	ensure_installed = {
-- 		"lua_ls",
-- 		"stylua",
-- 		"biome",
-- 		"pyright",
-- 		"rust-analyzer",
-- 		"gopls",
-- 		"jsonls",
-- 		"marksman",
-- 		"dockerls",
-- 		"helm_ls",
-- 		"ts_ls",
-- 		"yamlls",
-- 	},
-- })


require("lsp-setup").setup({
	servers = {
		lua_ls = {},
		biome = {},
		pyright = {},
		-- pylsp = {},
		rust_analyzer = {},
		gopls = {},
		jsonls = {},
		marksman = {},
		dockerls = {},
		helm_ls = {},
		ts_ls = {},
		yamlls = {},
	},
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

vim.lsp.enable({
	"lua_ls",
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

vim.diagnostic.config({
	virtual_text = { current_line = false },
	-- virtual_lines = true
})

-- vim.cmd(":colorscheme zaibatsu")
-- vim.api.nvim_set_hl(0, "Normal", { bg = "#1e1e2e", fg = "#cdd6f4" }) -- soothing background

vim.cmd(":colorscheme unokai")
-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
-- Main editor
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" }) -- non-current windows
-- Floating windows
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
-- Popups & completion
vim.api.nvim_set_hl(0, "Pmenu", { bg = "none" })
vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#44475a", fg = "#ffffff", bold = true }) -- keep visible
vim.api.nvim_set_hl(0, "PmenuSbar", { bg = "none" })
vim.api.nvim_set_hl(0, "PmenuThumb", { bg = "#888888" })
-- Statusline, Tabline, etc. (optional)
vim.api.nvim_set_hl(0, "StatusLine", { bg = "none" })
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "none" })
vim.api.nvim_set_hl(0, "TabLineFill", { bg = "none" })
