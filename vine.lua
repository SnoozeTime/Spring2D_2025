-- 
vine = {

}

function vine:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    o.facing = 1
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
    o.alive = true
    return o
end

function vine:update()
    self.anim:update()
end


function vine:draw()
    self.anim:draw(self.pos.x, self.pos.y, self.facing < 0)
end