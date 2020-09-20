function love.load()
	love.math.setRandomSeed(os.time())
  require("Intro/intro")
  require("map")
  require("player")
  introInitialise("Games")
  mapInitialise()
  playerInitialise()
  operatingSystem = love.system.getOS()

  gameColour = {}
  gameColour.foreground = {203, 100, 34}
  gameColour.background = {203, 100, 17}
  fr, fg, fb, fa = HSL(gameColour.foreground[1]/360, gameColour.foreground[2]/100, gameColour.foreground[3]/100, 1)
  br, bg, bb, ba = HSL(gameColour.background[1]/360, gameColour.background[2]/100, gameColour.background[3]/100, 1)
  love.graphics.setBackgroundColour(br, bg, bb)

  screen = {}
  screen.x = 0
  screen.y = 6000
  screen.font = love.graphics.newFont("Public_Sans/static/PublicSans-Black.ttf", 20)
  screen.megaFont = love.graphics.newFont("Public_Sans/static/PublicSans-Black.ttf", 40)
  screen.shakeX = 0
  screen.shakeY = 0
  screen.shake = 0
  screen.shakeYV = 0
  screen.state = 1
  screen.overlayAlpha = 0
  screen.msgTime = love.timer.getTime()
  screen.alertAlpha = 1
  if operatingSystem == "OS X" then 
    screen.message = "WASD/Arrow keys to move\n\n[R] to reset player\n[ESC] to quit\n[CTRL+CMD+F] to go fullscreen\n\n[?] to close"
  elseif operatingSystem == "Windows" then 
    screen.message = "WASD/Arrow keys to move\n\n[R] to reset player\n[ESC] to quit\n[F11] to go fullscreen\n\n[?] to close"
  else
    screen.message = "WASD/Arrow keys to move\n\n[R] to reset player\n[ESC] to quit\n\n[?] to close"
  end
end

function love.update(dt)
  introUpdate(dt)

  screen.shakeX = love.math.random(-screen.shake, screen.shake)
  screen.shakeY = love.math.random(-screen.shake, screen.shake)
  screen.shake = screen.shake + (0-screen.shake)*0.3
	screen.x = screen.x + (-player.x+love.graphics.getWidth()/2-screen.x)*0.3
 
  if screen.x > 0 then 
  	screen.x = 0--screen.x/5
  end
  if screen.x < -7900 then 
    screen.x = -7900--screen.x/5
  end

  if intro.timer >  1 then
    screen.y = screen.y + (love.graphics.getHeight()/2-300-screen.y)*0.1
  end
  if intro.timer >  1.5 then
    playerUpdate()
    --particleUpdate()
  end

  map.alpha = 1
  if love.keyboard.isDown("p") then
  	if love.keyboard.isDown("q") then 
  		map.alpha = 0.5
  	end
  	if love.keyboard.isDown("l") then 
  		player.checkpoint = 5
  		playerDie()
      player.deaths = player.deaths - 1 
  		screen.state = 1
  	end
  end

  if player.x > 52 then 
  	screen.alertAlpha = screen.alertAlpha + (0-screen.alertAlpha)*0.2
  end

  if player.checkpoint == 5 then 
    screen.state = 5
  end

  gameColour.foreground[1] = gameColour.foreground[1] + (map.checkpoints[player.checkpoint][3][1] - gameColour.foreground[1])*0.1
  gameColour.foreground[2] = gameColour.foreground[2] + (map.checkpoints[player.checkpoint][3][2] - gameColour.foreground[2])*0.1
  gameColour.foreground[3] = gameColour.foreground[3] + (map.checkpoints[player.checkpoint][3][3] - gameColour.foreground[3])*0.1
  gameColour.background[1] = gameColour.background[1] + (map.checkpoints[player.checkpoint][4][1] - gameColour.background[1])*0.1
  gameColour.background[2] = gameColour.background[2] + (map.checkpoints[player.checkpoint][4][2] - gameColour.background[2])*0.1
  gameColour.background[3] = gameColour.background[3] + (map.checkpoints[player.checkpoint][4][3] - gameColour.background[3])*0.1

  fr, fg, fb, fa = HSL(gameColour.foreground[1]/360, gameColour.foreground[2]/100, gameColour.foreground[3]/100, 1)
  br, bg, bb, ba = HSL(gameColour.background[1]/360, gameColour.background[2]/100, gameColour.background[3]/100, 1)
  love.graphics.setBackgroundColour(br, bg, bb)

  if screen.state == 1 then 
  	screen.overlayAlpha = screen.overlayAlpha + (0-screen.overlayAlpha)*0.2
  elseif screen.state == 3 then
  	screen.overlayAlpha = screen.overlayAlpha + (0.5-screen.overlayAlpha)*0.2
  else
  	screen.overlayAlpha = screen.overlayAlpha + (0.5-screen.overlayAlpha)*0.2
  end
  if love.keyboard.isDown("escape") then
    if love.window.isMaximized() or love.window.getFullscreen then
    	screen.state = 0
    end
  end
  if screen.state == 0 and screen.overlayAlpha > 0.499 then 
  	love.event.quit()
  end
  -- if love.keyboard.isDown("f") and love.keyboard.isDown("lgui") and love.keyboard.isDown("lctrl") and operatingSystem == "OS X" then
  --   	love.window.setFullscreen(true)
  -- end
  -- if love.keyboard.isDown("f11") and operatingSystem == "Windows" then
  --     love.window.setFullscreen(true)
  -- end
  if love.keyboard.isDown("/") and screen.msgTime - love.timer.getTime() < -0.3 then
    	if screen.state == 1 then
    		screen.state = 3
    	elseif screen.state == 3 then 
    		screen.state = 1
    	end
    	screen.msgTime = love.timer.getTime()
  end
end

function love.draw()
	mapDraw() --includes playerDraw() within
	
	love.graphics.setColour(fr, fg, fb, map.alpha)
	love.graphics.print("Quick and Simple Platformer", 40, screen.y + screen.shakeY + 20 - (love.graphics.getHeight()-600)/2)

	love.graphics.setFont(screen.megaFont)
	love.graphics.setColour(1, 221/255, 0, map.alpha)	
	love.graphics.print(player.coins.."/"..#map.coins.." coins", love.graphics.getWidth()-130, screen.y + screen.shakeY + 20 - (love.graphics.getHeight()-600)/2, nil, 0.5, 0.5 + player.balloon*0.03)
	love.graphics.setFont(screen.font)

	love.graphics.setColour(br, bg, bb, screen.alertAlpha)
	love.graphics.print("Press [?] to view all controls", 40, screen.y + screen.shakeY + 520 )-- (love.graphics.getHeight()-600)/2)
	
	love.graphics.setColour(0, 0, 0, screen.overlayAlpha)
	love.graphics.rectangle("fill", fuckBoolean(screen.state == 3)*love.graphics.getWidth()/2-screen.font:getWidth(screen.message)/2-50, 0, love.graphics.getWidth() - (fuckBoolean(screen.state == 3)*love.graphics.getWidth()/2-screen.font:getWidth(screen.message)/2-50)*2, love.graphics.getHeight())
	
	if screen.state == 2 then
		love.graphics.setColour(0.9, 0.9, 0.9, screen.overlayAlpha*2)
		love.graphics.print("Press ", love.graphics.getWidth()/2-screen.font:getWidth("Press [R] to reset")/2, screen.y + screen.shakeY + 200 - (love.graphics.getHeight()-600)/2)
		love.graphics.setColour(188/255, 82/255, 47/255, screen.overlayAlpha*2)
		love.graphics.print("[R]", love.graphics.getWidth()/2-screen.font:getWidth("Press [R] to reset")/2 + screen.font:getWidth("Press "), screen.y + screen.shakeY + 200 - (love.graphics.getHeight()-600)/2)
		love.graphics.setColour(0.9, 0.9, 0.9, screen.overlayAlpha*2)
		love.graphics.print(" to reset", love.graphics.getWidth()/2-screen.font:getWidth("Press [R] to reset")/2 + screen.font:getWidth("Press [R]"), screen.y + screen.shakeY + 200 - (love.graphics.getHeight()-600)/2)
	end

	if screen.state == 0 then 
		love.graphics.setColour(0.9, 0.9, 0.9, screen.overlayAlpha*2)
		love.graphics.print("quiting...", love.graphics.getWidth()/2-screen.font:getWidth("quiting...")/2, screen.y + screen.shakeY + 200 - (love.graphics.getHeight()-600)/2)
	end

  if screen.state == 5 then 
    love.graphics.setColour(0.9, 0.9, 0.9, screen.overlayAlpha*2)
    endScreen = "Well done! You completed my game!\n\nYou collected "..player.coins.." coins.\nYou took "..math.floor(intro.timer-1.5) .." seconds.\nYou died "..player.deaths.." times.\n\nI hope you enjoyed playing!"
    love.graphics.print(endScreen, love.graphics.getWidth()/2-screen.font:getWidth(endScreen)/2, screen.y + screen.shakeY + 100 - (love.graphics.getHeight()-600)/2)
  end

	if screen.state == 3 then 
		love.graphics.setColour(0.9, 0.9, 0.9, screen.overlayAlpha*5)
		love.graphics.print(screen.message, love.graphics.getWidth()/2-screen.font:getWidth(screen.message)/2, screen.y + screen.shakeY + 200 - (love.graphics.getHeight()-600)/2)
  end
  
  introDraw()
end

-- function file()
--   if love.filesystem.getInfo("bestCoins.txt") == nil then
--     love.filesystem.write("bestCoins.txt",player.coins)
--   end
--   bestCoins = love.filesystem.read("bestCoins.txt")
--   thonky = tonumber(bestCoins)
--   if thonky < player.coins then
--     love.filesystem.write("bestCoins.txt",player.coins)
--     highScore = player.coins
--   end

--   if love.filesystem.getInfo("bestTime.txt") == nil then
--     love.filesystem.write("bestTime.txt",intro.timer-1.5)
--   end
--   bestCoins = love.filesystem.read("bestCoins.txt")
--   thonky = tonumber(bestCoins)
--   if thonky < player.coins then
--     love.filesystem.write("bestCoins.txt",player.coins)
--     highScore = player.coins
--   end
-- end