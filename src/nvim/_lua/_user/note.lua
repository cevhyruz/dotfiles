local M = {}

local SIGN_NAME = "LightBulbSign"
local LIGHTBULB_VIRTUAL_TEXT_HL = "LightBulbVirtualText"
local LIGHTBULB_VIRTUAL_TEXT_NS = vim.api.nvim_create_namespace("nvim-lightbulb")

if vim.tbl_isempty(vim.fn.sign_getdefined(SIGN_NAME)) then
  vim.fn.sign_define(SIGN_NAME, {
    text = "💡",
    texthl = "CursorLine"
  })
end

local function _update_virtual_text(line, bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_clear_namespace(bufnr, LIGHTBULB_VIRTUAL_TEXT_NS, 0, -1)
  if line then
    vim.api.nvim_buf_set_extmark(
      bufnr,
      LIGHTBULB_VIRTUAL_TEXT_NS,
      line,
      -1,
      {
        virt_text = { { '💡', LIGHTBULB_VIRTUAL_TEXT_HL } },
        hl_mode = "replace"
      }
    )
  end
end

--- Patch for breaking neovim master update to LSP handlers
--- See: https://github.com/neovim/neovim/issues/14090#issuecomment-913198455
local function mk_handler(fn)
  return function(...)
    local config_or_client_id = select(4, ...)
    local is_new = type(config_or_client_id) ~= 'number'

    if is_new then
      fn(...)
    else
      local err = select(1, ...)
      local method = select(2, ...)
      local result = select(3, ...)
      local client_id = select(4, ...)
      local bufnr = select(5, ...)
      local config = select(6, ...)

  -- function(err, result, ctx, config)
      fn( err, result,
        {
          method = method,
          client_id = client_id,
          bufnr = bufnr
        },
        config)
    end
  end

end

local function handler_factory(line, bufnr)
  --- Handler for textDocument/codeAction.
  ---
  --- See lsp-handler for more information.
  ---
  --- @private
  local function code_action_handler(responses)
    -- Check for available code actions from all LSP server responses
    local has_actions = false
    for _,resp in pairs(responses) do
      if resp.result and not vim.tbl_isempty(resp.result) then
        has_actions = true
        break
      end
    end
    if not has_actions then
      _update_virtual_text(nil, bufnr)
    else
      _update_virtual_text(line, bufnr)
    end
  end
  return mk_handler(code_action_handler)
end

function M.update_lightbulb()
  local context = {
    diagnostics = vim.diagnostic.get()
  }

  local params = vim.lsp.util.make_range_params()
  params.context = context

  vim.lsp.buf_request_all(
    vim.api.nvim_get_current_buf(), -- bufnr
    'textDocument/codeAction', -- method
    params, -- params
    handler_factory(
      params.range.start.line,
      vim.api.nvim_get_current_buf())
  )
end

return M
