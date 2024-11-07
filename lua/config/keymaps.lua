-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local select = function(items, callback)
  if #items == 1 then
    do
      callback(items[1])
    end
  else
    do
      vim.ui.select(items, {}, function(choice)
        if choice == nil then
          do
            return
          end
        else
          do
            callback(choice)
          end
        end
      end)
    end
  end
end

local function get_next_file_name(dir, prefix)
  local i = 1
  local file_name
  while true do
    file_name = prefix .. "-" .. i .. ".anki"
    local full_path = dir .. "/" .. file_name
    if not vim.uv.fs_access(full_path, "R") then
      return file_name
    end
    i = i + 1
  end
end

local function find_flashcards_dir(start_dir)
  local dir = start_dir
  while dir ~= "/" do
    if vim.loop.fs_stat(dir .. "/flashcards") and vim.loop.fs_stat(dir .. "/flashcards").type == "directory" then
      return dir .. "/flashcards"
    elseif vim.uv.fs_access(dir .. "/.git", "R") then
      return dir .. "/flashcards"
    end
    dir = vim.fn.fnamemodify(dir, ":h")
  end
  return nil
end

function create_and_run_file(file_prefix)
  local current_file = vim.api.nvim_buf_get_name(0)
  local start_dir = vim.fn.expand("%:p:h")

  local flashcards_dir = find_flashcards_dir(start_dir)

  if not flashcards_dir then
    vim.notify("No 'flashcards' directory found in the parent directories and not a git repo.", vim.log.levels.WARN)
    return
  end

  local file_name = get_next_file_name(flashcards_dir, file_prefix)
  local new_file = flashcards_dir .. "/" .. file_name

  -- Create the new file
  vim.cmd("edit " .. new_file)

  -- Run the specified command in the new file
  vim.cmd("Anki Basic")
  vim.cmd("set ft=tex")

  -- Set an autocmd to run the on_save command when the file is saved
  vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = new_file,
    callback = function()
      vim.cmd("AnkiSend")
      vim.cmd("edit " .. current_file)
    end,
  })
end

vim.keymap.set("n", "<leader>mn", function()
  local prefixes = { "prob", "rl" }
  select(prefixes, create_and_run_file)
end)
