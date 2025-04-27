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
    frames = {64,66,68},
    w = 2,
    h = 2,
    loop = true,
  }


  return o
end

function rose:center()
  return {
    x = self.pos.x + self.anim.w * 8 / 2,
    y = self.pos.y + self.anim.h * 8 / 2,
  }
end

function rose:base()
  return {
    x = self.pos.x + self.anim.w * 8 / 2,
    y = self.pos.y + self.anim.h * 8,
  }
end

function rose:wither()
  if not self.withering then
    sfx(4)
    self.withering = true
    self.anim = anim:new{
      t = 0,
      trans_color = 5,
      frame = 1,
      frame_length = 10,
      frames = {70, 72, 74},
      w = 2,
      h = 2,
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
