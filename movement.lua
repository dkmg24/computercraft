-- stateful turtle movement

require "math"


-- PARAMS / CONSTANTS
-- movement related constants
MOVES_COAL = 80


-- STATE
-- keep track of x, y, z coordinates and orientation
position = {x=0, y=0, z=0}
orientation = 0  -- 0:x+, 1:y+, 2:x-, 3:y-
-- keep track of our fuel location
fuelGetPadding = 0
fuelPosition = {x=0, y=0, z=0}  -- wherever we started


-- HELPERS
-- manhattan distance from one point to another
function distance(start, stop)
  return ((stop.x - start.x) + (stop.y - start.y) + (stop.z - start.z))
end

-- computes the resulting orientation after a turn
function newOrientation(old, turn)

  -- wrap if we're at an edge
  if((old == 0) and (turn == -1)) then
    return 3
  elseif((old == 3) and (turn == 1)) then
    return 0
  end

  -- otherwise simple addition / subtraction
  return (old + turn)
end

-- computes the incremented position after a move
function newPosition(old, move)

  if(move == 'forward') then
    if(orientation == 0) then
      old.x = old.x + 1
    elseif(orientation == 1) then
      old.y = old.y + 1
    elseif(orientation == 2) then
      old.x = old.x - 1
    elseif(orientation == 3) then
      old.y = old.y - 1
    end
  elseif(move == 'back') then
    if(orientation == 0) then
      old.x = old.x - 1
    elseif(orientation == 1) then
      old.y = old.y - 1
    elseif(orientation == 2) then
      old.x = old.x + 1
    elseif(orientation == 3) then
      old.y = old.y + 1
    end
  elseif(move == 'up') then
    old.z = old.z + 1
  elseif(move == 'down') then
    old.z = old.z - 1
  end
  
  return old
end

-- moves and tracks position in space
-- both should be given in relative coordinates (1 or -1) one at a time
function move(mv, orient, dig)

  -- refuel if necessary
  if(turtle.getFuelLevel() < 1) then
    turtle.refuel(1)
  end

  -- moves
  -- forward
  if(mv.x == 1) then
    if(dig) then
      while(not turtle.forward()) do
        turtle.dig()
      end
    else
      turtle.forward()
    end
    position = newPosition(position, 'forward')

  -- backward
  elseif(mv.x == -1) then
    if(dig) then
      while(not turtle.back()) do
        turtle.digBack()
      end
    else
      turtle.back()
    end
    position = newPosition(position, 'back')

  -- left
  elseif(mv.y == 1) then
    turtle.turnLeft()
    orientation = newOrientation(orientation, 1)
    turtle.forward()
    position = newPosition(position, 'forward')

  -- right
  elseif(mv.y == -1) then
    turtle.turnRight()
    orientation = newOrientation(orientation, -1)
    turtle.forward()
    position = newPosition(position, 'forward')

  -- up
  elseif(mv.z == 1) then
    if(dig) then
      while(not turtle.up()) do
        turtle.digUp()
      end
    else
      turtle.up()
    end
    position = newPosition(position, 'up')

  -- down
  elseif(mv.z == -1) then
    if(dig) then
      while(not turtle.down()) do
        turtle.digDown()
      end
    else
      turtle.down()
    end
    position = newPosition(position, 'down')

  -- turns
  -- left (z up)
  elseif(orient == 1) then
    turtle.turnLeft()
    orientation = newOrientation(orientation, 1)

  -- right
  elseif(orient == -1) then
    turtle.turnRight()
    orientation = newOrientation(orientation, -1)
  end
end

-- mines a 2 high by 1 wide by xstop long tunnel
function mineTunnel(xstop)

  local x = 0  -- local tracking (not absolute position)
  while(math.abs(x) < math.abs(xstop)) do

    -- forward
    move({x=1, y=0, z=0}, 0, true)
    x = x + 1

    -- up
    move({x=0, y=0, z=1}, 0, true)

    -- forward
    move({x=1, y=0, z=0}, 0, true)
    x = x + 1

    -- down
    move({x=0, y=0, z=-1}, 0, true)
  end
end

-- mines a layer by calling mine tunnel
function mineLayer(xstop, ystop, turn, stride)

  local y = 0
  while(math.abs(y) < math.abs(ystop)) do

    -- mine to end
    mineTunnel(xstop)

    -- turn
    move({x=0, y=0, z=0}, turn, true)

    -- mine the turning area
    mineTunnel(stride)
    y = y + stride

    -- turn to face next col
    move({x=0, y=0, z=0}, turn, true)

    -- @ end of next col will turn opposite direction
    turn = -turn
  end
end

-- mines a people-sized mine
function mine(xstop, ystop, zstop, turn, stride, upDown)

  local z = 0
  while(math.abs(z) < math.abs(zstop)) do

    -- generate a layer
    mineLayer(xstop, ystop, turn, stride)

    -- move to the next layer
    move({x=0, y=0, z=upDown}, 0, true)
    move({x=0, y=0, z=upDown}, 0, true)
    move({x=0, y=0, z=upDown}, 0, true)
    z = z + (upDown * 2)

    turn = -turn
  end
end




