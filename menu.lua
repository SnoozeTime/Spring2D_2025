-- State for the main menu

function menu_init()
    music(12)
    local state = {
      t = 0,
      text = bubbletext("press x/o to start the game", {x=10, y=108}),
    }
    -- let's draw a bunch of mushrooms
    state.shrooms = {}
    for i=1,10 do
        add(state.shrooms, {
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
   
    _update = function() menu_update(state) end
    _draw = function() menu_draw(state) end
end 


function menu_update(state)
    for i=1,#state.shrooms do
        state.shrooms[i].anim:update()
    end

    state.t += 1

    state.text:update()

    -- start the first level
    if (btnp(4) or btnp(5)) then game_init(1) end
end


function menu_draw(state)
    cls(7)
    palt()
    palt(0, false)
    palt(6, true)
    map(32, 0)

    for i=1,#state.shrooms do
        state.shrooms[i].anim:draw(state.shrooms[i].pos.x, state.shrooms[i].pos.y, state.shrooms[i].pos.x > 64, false)
    end


    color(0)

    palt(6, true)

    sp = 128
    sx, sy = (sp % 16) * 8, (sp \ 16) * 8
    sspr(sx, sy, 8*5, 8*3, 25, 55 + 5*sin(state.t/100), 8*5*2, 8*3*2)
    --spr(128, 56, 50, 5, 3)
    state.text:draw()
end

-- State for the main game
