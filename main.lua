function love.load()
  love.graphics.setBackgroundColor(0, 53/255, 87/255)
  love.math.setRandomSeed(os.time())
  require("Intro/intro")
  require("map")
  require("player")
  introInitialise("Games")
  mapInitialise()
  playerInitialise()

  screen = {}
  screen.x = 0
  screen.y = 6000
  screen.font = love.graphics.newFont("Public_Sans/static/PublicSans-Black.ttf", 20)
  screen.shakeX = 0
  screen.shakeY = 0
  screen.shake = 0
  screen.state = 1
  screen.overlayAlpha = 0
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
  if love.keyboard.isDown("p") and love.keyboard.isDown("q") then 
  	map.alpha = 0.5
  end

  if screen.state == 2 then 
  	screen.overlayAlpha = screen.overlayAlpha + (0.5-screen.overlayAlpha)*0.2
  else
  	screen.overlayAlpha = screen.overlayAlpha + (0-screen.overlayAlpha)*0.2
  end
end

function love.draw()
  playerDraw()
	mapDraw()
	
	love.graphics.setColor(0/255, 107/255, 173/255, map.alpha)
	love.graphics.print("Quick and Simple Platformer", 40, screen.y + screen.shakeY + 20 - (love.graphics.getHeight()-600)/2)
	
	love.graphics.setColor(0, 0, 0, screen.overlayAlpha)
	love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
	
	love.graphics.setColor(0.9, 0.9, 0.9, screen.overlayAlpha*2)
	love.graphics.print("Press ", love.graphics.getWidth()/2-screen.font:getWidth("Press [R] to reset")/2, screen.y + screen.shakeY + 200 - (love.graphics.getHeight()-600)/2)
	love.graphics.setColor(188/255, 82/255, 47/255, screen.overlayAlpha*2)
	love.graphics.print("[R]", love.graphics.getWidth()/2-screen.font:getWidth("Press [R] to reset")/2 + screen.font:getWidth("Press "), screen.y + screen.shakeY + 200 - (love.graphics.getHeight()-600)/2)
	love.graphics.setColor(0.9, 0.9, 0.9, screen.overlayAlpha*2)
	love.graphics.print(" to reset", love.graphics.getWidth()/2-screen.font:getWidth("Press [R] to reset")/2 + screen.font:getWidth("Press [R]"), screen.y + screen.shakeY + 200 - (love.graphics.getHeight()-600)/2)
  
  introDraw()
end
