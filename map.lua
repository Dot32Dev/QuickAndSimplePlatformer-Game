function mapInitialise()
  map = {
  --{"type", x, y, width, height}
    {"ground", 0, 450, 500, 150},--first groind peice
    {"ground", 500, 350, 300, 250},--second ground peice
    {"ground", 0, 250, 300, 100},--floating platform
    {"ground", 0, -500, 20, 1100},--edge bar 
    {"ground", 1200, 350, 300, 250},--after lava land
    {"ground", 1800, 300, 100, 300},--pillar #1
    {"ground", 2200, 250, 100, 350},--pillar #2
    {"ground", 2600, 250, 200, 50},
    {"ground", 3000, 550, 350, 50},
    {"ground", 3350, 450, 50, 150},
    {"ground", 3400, 350, 50, 250},
    {"ground", 3150, 300, 50, 100},--lava sheild
    {"ground", 3150, 250, 100, 50},--block
    {"ground", 3400, 150, 50, 50},
    {"ground", 3650, 150, 100, 450},
    {"ground", 4300, 350, 100, 250},
    {"ground", 4900, 350, 300, 250},
    {"ground", 3900, 300, 50, 50},
    {"ground", 4600, 400, 50, 50},
    {"ground", 5250, 350, 350, 250},
    {"ground", 5950, 350, 150, 50},
    {"ground", 6450, 300, 150, 50},
    {"ground", 6950, 400, 150, 50},
    {"ground", 7400, 350, 150, 50},
    {"ground", 7900, 350, 800, 250},
    {"ground", 8700-20, -500, 1100, 1100},--edge bar 
    {"lava", 3100, 0, 50, 400},--lava pillar
    {"lava", 800, 450, 400, 150},--lava
    {"lava", 1500, 550, 300, 50},
    {"lava", 1900, 550, 300, 50},
    {"lava", 3450, 450, 200, 150},
    {"lava", 3750, 450, 550, 150},
    {"lava", 4400, 450, 500, 150},
    {"lava", 5200, 300, 50, 300},
    {"lava", 5600, 550, 2300, 50},
    {"lava", 2300, 550, 700, 50}
  }
  
  map.coins = {
  --{x, y, radius}
    {100, 200, 8},
    {170, 200, 8},
    {750, 300, 8},
    {1250, 300, 8},
    {1450, 300, 8},
    {1850, 250, 8},
    {3125, 500, 8},
    {2250, 200, 8},
    {2700, 200, 8},
    {3500, 200, 8},
    {4100, 50, 8},
    {4350, 250, 8},
    {5050, 300, 8},
    {5150, 300, 8}
  }
  map.coins.mesh = love.graphics.newMesh({
      {0, 0},       --middle
      {-1, -1},   --top left
      {1, -1},    --top right
      {1, 1},     --bottom right
      {-1, 1},    --bottom left
      {-1, -1}    --top left
    },"fan")

  map.checkpoints = {
  --{x, y, Forground Colour, Background Colour}
  	{50, 420, {203, 100, 34},{203, 100, 17}},
  	{3050,520, {153, 100, 34},{153, 100, 17}},
  	{3700,120, {213, 100, 34},{213, 100, 17}},
  	{4971,320, {290, 100, 34},{290, 100, 17}},
    {8500,320, {153, 100, 34},{153, 100, 17}}
  }
end

function mapDraw()
	love.graphics.setColour(fr, fg, fb, map.alpha)-- This section draws a rectangle from the bottom of the game world to the bottom of the screen
  love.graphics.rectangle("fill", 0, 600 + screen.y + screen.shakeY, love.graphics.getWidth(), love.graphics.getHeight()-love.graphics.getHeight()+300)
  
  for i=1, #map.coins do
	  if map.coins[i][4] == "alive" then
	  	love.graphics.setColour(1, 221/255, 0, 0.02) -- This handles the "glowing" effect that the coins radiate
	  	love.graphics.draw(map.coins.mesh, map.coins[i][1] + screen.x + screen.shakeX, map.coins[i][2] + screen.y + screen.shakeY, love.timer.getTime(), map.coins[i][3]*2)
	  	love.graphics.draw(map.coins.mesh, map.coins[i][1] + screen.x + screen.shakeX, map.coins[i][2] + screen.y + screen.shakeY, love.timer.getTime(), map.coins[i][3]*3)
			love.graphics.draw(map.coins.mesh, map.coins[i][1] + screen.x + screen.shakeX, map.coins[i][2] + screen.y + screen.shakeY, love.timer.getTime(), map.coins[i][3]*1.5)
			love.graphics.setColour(1, 221/255, 0)	-- The actual coin 
			love.graphics.draw(map.coins.mesh, map.coins[i][1] + screen.x + screen.shakeX, map.coins[i][2] + screen.y + screen.shakeY, love.timer.getTime(), map.coins[i][3])
		end
  end

  for i=1, #map.checkpoints do
  	love.graphics.setColour(0.15, 0.15, 0.15) -- The checkpoint pole
  	love.graphics.rectangle("fill", map.checkpoints[i][1] + screen.x + screen.shakeX - 2.5 - 10, map.checkpoints[i][2] + screen.y + screen.shakeY - 25, 5, 55)
  	if i == player.checkpoint then -- Sets the colour for the flag, red/green depending on if you have reached it
  		love.graphics.setColour(58/255, 182/255, 76/255)
  	else
  		love.graphics.setColour(188/255, 82/255, 47/255, map.alpha)
  	end
  	love.graphics.rectangle("fill", map.checkpoints[i][1] + screen.x + screen.shakeX + 2.5 - 10, map.checkpoints[i][2] + screen.y + screen.shakeY - 20, 25, 20)
  end

  --particleDraw() -- The draw call for the particle system
  playerDraw() -- The draw call for the player

  for i=1, #map do
  	if map[i][1] == "ground" then 
  		love.graphics.setColour(fr, fg, fb, map.alpha)
  	elseif map[i][1] == "lava" then -- the lava's "glow" is draw seperately from the main draw loop
  		love.graphics.setColour(188/255, 82/255, 47/255, map.alpha*0.1)
  		love.graphics.rectangle("fill", map[i][2]-8 + screen.x + screen.shakeX, map[i][3]-8 + screen.y + screen.shakeY, map[i][4]+8*2, map[i][5]+8*2, 8)
  		love.graphics.rectangle("fill", map[i][2]-16 + screen.x + screen.shakeX, map[i][3]-16 + screen.y + screen.shakeY, map[i][4]+16*2, map[i][5]+16*2, 16)
  		love.graphics.rectangle("fill", map[i][2]-32 + screen.x + screen.shakeX, map[i][3]-32 + screen.y + screen.shakeY, map[i][4]+32*2, map[i][5]+32*2, 32)
  		love.graphics.setColour(188/255, 82/255, 47/255, map.alpha)
  	else
  		love.graphics.setColour(br, bg, bb, map.alpha) -- Sets colour to the background if an object is unidentified
  	end
    
    love.graphics.rectangle("fill", map[i][2] + screen.x + screen.shakeX, map[i][3] + screen.y + screen.shakeY, map[i][4], map[i][5]) -- Draws object
  end
  
end