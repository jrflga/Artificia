local LoopManager = {}

local insert = table.insert
local remove = table.remove

function LoopManager:create()
  local loopmngr = {}

  loopmngr.tickers = {}

  function loopmngr:add(obj)
    insert(self.tickers, obj)
  end

  function loopmngr:update(dt)
    for i = 0, #self.tickers do
      local obj = self.tickers[i]
      if obj ~= nil then
        obj:tick(dt)
      end
    end
  end
    return loopmngr
end

return LoopManager
