return {
  {
    "nvim-cmp",
    opts = function(_, opts)
      table.insert(opts.sources, { name = "snippets" })
    end,
  },
}
