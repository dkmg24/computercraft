-- turtle block placement functions

movement = require "movement"
-- os.loadAPI("movement")
inventory = require "inventory"
-- os.loadAPI("inventory")


placement = {}


-- PUBLIC
-- attempts to place a block while maintaining state
-- direction is the same as movement.orientation (0:x+, 1:y+, 2:x-, 3:y-)
-- plus some extra codes for up and down (4:z+, 5:z-)
-- returns true if successful, false otherwise
function placement.place(blockId, direction, force)

    -- find and select the topmost stack of placeable blocks
    slot = inventory.find(blockId)
    if slot < 0 then

        io.write("Could not find block to place!\n")
        return false
    end
    inventory.select(slot)

    -- actually place the block
    -- NOTE: at this point we're sure place won't fail for any reason besides
    -- the space being filled with another block / entity
    if direction == 0 then  -- x+
        if force then 
            while(not turtle.place()) do
                turtle.dig()
            end
            return true
        else
            return turtle.place()
        end

    elseif direction == 1 then  -- y+
        movement.move({x=0, y=0, z=0}, 1, force)  -- turn left
        return inventory.place(blockId, 0, force)  -- call placeForward

    elseif direction == 2 then
        -- turn around
        movement.move({x=0, y=0, z=0}, 1, force)
        movement.move({x=0, y=0, z=0}, 1, force)
        return inventory.place(blockId, 0, force)  -- call placeForward

    elseif direction == 3 then
        movement.move({x=0, y=0, z=0}, -1, force)  -- turn right
        return inventory.place(blockId, 0, force)  -- call placeForward

    elseif direction == 4 then  -- +z (up)
        if force then 
            while(not turtle.placeUp()) do
                turtle.digUp()
            end
            return true
        else
            return turtle.placeUp()
        end

    elseif direction == 5 then  -- -z (down)
        if force then 
            while(not turtle.placeDown()) do
                turtle.digDown()
            end
            return true
        else
            return turtle.placeDown()
        end

    else  -- bad direction
        io.write("Invalid direction to place! Must be in [0, 5].\n")
        return false
    end
end

-- attempts to place blocks in a layer 
function placement.layer(xstop, ystop, turn, blockId, force)

    local y = 0
    local x = 0

    while(y < ystop) do

        x = 1
        while(x < xstop) do

            placement.place(blockId, 5, force)  -- place down
            movement.move({x=1, y=0, z=0}, 0, force)  -- move forward

            -- next row
            x = x + 1
        end

        -- turn, place, forward, turn
        movement.move({x=0, y=0, z=0}, turn, force)
        placement.place(blockId, 5, force)
        movement.move({x=1, y=0, z=0}, 0, force)
        movement.move({x=0, y=0, z=0}, turn, force)

        -- next col
        y = y + 1

        -- need to turn the opposite direction next time
        turn  = -turn
    end
end

return placement
