function love.load()
	love.math.setRandomSeed(os.time())
  require("Intro/intro")
  require("map")
  require("player")
  introInitialise("Games")
  mapInitialise()
  playerInitialise()

  gamecolour = 203 --love.math.random(0, 360)
  br, bg, bb, ba = HSL(gamecolour/360, 100/100, 17/100, 1)
  fr, fg, fb, fa = HSL(gamecolour/360, 100/100, 34/100, 1)
  love.graphics.setBackgroundColor(br, bg, bb)	--thanks to Zorg for the function and JÖSH2D for some debugging

  screen = {}
  screen.x = 0
  screen.y = 6000
  screen.font = love.graphics.newFont("Public_Sans/static/PublicSans-Black.ttf", 20)
  screen.megaFont = love.graphics.newFont("Public_Sans/static/PublicSans-Black.ttf", 40)
  screen.shakeX = 0
  screen.shakeY = 0
  screen.shake = 0
  screen.state = 1
  screen.overlayAlpha = 0
  screen.message = "WASD/Arrow keys to move\n\n[R] to reset player\n[ESC] to quit\n[CMD+F] to go fullscreen on Macos\n\n[?] to close"
  screen.msgTime = love.timer.getTime()
  screen.alertAlpha = 1
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

  if intro.timer >  1 then
    screen.y = screen.y + (love.graphics.getHeight()/2-300-screen.y)*0.1
  end
  if intro.timer >  1.5 then
    playerUpdate()
  end

  map.alpha = 1
  if love.keyboard.isDown("p") then
  	if love.keyboard.isDown("q") then 
  		map.alpha = 0.5
  	end
  	if love.keyboard.isDown("l") then 
  		map.alpha = 0.5
  	end
  end

  if player.x > 52 then 
  	screen.alertAlpha = screen.alertAlpha + (0-screen.alertAlpha)*0.2
  end

  if player.x > 2980 and gamecolour > 155 then 
  	gamecolour = gamecolour + (154-gamecolour)*0.1
  	br, bg, bb, ba = HSL(gamecolour/360, 100/100, 17/100, 1)
  	fr, fg, fb, fa = HSL(gamecolour/360, 100/100, 34/100, 1)
  	love.graphics.setBackgroundColor(br, bg, bb)
  end

  if player.x < 2980 and gamecolour < 204 then 
  	gamecolour = gamecolour + (203-gamecolour)*0.5
  	br, bg, bb, ba = HSL(gamecolour/360, 100/100, 17/100, 1)
  	fr, fg, fb, fa = HSL(gamecolour/360, 100/100, 34/100, 1)
  	love.graphics.setBackgroundColor(br, bg, bb)
  end

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
  if love.keyboard.isDown("f") and love.keyboard.isDown("lgui") then
    	love.window.setFullscreen(true)
  end
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
	
	love.graphics.setColor(fr, fg, fb, map.alpha)
	love.graphics.print("Quick and Simple Platformer", 40, screen.y + screen.shakeY + 20 - (love.graphics.getHeight()-600)/2)

	love.graphics.setFont(screen.megaFont)
	love.graphics.setColor(1, 221/255, 0, map.alpha)	
	love.graphics.print(player.coins.."/"..#map.coins.." coins", love.graphics.getWidth()-130, screen.y + screen.shakeY + 20 - (love.graphics.getHeight()-600)/2, nil, 0.5, 0.5 + player.balloon*0.03)
	love.graphics.setFont(screen.font)

	love.graphics.setColor(br, bg, bb, screen.alertAlpha)
	love.graphics.print("Press [Q] to view all controls", 40, screen.y + screen.shakeY + 520 )-- (love.graphics.getHeight()-600)/2)
	
	love.graphics.setColor(0, 0, 0, screen.overlayAlpha)
	love.graphics.rectangle("fill", fuckBoolean(screen.state == 3)*love.graphics.getWidth()/2-screen.font:getWidth(screen.message)/2-50, 0, love.graphics.getWidth() - (fuckBoolean(screen.state == 3)*love.graphics.getWidth()/2-screen.font:getWidth(screen.message)/2-50)*2, love.graphics.getHeight())
	
	if screen.state == 2 then
		love.graphics.setColor(0.9, 0.9, 0.9, screen.overlayAlpha*2)
		love.graphics.print("Press ", love.graphics.getWidth()/2-screen.font:getWidth("Press [R] to reset")/2, screen.y + screen.shakeY + 200 - (love.graphics.getHeight()-600)/2)
		love.graphics.setColor(188/255, 82/255, 47/255, screen.overlayAlpha*2)
		love.graphics.print("[R]", love.graphics.getWidth()/2-screen.font:getWidth("Press [R] to reset")/2 + screen.font:getWidth("Press "), screen.y + screen.shakeY + 200 - (love.graphics.getHeight()-600)/2)
		love.graphics.setColor(0.9, 0.9, 0.9, screen.overlayAlpha*2)
		love.graphics.print(" to reset", love.graphics.getWidth()/2-screen.font:getWidth("Press [R] to reset")/2 + screen.font:getWidth("Press [R]"), screen.y + screen.shakeY + 200 - (love.graphics.getHeight()-600)/2)
	end

	if screen.state == 0 then 
		love.graphics.setColor(0.9, 0.9, 0.9, screen.overlayAlpha*2)
		love.graphics.print("quiting...", love.graphics.getWidth()/2-screen.font:getWidth("quiting...")/2, screen.y + screen.shakeY + 200 - (love.graphics.getHeight()-600)/2)
	end

	if screen.state == 3 then 
		love.graphics.setColor(0.9, 0.9, 0.9, screen.overlayAlpha*5)
		love.graphics.print(screen.message, love.graphics.getWidth()/2-screen.font:getWidth(screen.message)/2, screen.y + screen.shakeY + 200 - (love.graphics.getHeight()-600)/2)
  end
  
  introDraw()
end

function HSL(h, s, l, a)
  if s<=0 then return l,l,l,a end
  h, s, l = h*6, s, l
  local c = (1-math.abs(2*l-1))*s
  local x = (1-math.abs(h%2-1))*c
  local m,r,g,b = (l-.5*c), 0,0,0
  if h < 1     then r,g,b = c,x,0
  elseif h < 2 then r,g,b = x,c,0
  elseif h < 3 then r,g,b = 0,c,x
  elseif h < 4 then r,g,b = 0,x,c
  elseif h < 5 then r,g,b = x,0,c
  else              r,g,b = c,0,x
  end return (r+m),(g+m),(b+m),a
end