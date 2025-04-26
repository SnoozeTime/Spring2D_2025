
function _init()
  menu_init()
end


function game_init()

  -- set the new callbacks
  _update = game_update
  _draw = game_draw

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


end

function game_draw()
  rectfill(0,0,127,127,0)
  map()
  hero:draw()
  for i=1,#enemies do
    enemies[i]:draw()
  end
end

function game_update()
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
end
