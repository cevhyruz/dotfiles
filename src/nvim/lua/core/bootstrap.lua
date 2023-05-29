local M = {}

local data = vim.fn.stdpath("data")
local fs_stat = vim.loop.fs_stat

local function close_curwin()
  return vim.api.nvim_buf_delete(0, { force = true })
end

local function echo(message)
  vim.cmd "redraw"
  vim.api.nvim_echo({ { message, "bold" } }, true, {})
end

local function configure_plugins(plugin_path)
  vim.opt.rtp:prepend(plugin_path)
  local plugins = require "plugins"
  local config = require("core.utils").load_config()

  if #config.plugins > 0 then
    table.insert(plugins, { import = config.plugins })
  end

  return require("lazy").setup(plugins, config.lazy_nvim)
end

local function install_lazy(lazy_path)
  if not fs_stat(lazy_path) then
    echo "  Installing lazy.nvim ..."
    local repo = "https://github.com/folke/lazy.nvim.git"
    vim.fn.system {
      "git", "clone", "--filter=blob:none", "--branch=stable", repo, lazy_path
    }
  end

  if configure_plugins(lazy_path) then
    close_curwin()
  end
end

local function install_mason(mason_path)
  vim.schedule(function()
    vim.cmd "MasonInstallAll"
    local packages = table.concat(vim.g.mason_binaries_list, " ")
    require("mason-registry"):on("package:install:success", function(pkg)
      -- rm package name
      packages = string.gsub(packages, pkg.name:gsub("%-", "%%-"), "")
      if packages:match("%S") == nil then
        vim.schedule(function()
          close_curwin()
          echo "Done!"
        end)
      end
    end)
  end)
end

M.init = function(lazy_path, mason_path)
  if not lazy_path then
    lazy_path = data .. "/lazy/lazy.nvim"
  end
  install_lazy(lazy_path)

  if not mason_path then
    mason_path = data .. "/mason"
  end

  vim.env.PATH = vim.env.PATH .. ":" .. mason_path .. "/bin"
  if not fs_stat(mason_path) then
    install_mason(mason_path)
  end
end

return M
