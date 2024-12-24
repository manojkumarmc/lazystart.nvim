local vim = vim

-- Basic settings
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.wo.wrap = false
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
vim.opt.scrolloff = 3
vim.opt.sidescrolloff = 3

vim.opt.tabstop = 4 -- 4 spaces for tabs (prettier default)
vim.opt.shiftwidth = 4 -- 4 spaces for indent width
vim.opt.expandtab = true -- expand tab to spaces
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
  { "numToStr/Comment.nvim", lazy = false },
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

  -- LSP
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
  },

  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    opts = {
      -- pickers = {
      --   git_branches = { previewer = false, theme = "ivy", show_remote_tracking_branches = false },
      --   git_commits = { previewer = false, theme = "ivy" },
      --   grep_string = { previewer = false, theme = "ivy" },
      --   diagnostics = { previewer = false, theme = "ivy" },
      --   find_files = { previewer = false, theme = "ivy" },
      --   buffers = { previewer = false, theme = "ivy" },
      --   current_buffer_fuzzy_find = { theme = "ivy" },
      --   resume = { previewer = false, theme = "ivy" },
      --   live_grep = { theme = "ivy" },
      -- },
      defaults = {
        layout_config = {
          prompt_position = "bottom",
        },
      },
    },
    keys = {
      { "<leader>z", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "File fuzzy find" },
      { "<leader>d", "<cmd>Telescope diagnostics<cr>", desc = "Show diagnostics" },
      { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Git branches" },
      { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Git commits" },
      { "<leader>w", "<cmd>Telescope grep_string<cr>", desc = "Grep string" },
      { "<leader>f", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>c", "<cmd>Telescope resume<cr>", desc = "Resume search" },
      { "<leader>s", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader><space>", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    extensions = {
      fzf = {
        fuzzy = true, -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true, -- override the file sorter
        case_mode = "smart_case", -- or "ignore_case" or "respect_case"
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

  -- Pair matching characters
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      disable_filetype = { "TelescopePrompt", "vim" },
    },
  },

  -- Gitsigns
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map("n", "]c", function()
            if vim.wo.diff then
              return "]c"
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return "<Ignore>"
          end, { expr = true })

          map("n", "[c", function()
            if vim.wo.diff then
              return "[c"
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return "<Ignore>"
          end, { expr = true })

          -- Actions
          map("n", "<leader>hs", gs.stage_hunk)
          map("n", "<leader>hr", gs.reset_hunk)
          map("v", "<leader>hs", function()
            gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end)
          map("v", "<leader>hr", function()
            gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end)
          map("n", "<leader>hS", gs.stage_buffer)
          map("n", "<leader>hu", gs.undo_stage_hunk)
          map("n", "<leader>hR", gs.reset_buffer)
          map("n", "<leader>hp", gs.preview_hunk)
          map("n", "<leader>hb", function()
            gs.blame_line({ full = true })
          end)
          map("n", "<leader>tb", gs.toggle_current_line_blame)
          map("n", "<leader>hd", gs.diffthis)
          map("n", "<leader>hD", function()
            gs.diffthis("~")
          end)
          map("n", "<leader>td", gs.toggle_deleted)

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
      { "echasnovski/mini-git", version = false, main = "mini.git" },
      { "echasnovski/mini.diff" },
    },
    config = function()
      require("mini.statusline").setup()
    end,
  },

  {
    "echasnovski/mini.indentscope",
    config = function()
      require("mini.indentscope").setup()
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

  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup({})
    end,
    keys = {
      {
        "<leader>tt",
        "<cmd>NvimTreeToggle<CR>",
        desc = "File Tree",
      },
    },
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
    dependencies = { "nvim-treesitter" },
    config = function()
      require("treesj").setup({
        max_join_length = 2400,
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
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && npm install",
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
        direction = "float",
        shade_terminals = true,
        shading_factor = "75",
        shell = vim.o.shell,
        start_in_insert = true,
      })
    end,
  },

  --- plugin end
})

-- -- Open Telescope on start
-- vim.api.nvim_create_autocmd("VimEnter", {
--   callback = function()
--     if vim.fn.argv(0) == "" then
--       require("telescope.builtin").find_files()
--     end
--   end,
-- })

-- Set up Comment.nvim
require("Comment").setup({
  pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
})

-- Set up Mason and install set up language servers
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "rust_analyzer",
    "gopls",
    -- "pyright",
    "pylsp",
    "jsonls",
    "marksman",
    "dockerls",
    "helm_ls",
    "biome",
  },
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()
-- local capabilities = require("blink.cmp").get_lsp_capabilities()

require("mason-lspconfig").setup_handlers({
  function(server_name)
    require("lspconfig")[server_name].setup({
      capabilities = capabilities,
    })
  end,
})

-- Global LSP mappings
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

-- More LSP mappings
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set({ "n", "v" }, "<space>.", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  end,
})

-- Set up nvim-cmp
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local luasnip = require("luasnip")
local cmp = require("cmp")

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
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
    { name = "nvim_lsp", max_item_count = 8 },
    { name = "buffer", max_item_count = 8 },
    { name = "path", max_item_count = 5 },
    { name = "luasnip", max_item_count = 5 },
  },
  formatting = {
    format = function(_, vim_item)
      vim_item.abbr = string.sub(vim_item.abbr, 1, 20)
      return vim_item
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
})

cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

-- Autoformat
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format({ bufnr = args.buf })
  end,
})

-- set colorscheme
-- vim.cmd("colorscheme rose-pine-moon")
vim.cmd("colorscheme catppuccin")

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
