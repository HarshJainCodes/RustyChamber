Room1 = Class{__includes = BaseState}
require 'gui.dialougeBox'

function Room1:init()
    self.id = 1
    self.backgroundImage = love.graphics.newImage('assets/download.png')
    self.startingVideo = love.graphics.newVideo('assets/starting_scene.ogg')
    self.startingVideo:play()

    -- will store all the items that can be obtained
    self.items = {}

    -- key holes
    self.keyhole = {}
    self.keyhole.x = 670
    self.keyhole.y = 350
    self.keyhole.width = 40
    self.keyhole.height = 40
    self.keyhole.image = love.graphics.newImage('assets/grey_key_hole.png')

    self.popUpWindowKey = {}
    -- self.popUpWindowKey.magnified_keyHole = love.graphics.newImage('assets/magnified_keyHole.png')
    self.popUpWindowKey.magnified_keyHole = love.graphics.newImage('assets/door_close.png')
    self.popUpWindowKey.alphaInitial = 0
    self.popUpWindowKey.alphaFinal = 1
    self.popUpWindowKey.alphaProgress = 0
    self.popUpWindowKey.active = false
    self.popUpWindowKey.x = WINDOW_WIDTH/2 - self.popUpWindowKey.magnified_keyHole:getWidth()/2
    self.popUpWindowKey.y = WINDOW_HEIGHT/2 - self.popUpWindowKey.magnified_keyHole:getHeight()/2
    self.popUpWindowKey.width = self.popUpWindowKey.magnified_keyHole:getWidth()
    self.popUpWindowKey.height = self.popUpWindowKey.magnified_keyHole:getHeight()
    self.popUpWindowKey.blur = moonshine(WINDOW_WIDTH, WINDOW_HEIGHT, moonshine.effects.boxblur).chain(moonshine.effects.vignette)
    self.popUpWindowKey.blur.boxblur.radius = {20, 20}
    self.popUpWindowKey.blur.disable("boxblur")
    self.popUpWindowKey.blur.disable("vignette")

    --shift room
    self.leftRoomButton = {}
    self.leftRoomButton.width = 20
    self.leftRoomButton.height = 20
    self.leftRoomButton.x = 100
    self.leftRoomButton.y = WINDOW_HEIGHT/2 - self.leftRoomButton.height/2

    table.insert(self.items, knife)
    table.insert(self.items, key)

    -- tutorial red blinking
    self.tutorialRed = 0
    self.tutorialRedMultiplier = 1


    -- dialouge system for the game
    self.dialougeSystem = DialougeSystem()
    self.startDialougeRoom1 = false

    self.dialouge1 = Dialouge(1, "Where am I ?", 3)
    self.dialouge2 = Dialouge(2, "Gotta find a way out of here", 3)
    self.dialouge3 = Dialouge(3, "Look At Your Surroundings for hints", 1000)

    self.dialougeSystem:insertDialouge(self.dialouge1)
    self.dialougeSystem:insertDialouge(self.dialouge2)
    self.dialougeSystem:insertDialouge(self.dialouge3)

    -- shaders effect

    -- shader will be applied when the user opens their eyes for the first time

    self.vignetteEffecBlur = moonshine(WINDOW_WIDTH, WINDOW_HEIGHT, moonshine.effects.boxblur).chain(moonshine.effects.vignette)
    self.vignetteEffecBlur.vignette.radius = 0
    self.vignetteEffecBlur.vignette.softness = 0.5
    self.vignetteEffecBlur.vignette.opacity = 1
    self.vignetteEffecBlurRadius = 0
    self.vignetteEffecBlurMultiply = 1
    self.vignetteEffecBlurDecreasing = false
    self.vignetteEffecBlurDecreasingIncreasing = false
    self.vignetteEffecBlurEnd = false
    self.vignetteEffecBlur.boxblur.radius = {20, 20}

    self.endScreenTransition = moonshine(WINDOW_WIDTH, WINDOW_HEIGHT, moonshine.effects.vignette)
    self.endScreenTransitionRadius = 1
    self.endScreenTransitionTrigger = false


    self.nextLevelTransition = moonshine(WINDOW_WIDTH, WINDOW_HEIGHT, moonshine.effects.vignette)
    self.nextLevelTransition.disable("vignette")
    self.nextLevelTransition.vignette.opacity = 1
    self.nextLevelTransitionRadius = 1
end

function Room1:mousemoved(x, y, dx, dy, isTouch)
    inventory:mousemoved(realX, realY, dx, dy, isTouch)
end

function Room1:mousepressed(x, y, button)
    -- if x > self.leftRoomButton.x and x < self.leftRoomButton.x + self.leftRoomButton.width and y > self.leftRoomButton.y and y < self.leftRoomButton.y + self.leftRoomButton.height then
    --     gStateMachine:change('room2')
    --     return
    -- end

    if self.vignetteEffecBlurEnd then
        if not self.popUpWindowKey.active then
            if x > self.keyhole.x and x < self.keyhole.x + self.keyhole.width and y > self.keyhole.y and y < self.keyhole.y + self.keyhole.height then
                self.popUpWindowKey.active = true
                self.popUpWindowKey.blur.enable("boxblur")
            end

            for key, item in pairs(self.items) do
                if not item.addedToInventory then
                    if x > item.x and x < item.x + item.width and y > item.y and y < item.y + item.height then
                        item.addedToInventory = true
                        if item.name == "key" then
                            savedItems1.key = true
                            love.filesystem.write('inventorySaved.txt', json.encode(savedItems1))
                        elseif item.name == "knife" then
                            savedItems1.knife = true
                            love.filesystem.write('inventorySaved.txt', json.encode(savedItems1))
                        end
                        inventory:insertItem(item)
                    end
                end
            end
        else
            -- clicked outside of the popup window
            if (x < self.popUpWindowKey.x or x > self.popUpWindowKey.x + self.popUpWindowKey.width or y < self.popUpWindowKey.y or y > self.popUpWindowKey.y + self.popUpWindowKey.height) and (x < WINDOW_WIDTH - 100) then
                self.popUpWindowKey.active = false
                self.popUpWindowKey.alphaInitial = 0
                self.popUpWindowKey.alphaProgress = 0
                self.popUpWindowKey.blur.disable("boxblur")
            else
                -- the user clears the stage
                if (x > self.popUpWindowKey.x and x < self.popUpWindowKey.x + self.popUpWindowKey.width and y > self.popUpWindowKey.y and y < self.popUpWindowKey.y + self.popUpWindowKey.height) and (x < WINDOW_WIDTH - 100) and inventory.selectedItemId == key.id then
                    self.endScreenTransitionTrigger = true
                    self.nextLevelTransition.enable("vignette")
                    --- unlock the next room
                    LOCKED_ROOMS = math.max(LOCKED_ROOMS, 2)
                    -- save the progress to the new file
                    love.filesystem.write("locked_rooms.txt", json.encode({unlockedTill = LOCKED_ROOMS}))
                end
            end
        end

        inventory:mousepressed(x, y, button)
    end
end

function Room1:mousereleased(x, y, button)
    inventory:mousereleased(x, y, button)
end

function Room1:CauseTheBlinkOfEye(dt)
    if self.vignetteEffecBlurEnd == true then
        return
    end

    self.vignetteEffecBlurRadius = self.vignetteEffecBlurRadius + dt * self.vignetteEffecBlurMultiply
    self.vignetteEffecBlur.vignette.radius = self.vignetteEffecBlurRadius

    if self.vignetteEffecBlurRadius >= 1.5 and self.vignetteEffecBlurMultiply == 1 then
        self.vignetteEffecBlurMultiply = -1
        self.vignetteEffecBlurDecreasing = true
    end

    if self.vignetteEffecBlurMultiply == -1 then
        if self.vignetteEffecBlurRadius <= 0 then
            self.vignetteEffecBlurMultiply = 1
            self.vignetteEffecBlur.disable("boxblur")
            self.vignetteEffecBlurDecreasingIncreasing = true
        end

        if self.vignetteEffecBlurRadius >= 1.3 and self.vignetteEffecBlurDecreasingIncreasing == true then
            self.vignetteEffecBlur.disable("vignette")
            self.vignetteEffecBlurEnd = true
            self.startDialougeRoom1 = true
            self.dialougeSystem:playDialouge()
        end
    end
end

function Room1:update(dt)

    if self.endScreenTransitionTrigger then
        self.nextLevelTransitionRadius = self.nextLevelTransitionRadius - dt
        self.nextLevelTransition.vignette.radius = self.nextLevelTransitionRadius 
    end
    if love.keyboard.isDown("return") then
        gStateMachine:change('room' .. tostring(self.id + 1))
    end

    if not self.startingVideo:isPlaying() then
        self:CauseTheBlinkOfEye(dt)
    end

    self.tutorialRed = self.tutorialRed + dt / 2 * self.tutorialRedMultiplier

    if self.tutorialRed >= 1 then
        self.tutorialRedMultiplier = -1
    elseif self.tutorialRed <= 0 then
        self.tutorialRedMultiplier = 1
    end

    if self.endScreenTransitionTrigger then
        self.endScreenTransition.vignette.radius = self.endScreenTransitionRadius
        self.endScreenTransition.vignette.opacity = 1
        self.endScreenTransitionRadius = self.endScreenTransitionRadius - dt

        if self.endScreenTransitionRadius <= 0 then
            gStateMachine:change('room2')
        end
    end

    if self.popUpWindowKey.active then
        self.popUpWindowKey.alphaProgress = self.popUpWindowKey.alphaProgress + dt
        -- smoothing function math.sqrt()
        self.popUpWindowKey.alphaInitial = math.sqrt(self.popUpWindowKey.alphaProgress)

        if self.popUpWindowKey.alphaInitial > self.popUpWindowKey.alphaFinal then
            self.popUpWindowKey.alphaInitial = self.popUpWindowKey.alphaFinal
        end
    end

    -- if self.vignetteRadius <= 0 then
    --     self.vignetteMultiply = 1
    -- end
    self.dialougeSystem:update(dt)
end

function Room1:render()

    if self.startingVideo:isPlaying() then
        --love.graphics.setColor(0.2, 0.2, 0.2)
        love.graphics.draw(self.startingVideo, 0, 0, 0, WINDOW_WIDTH/self.startingVideo:getWidth(), WINDOW_HEIGHT/self.startingVideo:getHeight())
    else
        -- after the video has finished
        if self.vignetteEffecBlurRadius >= 0 then
            if not self.vignetteEffecBlurEnd then
                self.vignetteEffecBlur(
                    function ()
                        love.graphics.draw(self.backgroundImage, 0, 0, 0, WINDOW_WIDTH/self.backgroundImage:getWidth(), WINDOW_HEIGHT/self.backgroundImage:getHeight())
                    end
                )
            end

            -- after the kidnapper has opened their eyes show the objects
            if self.vignetteEffecBlurEnd then
                self.nextLevelTransition(
                    function ()
                        self.popUpWindowKey.blur(
                            function ()
                                love.graphics.draw(self.backgroundImage, 0, 0, 0, WINDOW_WIDTH/self.backgroundImage:getWidth(), WINDOW_HEIGHT/self.backgroundImage:getHeight())

                                for key, value in pairs(self.items) do
                                    -- blinking effect so that user gets hint to pick up the knife
                                    love.graphics.setColor(self.tutorialRed, self.tutorialRed, self.tutorialRed)
                                    value.render()
                                    love.graphics.setColor(1, 1, 1)
                                end

                                love.graphics.draw(self.keyhole.image, self.keyhole.x, self.keyhole.y, 0, self.keyhole.width/self.keyhole.image:getWidth(), self.keyhole.height/self.keyhole.image:getHeight())
                            end
                        )

                        if self.popUpWindowKey.active then
                            love.graphics.setColor(1, 1, 1, self.popUpWindowKey.alphaInitial)
                            love.graphics.draw(self.popUpWindowKey.magnified_keyHole, self.popUpWindowKey.x, self.popUpWindowKey.y)
                            love.graphics.setColor(1, 1, 1, 1)
                        end

                        love.graphics.rectangle("fill", self.leftRoomButton.x, self.leftRoomButton.y, self.leftRoomButton.width, self.leftRoomButton.height)

                        inventory:render()

                        if self.startDialougeRoom1 then
                            self.dialougeSystem:render()
                        end
                    end
                )
            end
        end
    end
end