
function _init()
  menu_init()
end

function game_init(level_index)
  local state = {
    LEVELS = {
      {mushrooms=1, roses=3, start_pos={5,5}, vines=1, river={river_start={0,64},river_end={128,64}, bridge={64,64}}},
      {mushrooms=3, roses=3, start_pos={5,5}, vines=2, river={river_start={0,64},river_end={128,64}, bridge={64,64}}},
    },
  }

  state.level = level_index
  local level_desc = state.LEVELS[level_index]

  -- set the new callbacks
  _update = function() game_update(state) end
  _draw = function() game_draw(state) end

  music(0)

  state.shroom_grid = grid:new{
           -- 120 so we don't place shrooms just outside the bottom of the map
           bounds = {w = 120, h = 120},
           divisions = 10,
         }

  -- rivers etc
  state.env = river:new{river_start=level_desc.river.river_start, river_end=level_desc.river.river_end, bridge=level_desc.river.bridge}

  state.ninja = hero:new{
           pos = {x = level_desc.start_pos[1], y = level_desc.start_pos[2]},
           bounds = {w = 128, h = 128},
         }

  state.roses = {}
  for i=1,level_desc.roses do
    while true do
      local r = rose:new{
        pos = {x = flr(rnd(120-rose.SIZE)), y = flr(rnd(120-rose.SIZE))},
      }
      if not close_to_roses(state.roses, r.pos) and not state.env:in_river(r:base().x, r:base().y, 8) then
        add(state.roses, r)
        break
      end
    end
  end

  for i=1,level_desc.mushrooms do
    while true do  -- please don't take too long lmao
      local pos = {x = flr(rnd(120)), y = flr(rnd(120))}
      -- Don't overlap roses or other mushrooms
      if not close_to_roses(state.roses, pos) and state.shroom_grid:empty(pos) then
        state.shroom_grid:insert(pos, shroom:new{
          pos = pos,
        })
        break
      end
    end
  end

  state.spores = {}

  state.vines = {}
  for i=1,level_desc.vines do 

    local vine_x = flr(rnd(120))
    local vine_y = flr(rnd(120))

    while state.env:in_river(vine_x, vine_y, vine.SIZE) do
      vine_x = flr(rnd(120))
      vine_y = flr(rnd(120))
    end
    add(state.vines, vine:new {
      pos = {x = vine_x, y = vine_y}}
    )
  end
end

function close_to_roses(roses, pos)
  for i=1,#roses do
    local rc = roses[i]:center()
    local _, len = math.normalize({x = rc.x - pos.x, y = rc.y - pos.y})
    if len < 30 then
      return true
    end
  end
  return false
end

function game_draw(state)
  rectfill(0,0,127,127,0)
  map()
  state.env:draw()
  for i=1,#state.roses do
    state.roses[i]:draw()
  end
  for _,shroom in pairs(state.shroom_grid.grid) do
    shroom:draw()
  end
  for i=1,#state.spores do
    state.spores[i]:draw()
  end

  for i=1,#state.vines do
    state.vines[i]:draw()
  end
  state.ninja:draw()
end

function game_update(state)
  state.env:update()
  state.ninja:update(state.shroom_grid, state.vines, state.env)
  local dead_vines = {}
  for id,shroom in pairs(state.shroom_grid.grid) do
    local message = shroom:update(state.roses)
    if message then
      if message.id == shroom.REMOVE then
        state.shroom_grid.grid[id] = nil
      elseif message.id == shroom.NEW_SPORE then
        if state.shroom_grid:empty(message.spore.target) then
          add(state.spores, message.spore)
        end
      end
    end
  end
  local dead_spores = {}
  for i=1,#state.spores do
    local new_shroom = state.spores[i]:update()
    if new_shroom then
      if state.shroom_grid:empty(new_shroom.pos) then
        for ri=1,#state.roses do
          -- Kill any roses in this square.
          if state.shroom_grid:key(new_shroom.pos) == state.shroom_grid:key(state.roses[ri]:center()) then
            state.roses[ri]:wither()
          end
        end
        state.shroom_grid:insert(new_shroom.pos, new_shroom)
      end
      add(dead_spores,i)
    end
  end
  for i=#dead_spores,1,-1 do
    deli(state.spores,dead_spores[i])
  end
  local dead_roses = {}
  for i=1,#state.roses do
    if not state.roses[i]:update() then
      add(dead_roses, i)
    end
  end
  for i=#dead_roses,1,-1 do
    deli(state.roses,dead_roses[i])
  end

  if #state.roses <= 0 then
    gameover_init()
  end
  if next(state.shroom_grid.grid) == nil and #state.spores <= 0 and #state.vines <= 0 then
    if state.level < #state.LEVELS then
      level_switch_init(state.level + 1)
    else
      win_init()
    end
  end

  -- Update the vines
  --------------------
  for i=1,#state.vines do
    local message = state.vines[i]:update(state.ninja, state.env)
    if message then
      if message.id == vine.REMOVE then
        add(dead_vines, i)
      end
    end
  end

  -- clean up dead vines
  for i=#dead_vines,1,-1 do
    deli(state.vines,dead_vines[i])
  end
end
