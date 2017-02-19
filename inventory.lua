-- stateful turtle inventory management


inventory = {}


-- CONSTANTS
-- block ids
inventory.BID_ANY = 1
inventory.BID_EMPTY = 0

-- STATE
-- maps slot number to a flag indicating block presence
-- default is first slot fuel (0) then rest of the blocks to place (1)
slotToId = {
    -1, -1, -1, -1,
    -1, -1, -1, -1,
    -1, -1, -1, -1,
    -1, -1, -1, -1
}
selectedSlot = 1  -- 1-indexed lists in lua
fuelSlot = 1


-- PUBLIC
-- refreshes our inventory state
function inventory.refreshState()

    for i=1,16 do

        -- get slot item count
        turtle.select(i)  -- select without updating state (must fix at the end)
        numItems = turtle.getItemCount()

        -- update our inventory state
        if(numItems == 0) then
            slotToId[i] = inventory.BID_EMPTY
        else
            slotToId[i] = inventory.BID_ANY
        end
    end

    -- need to return to the slot we started at before we did the search
    turtle.select(selectedSlot)
end

-- selects the slot while maintaining state
function inventory.select(slot)

    turtle.select(slot)
    selectedSlot = slot
end

-- attempts to find a slot with the blockId in inventory
-- returns the slot number otherwise -1
function inventory.find(blockId)

    -- need to refresh state since we depend on slotToId being correct
    inventory.refreshState()

    for i=1,16 do

        if((slotToId[i] == blockId) and (not (i == fuelSlot))) then
            
            -- get the number of items in this slot
            turtle.select(i)
            numItems = turtle.getItemCount()

            -- if there's actually an item in here then return
            if numItems > 0 then

                turtle.select(selectedSlot)  -- back to old slot
                return i
            end
        end
    end

    turtle.select(selectedSlot)
    return -1
end

return inventory
