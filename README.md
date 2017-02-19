computercraft scripts

# Movement
### move(move, turn, force)
- inputs
 1. move: {x=int, y=int, z=int}: relative coords, only 1 or -1 for one direction at a time
 2. turn: int: 1 or -1 for +z/left or -z/right
 3. force: bool: whether to force the move by digging
- post
 1. position is updated
 2. turtle is refueled if necessary
 3. blocks preventing movement are removed if force is true

# Inventory
### refreshState()
- post
 1. slotToId is valid

# Mining
### mineTunnel(xStop)
- inputs
 1. xStop: int: number of blocks to mine forward
### mineLayer(xStop, yStop, turn, stride)
- inputs
 1. xStop: int: number of blocks to mine forward
 2. yStop: int: number of blocks to mine in direction of turn
 3. turn: int: 1 or -1 for first turn to the left or right resp.
 4. stride: int: number of blocks to leave between tunnels
### mine(xstop, ystop, zstop, turn, stride, upDown)
- inputs
 1. xstop: int: number of blocks to mine forward
 2. ystop: int: number of blocks to mine in direction of turn
 3. zstop: int: number of blocks to mine in direction of upDown
 4. turn: int: 1 or -1 for first turn to the left or right resp.
 5. stride: int: number of blocks to leave between tunnels
 6. upDown: int: 1 or -1 for first move up or down resp.

# Placement
### place(blockId, direction, force) -> success
- inputs
 1. blockId: int: block to place
 2. direction: int: [0, 5] -> [+x, -z]
 3. force: bool: whether to mine any blocks in the way
- outputs
 1. success: bool: whether the placement was successful (true or infinte loop if force is true)
### layer(xstop, ystop, turn, blockId, force)
- inputs
 1. xstop: int: number of blocks to place forward
 2. ystop: int: number of blocks to place in direction of turn
 3. turn: int: 1 or -1 for first turn left or right resp.
 4. blockId: int: block id to place
 5. force: bool: whether to mine any blocks in the way