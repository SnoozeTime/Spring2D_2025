function _init()
  skels = {}
  for i=1,1 do
    add(skels,
      hero:new{
        anim = anim:new{
          t = 0,
          frame = flr(rnd(4)) + 1,
          frame_length = flr(rnd(10)),
          frames = {21,23,25,27},
          w = 2,
          h = 2,
        },
        pos = {x = flr(rnd(120)), y = flr(rnd(120))},
        bounds = {w = 128, h = 128},
      })
  end
end

function _draw()
  rectfill(0,0,127,127,0)
  map()
  for i=1,#skels do
    skels[i]:draw()
  end
end

function _update()
  for i=1,#skels do
    skels[i]:update()
  end
end
