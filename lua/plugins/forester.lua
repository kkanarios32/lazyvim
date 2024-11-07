return {
  {
    "kentookura/forester.nvim",
    branch = "36-installation-and-initialization",
    event = "VeryLazy",
    dependencies = {
      { "nvim-telescope/telescope.nvim" },
      { "nvim-treesitter/nvim-treesitter" },
      { "nvim-lua/plenary.nvim" },
      { "hrsh7th/nvim-cmp" },
    },
    config = function()
      -- this ensures that the treesitter is initialized, and toml is installed
      local configs = require("nvim-treesitter.configs")
      configs.setup({
        ensure_installed = { "toml" },
        sync_install = true,
      })

      -- this ensures forester is initialized, makeing `forester` tree-sitter available
      require("forester").setup()

      -- installs the forester tree-sitter, so the syntax highlighting is available
      configs.setup({
        ensure_installed = { "toml", "forester" },
        sync_install = false,
      })

      local foresterCompletionSource = require("forester.completion")
      local cmp = require("cmp")
      cmp.register_source("forester", foresterCompletionSource)
      cmp.setup.filetype("forester", { sources = { { name = "forester", dup = 0 } } })
      cmp.setup()
      vim.keymap.set("n", "<leader>n.", "<cmd>Forester browse<CR>", { silent = true })
      vim.keymap.set("n", "<leader>nn", "<cmd>Forester new<CR>", { silent = true })
      vim.keymap.set("n", "<leader>nr", "<cmd>Forester new_random<CR>", { silent = true })
      vim.keymap.set("i", "<C-t>", "<cmd>Forester transclude_new<CR>", { silent = true })
      vim.keymap.set("i", "<C-l>", "<cmd>Forester link_new<CR>", { silent = true })
    end,
  },
}
