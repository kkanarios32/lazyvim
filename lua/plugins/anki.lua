return {
  "rareitems/anki.nvim",
  -- lazy -- don't lazy it, it tries to be as lazy possible and it needs to add a filetype association
  dependencies = {
    { "hrsh7th/nvim-cmp" },
  },
  opts = {
    {
      -- this function will add support for associating '.anki' extension with both 'anki' and 'tex' filetype.
      models = {
        -- Here you specify which notetype should be associated with which deck
        ["Basic"] = "Math",
      },
    },
  },
  config = function()
    local anki = require("anki")
    anki.setup()
    local extended_filetypes = Snippets.config.get_option("extended_filetypes", {})
    extended_filetypes["anki"] = extended_filetypes["anki"] or {}
    table.insert(extended_filetypes["anki"], "tex")
    table.insert(extended_filetypes["anki"], "*")
    Snippets.config.set_option("extended_filetypes", extended_filetypes)
    local cmp = require("cmp")
    cmp.setup.filetype("anki", {
      sources = {
        { name = "path" },
        { name = "buffer" },
        { name = "snippets" },
      },
    })
    cmp.setup()
  end,
}
