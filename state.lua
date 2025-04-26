-- State for the main menu

function menu_init()
    _update = menu_update
    _draw = menu_draw


    -- let's draw a bunch of mushrooms
    enemies = {}
    for i=1,10 do
        add(enemies, enemy:new{
        pos = {x = flr(rnd(120)), y = flr(rnd(120))},
        anim =  anim:new{
            t = 0,
            trans_color = 6,
            frame = 1,
            frame_length = 3,
            frames = {5,6},
            w = 1,
            h = 1,
            loop = true,
          }
        })
    end
   
end 


function menu_update()
    for i=1,#enemies do
        enemies[i].anim:update()
    end

    if (btnp(❎)) then game_init() end
end


function menu_draw()
    cls(7)
    palt()
    palt(0, false)
    palt(6, true)
    map(32, 0)

    for i=1,#enemies do
        enemies[i].anim:draw(enemies[i].pos.x, enemies[i].pos.y, enemies[i].pos.x > 64, false)
    end


    color(8)
    print("Press x/o to start the game", 10, 104)
end

-- State for the main game
