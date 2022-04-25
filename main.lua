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

function movement(dt)
    if energy == 0 then
        tired = true
    elseif tired and energy == 300 then
        tired = false
    end
    if love.keyboard.isDown("d") and playerY == playerGround and not tired then
        playerX = playerX + 10
        direction = 1
        energy = energy - 2
        if dir == -1 then
            playerX = playerX - 48
        end
        dir = 1
        updateAnimation(run, dt)
    end
    if love.keyboard.isDown("a") and playerY == playerGround and not tired then
        playerX = playerX - 10
        direction = -1
        energy = energy - 2
        if dir == 1 then
            playerX = playerX + 48
        end
        dir = -1
        updateAnimation(run, dt)
    end
    if playerX > width - 48 and dir == 1 then
        playerX = width - 48
    end
    if playerX < 0 and dir == 1 then
        playerX = 0
    end
    if playerX < 48 and dir == -1 then
        playerX = 48
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
            updateAnimation(run, dt)
        elseif direction == -1 then
            playerX = playerX - 6
            energy = energy - 2
            updateAnimation(run, dt)
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

function newAnimation(image, width, height, duration)
    local animation = {}
    animation.spriteSheet = image;
    animation.quads = {};

    for y = 0, image:getHeight() - height, height do
        for x = 0, image:getWidth() - width, width do
            table.insert(animation.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
        end
    end

    animation.duration = duration or 1
    animation.currentTime = 0
    return animation
end

function updateAnimation(animation, dt)
    animation.currentTime = animation.currentTime + dt
    if animation.currentTime >= animation.duration then
        animation.currentTime = animation.currentTime - animation.duration
    end
end

function drawAnimation(animation, x, y, width, height)
    spriteNum = math.floor(animation.currentTime / animation.duration * #animation.quads) + 1
    love.graphics.draw(animation.spriteSheet, animation.quads[spriteNum], x, y, 0, width, height)
end

function checkStomp()
    if love.keyboard.isDown("lshift") then
        playerGravity = -4500
    else
        playerGravity = -1500
    end
end

function love.draw()
    drawBG()
    drawEnergy()
    drawHealth()
    drawAnimation(run, playerX, playerY, dir*4, 4)
end

function love.update(dt)
    movement(dt)
    jump(dt)
    regenEnergy()
    regenHealth()
    checkStomp()
end

function love.load()
    love.window.setTitle("Vlife")
    width = love.graphics.getWidth()
    playerX = width/2 -30
    playerY = 300
    direction = 0
    dir = 1
    run = newAnimation(love.graphics.newImage("person.png"), 16, 18, 1)
    imageBg = love.graphics.newImage("bg.png")
    playerGround = 300
	playerY_velocity = 0
	playerJump_height = -600
	playerGravity = -1500
    energy = 300
    health = 100
    tired = false
end