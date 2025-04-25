skel = {}

function skel:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function skel:update()
  self.anim:update()

  self.pos.x += self.vel.x
  if self.pos.x < 0 then
    self.pos.x = -self.pos.x
    self.vel.x = -self.vel.x
  elseif self.pos.x + self.size >= self.bounds.w then
    self.pos.x = self.bounds.w - (self.pos.x + self.size - self.bounds.w) - self.size
    self.vel.x = -self.vel.x
  end

  self.pos.y += self.vel.y
  if self.pos.y < 0 then
    self.pos.y = -self.pos.y
    self.vel.y = -self.vel.y
  elseif self.pos.y + self.size >= self.bounds.h then
    self.pos.y = self.bounds.h - (self.pos.y + self.size - self.bounds.h) - self.size
    self.vel.y = -self.vel.y
  end
end

function skel:draw()
  self.anim:draw(self.pos.x, self.pos.y, self.vel.x < 0)
end

function _init()
  skels = {}
  for i=1,10 do
    add(skels,
      skel:new{
        anim = anim:new{
          t = 0,
          frame = flr(rnd(4)) + 1,
          frame_length = flr(rnd(10)),
          frames = {21,23,25,27},
          w = 2,
          h = 2,
        },
        pos = {x = flr(rnd(120)), y = flr(rnd(120))},
        vel = {x = flr(rnd(6))-3, y = flr(rnd(6))-3},
        size = 16,
        bounds = {w = 128, h = 128},
      })
  end
end

function _draw()
  rectfill(0,0,127,127,0)
  map()
  for i=1,#skels do
    skels[i]:draw()
  end
end

function _update()
  for i=1,#skels do
    skels[i]:update()
  end
end
