hero = {
  WALKSPEED = 2,
  SIZE = 8,
  DROWN_DURATION=40,
}

function hero:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  o.initial_pos = {x=o.pos.x, y=o.pos.y}
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
  o.drown_counter = 0
  o.state = "player_control"
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

  o.vine_catch_anim = anim:new{
    t = 0,
    trans_color = 6,
    frame = 1,
    frame_length = 3,
    frames = {21,53},
    w = 1,
    h = 1,
    loop = true,
  }
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

function hero:colcirc()
  return {
    x = self.pos.x + self.SIZE / 2,
    y = self.pos.y + self.SIZE / 2,
    r = self.SIZE / 2,
  }
end

function hero:update(shroom_grid, vines, env)
  if self.state == "player_control" then
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

    if self:pressed(4) and not self.blade then
      sfx(1)
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

    if self.blade then
      local colcirc = {
        x = self.pos.x + 4 + (self.facing > 0 and 4 or -4),
        y = self.pos.y + 4,
        r = 8,
      }

      -- shrooms collision
      for id,shroom in pairs(shroom_grid.grid) do
        local enemy_col = shroom:colcirc()
        if enemy_col then
          local col = collision.circcirc(colcirc, enemy_col)
          if col then
            shroom:collide(col)
          end
        end
      end

      -- vines collision
      for i=1,#vines do 
        local body_col, head_col = vines[i]:colcirc()
        if body_col then
          local col = collision.circcirc(colcirc, body_col)
          if col then
            vines[i]:collide(col)
          end
        end

        if head_col then
          local col = collision.circcirc(colcirc, head_col)
          if col then
            vines[i]:collide(col)
          end
        end


      end

    end


    -- did you fall in the river ? 
    if env:in_river(self.pos.x, self.pos.y, 0) then
      self.state = "drowning"
      sfx(3)
    end


  elseif self.state == "caught_by_vine" then
    -- State when not in control
    self.vine_catch_anim:update()

  elseif self.state == "drowning" then
    self.vine_catch_anim:update()

    self.drown_counter += 1
    if self.drown_counter > self.DROWN_DURATION then
      self.drown_counter = 0
      self.pos = {x=self.initial_pos.x, y=self.initial_pos.y}
      self.state = "player_control"
    end
  end

end

function hero:vine_catch()
  -- TODO: Maybe need to prevent re-catch?
  self.state = "caught_by_vine"
end

function hero:vine_release()
  self.state = "player_control"
end

function hero:draw()

  if self.state == "player_control" then
    if self.vel.x == 0 and self.vel.y == 0 then
      self.idle_anim:draw(self.pos.x, self.pos.y, self.facing < 0)
    else
      self.moving_anim:draw(self.pos.x, self.pos.y, self.facing < 0)
    end
    if self.blade then
      self.blade:draw(self.pos.x + (self.facing < 0 and -8 or 8), self.pos.y, self.facing < 0)
    end
  elseif self.state == "caught_by_vine" then
    self.vine_catch_anim:draw(self.pos.x, self.pos.y, self.facing < 0)
  elseif self.state == "drowning" then
    -- dont ask me why.
    spr_r(14, self.pos.x, self.pos.y, self.drown_counter*10, 1,1)
  end
end




function spr_r(s,x,y,a,w,h)
  sw=(w or 1)*8
  sh=(h or 1)*8
  sx=(s%8)*8
  sy=flr(s/8)*8
  x0=flr(0.5*sw)
  y0=flr(0.5*sh)
  a=a/360
  sa=sin(a)
  ca=cos(a)
  for ix=0,sw-1 do
   for iy=0,sh-1 do
    dx=ix-x0
    dy=iy-y0
    xx=flr(dx*ca-dy*sa+x0)
    yy=flr(dx*sa+dy*ca+y0)
    if (xx>=0 and xx<sw and yy>=0 and yy<=sh) then
      if sget(sx+xx,sy+yy) != 6 then 
        pset(x+ix,y+iy,sget(sx+xx,sy+yy))
      end
    end
   end
  end
 end
 