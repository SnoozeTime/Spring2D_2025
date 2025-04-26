hero = {
  WALKSPEED = 2,
  SIZE = 8,
}

function hero:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  o.btn = btn()
  o.lastbtn = o.btn
  o.vel = {x = 0, y = 0}
  o.facing = 1
  o.moving_anim = anim:new{
    t = 0,
    trans_color = 6,
    frame = flr(rnd(4)) + 1,
    frame_length = 3,
    frames = {23,24,33,34},
    w = 1,
    h = 1,
    loop = true,
  }
  o.idle_anim = anim:new{
    t = 0,
    trans_color = 6,
    frame = 1,
    frame_length = 3,
    frames = {21,22},
    w = 1,
    h = 1,
    loop = true,
  }
  o.blade = nil
  return o
end

function hero:pressed(btni)
  local btnmask = 1 << btni
  return (not (self.lastbtn & btnmask == btnmask)) and (self.btn & btnmask == btnmask)
end

function hero:held(btni)
  local btnmask = 1 << btni
  return self.btn & btnmask == btnmask
end

function hero:update()
  self.moving_anim:update()
  self.idle_anim:update()

  self.lastbtn = self.btn
  self.btn = btn()

  local lr = 0
  if self:held(0) then
    lr -= 1
  end
  if self:held(1) then
    lr += 1
  end
  local ud = 0
  if self:held(2) then
    ud -= 1
  elseif self:held(3) then
    ud += 1
  end

  if lr != 0 then
    self.facing = lr
  end

  local walkspeed = self.WALKSPEED
  if lr != 0 and ud != 0 then
    walkspeed /= sqrt(2)
  end
  self.vel.x = lr * walkspeed
  self.vel.y = ud * walkspeed

  self.pos.x += self.vel.x
  if self.pos.x < 0 then
    self.pos.x = 0
  elseif self.pos.x + self.SIZE >= self.bounds.w then
    self.pos.x = self.bounds.w - self.SIZE - 1
  end

  self.pos.y += self.vel.y
  if self.pos.y < 0 then
    self.pos.y = 0
  elseif self.pos.y + self.SIZE >= self.bounds.h then
    self.pos.y = self.bounds.h - self.SIZE - 1
  end

  if self.blade then
    self.blade:update()
    if self.blade:done() then
      self.blade = nil
    end
  end

  if self:pressed(4) then
    self.blade = anim:new{
      t = 0,
      trans_color = 6,
      frame = 1,
      frame_length = 0,
      frames = {35,36,37,38},
      w = 1,
      h = 1,
      loop = false,
    }
  end
end

function hero:draw()
  if self.vel.x == 0 and self.vel.y == 0 then
    self.idle_anim:draw(self.pos.x, self.pos.y, self.facing < 0)
  else
    self.moving_anim:draw(self.pos.x, self.pos.y, self.facing < 0)
  end
  if self.blade then
    self.blade:draw(self.pos.x + (self.facing < 0 and -8 or 8), self.pos.y, self.facing < 0)
  end
end
