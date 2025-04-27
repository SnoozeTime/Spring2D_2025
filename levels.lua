
function level_switch_init(level_index)
  _update = level_switch_update
  _draw = level_switch_draw

  level = level_index

  top_text = bubbletext("level cleared!", {x=42, y=60})
  bottom_text = bubbletext("press x/o to continue.", {x=26, y=84})

  music(15)
end
  
function level_switch_update()
  if (btnp(4) or btnp(5)) then game_init(level) end
  top_text:update()
  bottom_text:update()
end

function level_switch_draw()
  cls(0)
  color(7)
  top_text:draw()
  bottom_text:draw()
end
  
