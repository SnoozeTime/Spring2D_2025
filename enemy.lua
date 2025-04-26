enemy = {
  WALKSPEED = 0.5,
  SIZE = 8,
  DEATH_SPEED = 5,
  DEATH_FRICTION = 0.8,
}

function enemy:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  o.vel = {x = 0, y = 0}
  o.facing = 1
  o.anim = anim:new{
    t = 0,
    trans_color = 6,
    frame = 1,
    frame_length = 3,
    frames = {5,6},
    w = 1,
    h = 1,
    loop = true,
  }
  o.alive = true
  return o
end

function enemy:pressed(btni)
  local btnmask = 1 << btni
  return (not (self.lastbtn & btnmask == btnmask)) and (self.btn & btnmask == btnmask)
end

function enemy:held(btni)
  local btnmask = 1 << btni
  return self.btn & btnmask == btnmask
end

function normalize(vec)
  local len = sqrt(vec.x*vec.x + vec.y*vec.y)
  if len < 1 then
    return nil
  end
  return {x = vec.x/len, y = vec.y/len}, len
end

function enemy:colcirc()
  if not self.alive then
    return nil
  end

  return {
    x = self.pos.x + self.SIZE / 2,
    y = self.pos.y + self.SIZE / 2,
    r = self.SIZE / 2,
  }
end

function enemy:collide(collision)
  self.alive = false
  self.anim = anim:new{
    t = 0,
    trans_color = 6,
    frame = 1,
    frame_length = 0,
    frames = {5,0,5,0,5,0,5,0,5,0,5,0,5,0,5,0,5,0,5,0,5,0,5,0,5,0,5,0,5,0,5,0},
    w = 1,
    h = 1,
    loop = false,
  }
  self.vel = {x = collision.x*self.DEATH_SPEED, y = collision.y*self.DEATH_SPEED}
end

function enemy:update(hero)
  self.anim:update()

  if self.alive then
    local dp = {x = hero.pos.x - self.pos.x, y = hero.pos.y - self.pos.y}
    local facing_normal, len = normalize(dp)

    if facing_normal then
      self.facing = facing_normal.x

      local walkspeed = self.WALKSPEED
      self.vel.x = facing_normal.x * walkspeed
      self.vel.y = facing_normal.y * walkspeed
    else
      self.vel.x = 0
      self.vel.y = 0
    end

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
    return true
  else
    self.vel.x *= self.DEATH_FRICTION
    self.vel.y *= self.DEATH_FRICTION
    self.pos.x += self.vel.x
    self.pos.y += self.vel.y
    return not self.anim:done()
  end
end

function enemy:draw()
  self.anim:draw(self.pos.x, self.pos.y, self.facing < 0)
end
