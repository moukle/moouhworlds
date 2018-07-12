TILESIZE = 10
player = {}
fruit = {}

local Direction = {
    UP = 0,
    DOWN = 1,
    RIGHT = 2,
    LEFT = 3
}

function love.load()
    player.x = 0
    player.y = 0
    player.bodyParts = {}
    player.cooldown = 10
    player.direction = Direction.DOWN
    fruit:spawn()
end

function fruit:spawn()
    self.x = math.random(0, 50)
    self.y = math.random(0, 50)
end

function fruitCollsion(player, fruit)
    if player.x == fruit.x and player.y == fruit.y then
        bodyPart = {}
        bodyPart.x = player.x
        bodyPart.y = player.y
        table.insert(player.bodyParts, bodyPart)
        fruit:spawn()
    end
end

function wallCollision(player)
    -- and wrap!
end

function checkCollisions(player, fruit)
    player:bodyCollision()
    fruitCollsion(player, fruit)
    wallCollision(player)
end

function player:bodyCollision()
    partsButFirst = select(1, self.bodyParts)
    for _,p in pairs(partsButFirst) do
        if p.x == self.x and p.y == self.y then
            print("CRASSSH")
        end
    end
end

function player:update()
    if self.cooldown <= 0 then
        self.cooldown = 10
        checkCollisions(player, fruit)
        self:updateBody()
        self:move()
    end
end

function player:updateBody()
    bodySize = table.getn(self.bodyParts)
    if bodySize >= 1 then
        table.remove(self.bodyParts, bodySize)
        bodyPart = {}
        bodyPart.x = player.x
        bodyPart.y = player.y
        table.insert(self.bodyParts, 1, bodyPart)
    end
end

function player:move()
    if self.direction == Direction.RIGHT then
        self.x = self.x + 1
    elseif self.direction == Direction.LEFT then
        self.x = self.x - 1
    elseif self.direction == Direction.DOWN then
        self.y = self.y + 1
    elseif self.direction == Direction.UP then
        self.y = self.y - 1
    end
end

function love.update(dt)
    player.cooldown = player.cooldown - 1
    if love.keyboard.isDown("f") then
        player.direction = Direction.RIGHT
    elseif love.keyboard.isDown("s") then
        player.direction = Direction.LEFT
    elseif love.keyboard.isDown("e") then
        player.direction = Direction.UP
    elseif love.keyboard.isDown("d") then
        player.direction = Direction.DOWN
    end
    player:update()
end

function player:draw()
    love.graphics.setColor(0, 0.4, 0.4)
    love.graphics.rectangle("fill", self.x*TILESIZE, self.y*TILESIZE, TILESIZE, TILESIZE)
    for _,p in pairs(self.bodyParts) do
        love.graphics.rectangle("fill", p.x*TILESIZE, p.y*TILESIZE, TILESIZE, TILESIZE)
    end
end

function fruit:draw()
    love.graphics.setColor(0.4, 0.4, 0)
    love.graphics.rectangle("fill", self.x*TILESIZE, self.y*TILESIZE, TILESIZE, TILESIZE)
end

function love.draw()
    player:draw()
    fruit:draw()
end