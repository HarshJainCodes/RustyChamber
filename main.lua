WINDOW_WIDTH = 1200
WINDOW_HEIGHT = 800

push = require 'push'
Class = require 'Class'
json = require 'libraries.json.json'
moonshine = require 'libraries.moonshine'

require 'StateMachine'
require 'states/BaseState'
require 'states.MainMenu'
require 'states.RoomSelect'
require 'states.TransitionToNextLevel'
require 'states.helperFunctions'
require 'states.Room1'
require 'states.Room2'
require 'states.Room3'
require 'states.Room4'
require 'inventory'


function love.load()
-- this is the github version
    push:setupScreen(WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        stretched = false,
        fullscreentype = "windows",
        highdpi = true,
        usedpiscale = true
    })
    -- love.window.setVSync(0)

    -- love.graphics.setDefaultFilter("nearest", "nearest")

    love.filesystem.setIdentity("RustyChamber")

    gStateMachine = StateMachine{
        ['mainMenu'] = function () return MainMenu() end,
        ['play'] = function () return PlayState() end,
        ['roomSelect'] = function () return RoomSelect() end,
        ['room1'] = function() return Room1() end,
        ['room2'] = function() return Room2() end,
        ['room3'] = function () return Room3() end,
        ['room4'] = function () return Room4() end,
        ['stateTransition'] = function () return TransitionToNextLevel() end
    }

    MOUSE_ASSET = nil
    inventory = Inventory()

    -- this is by default
    LOCKED_ROOMS = 1
    if love.filesystem.getInfo("locked_rooms.txt") then
        content, size = love.filesystem.read("locked_rooms.txt")

        decoded_content = json.decode(content)
        LOCKED_ROOMS = decoded_content.unlockedTill
    else
        love.filesystem.write("locked_rooms.txt", json.encode({unlockedTill = 1}))
    end

    gStateMachine:change('room3')
end

-- world:addCollisionClass('tempClass', {ignores = {'tempClass'}})


function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
    gStateMachine.current:keypressed(key)
end

function love.mousemoved(x, y, dx, dy, isTouch)
    realX, realY = push:toGame(x, y)

    if realX ~= nil and realY ~= nil then
        gStateMachine.current:mousemoved(x, y, dx, dy, isTouch)
    end
end

function love.mousepressed(x, y, button)
    x1, y1 = push:toGame(x, y)
    gStateMachine.current:mousepressed(x1, y1, button)
end

function love.mousereleased(x, y, button)
    x1, y1 = push:toGame(x, y)
    gStateMachine.current:mousereleased(x1, y1, button)
end

function love.update(dt)
    gStateMachine:update(dt)
end

function love.draw()
    push:apply('start')
    gStateMachine:render()
    love.graphics.print(love.timer.getFPS(), 0, 0)

    --love.graphics.print(collectgarbage("count"))
    push:apply('end')
end