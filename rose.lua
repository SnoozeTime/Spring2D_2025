rose = {
  TCOLOR = 6,
  SIZE = 8,
}

function rose:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  self.withering = false
  o.anim = anim:new{
    t = 0,
    trans_color = 5,
    frame = 1,
    frame_length = 10,
    -- Only one frame.
    frames = {64,66,68},
    w = 2,
    h = 2,
    loop = true,
  }
  return o
end

function rose:wither()
  if not self.withering then
    self.withering = true
    self.anim = anim:new{
      t = 0,
      trans_color = 6,
      frame = 1,
      frame_length = 0,
      frames = {8,0,8,0,8,0,8,0,8,0,8,0,8,0,8,0,8,0,8,0,8,0,8,0,8,0,8,0,8,0,8,0},
      w = 1,
      h = 1,
      loop = false,
    }
  end
end

function rose:update()
  self.anim:update()
  return self.anim:done()
end

function rose:draw()
  self.anim:draw(self.pos.x,self.pos.y)
end
