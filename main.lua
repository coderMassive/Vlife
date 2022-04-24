function drawPlayer()
    love.graphics.draw(image, playerX, playerY)
end

function drawEnergy()
    love.graphics.setColor(255, 255, 0)
    love.graphics.rectangle("fill", 0, 10, energy * 4/3, 20)
    love.graphics.setColor(255, 0, 0)
end

function drawBG()
    love.graphics.draw(imageBg, 0, 0, 0, 1.5, 1.5)
end

function drawHealth()
    love.graphics.rectangle("fill", width/2 + 400 - 4*health, 10, health * 4, 20)
    love.graphics.setColor(255, 255, 255)
end

function movement()
    if energy == 0 then
        tired = true
    elseif tired and energy == 300 then
        tired = false
    end
    if love.keyboard.isDown("d") and playerY == playerGround and not tired then
        playerX = playerX + 10
        direction = 1
        energy = energy - 2
    end
    if love.keyboard.isDown("a") and playerY == playerGround and not tired then
        playerX = playerX - 10
        direction = -1
        energy = energy - 2
    end
    if playerX > width - 60 then
        playerX = width - 60
    end
    if playerX < 0 then
        playerX = 0
    end
end

function jump(dt)
    if love.keyboard.isDown('w') and not tired then
        if playerY_velocity == 0 then
            playerY_velocity = playerJump_height
        end
    end
    if playerY_velocity ~= 0 then
		playerY = playerY + playerY_velocity * dt
		playerY_velocity = playerY_velocity - playerGravity * dt
        if direction == 1 then
            playerX = playerX + 6
            energy = energy - 2
        elseif direction == -1 then
            playerX = playerX - 6
            energy = energy - 2
        end
	end
    if playerY > playerGround then
        playerY_velocity = 0
        playerY = playerGround
	end
    if playerY == playerGround then
        direction = 0
    end
end

function regenEnergy()
    if tired and energy < 300 then
        energy = energy + 2
    elseif energy < 300 then
        energy = energy + 1
    end
end

function regenHealth()
    if health < 100 then
        health = health + 0.1
    end
end

function love.draw()
    drawBG()
    drawEnergy()
    drawHealth()
    drawPlayer()
end

function love.update(dt)
    movement()
    jump(dt)
    regenEnergy()
    regenHealth()
end

function love.load()
    love.window.setTitle("Vlife")
    width = love.graphics.getWidth()
    playerX = width/2 -30
    playerY = 300
    direction = 0
    image = love.graphics.newImage("person.png")
    imageBg = love.graphics.newImage("bg.png")
    playerGround = 300
	playerY_velocity = 0
	playerJump_height = -600
	playerGravity = -1500
    energy = 300
    health = 100
    tired = false
end