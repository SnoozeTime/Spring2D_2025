function _init()
  r = {
    t = 0,
    pos = {x = 1, y = 50},
    vel = {x = 1, y = 2},
    size = 16,
    bounds = {w = 128, h = 128},
  }
  function r:update()
    self.t += 1
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

  function r:draw()
    spr(21 + 2 * (flr(self.t / 4) % 4), self.pos.x, self.pos.y, 2, 2, r.vel.x < 0)
  end
end

function _draw()
  rectfill(0,0,127,127,0)
  map()
  r:draw()
end

function _update()
  r:update()
end
