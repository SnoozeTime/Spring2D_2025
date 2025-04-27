function gameover_init()
  music(20)
  local state = {
    top_text = bubbletext("game over!", {x=48, y=80}),
    bottom_text = bubbletext("press x/o to restart", {x=26, y=104}),
  }
  _update = function() gameover_update(state) end
  _draw = function() gameover_draw(state) end
end

function gameover_update(state)
  if (btnp(4) or btnp(5)) then menu_init() end
  state.top_text:update()
  state.bottom_text:update()
end

function gameover_draw(state)
  cls(0)
  color(7)
  state.top_text:draw()
  state.bottom_text:draw()
end
