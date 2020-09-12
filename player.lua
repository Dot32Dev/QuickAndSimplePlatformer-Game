function playerInitialise()
  player = {}
  player.x = 300
  player.y = 80
  player.xV = 0
  player.yV = 0
  player.size = 20
  player.collision = 0


  player.mesh = love.graphics.newMesh({
      {0, 0},       --middle
      {-1, -1.5},   --top left
      {1, -1.5},    --top right
      {1, 1.5},     --bottom right
      {-1, 1.5},    --bottom left
      {-1, -1.5}    --top left
    },"fan")
end

function playerUpdate()
  player.xV = player.xV * 0.93
  player.x = player.x + player.xV
  player.yV = player.yV + 1
  player.y = player.y + player.yV

  player.collision = 0
  for i=1, #map do
    if
    (player.y + player.size * 1.5 > map[i][3] and player.y - player.size * 1.5 < map[i][3] + map[i][5])
    and
    (player.x + player.size > map[i][2] and player.x - player.size < map[i][4]+map[i][2])
    then
      player.collision = 1
    	if (player.x - player.xV + player.size > map[i][2] and player.x - player.xV - player.size < map[i][4]+map[i][2]) then
	      player.y = player.y - player.yV
	      player.yV = -player.yV*0.3
	      
	      if player.y < map[i][2] then 
	      	player.collision = 2
	      else
	      	player.collision = -1
	      end
    	end
    	player.y = player.y - 5
    	if (player.y - player.yV + player.size * 1.5 > map[i][3] and player.y - player.yV - player.size * 1.5 < map[i][3] + map[i][5]) then
	      player.x = player.x -player.xV
	      player.xV = -player.xV*0.3
	      if player.collision == 2 then
	      	player.collision = 4
	      end
	      player.collision = 3
	      
    	end
    	player.y = player.y + 5
    end
  end

  if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
    player.xV = player.xV - 1.2
  end
  if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
    player.xV = player.xV + 1.2
  end
  if love.keyboard.isDown("w") or love.keyboard.isDown("up")  then
    if player.collision == 2 or player.collision == 4 then
      player.yV = -15
      screen.shake = 2
    end
  end
  if love.keyboard.isDown("p") then
    --
  end
end

function playerDraw()
  love.graphics.setColor(0.8, 0.8, 0.8)
  love.graphics.draw(player.mesh, player.x + screen.x + screen.shakeX, player.y + screen.y + screen.shakeY, nil--[[player.xV*0.7*math.pi/180]] ,player.size)
  love.graphics.print("\n\n"..player.collision, 20)
end
