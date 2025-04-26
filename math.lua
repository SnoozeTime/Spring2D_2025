math = {}

function math.normalize(vec)
  local len = sqrt(vec.x*vec.x + vec.y*vec.y)
  if len == 0 then
    return nil, 0
  end
  return {x = vec.x/len, y = vec.y/len}, len
end

