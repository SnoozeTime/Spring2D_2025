collision = {}

function collision.circcirc(a,b)
  -- TODO: div0
  local ray = {x = a.x - b.x, y = a.y - b.y}
  local distance = sqrt(ray.x*ray.x + ray.y*ray.y)
  if distance < a.r + b.r then
    local magnitude = a.r + b.r - distance
    return {x = magnitude * ray.x/distance, y = magnitude * ray.y/distance}
  end
  return nil
end
