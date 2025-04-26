function gameover_init()
  _update = gameover_update
  _draw = gameover_draw
end

function gameover_update()
  if (btnp(❎)) then menu_init() end
end

function gameover_draw()
  cls(0)
  color(7)
  print("game over!", 48, 80)
  print("press x/o to restart", 26, 104)
end
