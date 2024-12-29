return {
  {
    "rareitems/anki.nvim",
    -- lazy -- don't lazy it, it tries to be as lazy possible and it needs to add a filetype association
    opts = {
      {
        -- this function will add support for associating '.anki' extension with both 'anki' and 'tex' filetype.
        models = {
          -- Here you specify which notetype should be associated with which deck
          ["Basic"] = "Math",
        },
      },
    },
  },
}
