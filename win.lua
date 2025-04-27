function win_init(alive, total)
  music(17)
  local state = {
    t = 0,
    top_text = bubbletext("you win!", {x=nil, y=60}),
    bottom_text = bubbletext("press x/o to restart.", {x=nil, y=84}),
    flower_score = flower_score:new{alive = alive, total = total, y_pos = 32},
  }

  _update = function() win_update(state) end
  _draw = function() win_draw(state) end
end

function win_update(state)
  if state.t > 15 and (btnp(4) or btnp(5)) then menu_init() end
  state.top_text:update()
  state.bottom_text:update()
  state.flower_score:update()
end

function win_draw(state)
  cls(0)
  color(7)
  state.top_text:draw()
  state.bottom_text:draw()
  state.flower_score:draw()
end
