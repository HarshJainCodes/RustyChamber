WINDOW_WIDTH = 1200
WINDOW_HEIGHT = 800

push = require 'push'
Class = require 'Class'
require 'StateMachine'
require 'states/BaseState'
require 'states.MainMenu'
require 'states.RoomSelect'
require 'states/PlayState'
require 'inventory'

moonshine = require 'libraries.moonshine'

function love.load()
-- this is the github version
    push:setupScreen(WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = true,
        resizable = true,
        stretched = true,
        fullscreentype = "windows",
        highdpi = true,
        usedpiscale = true
    })
    love.window.setVSync(0)

    -- love.graphics.setDefaultFilter("nearest", "nearest")

    gStateMachine = StateMachine{
        ['mainMenu'] = function () return MainMenu() end,
        ['play'] = function () return PlayState() end,
        ['roomSelect'] = function () return RoomSelect() end,
        ['room1'] = function() return Room1() end,
        ['room2'] = function() return Room2() end
    }

    inventory = Inventory()

    gStateMachine:change('roomSelect')
end

-- world:addCollisionClass('tempClass', {ignores = {'tempClass'}})


function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
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