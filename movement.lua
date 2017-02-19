-- stateful turtle movement


local movement = {}


inventory = require "inventory"
-- os.loadAPI("inventory")


-- PARAMS / CONSTANTS
-- movement related constants
MOVES_COAL = 80


-- STATE
-- keep track of x, y, z coordinates and orientation
position = {x=0, y=0, z=0}
orientation = 0  -- 0:x+, 1:y+, 2:x-, 3:y-
-- keep track of our fuel/home location
fuelGetPadding = 0
fuelPosition = {x=0, y=0, z=0}  -- wherever we started


-- PRIVATE
-- manhattan distance from one point to another
local function distance(start, stop)
  return ((stop.x - start.x) + (stop.y - start.y) + (stop.z - start.z))
end

-- computes the resulting orientation after a turn
local function newOrientation(old, turn)

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
local function newPosition(old, move)

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


-- PUBLIC
-- moves and tracks position in space
-- both should be given in relative coordinates (1 or -1) one at a time
-- will refuel as necessary
function movement.move(mv, orient, dig)

  -- refuel if necessary
  if(turtle.getFuelLevel() == 0) then

    -- refuel
    turtle.select(fuelSlot)
    if turtle.getItemCount() == 0 then
      io.write("Move attempted to refuel but I am out of fuel!\n")
      return false
    end

    turtle.refuel(1)  -- only take one fuel unit (hollywood HILLLSS)
    turtle.select(selectedSlot)  -- go back to old slot
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

return movement