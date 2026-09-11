
require "core.bootstrap".setup()

-- localrc


local Component = {}

function Component:new()
  local component = {
    -- define properties and methods specific to this component
    foobar = "this foobar"
  }


  -- self is just Component = {
  --   new = function()
  -- }
  --print(vim.inspect(self))


  setmetatable(component, self)
  self.__index = self



  return component
end

local foobar = {
  {x = 10, y = 10},
  {x = 10, y = 10},
  {x = 10, y = 10},
}
