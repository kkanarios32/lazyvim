-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Function to replace math delimiters in the current buffer
local function replace_math_delimiters()
  -- Get all lines in the current buffer
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local modified = false

  -- Process each line
  for i, line in ipairs(lines) do
    -- First replace double dollar signs ($$x$$)
    local new_line = line:gsub("%$%$(.-)%$%$", "##{%1}")

    -- Then replace single dollar signs ($x$)
    new_line = new_line:gsub("%$(.-)%$", "#{%1}")

    -- Check if the line was modified
    if new_line ~= line then
      modified = true
      lines[i] = new_line
    end
  end

  -- If any modifications were made, update the buffer
  if modified then
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  end
end

-- Create an autocommand for .tree files
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.tree",
  callback = function()
    replace_math_delimiters()
  end,
  desc = "Replace math delimiters in .tree files",
})
