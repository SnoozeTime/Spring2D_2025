-- 
vine = {
    MIN_WALK_FRAME = 30*1,
    MAX_WALK_FRAME = 30 * 5,
    SPEED = 0.4,
    SPAWN_FREQ = 20,
    RELEASE_FREQ = 10,
    MAX_SEGMENTS = 10,
    MIN_SEGMENT = 3,
    SIZE = 8,
    DEATH_FRICTION = 0.8,
    DEATH_SPEED = 5,
}

function vine:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    

    -- normal, len = math.normalize
    -- get a random point on the map and move toward it.
    local normal
    local len
    dir, len = math.normalize({x=flr(rnd(120))- o.pos.x, y=flr(rnd(120))-o.pos.y})
    o.dir = dir
    o.state = "walking"
    o.caught_hero = false
    o.facing = sgn(o.dir.x)
    o.current_walk_frames = flr(rnd(self.MAX_WALK_FRAME-self.MIN_WALK_FRAME))+self.MIN_WALK_FRAME
    o.segments = 0
    o.segment_count =  flr(rnd(self.MAX_SEGMENTS-self.MIN_SEGMENT))+self.MIN_SEGMENT
    o.walk_counter = 0
    o.spawn_counter = 0
    o.release_counter = 0
    o.anim = anim:new{
        t = 0,
        trans_color = 6,
        frame = 1,
        frame_length = 3,
        frames = {39,40},
        w = 1,
        h = 1,
        loop = true,
    }
    o.shooting_anim = anim:new{
        t = 0,
        trans_color = 6,
        frame = 1,
        frame_length = 3,
        frames = {49},
        w = 1,
        h = 1,
        loop = true,
    }
    o.alive = true
    return o
end

function vine:reiinit()

    -- this is for walking state
    local normal
    local len
    dir, len = math.normalize({x=flr(rnd(120))- self.pos.x, y=flr(rnd(120))-self.pos.y})
    self.dir = dir
    self.current_walk_frames = flr(rnd(self.MAX_WALK_FRAME-self.MIN_WALK_FRAME))+self.MIN_WALK_FRAME
    self.walk_counter = 0

    -- this is for shooting state
    self.segments = 0
    self.spawn_counter = 0

    -- release state
    self.release_counter = 0
    self.caught_hero = false
end


function vine:update(hero)
    self.anim:update()

    if self.state == "walking" then 

        if self.walk_counter > self.current_walk_frames then
            self.state = "shooting"
        else

            self.pos.x += self.dir.x*self.SPEED
            self.pos.y += self.dir.y*self.SPEED
        
            -- if there is a risk of going off screen, just change the direction
            if (self.pos.x < self.SIZE and self.dir.x < 0) or (self.pos.x > 120 and self.dir.x > 0) then
                self.dir.x *= -1
            end

            if (self.pos.y < self.SIZE and self.dir.y < 0) or (self.pos.y > 120 and self.dir.y > 0) then
                self.dir.y *= -1
            end
        
        end

        -- not necessary to do every frame but oh well
        self.facing = sgn(self.dir.x)

        self.walk_counter += 1
    elseif self.state == "shooting" then


        -- first check collision with the hero 
        local collided = false
        if self.segments > 0 and hero.state == "player_control" then
            local colcirc = {
                x = self.pos.x + self.segments * self.SIZE * sgn(self.dir.x),
                y = self.pos.y,
                r = self.SIZE,
            }

            local hero_col = hero:colcirc()
            local col = collision.circcirc(colcirc, hero_col)
            if col then
                self.state = "attracting"
                collided = true
                self.caught_hero = true
                hero:vine_catch()
                
                sfx(2)
            end
        end

        -- then add a segment if no collision
        if not collided then
            if self.spawn_counter > self.SPAWN_FREQ then
                self.segments += 1
                self.spawn_counter = 0

                if self.segments > self.segment_count then
                    self.state = "attracting"
                end
            else
                self.spawn_counter += 1
            end
        end
    elseif self.state == "attracting" then


        -- if hero was caught, update its position to the tip of the vine
        if hero.state == "caught_by_vine" and self.caught_hero then
            hero.pos.x = self.pos.x + self.segments * self.SIZE * sgn(self.dir.x)
            hero.pos.y = self.pos.y
        end

        if self.release_counter > self.RELEASE_FREQ then
            self.release_counter = 0
            self.segments -= 1
        else
            self.release_counter += 1
        end

        if self.segments == 0 then
            self.state = "walking"

            if self.caught_hero then
                hero:vine_release()
                sfx(2, -2)
            end

            -- reinitialize the walking state
            self:reiinit()
        end

    elseif self.state == "prepare_to_die" then


        self.pos.x += self.dir.x
        self.pos.y += self.dir.y
        self.dir.x *= self.DEATH_FRICTION
        self.dir.y *= self.DEATH_FRICTION

        -- retract the tongue before dying.
        if self.segments > 0 then
            self.segments -= 1
        else
            self.state = "dead"
        end
    elseif self.state == "dead" then 
        self.pos.x += self.dir.x
        self.pos.y += self.dir.y
        self.dir.x *= self.DEATH_FRICTION
        self.dir.y *= self.DEATH_FRICTION

        
        return self.anim:done() and { id = vine.REMOVE } or nil
    end


    return nil

end

function vine:colcirc()
    -- return body and end of vine collision circles
    if self.state == "prepare_to_die" or self.state == "dead" then
      return nil, nil
    end
  
    return {
      x = self.pos.x + self.SIZE / 2,
      y = self.pos.y + self.SIZE / 2,
      r = self.SIZE / 2,
    }, {
        x = self.pos.x + self.SIZE / 2 + self.segments * self.SIZE * sgn(self.dir.x),
        y = self.pos.y + self.SIZE / 2,
        r = self.SIZE / 2,
      }
end

function vine:collide(collision)

    if self.state != "prepare_to_die" and self.state != "dead" then
        self.state = "prepare_to_die"
        sfx(0)
        self.dir = {x = collision.x*self.DEATH_SPEED, y = collision.y*self.DEATH_SPEED}
        self.anim = anim:new{
            t = 0,
            trans_color = 6,
            frame = 1,
            frame_length = 0,
            frames = {39,0,39,0,39,0,39,0,39,0,39,0,39,0,39,0,39,0,39,0,39,0,39,0,39,0,39,0,39,0,39,0},
            w = 1,
            h = 1,
            loop = false,
          }
    end
end


function vine:draw()
    if self.state == "attracting" or self.state == "shooting" or self.state == "prepare_to_die" then 

        self.shooting_anim:draw(self.pos.x, self.pos.y, self.facing < 0)
        for n=1,self.segments do
            local frame
            if n == self.segments then
                frame = 51
            else
                frame = 50
            end
            palt()
            palt(0, false)
            palt(6, true)
            spr(frame, self.pos.x + n * self.SIZE * sgn(self.dir.x), self.pos.y, 1,1, self.facing < 0, false)
            --self.draw_segment(i)
        end
    else
        self.anim:draw(self.pos.x, self.pos.y, self.facing < 0)
    end

end


function vine:draw_segment(n)

    palt()
    palt(0, false)
    palt(6, true)
    spr(50, self.pos.x + n * self.SIZE * sgn(self.dir.x), self.pos.y, 1,1, self.facing < 0, false)
end
  
