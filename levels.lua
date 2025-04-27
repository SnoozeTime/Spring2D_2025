
function level_switch_init(level_index, alive, total)
  music(15)

  local state = {
    level = level_index,
    top_text = bubbletext("level cleared!", {x=nil, y=60}),
    bottom_text = bubbletext("press x/o to continue.", {x=nil, y=84}),
    flower_score = flower_score:new{alive = alive, total = total, y_pos = 32},
  }

  _update = function() level_switch_update(state) end
  _draw = function() level_switch_draw(state) end
end
  
function level_switch_update(state)
  if (btnp(4) or btnp(5)) then game_init(state.level) end
  state.top_text:update()
  state.bottom_text:update()
  state.flower_score:update()
end

function level_switch_draw(state)
  cls(0)
  color(7)
  state.top_text:draw()
  state.bottom_text:draw()
  state.flower_score:draw()
end
  
