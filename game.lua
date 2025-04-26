
function _init()
  menu_init()
end


function game_init()

  -- set the new callbacks
  _update = game_update
  _draw = game_draw

  music(0)

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

  spores = {}

  roses = {}
  for i=1,3 do
    add(roses, rose:new{
      pos = {x = flr(rnd(120-rose.SIZE)), y = flr(rnd(120-rose.SIZE))},
    })
  end
end

function game_draw()
  rectfill(0,0,127,127,0)
  map()
  for i=1,#roses do
    roses[i]:draw()
  end
  for i=1,#enemies do
    enemies[i]:draw()
  end
  for i=1,#spores do
    spores[i]:draw()
  end
  hero:draw()
end

function game_update()
  hero:update(enemies)
  local deads = {}
  for i=1,#enemies do
    local message = enemies[i]:update(roses)
    if message then
      if message.id == enemy.REMOVE then
        add(deads, i)
      elseif message.id == enemy.NEW_SPORE then
        add(spores, message.spore)
      end
    end
  end
  for i=#deads,1,-1 do
    deli(enemies,deads[i])
  end
  for i=1,#spores do
    spores[i]:update()
  end
  for i=1,#roses do
    roses[i]:update()
  end
end
