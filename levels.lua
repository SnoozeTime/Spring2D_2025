
function level_switch_init(level_index, alive, total)
  music(15)

  local state = {
    level = level_index,
    top_text = bubbletext("level cleared!", {x=38, y=60}),
    bottom_text = bubbletext("press x/o to continue.", {x=22, y=84}),
  }

  state.flowers = {}
  -- Total width of flower bar
  local flowers_width = 24 * total - 8
  local flowers_x = 128/2 - flowers_width/2
  for i=1,total do
    local r = rose:new{
      pos = {x = flowers_x, y = 32},
    }
    if total - alive >= i then
      r:wither()
    end
    add(state.flowers, r)
    flowers_x += 24
  end

  _update = function() level_switch_update(state) end
  _draw = function() level_switch_draw(state) end
end
  
function level_switch_update(state)
  if (btnp(4) or btnp(5)) then game_init(state.level) end
  state.top_text:update()
  state.bottom_text:update()
  for flower in all(state.flowers) do
    flower:update()
  end
end

function level_switch_draw(state)
  cls(0)
  color(7)
  state.top_text:draw()
  state.bottom_text:draw()
  for flower in all(state.flowers) do
    flower:draw()
  end
end
  
