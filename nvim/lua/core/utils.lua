local Utils = {}

-- @param dict Return something
function Utils.if_nil(value, default)
  if not value then
    return default or {}
  end
  return value
end

return Utils
