local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

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

require("lazy").setup({

  { "folke/neoconf.nvim", cmd = "Neoconf" },

  {
    -- LSP Configuration & Plugins
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      -- Useful status updates for LSP
      "j-hui/fidget.nvim",
      -- Additional lua configuration, makes nvim stuff amazing
      "folke/neodev.nvim",
      -- code context
      {
        "SmiteshP/nvim-navbuddy",
        dependencies = {
          "SmiteshP/nvim-navic",
          "MunifTanjim/nui.nvim",
        },
        opts = { lsp = { auto_attach = true } },
      },
    },
  },

  { "onsails/lspkind.nvim" },

  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
  },

  {
    -- Autocompletion
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
  },

  {
    -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    build = function()
      pcall(require("nvim-treesitter.install").update({ with_sync = true }))
    end,
  },

  {
    -- Additional text objects via treesitter
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = "nvim-treesitter",
  },

  {
    "folke/trouble.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("trouble").setup({})
    end,
  },

  { "tpope/vim-fugitive", dependencies = "tpope/vim-rhubarb" },

  "tpope/vim-repeat",

  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("gitsigns").setup({ current_line_blame = true })
    end,
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },
  -- colorschemes
  "navarasu/onedark.nvim",
  "EdenEast/nightfox.nvim",
  "martinsione/darkplus.nvim",

  {
    "folke/tokyonight.nvim",
    config = function()
      require("tokyonight").setup({ transparent = true })
    end,
  },

  "cpea2506/one_monokai.nvim",
  "rileytwo/kiss",

  {
    "nvimdev/lspsaga.nvim",
    config = function()
      require("lspsaga").setup({
        use_saga_diagnostic_sign = false,
      })
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- optional
      "nvim-tree/nvim-web-devicons", -- optional
    },
  },

  "nvim-tree/nvim-web-devicons",
  "mhinz/vim-startify",

  "sbdchd/neoformat", -- formatter

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          icons_enabled = true,
          -- theme = 'onedark',
          -- component_separators = "|",
          -- section_separators = "",
        },
        sections = {
          lualine_a = {
            {
              "filename",
              file_status = true, -- Displays file status (readonly status, modified status)
              newfile_status = false, -- Display new file status (new file means no write after created)
              path = 4, -- 0: Just the filename
              -- 1: Relative path
              -- 2: Absolute path
              -- 3: Absolute path, with tilde as the home directory
              -- 4: Filename and parent dir, with tilde as the home directory

              shorting_target = 40, -- Shortens path to leave 40 spaces in the window
              -- for other components. (terrible name, any suggestions?)
              symbols = {
                modified = "[+]", -- Text to show when the file is modified.
                readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
                unnamed = "[No Name]", -- Text to show for unnamed buffers.
                newfile = "[New]", -- Text to show for newly created file before first write
              },
            },
          },

          lualine_b = {
            "branch",
            {
              "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
            },
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
            },
          },

          lualine_c = {
            "datetime",
          },

          lualine_x = {
            {
              require("noice").api.statusline.mode.get,
              cond = require("noice").api.statusline.mode.has,
              color = { fg = "#ff9e64" },
            },
          },
          lualine_y = {
            -- { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            "encoding",
            {
              "fileformat",
              symbols = {
                mac = "", -- e711
                unix = "", -- e712
                dos = "", -- e70f
              },
            },
            { "filetype", icon_only = true },
            { "progress" },
            -- { "progress", separator = " ", padding = { left = 1, right = 0 } },
          },
        },
      })
    end,
  },

  "numToStr/Comment.nvim", -- "gc" to comment visual regions/lines
  "kg8m/vim-simple-align",

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },

  { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make", cond = vim.fn.executable("make") == 1 },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    dependencies = { "echasnovski/mini.icons", version = "*" },
    opts = {},
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

  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- optional, for file icons
    },
  },

  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        open_mapping = [[<c-\>]],
        direction = "float",
        shade_terminals = true,
        shading_factor = "75",
        shell = vim.o.shell,
        start_in_insert = true,
      })
    end,
  },

  { "mfussenegger/nvim-dap" },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
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

  {
    "mrcjkb/rustaceanvim",
    version = "^5", -- Recommended
    lazy = false, -- This plugin is already lazy
  },

  {
    "Wansmer/treesj",
    dependencies = { "nvim-treesitter" },
    config = function()
      require("treesj").setup({
        max_join_length = 2400,
      })
    end,
  },

  { "kevinhwang91/nvim-bqf", ft = "qf" },

  {
    "stevearc/oil.nvim",
    opts = {},
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        float = {
          padding = 2,
          max_width = 0,
          max_height = 0,
          border = "rounded",
          win_options = {
            winblend = 0,
          },
          -- This is the config that will be passed to nvim_open_win.
          -- Change values here to customize the layout
          override = function(conf)
            return conf
          end,
        },
      })
    end,
  },

  {
    "folke/twilight.nvim",
    opts = {},
  },

  {
    "folke/zen-mode.nvim",
    opts = {},
  },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {},
    dependencies = {
      "MunifTanjim/nui.nvim",
      -- "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        lsp = {
          progress = {
            enabled = false,
          },
        },
      })
    end,
  },

  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup()
    end,
  },

  {
    "stevearc/aerial.nvim",
    opts = {},
    -- Optional dependencies
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("aerial").setup({
        on_attach = function(bufnr)
          -- Jump forwards/backwards with '{' and '}'
          vim.keymap.set("n", "<leader>cp", "<cmd>AerialPrev<CR>", { buffer = bufnr })
          vim.keymap.set("n", "<leader>cn", "<cmd>AerialNext<CR>", { buffer = bufnr })
        end,
      })
    end,
  },

  {
    "dreamsofcode-io/ChatGPT.nvim",
    event = "VeryLazy",
    config = function()
      require("chatgpt").setup()
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
  },

  {
    "rmagatti/goto-preview",
    config = function()
      require("goto-preview").setup({})
    end,
  },

  { "sindrets/diffview.nvim" },

  { "mg979/vim-visual-multi" },

  {
    "jiaoshijie/undotree",
    dependencies = "nvim-lua/plenary.nvim",
    -- config = true,
    config = function()
      require("undotree").setup({
        float_diff = false,
      })
    end,
  },

  { "itchyny/calendar.vim" },

  {
    "echasnovski/mini.indentscope",
    config = function()
      require("mini.indentscope").setup()
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
    config = function()
      require("barbecue").setup()
    end,
    opts = {
      -- configurations go here
    },
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

  "RRethy/vim-illuminate",

  {
    "someone-stole-my-name/yaml-companion.nvim",
    dependencies = {
      { "neovim/nvim-lspconfig" },
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope.nvim" },
    },
    config = function()
      require("telescope").load_extension("yaml_schema")
    end,
    opts = {
      schemas = {
        {
          name = "Kubernetes 1.22.4",
          uri = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.22.4-standalone-strict/all.json",
        },
      },
    },
  },

  {
    "ggandor/leap.nvim",
    enabled = true,
    config = function(_, opts)
      local leap = require("leap")
      for k, v in pairs(opts) do
        leap.opts[k] = v
      end
      leap.add_default_mappings(true)
      vim.keymap.del({ "x", "o" }, "x")
      vim.keymap.del({ "x", "o" }, "X")
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    config = function()
      require("treesitter-context").setup()
    end,
  },

  {
    "AckslD/nvim-neoclip.lua",
    dependencies = {
      { "nvim-telescope/telescope.nvim" },
    },
    config = function()
      require("neoclip").setup()
    end,
  },

  {
    "junegunn/fzf",
    run = function()
      vim.fn["fzf#install"]()
    end,
  },

  {
    "gen740/SmoothCursor.nvim",
    config = function()
      require("smoothcursor").setup({})
    end,
  },

  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration

      -- Only one of these is needed, not both.
      "nvim-telescope/telescope.nvim", -- optional
      "ibhagwan/fzf-lua", -- optional
    },
    config = true,
  },

  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup({})
    end,
  },

  {
    "kdheepak/lazygit.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("telescope").load_extension("lazygit")
    end,
  },

  {
    "dhruvmanila/browser-bookmarks.nvim",
    version = "*",
    -- dependencies = {
    --   "kkharji/sqlite.lua",
    --   "nvim-telescope/telescope.nvim",
    -- },
    config = function()
      require("browser_bookmarks").setup({
        selected_browser = "chrome",
      })
    end,
  },

  -- {
  --   "barrett-ruth/telescope-http.nvim",
  --   config = function()
  --     require("telescope").load_extension("http")
  --   end,
  -- },

  {
    "paopaol/telescope-git-diffs.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
    },
  },

  "jonarrien/telescope-cmdline.nvim",

  {
    "sidebar-nvim/sidebar.nvim",
    config = function()
      require("sidebar-nvim").setup()
    end,
  },

  {
    "michaelrommel/nvim-silicon",
    lazy = true,
    cmd = "Silicon",
    config = function()
      require("silicon").setup({
        font = "FiraCode Nerd Font Mono",
      })
    end,
  },

  -- {
  --   "Exafunction/codeium.vim",
  --   event = "BufEnter",
  --   -- config = function()
  --   --   -- Change '<C-g>' here to any keycode you like.
  --   --   vim.keymap.set("i", "<C-g>", function() return vim.fn["codeium#Accept"]() end, { expr = true, silent = true })
  --   --   vim.keymap.set("i", "<c-;>", function() return vim.fn["codeium#CycleCompletions"](1) end, { expr = true, silent = true })
  --   --   vim.keymap.set("i", "<c-,>", function() return vim.fn["codeium#CycleCompletions"](-1) end, { expr = true, silent = true })
  --   --   vim.keymap.set("i", "<c-x>", function() return vim.fn["codeium#Clear"]() end, { expr = true, silent = true })
  --   -- end,
  -- },

  -- {
  --   "Exafunction/codeium.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "hrsh7th/nvim-cmp",
  --   },
  --   config = function()
  --     require("codeium").setup({})
  --   end,
  -- },

  { "arthurxavierx/vim-caser" }, -- the command starts with gss | gsu | gsl | gs_ | gsm | gst | gs<space>

  {
    "johnfrankmorgan/whitespace.nvim",
    config = function()
      require("whitespace-nvim").setup({
        highlight = "DiffDelete",
        ignored_filetypes = { "TelescopePrompt", "Trouble", "help", "registers" },
        ignore_terminal = true,
        return_cursor = true,
      })
      -- vim.keymap.set("n", "<Leader>dw", require("whitespace-nvim").trim, { desc = "Trim Whitespace" })
    end,
  },

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        -- suggestion = { enabled = false },
        panel = {
          auto_refresh = true,
          layout = {
            position = "right",
          },
        },
      })
    end, -- event = "InsertEnter",
  },

  {
    "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup()
    end,
  },

  {
    "javiorfo/nvim-soil",
    dependencies = { "javiorfo/nvim-nyctophilia" },
    lazy = true,
    ft = "plantuml",
    opts = {
      puml_jar = "/Users/mkmc/projects/software/plantuml/plantuml-1.2023.13.jar",
      image = {
        darkmode = false, -- Enable or disable darkmode
        format = "png", -- Choose between png or svg
        execute_to_open = function(img)
          return "viu " .. img
        end,
      },
    },
  },

  {
    "ray-x/go.nvim",
    dependencies = { -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup()
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  },

  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      bigfile = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      -- statuscolumn = { enabled = true },
      words = { enabled = true },
      toggle = { enabled = true },
    },
  },

  --
})
-- plugins end

vim.g.github_enterprise_urls = { "https://github.kyndryl.net" }

vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldmethod = "expr"
vim.o.foldlevel = 99

vim.o.tabstop = 4 -- 4 spaces for tabs (prettier default)
vim.o.shiftwidth = 4 -- 4 spaces for indent width
vim.o.expandtab = true -- expand tab to spaces
vim.o.autoindent = true -- copy indent from current line when starting new one
vim.o.cursorline = true

vim.o.splitright = true
vim.o.splitbelow = true

vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = "yes"
-- vim.wo.scrolloff = 999 -- cursor will always be on the center
vim.o.scrolloff = 5
vim.wo.scrolloff = 5

-- Set colorscheme
-- require('onedark').load()
vim.o.termguicolors = true
vim.cmd([[colorscheme tokyonight-night]])
-- vim.cmd [[colorscheme onedark]]
-- vim.cmd [[colorscheme nightfox]]
-- vim.cmd [[colorscheme one_monokai]]

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

-- require("one_monokai").setup({
--   {transparent = true}
-- })

-- Set lualine as statusline
-- See `:help lualine.txt`

-- Enable Comment.nvim
require("Comment").setup()

-- Gitsigns
-- See `:help gitsigns.txt`
require("gitsigns").setup({
  signs = {
    add = { text = "+" },
    change = { text = "~" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
  },
  current_line_blame = true,
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        ["<C-u>"] = false,
        ["<C-d>"] = false,
      },
    },
  },
  actions = {
    bqf = function(prompt_bufnr)
      local selected = require("telescope.actions.state").get_selected_entry(prompt_bufnr)
      for _, entry in ipairs(selected) do
        require("bqf").qf_set({ entry.value })
      end
      require("bqf").open()
    end,
  },
})

-- vim.keymap.set()

-- Enable telescope fzf native, if installed
pcall(require("telescope").load_extension, "fzf")
-- pcall(require("telescope").load_extension, "octo")
pcall(require("telescope").load_extension, "neoclip")
pcall(require("telescope").load_extension, "projects")
pcall(require("telescope").load_extension, "bookmarks")
-- pcall(require("telescope").load_extension, "http")
pcall(require("telescope").load_extension, "git_diffs")
pcall(require("telescope").load_extension, "cmdline")
-- pcall(require("telescope").load_extension, "yaml_schema")

local wk = require("which-key")
wk.add({
  -- { "n", "<leader>cp", "<cmd>AerialPrev<CR>", { buffer = bufnr } },
  -- { "n", "<leader>cn", "<cmd>AerialNext<CR>", { buffer = bufnr } },
  { "<leader>dw", require("whitespace-nvim").trim, desc = "Trim Whitespace", mode = "n" },
  { "<leader><space>", require("telescope.builtin").buffers, desc = "Find existing buffers", mode = "n" },
  { "<leader>?", require("telescope.builtin").oldfiles, desc = " Find recently opened files", mode = "n" },
  { "<leader>/", require("telescope.builtin").current_buffer_fuzzy_find, desc = "Find in current file", mode = "n" },
  { "<leader>D", vim.lsp.buf.type_definition, desc = "Type Definition", mode = "n" },
  { "<leader>S", '<cmd>lua require("spectre").toggle()<CR>', desc = "Toggle Spectre", mode = "n" },
  { "<leader>b", require("dap").toggle_breakpoint, desc = "Breakpoint Toggle", mode = "n" },
  { "<leader>c", group = "Code" },
  { "<leader>ca", "<cmd>Lspsaga code_action<cr>", desc = "Code Action", mode = "n" },
  { "<leader>cf", "<cmd>Lspsaga finder<cr>", desc = "Code Finder", mode = "n" },
  { "<leader>ch", "<cmd>Lspsaga hover_doc<cr>", desc = "Code Hover", mode = "n" },
  { "<leader>ci", "<cmd>Lspsaga incoming_calls<cr>", desc = "Calls Incoming", mode = "n" },
  { "<leader>cl", "<cmd>Lspsaga outline<cr>", desc = "Code Outline", mode = "n" },
  { "<leader>co", "<cmd>Lspsaga outgoing_calls<cr>", desc = "Calls Outgoing", mode = "n" },
  { "<leader>cr", vim.lsp.buf.rename, desc = "Code Rename", mode = "n" },
  { "<leader>ct", "<cmd>AerialToggle!<CR>", desc = "Open Code Tree", mode = "n" },
  { "<leader>cd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Diagnostics List", mode = "n" },
  { "<leader>d", group = "Diff" },
  { "<leader>db", "<cmd>windo diffthis<cr>", desc = "Show Diff", mode = "n" },
  { "<leader>do", "<cmd>windo diffoff<cr>", desc = "Diff Off", mode = "n" },
  { "<leader>e", vim.diagnostic.open_float, desc = "Diagnostics popup", mode = "n" },
  { "<leader>g", group = "Git" },
  { "<leader>ga", "<cmd>Git add .<cr>", desc = "Git Add", mode = "n" },
  { "<leader>gb", "<cmd>GBrowse<cr>", desc = "Git Browse", mode = "n" },
  { "<leader>gc", "<cmd>Git commit<cr>", desc = "Git Commit", mode = "n" },
  { "<leader>gd", "<cmd>Telescope git_diffs  diff_commits<CR>", desc = "Git commit diffs", mode = "n" },
  { "<leader>gf", "<cmd>G diff<CR>", desc = "Git diff", mode = "n" },
  { "<leader>gg", "<cmd>LazyGit<CR>", desc = "Lazygit", mode = "n" },
  { "<leader>gl", "<cmd>Git log<cr>", desc = "Git Log", mode = "n" },
  { "<leader>gn", "<cmd>Neogit<CR>", desc = "Neogit", mode = "n" },
  { "<leader>gs", "<cmd>Git status<cr>", desc = "Git Status", mode = "n" },
  { "<leader>q", "<cmd>copen<CR>", desc = "Quickfix", mode = "n" },
  { "<leader>s", group = "Search" },
  { "<leader>sb", require("browser_bookmarks").select, desc = "Search Bookmarks", mode = "n" },
  { "<leader>sc", "<cmd>Telescope neoclip<cr>", desc = "Search Clipboard", mode = "n" },
  { "<leader>sd", require("telescope.builtin").diagnostics, desc = "Search Diagnostics", mode = "n" },
  { "<leader>sd", require("telescope.builtin").lsp_document_symbols, desc = "Document Symbols" },
  { "<leader>sf", require("telescope.builtin").find_files, desc = "Search Files", mode = "n" },
  { "<leader>sg", require("telescope.builtin").live_grep, desc = "Search by Grep", mode = "n" },
  { "<leader>sh", require("telescope.builtin").help_tags, desc = "Search Help", mode = "n" },
  { "<leader>sl", "<cmd>Telescope cmdline<cr>", desc = "Search Commandline", mode = "n" },
  { "<leader>sp", "<cmd>Telescope projects<CR>", desc = "Search Projects", mode = "n" },
  { "<leader>sw", require("telescope.builtin").grep_string, desc = "Search current Word", mode = "n" },
  { "<leader>t", group = "Tree Explorer" },
  { "<leader>tf", "<cmd>NvimTreeFindFile<cr>", desc = "Tree Find File", mode = "n" },
  { "<leader>to", "<cmd>NvimTreeFocus<cr>", desc = "Tree Focus", mode = "n" },
  { "<leader>tt", "<cmd>NvimTreeToggle<cr>", desc = "Tree Toggle", mode = "n" },
  { "<leader>u", "<cmd>lua require('undotree').toggle()<cr>", desc = "Undotree", mode = "n" },
  { "<leader>w", group = "Workspace" },
  { "<leader>wa", vim.lsp.buf.add_workspace_folder, desc = "Workspace Add Folder", mode = "n" },
  { "<leader>wr", vim.lsp.buf.remove_workspace_folder, desc = "Workspace Remove Folder", mode = "n" },
  {
    "<leader>ws",
    require("telescope.builtin").lsp_dynamic_workspace_symbols,
    desc = "Workspace Symbols",
    mode = "n",
  },
  { "<leader>wd", require("whitespace-nvim").trim, desc = "Trim Whitespace", mode = "n" },
  { "<leader>p", "<cmd>MarkdownPreview<cr>", desc = "Markdown Preview", mode = "n" },
})

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require("nvim-treesitter.configs").setup({
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = {
    "c",
    "cpp",
    "go",
    "lua",
    "python",
    "rust",
    "typescript",
    "vim",
    "svelte",
    "javascript",
    "css",
    "markdown",
  },

  modules = {},
  sync_install = true,
  ignore_install = {},
  auto_install = true,

  highlight = { enable = true },
  indent = { enable = true, disable = { "python" } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<c-space>",
      node_incremental = "<c-space>",
      scope_incremental = "<c-s>",
      node_decremental = "<c-backspace>",
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        -- ["il"] = "@loop.inner",
        -- ["al"] = "@loop.outer",
        -- ["ib"] = "@block.inner",
        -- ["ab"] = "@block.outer",
        -- ["ig"] = "@assignment.inner",
        -- ["ag"] = "@assignment.outer",
        -- ["rg"] = "@assignment.right",
        -- ["lg"] = "@assignment.left",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>a"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>A"] = "@parameter.inner",
      },
    },
  },
})

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Diagnostics next" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Diagnostics prev" })

-- LSP settings.
local on_attach = function(client, bufnr)

  local nmap = function(keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end
    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  local signs = icons.diagnostics
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

  nmap("<leader>cr", vim.lsp.buf.rename, "Code Rename")
  nmap("gd", vim.lsp.buf.definition, "Goto Definition")
  nmap("gr", require("telescope.builtin").lsp_references, "Goto References")
  nmap("gI", vim.lsp.buf.implementation, "Goto Implementation")

  -- See `:help K` for why this keymap
  nmap("K", vim.lsp.buf.hover, "Hover Documentation")
  nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

  -- Lesser used LSP functionality
  nmap("gD", vim.lsp.buf.declaration, "Goto Declaration")
  nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "Workspace Add Folder")
  nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "Workspace Remove Folder")
  nmap("<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "[W]orkspace [L]ist Folders")

  require("illuminate").on_attach(client)

  -- Create a command `:Format` local to the LSP buffer

  vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
    vim.lsp.buf.format()
  end, { desc = "Format current buffer with LSP" })
end

vim.diagnostic.config({ virtual_text = false })

-- language servers to be installed
local servers = {
  gopls = {
    analyses = {
      unusedparams = true,
    },
    staticcheck = true,
    verboseOutput = true,
  },
  -- pyright = {
  --   -- python = {
  --   --   analysis = {
  --   --     autoSearchPaths = true,
  --   --     useLibraryCodeForTypes = true,
  --   --     diagnosticMode = "workspace",
  --   --     typeCheckingMode = "basic",
  --   --     inlayHints = {
  --   --       variableTypes = false,
  --   --       functionReturnTypes = false,
  --   --     },
  --   --   },
  --   -- },
  -- },
  rust_analyzer = {},
  lua_ls = {},
  svelte = {},
}

-- Setup neovim lua configuration
require("neodev").setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require("mason").setup()
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
  ensure_installed = vim.tbl_keys(servers),
})

mason_lspconfig.setup_handlers({
  function(server_name)
    require("lspconfig")[server_name].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    })
  end,
})

local pyright_on_attach = function(client, bufnr)
  -- Disable all diagnostic messages
  vim.diagnostic.disable()
-- this is needed for trouble icons
  local signs = icons.diagnostics
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end
end

require("lspconfig").pyright.setup({
  on_attach = pyright_on_attach,
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace",
        typeCheckingMode = "basic",
        inlayHints = {
          variableTypes = false,
          functionReturnTypes = false,
        },
      },
    },
  },
})

-- Turn on lsp status information
require("fidget").setup()

local lspkind = require("lspkind")

lspkind.init({
  mode = "symbol_text",
  -- preset = "codicons",
  symbol_map = {
    Text = "󰉿",
    Method = "󰆧",
    Function = "󰊕",
    Constructor = "",
    Field = "󰜢",
    Variable = "󰀫",
    Class = "󰠱",
    Interface = "",
    Module = "",
    Property = "󰜢",
    Unit = "󰑭",
    Value = "󰎠",
    Enum = "",
    Keyword = "󰌋",
    Snippet = "",
    Color = "󰏘",
    File = "󰈙",
    Reference = "󰈇",
    Folder = "󰉋",
    EnumMember = "",
    Constant = "󰏿",
    Struct = "󰙅",
    Event = "",
    Operator = "󰆕",
    TypeParameter = "",
  },
})

-- nvim-cmp setup
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = {
    { name = "copilot", group_index = 2 },
    { name = "nvim_lsp", group_index = 2 },
    { name = "luasnip", group_index = 2 },
    { name = "buffer", group_index = 2 },
    { name = "path", group_index = 2 },
    -- { name = "codeium" }, -- uncomment this for codeium
  },
  formatting = {
    format = lspkind.cmp_format({
      -- mode = "symbol", -- show only symbol annotations
      maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
      ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
      -- The function below will be called before any actual modifications from lspkind
      -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
      before = function(entry, vim_item)
        return vim_item
      end,
      mode = "symbol_text",
      menu = {
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        luasnip = "[LuaSnip]",
        nvim_lua = "[Lua]",
        latex_symbols = "[Latex]",
      },
    }),
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
})

require("nvim-tree").setup({
  sync_root_with_cwd = true,
  respect_buf_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = true,
  },
})

require("luasnip.loaders.from_vscode").lazy_load()

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
vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "red", linehl = "DapBreakpoint", numhl = "DapBreakpoint" })
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

-- local rt = require("rust-tools")
-- rt.setup({
--   server = {
--     on_attach = function(_, bufnr)
--       -- Hover actions
--       vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
--       -- Code action groups
--       vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
--     end,
--   },
-- })

vim.keymap.set("n", "-", "<cmd>Oil --float<CR>", { desc = "Open parent directory" })

vim.keymap.set("n", "gpd", require("goto-preview").goto_preview_definition, { desc = "Preview Definition" })
vim.keymap.set("n", "gpc", require("goto-preview").close_all_win, { desc = "Close Preview " })
vim.keymap.set("n", "gpt", require("goto-preview").goto_preview_type_definition, { desc = "Preview Type Definition" })
vim.keymap.set("n", "gpi", require("goto-preview").goto_preview_implementation, { desc = "Preview Implementation" })
vim.keymap.set("n", "gpD", require("goto-preview").goto_preview_declaration, { desc = "Preview Declaration " })
vim.keymap.set("n", "gpr", require("goto-preview").goto_preview_references, { desc = "Preview References " })

vim.keymap.set("n", "<C-l>", "20zl")
vim.keymap.set("n", "<C-h>", "20zh")
