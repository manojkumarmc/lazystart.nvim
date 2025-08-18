local vim = vim

-- Basic settings
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.cursorline = true
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.hlsearch = false
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.hidden = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.laststatus = 3
vim.opt.pumheight = 10
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 3
vim.opt.clipboard:append("unnamedplus")
vim.opt.autochdir = false
vim.opt.wrap = false
vim.opt.winborder = "rounded"

vim.opt.tabstop = 4       -- 4 spaces for tabs (prettier default)
vim.opt.shiftwidth = 4    -- 4 spaces for indent width
vim.opt.expandtab = true  -- expand tab to spaces
vim.opt.autoindent = true -- copy indent from current line when starting new one

local icons = {
    misc = {
        dots = "󰇘",
    },
    dap = {
        Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
        Breakpoint = " ",
        BreakpointCondition = " ",
        BreakpointRejected = { " ", "DiagnosticError" },
        LogPoint = ".>",
    },
    diagnostics = {
        Error = " ",
        Warn = " ",
        Hint = " ",
        Info = " ",
    },
    git = {
        added = " ",
        modified = " ",
        removed = " ",
    },
}

-- Helpers
local function change_colorscheme()
    local m = vim.fn.system("defaults read -g AppleInterfaceStyle")
    m = m:gsub("%s+", "") -- trim whitespace
    if m == "Dark" then
        vim.o.background = "dark"
    else
        vim.o.background = "light"
    end
end

-- Basic mappings
vim.keymap.set("n", "<C-H>", "<C-W><C-H>")
vim.keymap.set("n", "<C-J>", "<C-W><C-J>")
vim.keymap.set("n", "<C-K>", "<C-W><C-K>")
vim.keymap.set("n", "<C-L>", "<C-W><C-L>")
vim.keymap.set("n", "<C-S>", ":%s/")
vim.keymap.set("n", "sp", ":sp<CR>")
vim.keymap.set("n", "tj", ":tabprev<CR>")
vim.keymap.set("n", "tk", ":tabnext<CR>")
vim.keymap.set("n", "tn", ":tabnew<CR>")
vim.keymap.set("n", "to", ":tabo<CR>")
vim.keymap.set("n", "vs", ":vs<CR>")
vim.keymap.set("n", "<leader>j", ":cnext<CR>", { silent = true })
vim.keymap.set("n", "<leader>k", ":cprevious<CR>", { silent = true })
vim.keymap.set("n", "<leader>o", ":tabonly<cr>:only<CR>", { silent = true })
vim.keymap.set("v", "<leader>j", ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set("v", "<leader>k", ":m '>-2<CR>gv=gv", { silent = true })

-- for type, icon in pairs(icons.diagnostics) do
--     local hl = "DiagnosticSign" .. type
--     vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
-- end

-- Setup lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)

-- Install plugins
require("lazy").setup({

    -- Autoclose HTML-style tags
    -- "windwp/nvim-ts-autotag",

    -- Easy commenting in normal & visual mode
    { "numToStr/Comment.nvim",                       lazy = false },
    { "JoosepAlviste/nvim-ts-context-commentstring", event = "VeryLazy" },

    -- Code assistant
    {
        "robitx/gp.nvim",
        opts = {},
    },

    -- File explorer
    {
        "stevearc/oil.nvim",
        lazy = false,
        config = function()
            require("oil").setup({
                view_options = {
                    show_hidden = true,
                },
                default_file_explorer = true,
            })
        end,
        keys = {
            { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
        },
    },

    {
        "saghen/blink.cmp",
        -- optional: provides snippets for the snippet source
        dependencies = { "rafamadriz/friendly-snippets" },
        version = "1.*",
        opts = {
            -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
            -- 'super-tab' for mappings similar to vscode (tab to accept)
            -- 'enter' for enter to accept
            -- 'none' for no mappings
            --
            -- All presets have the following mappings:
            -- C-space: Open menu or open docs if already open
            -- C-n/C-p or Up/Down: Select next/previous item
            -- C-e: Hide menu
            -- C-k: Toggle signature help (if signature.enabled = true)
            --
            -- See :h blink-cmp-config-keymap for defining your own keymap
            keymap = { preset = "default" },
            appearance = {
                use_nvim_cmp_as_default = false,
                nerd_font_variant = "mono",
            },
            signature = { enabled = true },
            completion = {
                menu = {
                    draw = {
                        components = {
                            kind_icon = {
                                text = function(ctx)
                                    local icon = ctx.kind_icon
                                    if vim.tbl_contains({ "Path" }, ctx.source_name) then
                                        local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                                        if dev_icon then
                                            icon = dev_icon
                                        end
                                    else
                                        icon = require("lspkind").symbolic(ctx.kind, {
                                            mode = "symbol",
                                        })
                                    end

                                    return icon .. ctx.icon_gap
                                end,

                                -- Optionally, use the highlight groups from nvim-web-devicons
                                -- You can also add the same function for `kind.highlight` if you want to
                                -- keep the highlight groups in sync with the icons.
                                highlight = function(ctx)
                                    local hl = ctx.kind_hl
                                    if vim.tbl_contains({ "Path" }, ctx.source_name) then
                                        local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                                        if dev_icon then
                                            hl = dev_hl
                                        end
                                    end
                                    return hl
                                end,
                            }
                        }
                    }
                }
            }
        },
    },

    -- LSP
    {
        "junnplus/lsp-setup.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            require("lsp-setup").setup({
                -- capabilities = capabilities,
                capabilities = require("blink.cmp").get_lsp_capabilities(),
                servers = {
                    pyright = {},
                    rust_analyzer = {},
                    gopls = {},
                    lua_ls = {},
                    jsonls = {},
                    marksman = {},
                    dockerls = {},
                    helm_ls = {},
                    ts_ls = {},
                    yamlls = {
                        settings = {
                            yaml = {
                                schemas = {
                                    -- [require("kubernetes").yamlls_schema()] = "*.yaml",
                                    -- ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] = "/*.k8s.yaml",
                                    -- [require("kubernetes").yamlls_schema()] = require("kubernetes").yamlls_filetypes(),
                                },
                            },
                        },
                    },
                    harper_ls = {
                        userDictPath = "",
                        fileDictPath = "",
                        linters = {
                            SpellCheck = true,
                            SpelledNumbers = false,
                            AnA = true,
                            SentenceCapitalization = true,
                            UnclosedQuotes = true,
                            WrongQuotes = false,
                            LongSentences = true,
                            RepeatedWords = true,
                            Spaces = true,
                            Matcher = true,
                            CorrectNumberSuffix = true,
                        },
                        codeActions = {
                            ForceStable = false,
                        },
                        markdown = {
                            IgnoreLinkTitle = false,
                        },
                        diagnosticSeverity = "hint",
                        isolateEnglish = false,
                        dialect = "American",
                    },
                },
                inlay_hints = {
                    enabled = false,
                },
            })
        end,
    },

    -- Autocompletion
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        build = "make install_jsregexp",
        dependencies = {
            "rafamadriz/friendly-snippets",
        },
    },

    -- {
    --     "hrsh7th/nvim-cmp",
    --     dependencies = {
    --         "L3MON4D3/LuaSnip",
    --         "saadparwaiz1/cmp_luasnip",
    --         "hrsh7th/cmp-nvim-lsp",
    --         "hrsh7th/cmp-buffer",
    --         "hrsh7th/cmp-path",
    --     },
    -- },

    {
        "mason-org/mason.nvim",
        opts = {},
    },

    -- Fuzzy finder
    {
        "nvim-telescope/telescope.nvim",
        event = "VeryLazy",
        opts = {
            defaults = {
                theme = "ivy",
                layout_config = {
                    prompt_position = "bottom",
                },
                file_ignore_patterns = {
                    ".*_test%.py$",  -- Ignore Python test files (e.g., `example_test.py`)
                    ".*Test%.java$", -- Ignore Java test files (e.g., `MyClassTest.java`)
                    "tests/.*",      -- Ignore any folder named `tests`
                    "spec/.*",       -- Ignore any folder named `spec`
                    "%.spec%.ts$",   -- Ignore TypeScript spec files (e.g., `file.spec.ts`)
                },
            },
        },
        keys = {
            { "<leader>si", "<cmd>Telescope import<cr>", desc = "Search imports" },
        },
        dependencies = { "nvim-lua/plenary.nvim" },
        extensions = {
            fzf = {
                fuzzy = true,                   -- false will only do exact matching
                override_generic_sorter = true, -- override the generic sorter
                override_file_sorter = true,    -- override the file sorter
                case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
            },
        },
    },

    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
    },

    -- Better syntax highlighting & much more
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local configs = require("nvim-treesitter.configs")
            configs.setup({
                ensure_installed = "all",
                highlight = { enable = true },
                indent = { enable = true },
                autotag = { enable = true, enable_close_on_slash = false },
            })
        end,
    },

    -- Surround words with characters in normal mode
    {
        "kylechui/nvim-surround",
        event = "VeryLazy",
        opts = {},
    },
    -- Pair matching characters
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {
            disable_filetype = { "TelescopePrompt", "vim" },
        },
    },

    -- For formatting code
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                javascript = { "biome" },
                typescript = { "biome" },
                graphql = { "biome" },
                json = { "biome" },
                css = { "prettierd" },
                yaml = { "prettierd" },
                lua = { "stylua" },
                go = { "gofmt" },
                python = { "black" },
                rust = { "rustfmt" },
            },
            -- format_on_save = {}, == this needs to be uncommented for the prebufwrite to work
        },
    },

    -- Gitsigns
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                on_attach = function(bufnr)
                    local gitsigns = require("gitsigns")

                    local function map(mode, l, r, opts)
                        opts = opts or {}
                        opts.buffer = bufnr
                        vim.keymap.set(mode, l, r, opts)
                    end

                    -- Navigation
                    map("n", "]c", function()
                        if vim.wo.diff then
                            vim.cmd.normal({ "]c", bang = true })
                        else
                            gitsigns.nav_hunk("next")
                        end
                    end)

                    map("n", "[c", function()
                        if vim.wo.diff then
                            vim.cmd.normal({ "[c", bang = true })
                        else
                            gitsigns.nav_hunk("prev")
                        end
                    end)

                    -- Actions
                    map("n", "<leader>hs", gitsigns.stage_hunk)
                    map("n", "<leader>hr", gitsigns.reset_hunk)
                    map("v", "<leader>hs", function()
                        gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                    end)
                    map("v", "<leader>hr", function()
                        gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                    end)
                    map("n", "<leader>hS", gitsigns.stage_buffer)
                    map("n", "<leader>hu", gitsigns.undo_stage_hunk)
                    map("n", "<leader>hR", gitsigns.reset_buffer)
                    map("n", "<leader>hp", gitsigns.preview_hunk)
                    map("n", "<leader>hb", function()
                        gitsigns.blame_line({ full = true })
                    end)
                    map("n", "<leader>tb", gitsigns.toggle_current_line_blame)
                    map("n", "<leader>hd", gitsigns.diffthis)
                    map("n", "<leader>hD", function()
                        gitsigns.diffthis("~")
                    end)
                    map("n", "<leader>td", gitsigns.toggle_deleted)

                    -- Text object
                    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
                end,
            })
        end,
    },

    -- key display
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            preset = "helix",
        },
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    },

    -- mini and friends
    {
        "echasnovski/mini.ai",
        config = function()
            require("mini.ai").setup()
        end,
    },

    {
        "echasnovski/mini.statusline",
        dependencies = {
            { "echasnovski/mini.icons" },
            { "echasnovski/mini-git",  version = false, main = "mini.git" },
            { "echasnovski/mini.diff" },
        },
        config = function()
            require("mini.statusline").setup({})
        end,
    },

    {
        "nvimdev/indentmini.nvim",
        config = function()
            -- vim.cmd.highlight('IndentLine guifg=#8b8c80')
            -- vim.cmd.highlight('IndentLineCurrent guifg=#8b8c80')
            vim.cmd.highlight("IndentLine guifg=#43393c")
            vim.cmd.highlight("IndentLineCurrent guifg=#43393c")
            require("indentmini").setup({
                exclude = { "markdown", "startify" },
                only_current = true,
            })
        end,
    },

    {
        "echasnovski/mini.tabline",
        config = function()
            require("mini.tabline").setup()
        end,
    },

    -- bqf and friends
    {
        "kevinhwang91/nvim-bqf",
        ft = "qf",
        config = function()
            require("bqf").setup({})
        end,
    },
    {
        "junegunn/fzf",
        build = function()
            vim.fn["fzf#install"]()
        end,
    },
    {
        "junegunn/fzf.vim",
    },

    -- colorscheme catppuccin
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                transparent_background = true,
                no_italic = true,
            })
        end,
    },

    { "Rigellute/shades-of-purple.vim" },
    { "rose-pine/vim" },
    { "dterei/VimCobaltColourScheme" },
    { "gregsexton/Gravity" },
    { "ryross/ryderbeans" },
    { "yorumicolors/yorumi.nvim" },
    {
        "datsfilipe/vesper.nvim",
        config = function()
            require("vesper").setup({
                transparent = false,   -- Boolean: Sets the background to transparent
                italics = {
                    comments = false,  -- Boolean: Italicizes comments
                    keywords = false,  -- Boolean: Italicizes keywords
                    functions = false, -- Boolean: Italicizes functions
                    strings = false,   -- Boolean: Italicizes strings
                    variables = false, -- Boolean: Italicizes variables
                },
                overrides = {},        -- A dictionary of group names, can be a function returning a dictionary or a table.
                palette_overrides = {},
            })
        end,
    },
    {
        "wnkz/monoglow.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },
    {
        "lalitmee/cobalt2.nvim",
        event = { "ColorSchemePre" },
        dependencies = { "tjdevries/colorbuddy.nvim", tag = "v1.0.0" },
        init = function()
            require("colorbuddy").colorscheme("cobalt2")
        end,
    },

    {
        "kevinhwang91/nvim-hlslens",
        config = function()
            require("hlslens").setup({})
        end,
    },

    {
        "tzachar/local-highlight.nvim",
        config = function()
            require("local-highlight").setup()
        end,
    },

    {
        "utilyre/barbecue.nvim",
        name = "barbecue",
        version = "*",
        dependencies = {
            "SmiteshP/nvim-navic",
            "nvim-tree/nvim-web-devicons", -- optional dependency
        },
        opts = {},
    },

    {
        "VidocqH/lsp-lens.nvim",
        config = function()
            require("lsp-lens").setup({
                enable = false,
            })
        end,
    },

    {
        "Wansmer/treesj",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        -- keys = { '<space>m', '<space>j', '<space>s' },
        keys = { "<space>m", "<space>j" },
        config = function()
            require("treesj").setup({
                max_join_length = 4800,
            })
        end,
    },

    { "mhinz/vim-startify" },

    {
        "kdheepak/lazygit.nvim",
        lazy = true,
        cmd = {
            "LazyGit",
            "LazyGitConfig",
            "LazyGitCurrentFile",
            "LazyGitFilter",
            "LazyGitFilterCurrentFile",
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        keys = {
            { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
        },
    },

    {
        "rmagatti/goto-preview",
        event = "BufEnter",
        config = true, -- necessary as per https://github.com/rmagatti/goto-preview/issues/88
        keys = {
            {
                "gpr",
                "<cmd>lua require('goto-preview').goto_preview_references()<CR>",
                desc = "Go to references",
                { noremap = true },
            },
            {
                "gpd",
                "<cmd>lua require('goto-preview').goto_preview_definition()<CR>",
                desc = "Go to definition",
                { noremap = true },
            },
            {
                "gpt",
                "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>",
                desc = "Go to type definition",
                { noremap = true },
            },
            {
                "gpi",
                "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>",
                desc = "Go to implemenation",
                { noremap = true },
            },
            {
                "gpD",
                "<cmd>lua require('goto-preview').goto_preview_declaration()<CR>",
                desc = "Go to declaration",
                { noremap = true },
            },
            {
                "gpc",
                "<cmd>lua require('goto-preview').goto_preview_close_all_win()<CR>",
                desc = "Go to declaration",
                { noremap = true },
            },
        },
    },

    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && yarn install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    },

    { "kg8m/vim-simple-align" },

    -- debug setup
    { "mfussenegger/nvim-dap" },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            require("dapui").setup()
        end,
    },
    {
        "theHamsta/nvim-dap-virtual-text",
        config = function()
            require("nvim-dap-virtual-text").setup({})
        end,
    },

    -- { "RRethy/vim-illuminate" },

    {
        "ya2s/nvim-cursorline",
        config = function()
            require("nvim-cursorline").setup({
                cursorline = {
                    enable = false,
                    timeout = 1000,
                    number = false,
                },
                cursorword = {
                    enable = true,
                    min_length = 3,
                    hl = { underline = true },
                },
            })
        end,
    },

    {
        "akinsho/toggleterm.nvim",
        version = "*",
        config = function()
            require("toggleterm").setup({
                open_mapping = [[<c-\>]],
                direction = "horizontal",
                width = "100",
                shade_terminals = true,
                shading_factor = "75",
                shell = vim.o.shell,
                start_in_insert = true,
            })
        end,
    },

    {
        "jellydn/quick-code-runner.nvim",
        dependencies = { "MunifTanjim/nui.nvim" },
        opts = {
            debug = true,
        },
        cmd = { "QuickCodeRunner", "QuickCodePad" },
        keys = {
            {
                "<leader>cr",
                ":QuickCodeRunner<CR>",
                desc = "Quick Code Runner",
                mode = "v",
            },
            {
                "<leader>cp",
                ":QuickCodePad<CR>",
                desc = "Quick Code Pad",
            },
        },
    },

    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {},
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
        config = function()
            require("noice").setup({
                lsp = {
                    progress = {
                        enabled = true,
                    },
                },
            })
        end,
    },

    {
        "nvim-pack/nvim-spectre",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("spectre").setup()
        end,
    },

    { "itchyny/calendar.vim" },

    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
            -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
        },
        config = function()
            require("neo-tree").setup({
                filesystem = {
                    follow_current_file = {
                        enabled = true,         -- This will find and focus the file in the active buffer every time
                        leave_dirs_open = true, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
                    },
                },
            })
        end,
        keys = {
            {
                "<leader>tt",
                "<cmd>Neotree<CR>",
                desc = "File Tree",
            },
        },
    },

    { "HiPhish/rainbow-delimiters.nvim" },

    {
        "tpope/vim-fugitive",
        dependencies = "tpope/vim-rhubarb",
    },

    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            image = {
                enabled = true,
                max_width = 600,
                max_height = 300,
            },
            bigfile = { enabled = true },
            scroll = { enabled = true },
            words = { enabled = true },
            lazygit = { enabled = true },
            explorer = {
                enabled = true,
                layout = { position = "left" },
            },
            picker = {
                enabled = true,
                sources = {
                    files = {
                        hidden = true, -- show hidden files
                        follow = true,
                    },
                },
                layout = {
                    layout = {
                        -- preset = "ivy",
                        backdrop = true,
                        -- position = "bottom",
                        -- width = 0.6,
                        -- height = 0.5,
                        -- zindex = 20,
                    },
                },
                icons = {
                    files = {
                        enabled = true, -- show file icons
                    },
                },
                formatters = {
                    file = {
                        filename_first = true, -- display filename before the file path
                    },
                },
            },
        },
        keys = {
            {
                "<leader>lg",
                function()
                    Snacks.lazygit.open()
                end,
                desc = "Lazygit",
            },
            {
                "<leader>ll",
                function()
                    Snacks.lazygit.log()
                end,
                desc = "Lazygit logs",
            },
            {
                "<leader>lf",
                function()
                    Snacks.lazygit.log_file()
                end,
                desc = "Lazygit file logs",
            },
            {
                "<leader>gb",
                function()
                    Snacks.picker.git_branches()
                end,
                desc = "Git Branches",
            },
            {
                "<leader>gl",
                function()
                    Snacks.picker.git_log()
                end,
                desc = "Git Log",
            },
            {
                "<leader>gL",
                function()
                    Snacks.picker.git_log_line()
                end,
                desc = "Git Log Line",
            },
            {
                "<leader>gs",
                function()
                    Snacks.picker.git_status()
                end,
                desc = "Git Status",
            },
            {
                "<leader>gS",
                function()
                    Snacks.picker.git_stash()
                end,
                desc = "Git Stash",
            },
            {
                "<leader>gd",
                function()
                    Snacks.picker.git_diff()
                end,
                desc = "Git Diff (Hunks)",
            },
            {
                "<leader>gf",
                function()
                    Snacks.picker.git_log_file()
                end,
                desc = "Git Log File",
            },
            {
                "<leader>ff",
                function()
                    Snacks.picker.files()
                end,
                desc = "Find Files",
            },
            {
                "<leader>fn",
                function()
                    require("telescope.builtin").find_files({ cwd = vim.fn.expand("%:p:h") })
                end,
                desc = "Find Dir Files",
            },
            {
                "<leader>fc",
                function()
                    Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
                end,
                desc = "Find Config File",
            },
            {
                "<leader>fg",
                function()
                    Snacks.picker.git_files()
                end,
                desc = "Find Git Files",
            },
            {
                "<leader>fp",
                "<cmd>Telescope projects<cr>",
                desc = "Projects",
            },
            {
                "<leader>fr",
                function()
                    Snacks.picker.recent()
                end,
                desc = "Recent",
            },
            {
                "<leader>fR",
                function()
                    Snacks.picker.resume()
                end,
                desc = "Resume",
            },
            {
                "<leader>fi",
                function()
                    Snacks.picker.icons()
                end,
                desc = "Icons",
            },
            {
                "<leader>a",
                function()
                    Snacks.picker.lines()
                end,
                desc = "Buffer Lines",
            },
            {
                "<leader>z",
                "<cmd>BLines<cr>",
                desc = "FZF Buffer Lines",
            },
            {
                "<leader><leader>",
                function()
                    Snacks.picker.buffers()
                end,
                desc = "Buffers",
            },
            {
                "<leader>sb",
                function()
                    Snacks.picker.grep_buffers()
                end,
                desc = "Grep Open Buffers",
            },
            {
                "<leader>sz",
                "<cmd>Lines<cr>",
                desc = "FZF Buffer Lines",
            },
            {
                "<leader>sg",
                function()
                    Snacks.picker.grep()
                end,
                desc = "Grep",
            },
            {
                "<leader>sw",
                function()
                    Snacks.picker.grep_word()
                end,
                desc = "Visual selection or word",
                mode = { "n", "x" },
            },
            {
                "<leader>su",
                function()
                    Snacks.picker.undo()
                end,
                desc = "Undotree",
            },
            {
                "<leader>sl",
                function()
                    Snacks.picker.colorschemes()
                end,
                desc = "Colorschemes",
            },
            {
                "<leader>ee",
                function()
                    Snacks.explorer()
                end,
                desc = "File Explorer",
            },
            {
                "<leader>cs",
                function()
                    Snacks.picker.lsp_symbols()
                end,
                desc = "Code Symbols",
            },
            {
                "<leader>cz",
                "<cmd>ZenMode<cr>",
                desc = "Zen mode",
            },
        },
    },

    { "mistricky/codesnap.nvim", build = "make" },

    {
        "ahmedkhalf/project.nvim",
        config = function()
            require("project_nvim").setup({
                sync_root_with_cwd = true,
                respect_buf_cwd = true,
                update_focused_file = {
                    enable = true,
                    update_root = true,
                },
            })
        end,
    },

    {
        "piersolenski/telescope-import.nvim",
        dependencies = "nvim-telescope/telescope.nvim",
    },

    -- {
    --     "neovim/nvim-lspconfig",
    --     dependencies = {
    --         {
    --             "SmiteshP/nvim-navbuddy",
    --             dependencies = {
    --                 "SmiteshP/nvim-navic",
    --                 "MunifTanjim/nui.nvim",
    --             },
    --             opts = { lsp = { auto_attach = true } },
    --         },
    --     },
    -- },

    {
        "rachartier/tiny-inline-diagnostic.nvim",
        event = "VeryLazy", -- Or `LspAttach`
        priority = 1000,    -- needs to be loaded in first
        config = function()
            vim.diagnostic.config({ virtual_text = false })
            require("tiny-inline-diagnostic").setup({})
        end,
    },

    {
        "stevearc/aerial.nvim",
        opts = {},
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("aerial").setup({})
        end,
    },

    -- {
    --     "diogo464/kubernetes.nvim",
    --     config = function()
    --         require("kubernetes").setup({})
    --     end,
    -- },

    {
        "h4ckm1n-dev/kube-utils-nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        lazy = true,
        event = "VeryLazy",
    },

    {
        "dhruvmanila/browser-bookmarks.nvim",
        version = "*",
        -- opts = {
        -- 	selected_browser = "firefox",
        -- },
        dependencies = {
            "kkharji/sqlite.lua",
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            require("browser_bookmarks").setup({
                -- config_dir = "/Users/mkmc/Library/Application Support/Firefox/Profiles/y2fgupr9.dev-edition-default",
                config_dir = "/Users/mkmc/Library/Application Support/Firefox/Profiles/",
                selected_browser = "firefox",
            })
        end,
    },

    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",         -- required
            "sindrets/diffview.nvim",        -- optional - Diff integration
            "nvim-telescope/telescope.nvim", -- optional
        },
        config = true,
        keys = {
            { "<leader>gn", "<cmd>Neogit<cr>", desc = "Neogit" },
        },
    },

    {
        "cappyzawa/trim.nvim",
        config = function()
            require("trim").setup({
                trim_on_write = true,
                patterns = {
                    [[%s/\s\+$//e]],  -- Remove trailing whitespace
                    [[%s/\n\+\%$//]], -- Remove empty lines at the end
                },
            })
        end,
    },

    {
        "folke/trouble.nvim",
        opts = {}, -- for default options, refer to the configuration section for custom setup.
        cmd = "Trouble",
        keys = {
            {
                "<leader>ce",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>cd",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<leader>cl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "<leader>xL",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)",
            },
            {
                "<leader>xQ",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix List (Trouble)",
            },
        },
    },

    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        opts = {},
        config = function()
            require("render-markdown").setup({
                completions = { lsp = { enabled = true } },
            })
        end,
    },

    {
        "Biscuit-Theme/nvim",
        name = "biscuit",
    },

    {
        "uloco/bluloco.nvim",
        lazy = false,
        priority = 1000,
        dependencies = { "rktjmp/lush.nvim" },
        config = function()
            require("bluloco").setup({})
        end,
    },

    -- Markdown new line manager
    {
        "bullets-vim/bullets.vim",
        config = function()
            vim.g.bullets_delete_last_bullet_if_empty = 0
        end,
    },

    -- search ahead
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {},
        keys = {
            {
                "s",
                mode = { "n", "x", "o" },
                function()
                    require("flash").jump()
                end,
                desc = "Flash",
            },
            {
                "R",
                mode = { "o", "x" },
                function()
                    require("flash").treesitter_search()
                end,
                desc = "Treesitter Search",
            },
        },
    },

    {
        "folke/twilight.nvim",
        opts = {},
    },
    {
        "folke/zen-mode.nvim",
        opts = {
            window = {
                backdrop = 0.95,            -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
                width = 120,                -- width of the Zen window
                height = 1,                 -- height of the Zen window
                options = {
                    signcolumn = "no",      -- disable signcolumn
                    number = false,         -- disable number column
                    relativenumber = false, -- disable relative numbers
                    cursorline = false,     -- disable cursorline
                },
            },
            plugins = {
                options = {
                    enabled = true,
                    ruler = false,             -- disables the ruler text in the cmd line area
                    showcmd = false,           -- disables the command in the last line of the screen
                    laststatus = 0,            -- turn off the statusline in zen mode
                },
                twilight = { enabled = true }, -- enable to start Twilight when zen mode opens
            },
        },
    },

    {
        "javiorfo/nvim-soil",
        dependencies = { "javiorfo/nvim-nyctophilia" },
        lazy = true,
        ft = "plantuml",
        opts = {
            actions = {
                redraw = false,
            },
            puml_jar = "~/projects/software/plantuml-1.2025.2.jar",
            image = {
                darkmode = false, -- Enable or disable darkmode
                format = "png",   -- Choose between png or svg
                execute_to_open = function(img)
                    return "feh " .. img
                end,
            },
        },
    },

    {
        "kelly-lin/ranger.nvim",
        config = function()
            require("ranger-nvim").setup({ replace_netrw = true })
            vim.api.nvim_set_keymap("n", "<leader>ef", "", {
                noremap = true,
                callback = function()
                    require("ranger-nvim").open(true)
                end,
            })
        end,
    },

    {
        "claydugo/browsher.nvim",
        event = "VeryLazy",
        config = function()
            require("browsher").setup({
                providers = {
                    ["github.ibm.com"] = {
                        url_template = "%s/blob/%s/%s",
                        single_line_format = "#L%d",
                        multi_line_format = "#L%d-L%d",
                    },
                },
            })
        end,
    },

    {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        keys = {
            { "<leader>xi", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
        },
        config = function()
            require("img-clip").setup({
                default = {
                    dir_path = "imgs",
                    relative_to_current_file = true,
                }
            })
        end
    },

    {
        "onsails/lspkind.nvim",
        enabled = not vim.g.fallback_icons_enabled,
        opts = {
            mode = "symbol",
            symbol_map = {
                Array = "󰅪",
                Boolean = "⊨",
                Class = "󰌗",
                Constructor = "",
                Key = "󰌆",
                Namespace = "󰅪",
                Null = "NULL",
                Number = "#",
                Object = "󰀚",
                Package = "󰏗",
                Property = "",
                Reference = "",
                Snippet = "",
                String = "󰀬",
                TypeParameter = "󰊄",
                Unit = "",
            },
            menu = {},
        },
        config = function(_, opts)
            require("lspkind").init(opts)
        end,
    },

    --- plugin end
    ---
})

-- Set up Comment.nvim
require("Comment").setup({
    pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
})

-- -- Autoformat
-- vim.api.nvim_create_autocmd("BufWritePre", {
--     pattern = "*",
--     callback = function(args)
--         require("conform").format({ bufnr = args.buf })
--     end,
-- })

-- Format command created for formatting to prevent the jumping of cursor
vim.api.nvim_create_user_command("Format", function(args)
    local range = nil
    if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
            start = { args.line1, 0 },
            ["end"] = { args.line2, end_line:len() },
        }
    end
    require("conform").format({ async = true, lsp_format = "fallback", range = range })
end, { range = true })

-- set colorscheme
-- vim.cmd.colorscheme("rose-pine-moon")
-- vim.cmd.colorscheme("catppuccin")
vim.cmd.colorscheme("catppuccin-mocha")
-- vim.cmd.colorscheme("biscuit")
-- vim.cmd.colorscheme("shades_of_purple")
-- vim.cmd.colorscheme("rose-pine")

-- load telescope extensions
require("telescope").load_extension("fzf")

-- dap begin
local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

vim.api.nvim_set_hl(0, "blue", { fg = "#3d59a1" })
vim.api.nvim_set_hl(0, "green", { fg = "#9ece6a" })
vim.api.nvim_set_hl(0, "yellow", { fg = "#FFFF00" })
vim.api.nvim_set_hl(0, "orange", { fg = "#f09000" })
vim.api.nvim_set_hl(0, "red", { fg = "#FF0000" })

-- Just for the time being
vim.fn.sign_define("DapBreakpoint", { text = "B", texthl = "red", linehl = "DapBreakpoint", numhl = "DapBreakpoint" })
vim.fn.sign_define("DapBreakpointCondition", {
    text = "ﳁ",
    texthl = "blue",
    linehl = "DapBreakpoint",
    numhl = "DapBreakpoint",
})
vim.fn.sign_define("DapBreakpointRejected", {
    text = "",
    texthl = "orange",
    linehl = "DapBreakpoint",
    numhl = "DapBreakpoint",
})
vim.fn.sign_define("DapStopped", { text = "", texthl = "green", linehl = "DapBreakpoint", numhl = "DapBreakpoint" })
vim.fn.sign_define(
    "DapLogPoint",
    { text = "", texthl = "yellow", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)

vim.keymap.set("n", "<F5>", require("dap").continue)
vim.keymap.set("n", "<F10>", require("dap").step_over)
vim.keymap.set("n", "<F11>", require("dap").step_into)
vim.keymap.set("n", "<F12>", require("dap").step_out)
vim.keymap.set("n", "<leader>b", require("dap").toggle_breakpoint, { desc = "Breakpoint Toggle" })

dap.adapters.python = function(cb, config)
    if config.request == "attach" then
        local port = (config.connect or config).port
        local host = (config.connect or config).host or "127.0.0.1"
        cb({
            type = "server",
            port = assert(port, "`connect.port` is required for a python `attach` configuration"),
            host = host,
            options = {
                source_filetype = "python",
            },
        })
    else
        cb({
            type = "executable",
            command = os.getenv("VIRTUAL_ENV") .. "/bin/python",
            args = { "-m", "debugpy.adapter" },
            options = {
                source_filetype = "python",
            },
        })
    end
end

dap.configurations.python = {
    {
        -- The first three options are required by nvim-dap
        type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
        request = "launch",
        name = "Launch file",

        -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

        program = "${file}", -- This configuration will launch the current file if used.
        pythonPath = function()
            -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
            -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
            -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
            local cwd = vim.fn.getcwd()
            if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
                return cwd .. "/venv/bin/python"
            elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
                return cwd .. "/.venv/bin/python"
            else
                -- return '/usr/bin/python'
                return os.getenv("VIRTUAL_ENV") .. "/bin/python"
            end
        end,
    },
}

dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
        command = "/Users/mkmc/.local/share/nvim/mason/bin/codelldb",
        args = { "--port", "${port}" },
    },
}

dap.configurations.rust = {
    {
        name = "Rust debug",
        type = "codelldb",
        request = "launch",
        -- program = function()
        --   return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
        -- end,
        program = "${workspaceFolder}/target/debug/${workspaceFolderBasename}",
        cwd = "${workspaceFolder}",
        -- stopOnEntry = true,
        stopOnEntry = false,
    },
}
-- dap end

-- which-key group
local wk = require("which-key")
wk.add({
    -- { "n", "<leader>cp", "<cmd>AerialPrev<CR>", { buffer = bufnr } },
    -- { "n", "<leader>cn", "<cmd>AerialNext<CR>", { buffer = bufnr } },
    { "<leader>c",  group = "Code" },
    { "<leader>cr", "<cmd>lua vim.lsp.buf.rename()<cr>",          desc = "Code rename",           mode = "n" },
    { "<leader>ca", "<cmd>lua vim.lsp.buf.action()<cr>",          desc = "Code action",           mode = "n" },
    { "<leader>cf", "<cmd>Format<cr>",                            desc = "Code format",           mode = "n" },
    { "[d",         "<cmd>lua vim.diagnostic.goto_prev()<cr>",    desc = "Prev diagnostic",       mode = "n" },
    { "]d",         "<cmd>lua vim.diagnostic.goto_next()<cr>",    desc = "Prev diagnostic",       mode = "n" },
    { "<leader>h",  group = "Hunk" },
    { "<leader>g",  group = "Git" },
    { "<leader>m",  group = "Markdown" },
    { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>",             desc = "Markdown preview",      mode = "n" },
    { "<leader>s",  group = "Search" },
    { "<leader>f",  group = "Find" },
    { "<leader>fz", "<cmd>Files<cr>",                             desc = "FZF Find Files",        mode = "n" },
    { "<leader>fm", "<cmd>Marks<cr>",                             desc = "FZF Find Marks",        mode = "n" },
    { "<leader>fj", "<cmd>Jumps<cr>",                             desc = "FZF Find Jumps",        mode = "n" },
    { "<leader>l",  group = "Lazygit" },
    { "<leader>t",  group = "Tree Explorer" },
    { "gi",         "<cmd>lua vim.lsp.buf.implementation()<cr>",  desc = "Go to implementation",  mode = "n" },
    { "gd",         "<cmd>lua vim.lsp.buf.definition()<cr>",      desc = "Go to definition",      mode = "n" },
    { "gt",         "<cmd>lua vim.lsp.buf.type_definition()<cr>", desc = "Go to type definition", mode = "n" },
    { "gD",         "<cmd>lua vim.lsp.buf.declaration()<cr>",     desc = "Go to declaration",     mode = "n" },
    { "K",          "<cmd>lua vim.lsp.buf.hover()<cr>",           desc = "Hover",                 mode = "n" },
    { "<C-k>",      "<cmd>lua vim.lsp.buf.signature_help()<cr>",  desc = "Function signature",    mode = "n" },
})

-- load telescope extensions
require("telescope").load_extension("import")

require("luasnip.loaders.from_vscode").lazy_load()

-- Mapping selecting mappings
vim.keymap.set("n", "<leader><Tab>", "<plug>(fzf-maps-n)", { desc = "Normal maps", silent = true })
vim.keymap.set("x", "<leader><Tab>", "<plug>(fzf-maps-x)", { desc = "Visual maps", silent = true })
vim.keymap.set("o", "<leader><Tab>", "<plug>(fzf-maps-o)", { desc = "o mode", silent = true })

-- Insert mode completion
vim.keymap.set("i", "<C-x><C-k>", "<plug>(fzf-complete-word)", { desc = "Complete Word", silent = true })
vim.keymap.set("i", "<C-x><C-f>", "<plug>(fzf-complete-path)", { desc = "Complete Path", silent = true })
vim.keymap.set("i", "<C-x><C-b>", "<plug>(fzf-complete-buffer-line)", { desc = "Complete BLines", silent = true })
vim.keymap.set("i", "<C-x><C-l>", "<plug>(fzf-complete-line)", { desc = "Complete Lines", silent = true })

vim.keymap.set("n", "<leader>xl", '"*yy', { desc = "Yank line to clipboard" })
vim.keymap.set("v", "<leader>xx", '"*y', { desc = "Yank selection to clipboard" })
vim.keymap.set("n", "<leader>xp", '"*p', { desc = "Paste selection from buffer" })

local function go_to_project_root()
    local root_markers = { ".git", "package.json", "Makefile" }
    local path = vim.fn.expand("%:p:h")
    local root = nil

    while path ~= "/" do
        for _, marker in ipairs(root_markers) do
            if vim.fn.glob(path .. "/" .. marker) ~= "" then
                root = path
                break
            end
        end
        if root then
            break
        end
        path = vim.fn.fnamemodify(path, ":h")
    end

    if root then
        vim.cmd("cd " .. root)
        print("Moved to project root: " .. root)
    else
        print("No project root found")
    end
end

vim.api.nvim_create_user_command("ProjectRoot", go_to_project_root, {})

vim.keymap.set("n", "<leader>td", function()
    local current = vim.diagnostic.is_enabled()
    vim.diagnostic.enable(not current)
end, { desc = "Toggle Diagnostics" })

vim.api.nvim_set_keymap("n", "<leader>tr", ':<C-u>call setreg("r", "$o|    |    |    |<Esc>^f|l")<CR>@r', {
    noremap = true,
    silent = true,
    desc = "Insert new Markdown table row",
})

vim.diagnostic.config({
    virtual_text = false, -- Set to true if you want inline diagnostics
    signs = {
        active = false, -- Enable signs
        text = {
            [vim.diagnostic.severity.ERROR] = "", -- UTF-8 character for cross/error symbol
            [vim.diagnostic.severity.WARN] = "", -- UTF-8 character for warning symbol
            [vim.diagnostic.severity.INFO] = "", -- UTF-8 character for info symbol
            -- [vim.diagnostic.severity.HINT] = "",
            -- [vim.diagnostic.severity.HINT] = "",
            -- [vim.diagnostic.severity.HINT] = "",
            -- [vim.diagnostic.severity.HINT] = "",
            [vim.diagnostic.severity.HINT] = "󰛩",
        },
        linehl = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
            [vim.diagnostic.severity.WARN] = "NONE",
            [vim.diagnostic.severity.INFO] = "NONE",
            [vim.diagnostic.severity.HINT] = "NONE",
        },
    },
})

-- Example of how you might link custom highlight groups if your colorscheme doesn't define them
-- (Add this to your init.lua after your colorscheme is loaded or in an autocmd for ColorScheme)
vim.cmd([[highlight DiagnosticSignError guifg=#e51b5c guibg=NONE]]) -- Reddish
vim.cmd([[highlight DiagnosticSignWarn guifg=#ff9900 guibg=NONE]])  -- Orangish
vim.cmd([[highlight DiagnosticSignInfo guifg=#0088ff guibg=NONE]])  -- Bluish
vim.cmd([[highlight DiagnosticSignHint guifg=#d1ce40 guibg=NONE]])  -- Greenish

-- You might also want to set keymaps for navigating diagnostics
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "gq", vim.diagnostic.setloclist, { desc = "Open diagnostics in loclist" })

local function insert_markdown_table_row()
    local current_line = vim.api.nvim_get_current_line()
    local row_pattern = "^%s*|.*|"            -- Matches lines that look like markdown table rows
    local separator_pattern = "^%s*|%s*[-=:]" -- Matches the separator line

    -- Check if the current line is part of a Markdown table
    if not current_line:match(row_pattern) and not current_line:match(separator_pattern) then
        print("Not on a Markdown table row.")
        return
    end

    -- Save current cursor position
    local current_col = vim.api.nvim_win_get_cursor(0)[2]
    local current_row = vim.api.nvim_win_get_cursor(0)[1]

    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("$", true, true, true), "n", false)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("o", true, true, true), "n", false)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, true, true), "n", false)

    local line_to_copy = vim.api.nvim_get_current_line()
    if line_to_copy:match(separator_pattern) then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("k", true, true, true), "n", false)
        line_to_copy = vim.api.nvim_get_current_line()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("j", true, true, true), "n", false)
    end

    -- Extract just the pipes and spaces
    local new_row_content = ""
    for char in line_to_copy:gmatch("[|%s]") do
        new_row_content = new_row_content .. char
    end

    new_row_content = new_row_content:gsub("([^|]+)", function(match)
        return string.rep(" ", #match)
    end)
    new_row_content = new_row_content:gsub("^%s*|", "|"):gsub("|%s*$", "|")
    new_row_content = new_row_content:gsub("|%s*", "| ")
    vim.api.nvim_put({ new_row_content }, "l", false, true) -- 'l' for line-wise, false for not after, true for retain position
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("^f|l", true, true, true), "n", false)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("i", true, true, true), "n", false)
end

vim.keymap.set("n", "<leader>tr", insert_markdown_table_row, {
    noremap = true,
    silent = true,
    desc = "Insert new Markdown table row",
})
