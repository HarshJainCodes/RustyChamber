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
require 'inventory'
require 'states.Room1'
require 'states.Room2'
require 'states.Room3'
require 'states.Room4'
require 'states.Room5'



function love.load()
-- this is the github version
    push:setupScreen(WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        stretched = false,
        -- fullscreentype = "android",
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
        ['room5'] = function () return Room5() end,
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


    -- for room 1
    if love.filesystem.getInfo('inventorySaved.txt') then
        content, size = love.filesystem.read('inventorySaved.txt')
        savedItems1 = json.decode(content)
        knife.addedToInventory = savedItems1.knife
        key.addedToInventory = savedItems1.key

        if savedItems1.knife == true then
            inventory:insertItem(knife)
        end
        if savedItems1.key == true then
            inventory:insertItem(key)
        end
    else
        savedItems1 = {}
        savedItems1.knife = false
        savedItems1.key = false

        love.filesystem.write('inventorySaved.txt', json.encode(savedItems1))
    end

    -- for room 2
    if love.filesystem.getInfo('inventorySaved1.txt') then
        content, size = love.filesystem.read('inventorySaved1.txt')
        savedItems2 = json.decode(content)

        crowbar.addedToInventory = savedItems2.crowbar
        brown_key.addedToInventory = savedItems2.brown_key
        battery.addedToInventory = savedItems2.battery
        eraser.addedToInventory = savedItems2.eraser
        screwdriver.addedToInventory = savedItems2.screwDriver
        storeRoomOpened = savedItems2.storeRoomOpened

        print(storeRoomOpened)

        if savedItems2.crowbar == true then
            inventory:insertItem(crowbar)
        end
        if savedItems2.brown_key == true then
            inventory:insertItem(brown_key)
        end
        if savedItems2.battery == true then
            inventory:insertItem(battery)
        end
        if savedItems2.eraser == true then
            inventory:insertItem(eraser)
        end
        if savedItems2.screwDriver == true then
            inventory:insertItem(screwdriver)
        end
    else
        savedItems2 = {}
        savedItems2.crowbar = false
        savedItems2.brown_key = false
        savedItems2.battery = false
        savedItems2.eraser = false
        savedItems2.screwDriver = false
        savedItems2.storeRoomOpened = false

        love.filesystem.write('inventorySaved1.txt', json.encode(savedItems2))
    end

    -- for room 3
    if love.filesystem.getInfo('inventorySaved2.txt') then
        content, size = love.filesystem.read('inventorySaved2.txt')
        savedItems2 = json.decode(content)
        wrench.addedToInventory = savedItems2.wrench
        soapAndWater.addedToInventory = savedItems2.soapAndWater
        mirrorHidden = savedItems2.mirrorHidden
        dirtErased = savedItems2.dirtErased

        if savedItems2.wrench == true then
            inventory:insertItem(wrench)
        end
        if savedItems2.soapAndWater == true then
            inventory:insertItem(soapAndWater)
        end
    else
        savedItems2 = {}
        savedItems2.wrench = false
        savedItems2.soapAndWater = false
        savedItems2.mirrorHidden = false
        savedItems2.dirtErased = false

        love.filesystem.write('inventorySaved2.txt', json.encode(savedItems2))
    end

    gStateMachine:change('room2')
end

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
    if x1 ~= nil and y1 ~= nil then
        gStateMachine.current:mousepressed(x1, y1, button)
    end
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