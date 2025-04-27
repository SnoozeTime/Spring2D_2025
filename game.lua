
function _init()
  menu_init()
end

function game_init(level_index)
  local game = {
    LEVELS = {
      {mushrooms=1, roses=1, start_pos={5,5}, vines=1, river={river_start={0,64},river_end={128,64}, bridge={64,64}}},
      {mushrooms=3, roses=1, start_pos={5,5}, vines=2, river={river_start={0,64},river_end={128,64}, bridge={64,64}}},
    },
  }

  game.level = level_index
  local level_desc = game.LEVELS[level_index]

  -- set the new callbacks
  _update = function() game_update(game) end
  _draw = function() game_draw(game) end

  music(0)

  game.shroom_grid = grid:new{
           -- 120 so we don't place shrooms just outside the bottom of the map
           bounds = {w = 120, h = 120},
           divisions = 10,
         }

  -- rivers etc
  game.env = river:new{river_start=level_desc.river.river_start, river_end=level_desc.river.river_end, bridge=level_desc.river.bridge}

  game.ninja = hero:new{
           pos = {x = level_desc.start_pos[1], y = level_desc.start_pos[2]},
           bounds = {w = 128, h = 128},
         }
  for i=1,level_desc.mushrooms do
    while true do  -- please don't take too long lmao
      local pos = {x = flr(rnd(120)), y = flr(rnd(120))}
      if game.shroom_grid:empty(pos) then
        game.shroom_grid:insert(pos, shroom:new{
          pos = pos,
        })
        break
      end
    end
  end

  game.spores = {}

  game.roses = {}
  for i=1,level_desc.roses do
    add(game.roses, rose:new{
      pos = {x = flr(rnd(120-rose.SIZE)), y = flr(rnd(120-rose.SIZE))},
    })
  end

  game.vines = {}
  for i=1,level_desc.vines do 

    local vine_x = flr(rnd(120))
    local vine_y = flr(rnd(120))

    while game.env:in_river(vine_x, vine_y, vine.SIZE) do
      vine_x = flr(rnd(120))
      vine_y = flr(rnd(120))
    end
    add(game.vines, vine:new {
      pos = {x = vine_x, y = vine_y}}
    )
  end
end

function game_draw(game)
  rectfill(0,0,127,127,0)
  map()
  game.env:draw()
  for i=1,#game.roses do
    game.roses[i]:draw()
  end
  for _,shroom in pairs(game.shroom_grid.grid) do
    shroom:draw()
  end
  for i=1,#game.spores do
    game.spores[i]:draw()
  end

  for i=1,#game.vines do
    game.vines[i]:draw()
  end
  game.ninja:draw()
end

function game_update(game)
  game.env:update()
  game.ninja:update(game.shroom_grid, game.vines, game.env)
  local dead_vines = {}
  for id,shroom in pairs(game.shroom_grid.grid) do
    local message = shroom:update(game.roses)
    if message then
      if message.id == shroom.REMOVE then
        game.shroom_grid.grid[id] = nil
      elseif message.id == shroom.NEW_SPORE then
        if game.shroom_grid:empty(message.spore.target) then
          add(game.spores, message.spore)
        end
      end
    end
  end
  local dead_spores = {}
  for i=1,#game.spores do
    local new_shroom = game.spores[i]:update()
    if new_shroom then
      if game.shroom_grid:empty(new_shroom.pos) then
        for ri=1,#game.roses do
          -- Kill any roses in this square.
          if game.shroom_grid:key(new_shroom.pos) == game.shroom_grid:key(game.roses[ri]:center()) then
            game.roses[ri]:wither()
          end
        end
        game.shroom_grid:insert(new_shroom.pos, new_shroom)
      end
      add(dead_spores,i)
    end
  end
  for i=#dead_spores,1,-1 do
    deli(game.spores,dead_spores[i])
  end
  local dead_roses = {}
  for i=1,#game.roses do
    if not game.roses[i]:update() then
      add(dead_roses, i)
    end
  end
  for i=#dead_roses,1,-1 do
    deli(game.roses,dead_roses[i])
  end

  if #game.roses <= 0 then
    gameover_init()
  end
  if next(game.shroom_grid.grid) == nil and #game.spores <= 0 and #game.vines <= 0 then
    if game.level < #game.LEVELS then
      level_switch_init(game.level + 1)
    else
      win_init()
    end
  end

  -- Update the vines
  --------------------
  for i=1,#game.vines do
    local message = game.vines[i]:update(game.ninja, game.env)
    if message then
      if message.id == vine.REMOVE then
        add(dead_vines, i)
      end
    end
  end

  -- clean up dead vines
  for i=#dead_vines,1,-1 do
    deli(game.vines,dead_vines[i])
  end
end
