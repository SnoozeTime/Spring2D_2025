math = {}

function math.normalize(vec)
  local len = sqrt(vec.x*vec.x + vec.y*vec.y)
  if len == 0 then
    return nil, 0
  end
  return {x = vec.x/len, y = vec.y/len}, len
end

function math.perturb(normal, variance)
  local new_angle = atan2(normal.x, normal.y) + rnd(variance) - variance/2
  return {x = cos(new_angle), y = sin(new_angle)}
end
