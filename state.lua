-- State for the main menu

function menu_init()
    _update = menu_update
    _draw = menu_draw
end 


function menu_update()
    if (btnp(❎)) then game_init() end
end


function menu_draw()
    cls(7)
    color(8)
    print("Press x/o to start the game", 10, 64)
end

-- State for the main game
