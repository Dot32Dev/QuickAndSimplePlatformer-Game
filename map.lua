function mapInitialise()
 map = {
   {"ground", 0, 450, 800, 150},
   {"ground", 500, 350, 800, 250}
 }
end

function mapDraw()
  love.graphics.setColor(0/255, 107/255, 173/255, map.alpha)
  for i=1, #map do
    love.graphics.rectangle("fill", map[i][2] + screen.x + screen.shakeX, map[i][3] + screen.y + screen.shakeY, map[i][4], map[i][5])
  end
end
