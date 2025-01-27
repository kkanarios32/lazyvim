return {
  "kentookura/forester.nvim",
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

    local cmp = require("cmp")
    local snippets = require("snippets")
    local foresterCompletionSource = require("forester.completion")
    cmp.register_source("forester", foresterCompletionSource)
    local extended_filetypes = Snippets.config.get_option("extended_filetypes", {})
    extended_filetypes["forester"] = extended_filetypes["forester"] or {}
    table.insert(extended_filetypes["forester"], "tex")
    table.insert(extended_filetypes["forester"], "*")
    Snippets.config.set_option("extended_filetypes", extended_filetypes)
    cmp.setup.filetype("forester", {
      sources = {
        { name = "forester", dup = 0 },
        { name = "path" },
        { name = "buffer" },
        { name = "snippets" },
      },
    })
    cmp.setup()
    vim.keymap.set("n", "<leader>n.", "<cmd>Forester browse<CR>", { silent = true })
    vim.keymap.set("n", "<leader>nn", "<cmd>Forester new<CR>", { silent = true })
    vim.keymap.set("n", "<leader>nr", "<cmd>Forester new_random<CR>", { silent = true })
    vim.keymap.set("i", "<C-t>", "<cmd>Forester transclude_new<CR>", { silent = true })
    vim.keymap.set("i", "<C-l>", "<cmd>Forester link_new<CR>", { silent = true })
  end,
}
