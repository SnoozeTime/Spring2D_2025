enemy = {
  WALKSPEED = 0.5,
  SIZE = 8,
  DEATH_SPEED = 5,
  DEATH_FRICTION = 0.8,
  SPORE_WAIT_FRAMES = 3*30,
  -- Messages
  REMOVE = 0,
  NEW_SPORE = 1,
}

function enemy:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  o.vel = {x = 0, y = 0}
  o.facing = 1
  o.spore_t = 0
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

-- return messages {id,...}
function enemy:update(roses)
  self.anim:update()

  if self.alive then
    self.spore_t += 1
    if self.spore_t >= self.SPORE_WAIT_FRAMES then
      self.spore_t = 0
      return {
        id = enemy.NEW_SPORE,
        spore = spore:new{
          start = {x = self.pos.x, y = self.pos.y},
          rose = roses[flr(rnd(#roses))+1],
        }
      }
    end
    return nil
  else
    self.vel.x *= self.DEATH_FRICTION
    self.vel.y *= self.DEATH_FRICTION
    self.pos.x += self.vel.x
    self.pos.y += self.vel.y
    return self.anim:done() and { id = enemy.REMOVE } or nil
  end
end

function enemy:draw()
  self.anim:draw(self.pos.x, self.pos.y, self.facing < 0)
end

-- Spores

spore = {
  SPEED = 0.1,
  SIZE = 3,
}

function spore:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  o.pos = {x = o.start.x, y = o.start.y}
  o.vel = {x = 0, y = 0}
  o.anim = anim:new{
    t = 0,
    trans_color = 6,
    frame = 1,
    frame_length = 4,
    frames = {1,2},
    w = 1,
    h = 1,
    loop = true,
  }
  o.alive = true
  return o
end

function spore:update()
  self.anim:update()

  local dp = {x = self.rose.pos.x - self.pos.x, y = self.rose.pos.y - self.pos.y}
  local facing_normal, len = math.normalize(dp)

  if facing_normal and len > 0.1 then
    self.facing = facing_normal.x

    local speed = self.SPEED
    self.vel.x = facing_normal.x * speed
    self.vel.y = facing_normal.y * speed
  else
    self.vel.x = 0
    self.vel.y = 0
  end

  self.pos.x += self.vel.x
  self.pos.y += self.vel.y
end

function spore:draw()
  self.anim:draw(self.pos.x, self.pos.y)
end
