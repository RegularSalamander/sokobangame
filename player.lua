player = class:new()

function player:init(x, y)
    self.pos = {x=x, y=y}
end

function player:draw()
    love.graphics.draw(
        images.player,
        self.pos.x * tileSize,
        self.pos.y * tileSize
    )
end

function player:update()
    --movement
    if controls["up"] == 1 then
        self:move(0, -1)
    elseif controls["down"] == 1 then
        self:move(0, 1)
    elseif controls["left"] == 1 then
        self:move(-1, 0)
    elseif controls["right"] == 1 then
        self:move(1, 0)
    end

    return true
end

function player:move(dx, dy)
    local doMove = true

    local next = getObjectAt(self.pos.x + dx, self.pos.y + dy)
    if next.wall then return end

    if next.blob then
        doMove = next.blob:push(dx, dy)
    end

    if doMove then
        self.pos.x = self.pos.x + dx
        self.pos.y = self.pos.y + dy
    end
end