local M = {}
local merge_tb = vim.tbl_deep_extend

-- Load the default configuration ammended by localrc config.
M.load_config = function()
  local config = require "core.default_config"
  local localrc_path = vim.api.nvim_get_runtime_file("lua/user/localrc.lua", false)[1]

  -- if there are localrc.mappings entries then
  if localrc_path then
    local localrc = dofile(localrc_path)
    config.mappings = M.remove_disabled_keys(localrc.mappings, require "core.mappings")
    -- update default_config by the values of localrc.
    config = merge_tbl("force", config, localrc)
  end

  config.mappings.disabled = nil

  return config
end

M.remove_disabled_keys = function(localrc_mappings, default_mappings)
  if not localrc_mappings then
    return default_mappings
  end

  -- store keys in a array with true value to compare
  for _, mappings in pairs(localrc_mappings) do
    local keys_to_disable = {}
    for mode, section_keys in pairs(mappings) do
      if not keys_to_disable[mode] then
        keys_to_disable[mode] = {}
      end
      section_keys = (type(section_keys) == "table" and section_keys) or {}
      for k, _ in pairs(section_keys) do
        keys_to_disable[mode][k] = true
      end
    end
  end

  -- make a copy as we need to modify default_mappings
  for section_name, section_mappings in pairs(default_mappings) do
    for mode, mode_mappings in pairs(section_mappings) do
      mode_mappings = (type(mode_mappings) == "table" and mode_mappings) or {}
      for k, _ in pairs(mode_mappings) do
        -- if key if found then remove from default_mappings
        if keys_to_disable[mode] and keys_to_disable[mode][k] then
          default_mappings[section_name][mode][k] = nil
        end
      end
    end
  end

  return default_mappings
end

M.load_mappings = function(section, mapping_opt)
  local function set_section_map(section_values)
    if section_values.plugin then
      return
    end

    section_values.plugin = nil

    for mode, mode_values in pairs(section_values) do
      local default_opts = merge_tb( "force", { mode = mode }, mapping_opt or {})
      for keybind, mapping_info in pairs(mode_values) do
        -- merge default + user options.
        local opts = merge_tb("force", default_opts, mapping_info.opts or {})

        mapping_info.opts, opts.mode = nil, nil
        opts.desc = mapping_info[2]

        vim.keymap.set(mode, keybind, mapping_info[1], opts)
      end
    end
  end

  local mappings = require("core.utils").load_config().mappings

  if section ~= nil and type(section) == "string" then
    mappings[section]["plugins"] = nil
    mappings = { mappings[section] }
  end

  for _, sect in pairs(mappings) do 
    set_section_map(sect)
  end
end

M.lazy_load = function(plugin)
  vim.api.nvim_create_autocmd({ "BufRead", "BufWinEnter", "BufNewFile" }, {
    group = vim.api.nvim_create_augroup("BeLazyOnFileOpen" .. plugin, {}),
    callback = function()
      local file = vim.fn.expand "%"
      
      if file ~= "NvimTree_1" and file ~= "[lazy]" and file ~= "" then
        vim.api.nvim_del_augroup_by_name("BeLazyOnFileOpen" .. plugin)

        -- don't defer for treesitter as it will slow highlighting
        -- This deferring only happens only when we do "nvim filename"
        
        if plugin ~= "nvim-treesitter" then
          vim.schedule(function()
            require("lazy").load { plugins = plugin }

            if plugin == "nvim-lspconfig" then
              vim.cmd "silent! do FileType"
            end
          end, 0)
        else
          require("lazy").load { plugins = plugin }
        end
      end
    end
  })
end

return M
