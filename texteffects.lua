-- Create with this function, then add update() and draw() to the respetive
-- sections.
function bubbletext(text, pos)
  return {
    t=0,
    pos=pos,
    text=text,
    char_ticks=2,
    update=function(self)
      self.t += 1
    end,
    draw=function(self)
      local dx,dy = 0,0
      last_char = flr(self.t/self.char_ticks)
      for i=1,#self.text do 
        if i > last_char then
          break
        end
        text_x = self.pos.x+dx
        text_y = self.pos.y+dy+2*cos((4*i+self.t*2)/80)
        print(self.text[i], text_x, text_y+1, 0)
        print(self.text[i], text_x, text_y-1, 0)
        print(self.text[i], text_x+1, text_y, 0)
        print(self.text[i], text_x-1, text_y, 0)
        print(self.text[i], text_x, text_y, 7)
        if self.text[i] == '\n' then
          dx = 0
          dy += 7
        else
          dx += 4
        end
      end
    end,
  }
end
