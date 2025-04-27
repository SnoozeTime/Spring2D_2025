function win_init()
  music(17)
  local state = {
    top_text = bubbletext("you win!", {x=52, y=60}),
    bottom_text = bubbletext("press x/o to restart.", {x=26, y=84}),
  }

  _update = function() win_update(state) end
  _draw = function() win_draw(state) end
end

function win_update(state)
  if (btnp(❎)) then menu_init() end
  state.top_text:update()
  state.bottom_text:update()
end

function win_draw(state)
  cls(0)
  color(7)
  state.top_text:draw()
  state.bottom_text:draw()
end
