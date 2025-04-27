
LEVELS = {
  {mushrooms=1, roses=1, start_pos={5,5}, vines=1, river={river_start={0,64},river_end={128,64}, bridge={64,64}}}
}


function level_switch_init()
    _update = level_switch_update
    _draw = level_switch_draw

    music(15)
  end
  
function level_switch_update()
  if (btnp(❎)) then menu_init() end
end

function level_switch_draw()
  cls(0)
  color(7)
  print("Level cleared!", 52, 80)
  print("Press x/o to continue", 26, 104)
end
  