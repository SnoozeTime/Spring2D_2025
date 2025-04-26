function _init()
  hero = hero:new{
           pos = {x = flr(rnd(120)), y = flr(rnd(120))},
           bounds = {w = 128, h = 128},
         }
end

function _draw()
  rectfill(0,0,127,127,0)
  map()
  hero:draw()
end

function _update()
  hero:update()
end
