-- mimics the computercraft turtle API so you can test offline

testPosition = {x=0, y=0, z=0}

turtle = {
  dig = function (self)
    print "dig forward"
  end,

  digUp = function (self)
    print "dig up"
  end,

  digDown = function (self)
    print "dig down"
  end,

  forward = function (self)
    print("forward")
    return true
  end,

  back = function (self)
    print("back")
    return true
  end,

  up = function (self)
    print("up")
    return true
  end,

  down = function (self)
    print("down")
    return true
  end,

  turnLeft = function (self)
    print("turning left")
  end,

  turnRight = function (self)
    print("turning right")
  end,

  getFuelLevel = function (self)
    print("getting fuel level")
    return 1
  end
}