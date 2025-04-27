math = {}

function math.normalize(vec)
  local len = sqrt(vec.x*vec.x + vec.y*vec.y)
  if len == 0 then
    return nil, 0
  end
  return {x = vec.x/len, y = vec.y/len}, len
end

-- Changes the normal randomly, with a preference to tend towards the original
-- direction.
function math.perturb(normal)
  local r = rnd(2) - 1
  local new_angle = atan2(normal.x, normal.y) + r*r*r/2
  return {x = cos(new_angle), y = sin(new_angle)}
end
