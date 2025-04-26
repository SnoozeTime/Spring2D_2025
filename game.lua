function _init()
  hero = hero:new{
           pos = {x = flr(rnd(120)), y = flr(rnd(120))},
           bounds = {w = 128, h = 128},
         }
  enemies = {}
  for i=1,10 do
    add(enemies, enemy:new{
      pos = {x = flr(rnd(120)), y = flr(rnd(120))},
      bounds = {w = 128, h = 128},
    })
  end
  roses = {}
  for i=1,3 do
    add(roses, rose:new{
      pos = {x = flr(rnd(120-rose.SIZE)), y = flr(rnd(120-rose.SIZE))},
    })
  end
end

function _draw()
  rectfill(0,0,127,127,0)
  map()
  for i=1,#roses do
    roses[i]:draw()
  end
  for i=1,#enemies do
    enemies[i]:draw()
  end
  hero:draw()
end

function _update()
  hero:update(enemies)
  local deads = {}
  for i=1,#enemies do
    if not enemies[i]:update(hero) then
      add(deads, i)
    end
  end
  for i=#deads,1,-1 do
    deli(enemies,deads[i])
  end
  for i=1,#roses do
    roses[i]:update()
  end
end
