
function _init()
  menu_init()
end


function game_init()

  -- set the new callbacks
  _update = game_update
  _draw = game_draw

  music(0)

  ninja = hero:new{
           pos = {x = flr(rnd(120)), y = flr(rnd(120))},
           bounds = {w = 128, h = 128},
         }
  shrooms = {}
  for i=1,1 do
    add(shrooms, shroom:new{
      pos = {x = flr(rnd(120)), y = flr(rnd(120))},
      bounds = {w = 128, h = 128},
    })
  end

  spores = {}

  roses = {}
  for i=1,1 do
    add(roses, rose:new{
      pos = {x = flr(rnd(120-rose.SIZE)), y = flr(rnd(120-rose.SIZE))},
    })
  end

  vines = {}
  for i=1,2 do 
    add(vines, vine:new {
      pos = {x = flr(rnd(120)), y = flr(rnd(120))}}
    )
  end
end

function game_draw()
  rectfill(0,0,127,127,0)
  map()
  for i=1,#roses do
    roses[i]:draw()
  end
  for i=1,#shrooms do
    shrooms[i]:draw()
  end
  for i=1,#spores do
    spores[i]:draw()
  end

  for i=1,#vines do
    vines[i]:draw()
  end
  ninja:draw()
end

function game_update()
  ninja:update(shrooms)
  local dead_shrooms = {}
  for i=1,#shrooms do
    local message = shrooms[i]:update(roses)
    if message then
      if message.id == shroom.REMOVE then
        add(dead_shrooms, i)
      elseif message.id == shroom.NEW_SPORE then
        add(spores, message.spore)
      end
    end
  end
  for i=#dead_shrooms,1,-1 do
    deli(shrooms,dead_shrooms[i])
  end
  local dead_spores = {}
  for i=1,#spores do
    local new_shroom = spores[i]:update()
    if new_shroom then
      add(shrooms, new_shroom)
      add(dead_spores,i)
    end
  end
  for i=#dead_spores,1,-1 do
    deli(spores,dead_spores[i])
  end
  local dead_roses = {}
  for i=1,#roses do
    if not roses[i]:update() then
      add(dead_roses, i)
    end
  end
  for i=#dead_roses,1,-1 do
    deli(roses,dead_roses[i])
  end

  if #roses <= 0 then
    gameover_init()
  end
  if #spores <= 0 and #shrooms <= 0 then
    win_init()
  end

  for i=1,#vines do
    vines[i]:update(ninja)
  end
end
