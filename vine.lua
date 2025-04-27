-- 
vine = {
    MIN_WALK_FRAME = 30*1,
    MAX_WALK_FRAME = 30 * 5,
    walk_counter = 0,
    speed = 0.4,
    spawn_freq = 20,
    spawn_counter = 0,
    release_freq = 10,
    release_counter = 0,
    MAX_SEGMENTS = 10,
    MIN_SEGMENT = 3
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
    o.facing = sgn(o.dir.x)
    o.current_walk_frames = flr(rnd(self.MAX_WALK_FRAME-self.MIN_WALK_FRAME))+self.MIN_WALK_FRAME
    o.segments = 0
    o.segment_count =  flr(rnd(self.MAX_SEGMENTS-self.MIN_SEGMENT))+self.MIN_SEGMENT
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
end


function vine:update(hero)
    self.anim:update()

    if self.state == "walking" then 

        if self.walk_counter > self.current_walk_frames then
            self.state = "shooting"
        else

            self.pos.x += self.dir.x*self.speed
            self.pos.y += self.dir.y*self.speed
        
            -- if there is a risk of going off screen, just change the direction
            if (self.pos.x < 8 and self.dir.x < 0) or (self.pos.x > 120 and self.dir.x > 0) then
                self.dir.x *= -1
            end

            if (self.pos.y < 8 and self.dir.y < 0) or (self.pos.y > 120 and self.dir.y > 0) then
                self.dir.y *= -1
            end
        
        end

        -- not necessary to do every frame but oh well
        self.facing = sgn(self.dir.x)

        self.walk_counter += 1
    elseif self.state == "shooting" then


        -- first check collision with the hero
        local collided = false
        if self.segments > 0 then
            local colcirc = {
                x = self.pos.x + self.segments * 8 * sgn(self.dir.x),
                y = self.pos.y,
                r = 8,
            }

            local hero_col = hero:colcirc()
            local col = collision.circcirc(colcirc, hero_col)
            if col then
                self.state = "attracting"
                collided = true
                hero:vine_catch()
            end
        end
            
        

        -- then add a segment if no collision
        if not collided then
            if self.spawn_counter > self.spawn_freq then
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
        if hero.state == "caught_by_vine" then
            hero.pos.x = self.pos.x + self.segments * 8 * sgn(self.dir.x)
            hero.pos.y = self.pos.y
        end

        if self.release_counter > self.release_freq then
            self.release_counter = 0
            self.segments -= 1
        else
            self.release_counter += 1
        end

        if self.segments == 0 then
            self.state = "walking"
            hero:vine_release()

            -- reinitialize the walking state
            self:reiinit()
        end


    end

end


function vine:draw()
    if self.state == "walking" then 
        self.anim:draw(self.pos.x, self.pos.y, self.facing < 0)
    else
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
            spr(frame, self.pos.x + n * 8 * sgn(self.dir.x), self.pos.y, 1,1, self.facing < 0, false)
            --self.draw_segment(i)
        end
    end
end


function vine:draw_segment(n)

    

    palt()
    palt(0, false)
    palt(6, true)
    spr(50, self.pos.x + n * 8 * sgn(self.dir.x), self.pos.y, 1,1, self.facing < 0, false)
end
  