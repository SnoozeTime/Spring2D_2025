shroom = {
  WALKSPEED = 0.5,
  SIZE = 8,
  DEATH_SPEED = 5,
  DEATH_FRICTION = 0.8,
  SPORE_WAIT_FRAMES = 3*30,
  -- Messages
  REMOVE = 0,
  NEW_SPORE = 1,
}

function shroom:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  o.vel = {x = 0, y = 0}
  o.facing = 1
  o.spore_t = flr(rnd(o.SPORE_WAIT_FRAMES))
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

function shroom:pressed(btni)
  local btnmask = 1 << btni
  return (not (self.lastbtn & btnmask == btnmask)) and (self.btn & btnmask == btnmask)
end

function shroom:held(btni)
  local btnmask = 1 << btni
  return self.btn & btnmask == btnmask
end

function shroom:colcirc()
  if not self.alive then
    return nil
  end

  return {
    x = self.pos.x + self.SIZE / 2,
    y = self.pos.y + self.SIZE / 2,
    r = self.SIZE / 2,
  }
end

function shroom:collide(collision)
  if self.alive then
    self.alive = false
    sfx(0)
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
end

-- return messages {id,...}
function shroom:update(roses)
  self.anim:update()

  if self.alive then
    self.spore_t += 1
    if self.spore_t >= self.SPORE_WAIT_FRAMES then
      self.spore_t = 0
      return {
        id = shroom.NEW_SPORE,
        spore = spore:new{
          start = {x = self.pos.x, y = self.pos.y},
          rose = rnd(roses)
        }
      }
    end
    return nil
  else
    self.vel.x *= self.DEATH_FRICTION
    self.vel.y *= self.DEATH_FRICTION
    self.pos.x += self.vel.x
    self.pos.y += self.vel.y
    return self.anim:done() and { id = shroom.REMOVE } or nil
  end
end

function shroom:draw()
  self.anim:draw(self.pos.x, self.pos.y, self.facing < 0)
end

-- Spores

spore = {
  FLOAT_FRAMES = 4*30,
  SIZE = 3,
  ATTACK_DISTANCE = 16,
}

function spore:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  o.t = 0
  -- figure out where the rose is
  o.pos = {x = o.start.x, y = o.start.y}
  local normal
  local len
  normal, len = math.normalize({x=o.rose.pos.x - o.pos.x, y = o.rose.pos.y - o.pos.y})
  -- If we're close enough, attack directly.
  if len < self.ATTACK_DISTANCE then
    o.target = {x = o.rose.pos.x, y = o.rose.pos.y}
    o.target_acquired = true
  else
    -- Attack as far as we can
    -- TODO: randomize this a bit
    o.target = {
      x = o.pos.x + normal.x * self.ATTACK_DISTANCE,
      y = o.pos.y + normal.y * self.ATTACK_DISTANCE,
    }
    o.target_acquired = false
  end
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
  self.t += 1
  self.anim:update()

  if self.t >= self.FLOAT_FRAMES then
    if self.target_acquired then
      self.rose:wither()
    end
    -- plant shroom
    return shroom:new{
      pos = {x = self.pos.x, y = self.pos.y}
    }
  end

  self.pos.x = self.start.x + (self.target.x - self.start.x) * self.t / self.FLOAT_FRAMES
  self.pos.y = self.start.y + (self.target.y - self.start.y) * self.t / self.FLOAT_FRAMES

  return nil
end

function spore:draw()
  self.anim:draw(self.pos.x, self.pos.y)
end
