-- State for the main menu

function menu_init()
    _update = menu_update
    _draw = menu_draw
end 


function menu_update()
    if (btnp(❎)) game_init()
end


function menu_draw()
    cls()
    print("This is the menu", 1, 1)
end

-- State for the main game
