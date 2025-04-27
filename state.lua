-- State for the main menu

function menu_init()
    _update = menu_update
    _draw = menu_draw


    
    music(12)
    -- let's draw a bunch of mushrooms
    shrooms = {}
    for i=1,10 do
        add(shrooms, shroom:new{
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
    for i=1,#shrooms do
        shrooms[i].anim:update()
    end

    if (btnp(❎)) then game_init(LEVELS[1]) end
end


function menu_draw()
    cls(7)
    palt()
    palt(0, false)
    palt(6, true)
    map(32, 0)

    for i=1,#shrooms do
        shrooms[i].anim:draw(shrooms[i].pos.x, shrooms[i].pos.y, shrooms[i].pos.x > 64, false)
    end


    color(0)

    palt(6, true)

    sp = 128
    sx, sy = (sp % 16) * 8, (sp \ 16) * 8
    sspr(sx, sy, 8*5, 8*3, 25, 60, 8*5*2, 8*3*2)
    --spr(128, 56, 50, 5, 3)
    print("Press x/o to start the game", 10, 104)
end

-- State for the main game
