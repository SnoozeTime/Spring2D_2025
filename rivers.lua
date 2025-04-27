
river = {}


function river:new(o)

    -- river goes from one way 
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    o.sprites = {}

    -- easy start - go from middle of screen- left to right
    for i=0, 124, 8 do
        add(o.sprites, { pos = {x = i, y = 64}, anim = anim:new{
            t = 0,
            trans_color = 5,
            frame = 1,
            frame_length = 10,
            -- Only one frame.
            frames = {54, 55},
            w = 1,
            h = 1,
            loop = true,
          }})
    end

    return o
end


function river:in_river(x, y, r)
    for i=1,#self.sprites do
        local ray = {x = self.sprites[i].pos.x - x, y = self.sprites[i].pos.y - y}
        local distance = sqrt(ray.x*ray.x + ray.y*ray.y)
        if distance < 8 + r then
            return true
        end
    end

    return false
end



function river:update()
    for i=1,#self.sprites do
        self.sprites[i].anim:update()
    end

end


function river:draw()
    for i=1,#self.sprites do
        self.sprites[i].anim:draw(self.sprites[i].pos.x, self.sprites[i].pos.y)
    end
end
