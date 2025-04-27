
function _init()
  menu_init()
end


function game_init(level_desc)

  printh(LEVELS)

  -- set the new callbacks
  _update = game_update
  _draw = game_draw

  music(0)

  shroom_grid = grid:new{
           -- 120 so we don't place shrooms just outside the bottom of the map
           bounds = {w = 120, h = 120},
           divisions = 10,
         }

  -- rivers etc
  env = river:new{}

  ninja = hero:new{
           pos = {x = level_desc.start_pos[1], y = level_desc.start_pos[2]},
           bounds = {w = 128, h = 128},
         }
  for i=1,level_desc.mushrooms do
    while true do  -- please don't take too long lmao
      local pos = {x = flr(rnd(120)), y = flr(rnd(120))}
      if shroom_grid:empty(pos) then
        shroom_grid:insert(pos, shroom:new{
          pos = pos,
        })
        break
      end
    end
  end

  spores = {}

  roses = {}
  for i=1,level_desc.roses do
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
  env:draw()
  for i=1,#roses do
    roses[i]:draw()
  end
  for _,shroom in pairs(shroom_grid.grid) do
    shroom:draw()
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
  env:update()
  ninja:update(shroom_grid, vines)
  local dead_vines = {}
  for id,shroom in pairs(shroom_grid.grid) do
    local message = shroom:update(roses)
    if message then
      if message.id == shroom.REMOVE then
        shroom_grid.grid[id] = nil
      elseif message.id == shroom.NEW_SPORE then
        if shroom_grid:empty(message.spore.target) then
          add(spores, message.spore)
        end
      end
    end
  end
  local dead_spores = {}
  for i=1,#spores do
    local new_shroom = spores[i]:update()
    if new_shroom then
      if shroom_grid:empty(new_shroom.pos) then
        shroom_grid:insert(new_shroom.pos, new_shroom)
      end
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
  if next(shroom_grid.grid) == nil and #spores <= 0 and #vines <= 0 then
    level_switch_init()
  end

  -- Update the vines
  --------------------
  for i=1,#vines do
    local message = vines[i]:update(ninja, env)
    if message then
      if message.id == vine.REMOVE then
        add(dead_vines, i)
      end
    end
  end

  -- clean up dead vines
  for i=#dead_vines,1,-1 do
    deli(vines,dead_vines[i])
  end
end
