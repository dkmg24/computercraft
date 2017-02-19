-- testing script

turtle = require "turtle"
placement = require "placement"

io = require "io"


-- redirect io
io.output("testLog.txt")


function test_placement_layer()

    io.write("||test_placement_layer||\n")

    -- fuel
    turtle.inventory[1].bid = 1
    turtle.inventory[1].qty = 64

    -- blocks to place
    turtle.inventory[2].bid = 1
    turtle.inventory[2].qty = 64
    turtle.inventory[3].bid = 1
    turtle.inventory[3].qty = 64

    turtle.printInventory()
    wait = io.read("*line")

    -- build an 8x8 layer, turning left initially, with block id 1, not forcing
    placement.layer(8, 8, 1, 1, false)

    -- verfy the result
    io.write("turtle.world[-1][-1:9][-1:9]:\n")
    for y=-1,9 do
        s = ""
        for x=-1,9 do
            s = s .. turtle.world[-1][y][x]
        end
        io.write(s, "\n")
    end

    io.write(string.format("turtle.fuelLevel: %d", turtle.fuelLevel), "\n")
    turtle.printInventory()

    io.write("^^test_placement_layer^^\n")
end

test_placement_layer()