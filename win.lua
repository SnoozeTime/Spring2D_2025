function win_init()
  _update = win_update
  _draw = win_draw
end

function win_update()
  if (btnp(❎)) then menu_init() end
end

function win_draw()
  cls(0)
  color(7)
  print("you win!", 52, 80)
  print("press x/o to restart", 26, 104)
end
