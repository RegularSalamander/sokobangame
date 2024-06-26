player = class:new()

function player:init(x, y)
    self.pos = {x=x, y=y}
    self.nextPos = {x=x, y=y}

    self.dir = 0
    self.frame = 0
end

function player:draw()
    local drawx = util.map(animationFrame, 0, animLengths.moveTime, self.pos.x, self.nextPos.x)
    local drawy = util.map(animationFrame, 0, animLengths.moveTime, self.pos.y, self.nextPos.y)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(
        images.player,
        love.graphics.newQuad(self.dir*tileSize, self.frame*tileSize, tileSize, tileSize, tileSize*4, tileSize*2),
        drawx*tileSize,
        drawy*tileSize,
        0,
        1,
        1
    )
end

function player:control()
    local allowMove = false

    --determine most recently pressed button
    local input = "up"
    local mostRecentPressed = controls["up"]
    if controls["left"] > mostRecentPressed then
        mostRecentPressed = controls["left"]
        input = "left"
    end
    if controls["right"] > mostRecentPressed then
        mostRecentPressed = controls["right"]
        input = "right"
    end
    if controls["down"] > mostRecentPressed then
        mostRecentPressed = controls["down"]
        input = "down"
    end
    
    --don't move unless buffered or actively pressing
    if mostRecentPressed <= 0 and not bufferedControl then
        return false
    end

    if input == "up" then
        allowMove = self:move(0, -1)
    elseif input == "down" then
        allowMove = self:move(0, 1)
    elseif input == "left" then
        allowMove = self:move(-1, 0)
    elseif input == "right" then
        allowMove = self:move(1, 0)
    end

    return allowMove
end

function player:move(dx, dy)
    local doMove = true

    local next = getObjectAt(self.pos.x + dx, self.pos.y + dy)
    if next.wall then return false end

    if next.blob then
        doMove = next.blob:push(dx, dy)
    end

    if next.hole then
        doMove = doMove and next.hole:push(dx, dy)
    end

    if doMove then
        self.nextPos.x = self.pos.x + dx
        self.nextPos.y = self.pos.y + dy

        if dy == 1 then
            self.dir = 0
        elseif dx == -1 then
            self.dir = 1
        elseif dx == 1 then
            self.dir = 2
        else
            self.dir = 3
        end

        self.frame = (self.frame + 1)%2
    end

    return doMove
end

function player:applyMove()
    self.pos.x = self.nextPos.x
    self.pos.y = self.nextPos.y
end

function player:cancelMove()
    self.nextPos.x = self.pos.x
    self.nextPos.y = self.pos.y
end