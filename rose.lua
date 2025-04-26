rose = {
  TCOLOR = 6,
  SIZE = 8,
}

function rose:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function rose:update()
end

function rose:draw()
  palt()
  palt(0,false)
  palt(self.TCOLOR,true)
  spr(8,self.pos.x,self.pos.y)
end
