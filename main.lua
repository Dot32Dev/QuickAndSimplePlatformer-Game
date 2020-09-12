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
end

function love.update(dt)
  introUpdate(dt)

  screen.shakeX = love.math.random(-screen.shake, screen.shake)
  screen.shakeY = love.math.random(-screen.shake, screen.shake)
  screen.shake = screen.shake + (0-screen.shake)*0.3
  screen.x = screen.x + (-player.x+love.graphics.getWidth()/2-screen.x)*0.3

  if intro.timer >  1 then
    screen.y = screen.y + (0-screen.y)*0.1
  end
  if intro.timer >  1.5 then
    playerUpdate()
  end

  map.alpha = 1
  if love.keyboard.isDown("p") and love.keyboard.isDown("q") then 
  	map.alpha = 0.5
  end
end

function love.draw()
  playerDraw()
  love.graphics.print("Quick and Simple Platformer", 20, screen.y + screen.shakeY + 20)
  mapDraw()

  introDraw()

end
