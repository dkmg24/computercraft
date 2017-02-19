-- mimics the computercraft turtle API so you can test offline


turtle = {}


-- STATE
-- the world state, a single empty chunk around the turtle
turtle.world = {}
for z=-64,64 do
  layer = {}
  for y=-64,64 do
    row = {}
    for x=-64,64 do
      row[x] = 0
    end
    layer[y] = row
  end
  turtle.world[z] = layer
end


-- any state intrinsic to the game / turtle API
turtle.fuelLevel = 0
turtle.inventory = {
  {bid=0, qty=0}, {bid=-0, qty=0}, {bid=-0, qty=0}, {bid=-0, qty=0},
  {bid=0, qty=0}, {bid=-0, qty=0}, {bid=-0, qty=0}, {bid=-0, qty=0},
  {bid=0, qty=0}, {bid=-0, qty=0}, {bid=-0, qty=0}, {bid=-0, qty=0},
  {bid=0, qty=0}, {bid=-0, qty=0}, {bid=-0, qty=0}, {bid=-0, qty=0},
}
turtle.selectedSlot = 1  -- need to simulate this since we don't always go through the inventory API

function turtle.printInventory()
  for i=1,4 do
    s = ""
    for j=1,4 do
      invTable = turtle.inventory[(4 * (i - 1)) + j]
      s = s .. string.format("  %d:%02d  ", invTable.bid, invTable.qty)
    end
    io.write(s, "\n")
  end
end

function turtle.dig()
  io.write("Digging forward", "\n")
end

function turtle.digUp()
  io.write("Digging up", "\n")
end

function turtle.digDown()
  io.write("Digging down", "\n")
end

function turtle.forward()
  io.write("Moving forward", "\n")
  turtle.fuelLevel = turtle.fuelLevel - 1
  return true
end

function turtle.back()
  io.write("Moving back", "\n")
  turtle.fuelLevel = turtle.fuelLevel - 1
  return true
end

function turtle.up()
  io.write("Moving up", "\n")
  turtle.fuelLevel = turtle.fuelLevel - 1
  return true
end

function turtle.down()
  io.write("Moving down", "\n")
  turtle.fuelLevel = turtle.fuelLevel - 1
  return true
end

function turtle.turnLeft()
  io.write("Turning left", "\n")
end

function turtle.turnRight()
  io.write("Turning right", "\n")
end

function turtle.place()
  io.write("Placing forward", "\n")
  turtle.world[position.z][position.y][position.x + 1] = 1
  turtle.inventory[turtle.selectedSlot].qty = turtle.inventory[turtle.selectedSlot].qty - 1
end

function turtle.placeUp()
  io.write("Placing up", "\n")
  turtle.world[position.z + 1][position.y][position.x] = 1
  turtle.inventory[turtle.selectedSlot].qty = turtle.inventory[turtle.selectedSlot].qty - 1
end

function turtle.placeDown()
  io.write("Placing down", "\n")
  turtle.world[position.z - 1][position.y][position.x] = 1
  turtle.inventory[turtle.selectedSlot].qty = turtle.inventory[turtle.selectedSlot].qty - 1
end

function turtle.getFuelLevel()
  -- io.write(string.format("Getting fuel level (%d)", turtle.fuelLevel), "\n")
  return turtle.fuelLevel
end

function turtle.refuel(num)
  io.write(string.format("Refueling by %d", num), "\n")

  fuelSelected = (turtle.inventory[turtle.selectedSlot].bid == 1)
  isFuel = (turtle.inventory[turtle.selectedSlot].qty > 0)

  if fuelSelected and isFuel then
    turtle.fuelLevel = turtle.fuelLevel + 80  -- TODO: use fuel value
    turtle.inventory[turtle.selectedSlot].qty = turtle.inventory[turtle.selectedSlot].qty - 1
    io.write(string.format("Success! Fuel level is %d", turtle.fuelLevel), "\n")
  end
end

function turtle.select(num)
  -- io.write(string.format("Selected slot %d", num), "\n")
  turtle.selectedSlot = num
end

function turtle.getItemCount(num)
  -- io.write(string.format("Item count of slot %d is %d", turtle.selectedSlot, turtle.inventory[turtle.selectedSlot].qty), "\n")
  return turtle.inventory[num].qty
end

return turtle