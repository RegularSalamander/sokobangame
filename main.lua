require "class"
util = require "utils"

require "variables"
require "levels"
require "levelLoader"
require "save"

require "mainMenu"
require "levelSelect"
require "game"
require "disolveTransition"

require "player"
require "blob"
require "hole"
require "wall"
require "colorChanger"
require "holeAffectors"
require "particle"

gameState = ""
oldGameState = ""
nextGameState = ""

function love.load()
    math.randomseed(os.time())
    
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setLineStyle("rough")
    
    love.window.setMode(screenWidth*defaultScale, screenHeight*defaultScale, { vsync = true, msaa = 0, highdpi = true, resizable=true})
    love.window.setTitle("Bloboban")

    images = {}
    images.player = love.graphics.newImage("assets/player.png")
    images.blob = love.graphics.newImage("assets/blob.png")
    images.hole = love.graphics.newImage("assets/hole.png")
    images.filledhole = love.graphics.newImage("assets/filledhole.png")
    images.wall = love.graphics.newImage("assets/wall.png")
    images.colorChanger = love.graphics.newImage("assets/colorChanger.png")
    images.holeAffector = love.graphics.newImage("assets/holeAffector.png")
    images.level = love.graphics.newImage("assets/level.png")
    images.text = love.graphics.newImage("assets/text.png")
    images.title = love.graphics.newImage("assets/title.png")

    sounds = {}
    sounds.step1 = love.audio.newSource("assets/step1.wav", "static")
    sounds.step2 = love.audio.newSource("assets/step2.wav", "static")
    sounds.step3 = love.audio.newSource("assets/step3.wav", "static")
    sounds.step4 = love.audio.newSource("assets/step4.wav", "static")
    sounds.colorchange = love.audio.newSource("assets/colorchange.wav", "static")
    sounds.blobconnect = love.audio.newSource("assets/blobconnect.wav", "static")
    sounds.holeaffect = love.audio.newSource("assets/holeaffect.wav", "static")
    sounds.holefill = love.audio.newSource("assets/holefill.wav", "static")
    sounds.disolve1 = love.audio.newSource("assets/disolve1.wav", "static")
    sounds.disolve2 = love.audio.newSource("assets/disolve2.wav", "static")
    sounds.victory = love.audio.newSource("assets/victory.wav", "static")
    sounds.open = love.audio.newSource("assets/open.wav", "static")
    sounds.open:setVolume(0.5)

    largeFont = love.graphics.newFont("assets/fancySalamander.ttf", 32)
    font = love.graphics.newFont("assets/fancySalamander.ttf", 16)
    font:setFilter("nearest", "nearest")

    gameCanvas = love.graphics.newCanvas(screenWidth, screenHeight)
    
    setGameState("mainMenu")
end

function love.update(dt)
    if not love.window.hasFocus() then return end
    
    if _G[gameState .. "_update"] then
        _G[gameState .. "_update"](dt)
    end
end

function love.draw()
    if _G[gameState .. "_draw"] then
        _G[gameState .. "_draw"]()
    end

    love.graphics.setCanvas()
    local w, h = love.graphics.getDimensions()
    local scl
    if keepInteger then
        scl = math.floor(math.min(w/screenWidth, h/screenHeight))
    else
        scl = math.min(w/screenWidth, h/screenHeight)
    end
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(gameCanvas, w/2, h/2, 0, scl, scl, screenWidth/2, screenHeight/2)
end

function love.keypressed(key, scancode, isrepeat)
    if scancode == "f11" then
        fullscreen = not fullscreen
        love.window.setFullscreen(fullscreen)
    end

	if _G[gameState .. "_keypressed"] then
		_G[gameState .. "_keypressed"](key, scancode, isrepeat)
	end
end

function love.keyreleased(key, scancode, isrepeat)
	if _G[gameState .. "_keyreleased"] then
		_G[gameState .. "_keyreleased"](key, scancode, isrepeat)
	end
end

function setGameState(newGameState)
    gameState = newGameState

    if _G[gameState .. "_load"] then
        _G[gameState .. "_load"]()
    end
end

function disolveToGameState(newGameState)
    oldGameState = gameState
    nextGameState = newGameState
    gameState = "disolveTransition"

    disolveTransition_load()
end