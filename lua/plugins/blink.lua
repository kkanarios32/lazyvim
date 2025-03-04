local latex_args = {
  "--synctex-editor-command",
  [[nvim-texlabconfig -file '%{input}' -line %{line}]],
  "--synctex-forward",
  "%l:1:%f",
  "%p",
}

return {
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = "williamboman/mason.nvim",
    config = function() 
      require("mason").setup()
      require("mason-lspconfig").setup { 
        ensure_installed = { "lua_ls", "basedpyright" },
      }
    end
  },
 {
    'saghen/blink.compat',
    -- use the latest release, via version = '*', if you also use the latest release for blink.cmp
    version = '*',
    -- lazy.nvim will automatically load the plugin when it's required by blink.cmp
    lazy = true,
    -- make sure to set opts so that lazy.nvim calls blink.compat's setup
    opts = {},
    config = function ()
      local blink = require("blink.compat.registry")
      local forester_completion = require("forester.completion")
      blink.register_source("forester", forester_completion)
    end
  },
  {
    'saghen/blink.cmp',
    -- use a release tag to download pre-built binaries
    version = '*',
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept, C-n/C-p for up/down)
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys for up/down)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-e: Hide menu
      -- C-k: Toggle signature help
      --
      -- See the full "keymap" documentation for information on defining your own keymap.
      keymap = { preset = 'default' },

      appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- Will be removed in a future release
        use_nvim_cmp_as_default = true,
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono'
      },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', 'forester' },
	providers = {
	  forester = {
	    name = 'forester',
	    module = 'blink.compat.source',
	  }
	}
      },

      -- Blink.cmp uses a Rust fuzzy matcher by default for typo resistance and significantly better performance
      -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
      -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
      --
      -- See the fuzzy documentation for more information
      fuzzy = { implementation = "prefer_rust_with_warning" }
    },
    opts_extend = { "sources.default" }
  },
  -- LSP servers and clients communicate what features they support through "capabilities".
  --  By default, Neovim support a subset of the LSP specification.
  --  With blink.cmp, Neovim has *more* capabilities which are communicated to the LSP servers.
  --  Explanation from TJ: https://youtu.be/m8C0Cq9Uv9o?t=1275
  --
  -- This can vary by config, but in-general for nvim-lspconfig:
    {
      "neovim/nvim-lspconfig",
      dependencies = { 
        "saghen/blink.cmp",
      },
      opts = {
    -- options for vim.diagnostic.config()
      ---@type vim.diagnostic.Opts
        diagnostics = {
          underline = true,
          update_in_insert = false,
          virtual_text = {
            spacing = 4,
            source = "if_many",
            prefix = "●",
            -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
            -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
            -- prefix = "icons",
          },
          severity_sort = true,
          -- signs = {
          --   text = {
          --     [vim.diagnostic.severity.ERROR] = LazyVim.config.icons.diagnostics.Error,
          --     [vim.diagnostic.severity.WARN] = LazyVim.config.icons.diagnostics.Warn,
          --     [vim.diagnostic.severity.HINT] = LazyVim.config.icons.diagnostics.Hint,
          --     [vim.diagnostic.severity.INFO] = LazyVim.config.icons.diagnostics.Info,
          --   },
          -- },
        },
        -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
        -- Be aware that you also will need to properly configure your LSP server to
        -- provide the inlay hints.
        inlay_hints = {
          enabled = true,
          exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
        },
        -- Enable this to enable the builtin LSP code lenses on Neovim >= 0.10.0
        -- Be aware that you also will need to properly configure your LSP server to
        -- provide the code lenses.
        codelens = {
          enabled = true,
        },
        -- Enable lsp cursor word highlighting
        document_highlight = {
          enabled = true,
        },
        -- add any global capabilities here
        capabilities = {
          workspace = {
            fileOperations = {
              didRename = true,
              willRename = true,
            },
          },
        },
        -- options for vim.lsp.buf.format
        -- `bufnr` and `filter` is handled by the LazyVim formatter,
        -- but can be also overridden when specified
        format = {
          formatting_options = nil,
          timeout_ms = nil,
        },
      -- LSP Server Settings
      -- @type lspconfig.options
        servers = {
          lua_ls = {
            mason = true, -- set to false if you don't want this server to be installed with mason
            -- Use this to add any additional keymaps
            -- for specific lsp servers
            -- ---@type LazyKeysSpec[]
            -- keys = {},
            settings = {
              Lua = {
                workspace = {
                  checkThirdParty = false,
                },
                codeLens = {
                  enable = true,
                },
                completion = {
                  callSnippet = "Replace",
                },
                doc = {
                  privateName = { "^_" },
                },
                hint = {
                  enable = true,
                  setType = false,
                  paramType = true,
                  paramName = "Disable",
                  semicolon = "Disable",
                  arrayIndex = "Disable",
                },
              },
            },
          },
          clangd = {
            cmd = {
              "clangd-18",
              "--background-index",
              "--suggest-missing-includes",
              "--clang-tidy",
              "--header-insertion=iwyu",
            },
          },
          texlab = {
            filetypes = { "plaintex", "tex", "bib" },
            settings = {
              texlab = {
                auxDirectory = ".",
                bibtexFormatter = "texlab",
                build = {
                  args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
                  executable = "latexmk",
                  forwardSearchAfter = true,
                  onSave = true,
                },
                chktex = {
                  onEdit = true,
                  onOpenAndSave = true,
                },
                diagnosticsDelay = 300,
                formatterLineLength = 80,
                forwardSearch = {
                  executable = "zathura",
                  args = latex_args,
                  onSave = true,
                },
                latexFormatter = "latexindent",
                latexindent = {
                  modifyLineBreaks = true,
                },
              },
            },
          },
          basedpyright = {},
        }
      },
      config = function(_, opts)
          local lspconfig = require "lspconfig"
          for server, config in pairs(opts.servers or {}) do
              config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
              lspconfig[server].setup(config)
          end
      end,
    },
{
  "folke/trouble.nvim",
  opts = {}, -- for default options, refer to the configuration section for custom setup.
  cmd = "Trouble",
  keys = {
    {
      "<leader>xx",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Diagnostics (Trouble)",
    },
    {
      "<leader>xX",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Buffer Diagnostics (Trouble)",
    },
    {
      "<leader>cs",
      "<cmd>Trouble symbols toggle focus=false<cr>",
      desc = "Symbols (Trouble)",
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
}
}
