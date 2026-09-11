local Utils = {}

-- clean close
Utils.close_curwin = function()
  return vim.api.nvim_buf_delete(0, { force = true })
end

-- redrawing echo
Utils.echo = function(msg)
  vim.cmd "redraw"
  vim.api.nvim_echo({{ msg, "bold" }}, true, {})
end

-- prompt a message in a popup
Utils.prompt = function(msg)

  local winwidth  = 40
  local winheight = 5

  local lines = vim.api.nvim_get_option("lines")
  local cols  = vim.api.nvim_get_option("columns")

  local row = math.floor((lines - winheight) / 2)
  local col = math.floor((cols - winwidth) / 2)

  local opts = {
    relative = "editor",
    width = winwidth,
    height = winheight,
    row = row,
    col = col,
    style = "minimal",
    border = "none",
  }
  local buf = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { msg })

  local win = vim.api.nvim_open_win(buf, true, opts)
end

-- Loads a plugin only when we open a file and attach to a buffer.
Utils.lazy_load = function(plugin)
  local lazy = require "lazy"
  vim.api.nvim_create_autocmd({ "BufRead", "BufWinEnter", "BufNewFile" }, {
    group = vim.api.nvim_create_augroup("load_on_attach_" .. plugin, {}),
    callback = function()
      local file = vim.fn.expand "%"
      if file ~= "NvimTree_1" and file ~= "[lazy]" and file ~= "" then
        vim.api.nvim_del_augroup_by_name("load_on_attach_" .. plugin)
        -- dont defer for treesitter as it will show slow highlighting
        -- This deferring only happens only when we do "nvim filename"
        if plugin ~= "nvim-treesitter" then
          vim.schedule(function()

            lazy.load { plugins = plugin }

            if plugin == "nvim-lspconfig" then
              vim.cmd "silent! do FileType"
            end
          end, 0)
        else
          lazy.load { plugins = plugin }
        end
      end
    end,
  })
end

return Utils
