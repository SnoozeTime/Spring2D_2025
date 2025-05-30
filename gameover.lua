function gameover_init(alive, total)
  -- HACK: stop the slurping noise
  sfx(2, -2)
  music(20)
  local state = {
    t = 0,
    top_text = bubbletext("game over!", {x=nil, y=80}),
    bottom_text = bubbletext("press x/o to restart", {x=nil, y=104}),
    flower_score = flower_score:new{alive = alive, total = total, y_pos = 32},
  }
  _update = function() gameover_update(state) end
  _draw = function() gameover_draw(state) end
end

function gameover_update(state)
  state.t += 1
  if state.t > 15 and (btnp(4) or btnp(5)) then menu_init() end
  state.top_text:update()
  state.bottom_text:update()
  state.flower_score:update()
end

function gameover_draw(state)
  cls(0)
  color(7)
  state.top_text:draw()
  state.bottom_text:draw()
  state.flower_score:draw()
end
