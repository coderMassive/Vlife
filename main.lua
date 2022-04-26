function drawBG()
    love.graphics.draw(imageBg, 0, 0, 0, 1.5, 1.5)
end

function movement(dt)
    if love.keyboard.isDown("d") and playerY == playerGround then
        playerX = playerX + 5
        direction = 1
        updateAnimation(run, dt)
    end
    if love.keyboard.isDown("a") and playerY == playerGround then
        playerX = playerX - 5
        direction = -1
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
    if love.keyboard.isDown('w') then
        if playerY_velocity == 0 then
            playerY_velocity = playerJump_height
        end
    end
    if playerY_velocity ~= 0 then
		playerY = playerY + playerY_velocity * dt
		playerY_velocity = playerY_velocity - playerGravity * dt
        if direction == 1 then
            playerX = playerX + 5
            updateAnimation(run, dt)
        elseif direction == -1 then
            playerX = playerX - 5
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

function newAnimation(image, width, height, duration)
    local animation = {}
    animation.spriteSheet = image
    animation.quads = {}

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
        playerGravity = -2000
    end
end

function createPlatform()
    local temp = {}
    temp.x = width
    temp.y = 250
    temp.w = 120
    temp.h = 20
    temp.speed = 2
    table.insert(platforms, temp)
end

function createFirstPlatform()
    local temp = {}
    temp.x = playerX
    temp.y = 250
    temp.w = 120
    temp.h = 20
    temp.speed = 2
    platforms = {temp}
end

function drawPlatforms()
    for i = 1, #platforms do
        local platform = platforms[i]
        love.graphics.rectangle("fill", platform.x, platform.y, platform.w, platform.h)
    end
end

function updatePlatforms()
    local dead = true
    for i = 1, #platforms do
        local platform = platforms[i]
        platform.x = platform.x - platform.speed
        if platform.x <= playerX + 50 and playerX <= platform.x + 120 or playerY < 180 then
            dead = false
        end
    end
    if dead then
        love.event.quit()
    end
    math.randomseed(os.time())
    local num = math.random(1, 4)
    if num ~= 4 and cooldown >= 90 then
        createPlatform()
        cooldown = 0
    end
    cooldown = cooldown + 1
end

function love.draw()
    drawBG()
    drawAnimation(run, playerX, playerY, 4, 4)
    drawPlatforms()
end

function love.update(dt)
    movement(dt)
    jump(dt)
    checkStomp()
    updatePlatforms()
end

function love.load()
    love.window.setTitle("Vlife")
    width = love.graphics.getWidth()
    playerX = width/2 + 250
    playerY = 300
    direction = 0
    createFirstPlatform()
    run = newAnimation(love.graphics.newImage("person.png"), 16, 18, 1)
    imageBg = love.graphics.newImage("bg.png")
    playerGround = 180
	playerY_velocity = 0
	playerJump_height = -600
	playerGravity = -2000
    stage = 1
    cooldown = 0
end