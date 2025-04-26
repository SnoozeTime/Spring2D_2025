collision = {}

function collision.circcirc(a,b)
  -- TODO: div0
  local ray = {x = b.x - a.x, y = b.y - a.y}
  local distance = sqrt(ray.x*ray.x + ray.y*ray.y)
  if distance < a.r + b.r then
    local magnitude = a.r + b.r - distance
    return normalize(ray)
  end
  return nil
end
