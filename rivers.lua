
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


function river:in_river(x, y, river_margin)

    local colliding = false

    for i=1,#self.sprites do


        local v = {x = x - self.sprites[i].pos.x, y = y - self.sprites[i].pos.y}
        local distance = sqrt(v.x* v.x + v.y * v.y)
        if distance < 6+river_margin then
            colliding = true
            break
        end

    end

    -- exception for the bridge.
    for i=1,#self.bridges do
        local v = {x = x - self.bridges[i].pos.x, y = y - self.bridges[i].pos.y}
        local distance = sqrt(v.x* v.x + v.y * v.y)
        if distance < 8 then
            colliding = false
            break
        end
    end 

    return colliding
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
