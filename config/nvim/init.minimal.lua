if vim.fn.has("nvim-0.11") == 0 then
  vim.notify("init.minimal.lua config only supports Neovim 0.11+", vim.log.levels.ERROR)
  return
end

vim.opt.ignorecase = true
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ruler = true
vim.opt.winbar = "%f"
vim.opt.cursorline = true
vim.opt.colorcolumn = "80"
vim.opt.clipboard:append("unnamedplus")
vim.opt.splitbelow = true
vim.opt.splitright = true
--vim.opt.wrap = false

-- vim.g.netrw_altv = 1

vim.g.netrw_banner = 0
vim.g.netrw_winsize = 16
vim.g.netrw_liststyle = 3

vim.g.netrw_fastbrowse = 2 -- keep hiddent netrw buffer alive instead of relisting each time
-- vim.g.netrw_keepdir = 0 -- keeps browsing dir synced with :pwd, 

local general_keybindings = {
  i = { ["kj"] = { "<Esc>", "Switch to normal mode" }, },

  n = { [";"] = { ":", "Quick commandline" },
        ["<m-l>"] = { "8zl", "Scroll by 8chars to right" },
        ["<m-h>"] = { "8zh", "Scroll by 8chars to left" },
        ["<m-j>"] = { "mz:m+<CR>`z", "Move current line downward" },
        ["<m-k>"] = { "mz:m-2<CR>`z", "Move current line upward" },
        [";w"] = { ":w<CR>", "Quick saving" },
        ["j"] = { "gj", "Move down through wrapped line normal line" },
        ["k"] = { "gk", "Move up through wrapped line normal line" },
        ["<C-e>"] = { "4<C-e>", "Scroll down by 4lines" },
        ["<C-y>"] = { "4<C-y>", "Scroll up by 4lines" },
        ["<Leader>s<Space>"] = { ":set spell!<CR>", "Toggle spell option" },
        ["<Leader>w<Space>"] = { ":set wrap!<CR>", "Toggle wrap option" },
        ["<Space>"] = { ":set hls!<CR>", "Toggle highlight search" },
        ["<C-n>"] = { ":Lexplore<CR>", "Toggle Netrw sidebar" },
        [";f "] = { ":Buffers!<CR>", "Opens Buffer list in quickfix" },
      },

  c = { ["kj"] = { "<Esc>", "Switch to normal mode" },
        ["<C-h>"] = { "<Left>", "Move cursor to left" },
        ["<C-l>"] = { "<Right>", "Move cursor to right" },
        ["K"] = { "<Up>", "Go up in history" },
        ["J"] = { "<Down>", "Go down in history" }, },

  v = { ["kj"] = { "<Esc>", "Switch back to normal mode" },
        ["<m-j>"] = { ":m'>+<cr>`<my`>mzgv`yo`z",  "move selected line downward" },
        ["<m-k>"] = { ":m'<-2<cr>`>my`<mzgv`yo`z", "move selected line upward" }, },

  x = { ["kj"] = { "<Esc>", "switch to normal mode" }, },
}

-- Map keybindings
for mode, mode_values in pairs(general_keybindings) do
  for keymap, keymap_info in pairs(mode_values) do
    local opts = { desc = keymap_info[2] }
    vim.keymap.set(mode, keymap, keymap_info[1], opts)
  end
end

local function is_buffer_list_qf_open()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].buftype == "quickfix" then
      local title = vim.fn.getqflist({ title = 1 }).title
      if title == "Buffer List" then
        return true
      end
    end
  end
  return false
end

local function open_from_qf(split_cmd)
  local item = vim.fn.getqflist()[vim.fn.line(".")]
  if not item or not item.bufnr or item.bufnr == 0 then
    return
  end

  local bufnr = item.bufnr

  vim.cmd("cclose")

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == bufnr then
      vim.api.nvim_set_current_win(win)
      return
    end
  end

  vim.cmd(split_cmd)
  vim.cmd("buffer " .. bufnr)
end

local function buffers_to_qf(opts)
  if opts.bang and is_buffer_list_qf_open() then
    vim.cmd("cclose")
    return
  end

  local buffers = vim.api.nvim_list_bufs()
  local qf_list = {}

  for _, buf in ipairs(buffers) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
      local name = vim.api.nvim_buf_get_name(buf)
      if name ~= "" then
        table.insert(qf_list, {
          bufnr = buf,
          lnum = 1,
          col = 1,
          text = name,
        })
      end
    end
  end

  vim.fn.setqflist({}, " ", {
    title = "Buffer List",
    items = qf_list,
  })

  vim.cmd("botright copen")

  if vim.o.winbar ~= "" then
    vim.wo.winbar = "%#Title# " .. vim.fn.getqflist({ title = 1 }).title .. " %*"
  end

  local qf_buf = vim.api.nvim_get_current_buf()
  vim.keymap.set("n", "v", function() open_from_qf("vsplit") end, { buffer = qf_buf, silent = true })
  vim.keymap.set("n", "o", function() open_from_qf("split") end, { buffer = qf_buf, silent = true })
end

vim.api.nvim_create_user_command("Buffers", buffers_to_qf, { bang = true })


-- local function buffers_to_qf()
--   local buffers = vim.api.nvim_list_bufs()
--   local qf_list = {}
--
--   for _, buf in ipairs(buffers) do
--     if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
--       local name = vim.api.nvim_buf_get_name(buf)
--       if name ~= "" then
--         table.insert(qf_list, {
--           bufnr = buf,
--           lnum = 1,
--           col = 1,
--           text = name,
--         })
--       end
--     end
--   end
--
--   vim.fn.setqflist({}, " ", {
--     title = "Buffer List",
--     items = qf_list,
--   })
--
--   vim.cmd("botright copen")
--
--   if vim.o.winbar ~= "" then
--     vim.wo.winbar = "%#Title# " .. vim.fn.getqflist({ title = 1 }).title .. " %*"
--   end
-- end
--
-- vim.api.nvim_create_user_command("Buffers", buffers_to_qf, {})


-- if there's only one window left, and it's the quickfix list, close it
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    if #vim.api.nvim_list_wins() == 1
      and vim.bo.buftype == "quickfix" then
      vim.cmd("quit")
    end
  end,
})


------------------------------------------------------------
-- Netrw display options
------------------------------------------------------------
-- Hide the "./" and "../" entries in the listing
vim.g.netrw_list_hide = [[^\./$,^\.\./$]]
vim.g.netrw_hide = 1


----------------------------------
--- Netrw crud opening file
----------------------------------

-- <CR>: Open the file or enter the directory under cursor
-- o:    Open file/directory in a new horizontal split

------------------------------------------------------------
-- Netrw CRUD mappings
------------------------------------------------------------
-- Holds the path of the file most recently "copied" with `c`
vim.g.netrw_clipfile = nil

local function netrw_target_path()
  local dir = vim.b.netrw_curdir
  local fname = vim.fn.expand("<cfile>")
  return dir .. "/" .. fname
end

-- Refresh the listing in place (faster / less disruptive than :Explore)
-- local function netrw_refresh()
--   vim.cmd("normal " .. vim.api.nvim_replace_termcodes("<c-l>", true, true, true))
-- end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    local opts = { buffer = true, silent = true }

    -- Hide the trailing "/" on directory entries (cosmetic, thin listing only)
    -- vim.opt_local.conceallevel = 3
    -- vim.opt_local.concealcursor = "nc"
    -- vim.cmd([[syntax match NetrwTrailSlash "/$" conceal]])


    -- l / <CR>: open dir under cursor (stay in netrw), or open the file
    -- and close the sidebar (assumes netrw is used via the <C-n> Lexplore
    -- toggle set up above)
    -- local function netrw_open_and_maybe_close()
    --   local fname = vim.fn.expand("<cfile>")
    --   local path = vim.b.netrw_curdir .. "/" .. fname
    --   local is_dir = vim.fn.isdirectory(path) == 1
    --
    --   vim.cmd("normal! \r") -- let netrw handle the actual open/navigate
    --
    --   if not is_dir then
    --     vim.cmd("Lexplore") -- toggles the sidebar closed
    --   end
    -- end

    -- map <Space> as <CR>
    vim.keymap.set("n", "<Space>", "<Plug>NetrwLocalBrowseCheck", opts)
    -- map 'v' to open vertical split to the far right always
    -- vim.keymap.set("n", "v", ,opts)

  vim.keymap.set("n", "<C-j>", "<C-w>P<C-e><C-w>p", { buffer = true, remap = true, desc = "Scroll preview down" })
  vim.keymap.set("n", "<C-k>", "<C-w>P<C-y><C-w>p", { buffer = true, remap = true, desc = "Scroll preview up" })



    -- vim.keymap.set("n", "l", netrw_open_and_maybe_close, opts)
    -- vim.keymap.set("n", "<CR>", netrw_open_and_maybe_close, opts)
    -- h: go up one directory (same as netrw's default "-")
    -- vim.keymap.set("n", "h", "-", { buffer = true, remap = true })

    -- a: create a new file in the current directory
    vim.keymap.set("n", "a", function()
      local dir = vim.b.netrw_curdir
      local name = vim.fn.input("New file: ")
      if name ~= "" then
        vim.fn.writefile({}, dir .. "/" .. name)
        --netrw_refresh()
      end
    end, opts)

  end,
})

