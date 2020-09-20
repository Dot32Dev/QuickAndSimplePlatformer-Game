function particleInitialise()
	particles = {}
	particles.coins = {}
	particles.jump = {}
end

function particleUpdate()
	for i=#particles.coins, 1, -1 do
		particles.coins[i][1] = particles.coins[i][1] + math.cos(particles.coins[i][3]*math.pi/180)*particles.coins[i][4]
		particles.coins[i][2] = particles.coins[i][2] + math.sin(particles.coins[i][3]*math.pi/180)*particles.coins[i][4] + particles.coins[i][5]
		particles.coins[i][5] = particles.coins[i][5] + 0.2
		particles.coins[i][4] = particles.coins[i][4] + (0 - particles.coins[i][4]) * 0.2
		if particles.coins[i][4] < 0.05 then 
			table.remove(particles.coins, i)
		end
	end
	for i=#particles.jump, 1, -1 do
		particles.jump[i][1] = particles.jump[i][1] + math.cos(particles.jump[i][3]*math.pi/180)*particles.jump[i][4]
		particles.jump[i][2] = particles.jump[i][2] + math.sin(particles.jump[i][3]*math.pi/180)*particles.jump[i][4] + particles.jump[i][5]
		particles.jump[i][5] = particles.jump[i][5] + 1
		particles.jump[i][4] = particles.jump[i][4] + (0 - particles.jump[i][4]) * 0.2
		if particles.jump[i][4] < 0.05 then 
			table.remove(particles.jump, i)
		end
	end
end

function particleDraw()
	for i=1, #particles.coins do
		love.graphics.setColour(1, 221/255, 0, 0.005)
		love.graphics.circle("fill", particles.coins[i][1] + screen.x + love.math.random(-5, 5), particles.coins[i][2] + screen.y + love.math.random(-10, 10), 5 + 8)
		love.graphics.circle("fill", particles.coins[i][1] + screen.x + love.math.random(-5, 5), particles.coins[i][2] + screen.y + love.math.random(-10, 10), 5 + 16)
		love.graphics.circle("fill", particles.coins[i][1] + screen.x + love.math.random(-5, 5), particles.coins[i][2] + screen.y + love.math.random(-10, 10), 5 + 32)
	end
	for i=1, #particles.jump do
		love.graphics.setColour(fr, fg, fb, map.alpha)
		love.graphics.rectangle("fill", particles.jump[i][1] + screen.x + screen.shakeX, particles.jump[i][2] + screen.y + screen.shakeY, 10, 10, 2, love.timer.getTime())
	end
end

function particleCall(type)
	if type == "coin" then 
		for i=1, 30 do
			local particle = {player.x, player.y, (360/30*i)-180, love.math.random(0, 15), 0}
			table.insert(particles.coins, particle)
		end
	end
	if type == "jump" then 
		for i=1, 5 do
			local particle = {player.x, player.y, (360/5*i)-180, love.math.random(0, 15), 0}
			table.insert(particles.jump, particle)
		end
	end
end