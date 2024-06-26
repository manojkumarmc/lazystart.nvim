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
  "folke/which-key.nvim",

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

  "tpope/vim-fugitive",
  "tpope/vim-rhubarb",
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
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },

  -- colorschemes
  "navarasu/onedark.nvim",
  "EdenEast/nightfox.nvim",
  "martinsione/darkplus.nvim",
  "folke/tokyonight.nvim",
  "cpea2506/one_monokai.nvim",

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

  -- "lukas-reineke/indent-blankline.nvim", -- Add indentation guides even on blank lines
  -- {
  --     "lukas-reineke/indent-blankline.nvim",
  --     main = "ibl",
  --     opts = {},
  --     config = function()
  --         require("ibl").setup({})
  --     end
  -- },

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
    config = function()
      require("which-key").setup({})
    end,
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

  { "simrat39/rust-tools.nvim" },

  {
    "Wansmer/treesj",
    dependencies = { "nvim-treesitter" },
    config = function()
      require("treesj").setup({
        max_join_length = 240,
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
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        -- messages = {
        --   enabled = false,
        -- },
        -- popupmenu = {
        --   enabled = true,
        -- },
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

  -- {
  --   "pwntester/octo.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-telescope/telescope.nvim",
  --   },
  --   config = function()
  --     require("octo").setup()
  --   end,
  -- },

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
    -- keys = {
    --   { ",", mode = { "n", "x", "o" }, desc = "Leap forward to" },
    --   { "<", mode = { "n", "x", "o" }, desc = "Leap backward to" },
    --   { "g,", mode = { "n", "x", "o" }, desc = "Leap from windows" },
    -- },
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
      require("smoothcursor").setup()
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
    dependencies = {
      "kkharji/sqlite.lua",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("browser_bookmarks").setup({
        selected_browser = "firefox",
      })
    end,
  },

  -- { "barrett-ruth/telescope-http.nvim" },

  {
    "paopaol/telescope-git-diffs.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
    },
  },

  "jonarrien/telescope-cmdline.nvim",

  -- {
  --   "anuvyklack/pretty-fold.nvim",
  --   config = function()
  --     require("pretty-fold").setup()
  --   end,
  -- },

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
        ignored_filetypes = { "TelescopePrompt", "Trouble", "help" },
        ignore_terminal = true,
        return_cursor = true,
      })
      vim.keymap.set("n", "<Leader>dw", require("whitespace-nvim").trim, { desc = "Trim Whitespace" })
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
})

-- plugins end

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
-- pcall(require("telescope").load_extension, "bookmarks")
-- pcall(require("telescope").load_extension, "http")
pcall(require("telescope").load_extension, "git_diffs")
pcall(require("telescope").load_extension, "cmdline")
-- pcall(require("telescope").load_extension, "yaml_schema")

-- See `:help telescope.builtin`
vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader><space>", require("telescope.builtin").buffers, { desc = "[ ] Find existing buffers" })

vim.keymap.set(
  "n",
  "<leader>/",
  require("telescope.builtin").current_buffer_fuzzy_find,
  { desc = "[/] Fuzzily search in current buffer]" }
)

vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sw", require("telescope.builtin").grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sc", "<cmd>Telescope neoclip<cr>", { desc = "[S]earch [C]lipboard" })
vim.keymap.set("n", "<leader>sl", "<cmd>Telescope cmdline<cr>", { desc = "[S]earch Command[L]ine" })

vim.keymap.set("n", "<leader>gs", "<cmd>Git status<cr>", { desc = "[G]it [S]tatus" })
vim.keymap.set("n", "<leader>ga", "<cmd>Git add .<cr>", { desc = "[G]it [A]dd" })
vim.keymap.set("n", "<leader>gl", "<cmd>Git log<cr>", { desc = "[G]it [L]og" })
vim.keymap.set("n", "<leader>gc", "<cmd>Git commit<cr>", { desc = "[G]it [C]ommit" })

local wk = require("which-key")
wk.register({
  ["<leader>g"] = { name = "Git" },
  ["<leader>t"] = { name = "Tree Explorer" },
  ["<leader>tf"] = { name = "Find" },
  ["<leader>c"] = { name = "Code" },
  ["<leader>w"] = { name = "Workspace" },
  ["<leader>s"] = { name = "Search" },
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
        ["il"] = "@loop.inner",
        ["al"] = "@loop.outer",
        ["ib"] = "@block.inner",
        ["ab"] = "@block.outer",
        ["ig"] = "@assignment.inner",
        ["ag"] = "@assignment.outer",
        ["rg"] = "@assignment.right",
        ["lg"] = "@assignment.left",
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
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Diagnostics popup" })
vim.keymap.set("n", "<leader>d", vim.diagnostic.setloclist, { desc = "[D]iagnostics List" })

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(client, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end

    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  -- local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
  local signs = icons.diagnostics
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

  nmap("<leader>cr", vim.lsp.buf.rename, "[C]ode [R]ename")
  -- nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
  nmap("<leader>ca", "<cmd>Lspsaga code_action<cr>", "[C]ode [A]ction")
  nmap("<leader>ci", "<cmd>Lspsaga incoming_calls<cr>", "[C]alls [I]ncoming")
  nmap("<leader>co", "<cmd>Lspsaga outgoing_calls<cr>", "[C]alls [O]utgoing")
  nmap("<leader>cf", "<cmd>Lspsaga finder<cr>", "[C]ode [F]inder")
  nmap("<leader>ch", "<cmd>Lspsaga hover_doc<cr>", "[C]ode [H]over")
  nmap("<leader>cl", "<cmd>Lspsaga outline<cr>", "[C]ode [O]utline")

  nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
  nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
  nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
  nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
  nmap("<leader>sd", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
  nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

  -- See `:help K` for why this keymap
  nmap("K", vim.lsp.buf.hover, "Hover Documentation")
  nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

  -- Lesser used LSP functionality
  nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
  nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
  nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
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
  gopls = {},
  pyright = {},
  rust_analyzer = {},
  tsserver = {},
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

vim.keymap.set("n", "<leader>tt", "<cmd>NvimTreeToggle<cr>", { desc = "[T]ree [T]oggle" })
vim.keymap.set("n", "<leader>tfo", "<cmd>NvimTreeFocus<cr>", { desc = "[T]ree [F]ocus" })
vim.keymap.set("n", "<leader>tff", "<cmd>NvimTreeFindFile<cr>", { desc = "[T]ree [F]ind File" })

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
vim.keymap.set("n", "<leader>ct", "<cmd>AerialToggle!<CR>", { desc = "Open Code Tree" })
vim.keymap.set("n", "<leader>u", "<cmd>lua require('undotree').toggle()<cr>", { desc = "Undotree" })

vim.keymap.set("n", "gpd", require("goto-preview").goto_preview_definition, { desc = "Preview Definition" })
vim.keymap.set("n", "gpc", require("goto-preview").close_all_win, { desc = "Close Preview " })
vim.keymap.set("n", "gpt", require("goto-preview").goto_preview_type_definition, { desc = "Preview Type Definition" })
vim.keymap.set("n", "gpi", require("goto-preview").goto_preview_implementation, { desc = "Preview Implementation" })
vim.keymap.set("n", "gpD", require("goto-preview").goto_preview_declaration, { desc = "Preview Declaration " })
vim.keymap.set("n", "gpr", require("goto-preview").goto_preview_references, { desc = "Preview References " })

vim.keymap.set("n", "<leader>S", '<cmd>lua require("spectre").toggle()<CR>', { desc = "Toggle Spectre" })
vim.keymap.set("n", "<leader>M", function()
  require("treesj").toggle({ split = { recursive = true } })
end, { desc = "Split recursive" })

vim.keymap.set("n", "<leader>q", "<cmd>copen<CR>", { desc = "Quickfix" })
vim.keymap.set("n", "<leader>sp", "<cmd>Telescope projects<CR>", { desc = "Search Projects" })
vim.keymap.set("n", "<leader>sb", require("browser_bookmarks").select, { desc = "Search Bookmarks" })
vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "Lazygit" })
vim.keymap.set("n", "<leader>gn", "<cmd>Neogit<CR>", { desc = "Neogit" })
vim.keymap.set("n", "<leader>gd", "<cmd>Telescope git_diffs  diff_commits<CR>", { desc = "Git commit diffs" })
vim.keymap.set("n", "<leader>gf", "<cmd>G diff<CR>", { desc = "Git diff" })

vim.keymap.set("n", "<leader>db", "<cmd>windo diffthis<cr>", { desc = "Show Diff" })
vim.keymap.set("n", "<leader>do", "<cmd>windo diffoff<cr>", { desc = "Diff Off" })

-- local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"
-- -- Repeat movement with ; and ,
-- -- ensure ; goes forward and , goes backward regardless of the last direction
-- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
-- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)
-- -- vim way: ; goes to the direction you were moving.
-- -- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
-- -- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)
-- -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
-- vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
-- vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
-- vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
-- vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
