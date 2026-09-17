if vim.fn.has("nvim-0.11") == 0 then
  vim.notify("init.minimal.lua config only supports Neovim 0.11+", vim.log.levels.ERROR)
  return
end

---Show attached LSP clients in `[name1, name2]` format.
---Long server names will be modified. For example, `lua-language-server` will be shorten to `lua-ls`
---Returns an empty string if there aren't any attached LSP clients.
---@return string
local function lsp_status()
    local attached_clients = vim.lsp.get_clients({ bufnr = 0 })
    if #attached_clients == 0 then
        return "LSP: No client/s attached"
    end
    local names = vim.iter(attached_clients)
        :map(function(client)
            local name = client.name:gsub("language.server", "ls")
            return name
        end)
        :totable()
    return "[" .. table.concat(names, ", ") .. "]"
end

function _G.statusline()
    return table.concat({
        "%f",
        "%h%w%m%r",
        "%=",
        lsp_status(),
        " %-14(%l,%c%V%)",
        "%P",
    }, " ")
end

vim.opt.statusline = "%{%v:lua._G.statusline()%}"

-- completion
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end
  end,
})
-- vim.o.completeopt = "menu,menuone,popup,fuzzy" -- modern completion menu
vim.o.completeopt = 'menu,menuone,noselect'
vim.o.updatetime = 300  -- optional: faster diagnostic/completion feel


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
vim.optwrap = "nowrap"

vim.g.netrw_banner = 0
vim.g.netrw_winsize = 16
vim.g.netrw_liststyle = 3

vim.g.netrw_fastbrowse = 2 -- keep hiddent netrw buffer alive instead of relisting each time
vim.g.netrw_keepdir = 0 -- keeps browsing dir synced with :pwd, 

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
        [";f "] = { ":Buffers<CR>", "Opens Buffer list in quickfix" },
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

local function buffers_to_qf()
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
end

vim.api.nvim_create_user_command("Buffers", buffers_to_qf, {})

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

-- local function netrw_refresh()
--   vim.fn["netrw#Refresh"](vim.fn.expand('%'))
-- end

local function netrw_refresh()
  vim.cmd("Ntree " .. vim.b.netrw_curdir)
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    local opts = { buffer = true, silent = true }

    -- Hide the trailing "/" on directory entries (cosmetic, thin listing only)
    vim.opt_local.conceallevel = 3
    vim.opt_local.concealcursor = "nc"
    vim.cmd([[syntax match NetrwTrailSlash "/$" conceal]])



    -- l / <CR>: open dir under cursor (stay in netrw), or open the file
    -- and close the sidebar (assumes netrw is used via the <C-n> Lexplore
    -- toggle set up above)
    local function netrw_open_and_maybe_close()
      local fname = vim.fn.expand("<cfile>")
      local path = vim.b.netrw_curdir .. "/" .. fname
      local is_dir = vim.fn.isdirectory(path) == 1

      vim.cmd("normal! \r") -- let netrw handle the actual open/navigate

      if not is_dir then
        vim.cmd("Lexplore") -- toggles the sidebar closed
      end
    end

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
        netrw_refresh()
      end
    end, opts)

    -- r: rename file/dir under cursor
    -- vim.keymap.set("n", "r", function()
    --   local dir = vim.b.netrw_curdir
    --   local old = vim.fn.expand("<cfile>")
    --   local new = vim.fn.input("Rename to: ", old)
    --   if new ~= "" and new ~= old then
    --     vim.fn.rename(dir .. "/" .. old, dir .. "/" .. new)
    --     netrw_refresh()
    --   end
    -- end, opts)

    -- dd: delete file/dir under cursor via trash-cli (safer than rm)
    -- vim.keymap.set("n", "dd", function()
    --   local file = vim.fn.expand("<cfile>")
    --   local target = netrw_target_path()
    --   local confirm = vim.fn.confirm('Trash "' .. file .. '"?', "&Yes\n&No", 2)
    --   if confirm == 1 then
    --     vim.fn.system({ "trash-put", target }) -- from trash-cli
    --     netrw_refresh()
    --   end
    -- end, opts)

    -- c: copy file under cursor (path) to clipboard + internal register
    -- vim.keymap.set("n", "c", function()
    --   local target = netrw_target_path()
    --   vim.g.netrw_clipfile = target
    --   vim.fn.setreg("+", target)
    --   print("Copied: " .. target)
    -- end, opts)

    -- p: move the previously "copied" file into the directory under cursor
    -- vim.keymap.set("n", "p", function()
    --   if not vim.g.netrw_clipfile then
    --     print("Nothing copied yet — press 'c' on a file first")
    --     return
    --   end
    --   local dir = vim.b.netrw_curdir
    --   local dest = dir .. "/" .. vim.fn.fnamemodify(vim.g.netrw_clipfile, ":t")
    --   vim.fn.system({ "mv", vim.g.netrw_clipfile, dest })
    --   vim.g.netrw_clipfile = nil
    --   netrw_refresh()
    -- end, opts)

  end,
})
