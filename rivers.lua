
river = {}


function river:new(o)

    printh(pairs(o.river_start))
    -- river goes from one way 
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    o.sprites = {}
    o.bridges = {}

    -- easy start - go from middle of screen- left to right
    for i=o.river_start[1], 124, 8 do

        if i != o.bridge[1] then
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
        else
            add(o.bridges, { pos = {x = i, y = 64}, anim = anim:new{
                t = 0,
                trans_color = 5,
                frame = 1,
                frame_length = 10,
                -- Only one frame.
                frames = {192},
                w = 1,
                h = 1,
                loop = true,
            }})
        end
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

    for i=1,#self.bridges do
        self.bridges[i].anim:update()
    end

end


function river:draw()
    for i=1,#self.sprites do
        self.sprites[i].anim:draw(self.sprites[i].pos.x, self.sprites[i].pos.y)
    end
    for i=1,#self.bridges do
        self.bridges[i].anim:draw(self.bridges[i].pos.x, self.bridges[i].pos.y)
    end
end
