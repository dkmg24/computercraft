-- turtle mining patterns


movement = require "movement"
-- os.loadAPI("movement")


mining = {}


-- PUBLIC
-- mines a 2 high by 1 wide by xstop long tunnel
function mining.mineTunnel(xstop)

  local x = 0  -- local tracking (not absolute position)
  while(math.abs(x) < math.abs(xstop)) do

    -- forward
    movement.move({x=1, y=0, z=0}, 0, true)
    x = x + 1

    -- up
    movement.move({x=0, y=0, z=1}, 0, true)

    -- forward
    movement.move({x=1, y=0, z=0}, 0, true)
    x = x + 1

    -- down
    movement.move({x=0, y=0, z=-1}, 0, true)
  end
end

-- mines a layer by calling mine tunnel
function mining.mineLayer(xstop, ystop, turn, stride)

  local y = 0
  while(math.abs(y) < math.abs(ystop)) do

    -- mine to end
    mining.mineTunnel(xstop)

    -- turn
    movement.move({x=0, y=0, z=0}, turn, true)

    -- mine the turning area
    mining.mineTunnel(stride)
    y = y + stride

    -- turn to face next col
    movement.move({x=0, y=0, z=0}, turn, true)

    -- @ end of next col will turn opposite direction
    turn = -turn
  end
end

-- mines a people-sized mine
function mining.mine(xstop, ystop, zstop, turn, stride, upDown)

  local z = 0
  while(math.abs(z) < math.abs(zstop)) do

    -- generate a layer
    mining.mineLayer(xstop, ystop, turn, stride)

    -- move to the next layer
    for i=1,4 do
        movement.move({x=0, y=0, z=upDown}, 0, true)
        z = z + upDown
    end

    turn = -turn
  end
end

return mining
