function mapInitialise()
 map = {
   {"ground", 0, 450, 500, 150},
   {"ground", 500, 350, 300, 250},
   {"ground", 0, 250, 300, 100},
   {"ground", -50, -500, 50, 1100},
   {"ground", 1200, 350, 300, 250},
   {"lava", 800, 450, 400, 150}
 }
end

function mapDraw()
  love.graphics.setColor(0/255, 107/255, 173/255, map.alpha)
  love.graphics.rectangle("fill", 0, 600 + screen.y + screen.shakeY, love.graphics.getWidth(), love.graphics.getHeight()-love.graphics.getHeight()+300)

  for i=1, #map do
  	if map[i][1] == "ground" then 
  		love.graphics.setColor(0/255, 107/255, 173/255, map.alpha)
  	elseif map[i][1] == "lava" then 
  		love.graphics.setColor(188/255, 82/255, 47/255, map.alpha)
  	end
    love.graphics.rectangle("fill", map[i][2] + screen.x + screen.shakeX, map[i][3] + screen.y + screen.shakeY, map[i][4], map[i][5])
  end
end

