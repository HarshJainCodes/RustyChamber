Room2 = Class{__includes = BaseState}

KeyButton = Class{}

function KeyButton:init(x, y, width, height, image, value)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.image = image
    self.value = value
end

function KeyButton:render()
    love.graphics.draw(self.image,  self.x, self.y, 0, self.width/self.image:getWidth(), self.height/self.image:getHeight())
end

function Room2:pinPressed(x, y, buttons)
    for key, value in pairs(buttons) do
        if checkAABBCollision(x, y, value) then
            self.enterPinPopup.text = self.enterPinPopup.text .. tostring(value.value)
            if self.enterPinPopup.text == "2003" then
                self.startingTransition.enable("vignette")
                self.LeavingScene4 = true
            end
            if #self.enterPinPopup.text == 4 and self.enterPinPopup.text ~= "2003" then
                self.enterPinPopup.text = ""
            end
        end
    end
end


function Room2:init()
    self.id = 2

    self.startingTransition = moonshine(WINDOW_WIDTH, WINDOW_HEIGHT, moonshine.effects.vignette)
    self.startingTransition.vignette.opacity = 1
    self.startingTransition.vignette.radius = 0
    self.EnteringScene = true
    self.LeavingScene3 = false
    self.LeavingScene4 = false
    self.startingTransitionRadius = 0

    self.backgroundImage = love.graphics.newImage('assets/room2/room2background.png')

    self.beer_bottle = PlacableItems(890, 550, 100, 100, love.graphics.newImage('assets/room2/beer_bottle.png'))

    self.digit_glow = PlacableItems(1000, 200, 100, 100, love.graphics.newImage('assets/room2/digit_glow.png'))

    self.textColor = {
        {0, 0, 1}, {1, 1, 0}, {0, 1, 0}, {1, 0, 0}
    }

    ----------------------------------------------------------------------light switch----------------------------------------------------------------------
    self.light = PlacableItems(WINDOW_WIDTH/2 - 35, 0, 70, 70, love.graphics.newImage('assets/room2/light.png'))
    self.light.switchedOn = true

    -------------------------------------------------------------------ELECTRIC BOARD------------------------------------------------------------------------

    self.electricBoard = PlacableItems(480, 470, 50, 50, love.graphics.newImage('assets/room2/electricBoard.png'))

    self.electricBoardPopup = PopupWindow(love.graphics.newImage('assets/room2/screwlocked_close_up.png'), 0.7, 0.7)

    self.electricBoardPopup.battery = InventoryPlacableItems(WINDOW_WIDTH/2 - 25, 550, 50, 100, 7, love.graphics.newImage('assets/room2/battery.png'), "battery")

    ---------------------------------------------ENTER PIN SCREEN----------------------------------------------------------------------------------------------
    self.enterPinInteractive = PlacableItems(580, 260, 100, 40, nil)
    self.enterPinInteractive.render = function ()
        love.graphics.rectangle("line", self.enterPinInteractive.x, self.enterPinInteractive.y, self.enterPinInteractive.width, self.enterPinInteractive.height)
    end

    self.enterPinPopup = PopupWindow(love.graphics.newImage('assets/room2/demo_image.jpg'), 0.5, 0.5)
    self.enterPinPopup.text = ""

    self.allButtons = {}

    table.insert(self.allButtons, KeyButton(WINDOW_WIDTH/2 - 150, 300, 100, 100, love.graphics.newImage('assets/room2/1_key.png'), 1))
    table.insert(self.allButtons, KeyButton(WINDOW_WIDTH/2 - 50, 300, 100, 100, love.graphics.newImage('assets/room2/2_key.png'), 2))
    table.insert(self.allButtons, KeyButton(WINDOW_WIDTH/2 + 50, 300, 100, 100, love.graphics.newImage('assets/room2/3_key.png'), 3))
    table.insert(self.allButtons, KeyButton(WINDOW_WIDTH/2 - 150, 400, 100, 100, love.graphics.newImage('assets/room2/4_key.png'), 4))
    table.insert(self.allButtons, KeyButton(WINDOW_WIDTH/2 - 50, 400, 100, 100, love.graphics.newImage('assets/room2/5_key.png'), 5))
    table.insert(self.allButtons, KeyButton(WINDOW_WIDTH/2 + 50, 400, 100, 100, love.graphics.newImage('assets/room2/6_key.png'), 6))
    table.insert(self.allButtons, KeyButton(WINDOW_WIDTH/2 - 150, 500, 100, 100, love.graphics.newImage('assets/room2/7_key.png'), 7))
    table.insert(self.allButtons, KeyButton(WINDOW_WIDTH/2 - 50, 500, 100, 100, love.graphics.newImage('assets/room2/8_key.png'), 8))
    table.insert(self.allButtons, KeyButton(WINDOW_WIDTH/2 + 50, 500, 100, 100, love.graphics.newImage('assets/room2/9_key.png'), 9))
    table.insert(self.allButtons, KeyButton(WINDOW_WIDTH/2 - 50, 600, 100, 100, love.graphics.newImage('assets/room2/0_key.png'), 0))



    -----------------------------------------------------------------------CARPET----------------------------------------------------------------------------------------------
    self.carpet = {}
    self.carpet.carpetImage = love.graphics.newImage('assets/room2/carpet.png')
    self.carpet.key = {}
    self.carpet.key.id = 6
    self.carpet.key.x = 650
    self.carpet.key.y = 560
    self.carpet.key.width = 40
    self.carpet.key.height = 40
    self.carpet.key.addedToInventory = false
    self.carpet.key.image = love.graphics.newImage('assets/room2/brown_key.png')
    self.carpet.key.name = "brown_key"
    self.carpet.key.render = function ()
        if not self.carpet.key.addedToInventory then
            love.graphics.draw(self.carpet.key.image, self.carpet.key.x, self.carpet.key.y, 0, self.carpet.key.width/self.carpet.key.image:getWidth(), self.carpet.key.height/self.carpet.key.image:getHeight())
        end
    end
    self.carpet.x = 550
    self.carpet.y = 550
    self.carpet.width = 250
    self.carpet.height = 62.5
    self.carpet.slideCarpet = false
    self.carpet.render = function ()
        love.graphics.draw(self.carpet.carpetImage, self.carpet.x, self.carpet.y, 0, self.carpet.width/self.carpet.carpetImage:getWidth(), self.carpet.height/self.carpet.carpetImage:getHeight())
    end

    --------------------------------------------------- CONTAINS DUSTBIN INTERACTIVE AND POPUP WINDOW---------------------------------------------------------

    self.dustBinInteractable = PlacableItems(150, 550, 80, 120, love.graphics.newImage('assets/room2/dustbin.png'))

    self.popUpDustbin = PopupWindow(love.graphics.newImage('assets/room2/dustbin_close_up.png'), 1, 1)

    self.popUpDustbin.blur = moonshine(WINDOW_WIDTH, WINDOW_HEIGHT, moonshine.effects.boxblur)
    self.popUpDustbin.blur.boxblur.radius = {20, 20}
    self.popUpDustbin.blur.disable("boxblur")


    ------------------------------------------------CONTAINS SWITCH INTERACTIVE CODE----------------------------------------------------------------------
    self.switchInteractable = PlacableItems(470, 260, 40, 40, nil)
    self.switchInteractable.switchStatus = "on"
    self.switchInteractable.imageOFF = love.graphics.newImage('assets/room2/switch.png')
    self.switchInteractable.imageON = love.graphics.newImage('assets/room2/switch_on.png')
    self.switchInteractable.render = function ()
        if self.switchInteractable.switchStatus == "off" then
            love.graphics.draw(self.switchInteractable.imageOFF, self.switchInteractable.x, self.switchInteractable.y, 0, self.switchInteractable.width/self.switchInteractable.imageOFF:getWidth(), self.switchInteractable.height/self.switchInteractable.imageOFF:getHeight())
        else
            love.graphics.draw(self.switchInteractable.imageON, self.switchInteractable.x, self.switchInteractable.y, 0, self.switchInteractable.width/self.switchInteractable.imageON:getWidth(), self.switchInteractable.height/self.switchInteractable.imageON:getHeight())
        end
    end

    ---------------------------------------------CONTAINS STORE ROOM DOOR INTERACTIVE CODE ------------------------------------------------------------------

    self.storeRoomOpened = false
    self.storeRoomDoorInteractable = PlacableItems(560, 650, 200, 133, love.graphics.newImage('assets/room2/store_room_door.png'))
    self.storeRoomDoorRevealed = PlacableItems(560, 650, 200, 133, love.graphics.newImage('assets/room2/store_room_door_open.png'))

    ---------------------------------------------CONTAINS PHOTO FRAME INTERACTIVE CODE --------------------------------------------------------------------
    self.photoframeInteractable = {}
    self.photoframeInteractable.x = 230
    self.photoframeInteractable.y = 200
    self.photoframeInteractable.width = 150
    self.photoframeInteractable.height = 200
    self.photoframeInteractable.disappear = false
    self.photoframeInteractable.alpha = 1
    self.photoframeInteractable.lerpProgress = 0
    self.photoframeInteractable.lerp = function (start, finish, t)
        return start + (finish - start) * t
    end
    self.photoframeInteractable.image = love.graphics.newImage('assets/room2/photo_frame.png')
    self.photoframeInteractable.render = function ()
        love.graphics.draw(self.photoframeInteractable.image, self.photoframeInteractable.x, self.photoframeInteractable.y, 0, self.photoframeInteractable.width/self.photoframeInteractable.image:getWidth(), self.photoframeInteractable.height/self.photoframeInteractable.image:getHeight())
    end

    ---------------------------------------------CONTAINS PAPER BALL INTERACTIVE WINDOW --------------------------------------------------------------------

    self.paperBallInteractable = PlacableItems(100, 650, 40, 40, love.graphics.newImage('assets/room2/paper.png'))

    self.popUpPaper = {}
    self.popUpPaper.dirtyImage = love.graphics.newImage('assets/room2/paper_no_pin.png')
    self.popUpPaper.dirtyImageAlpha = 1
    self.popUpPaper.image = love.graphics.newImage('assets/room2/paper_pin.png')
    self.popUpPaper.imageAlpha = 0
    self.popUpPaper.active = false
    self.popUpPaper.width = 0.75 * self.popUpPaper.image:getWidth()
    self.popUpPaper.height = 0.75 * self.popUpPaper.image:getHeight()
    self.popUpPaper.x = WINDOW_WIDTH/2 - self.popUpPaper.width/2
    self.popUpPaper.y = WINDOW_HEIGHT/2 - self.popUpPaper.height/2

    -- you require an eraser to erase the ink
    self.popUpPaper.eraserActive = false

    self.popUpPaper.lerp = function (start, finish, t)
        return start + (finish - start) * t
    end

    ---------------------------------------------LOCKER STEEL INTERACTIVE CODE----------------------------------------------------------------------------
    self.locker = {}
    self.locker.width = 250
    self.locker.height = 250
    self.locker.x = 230
    self.locker.y = 430
    self.locker.image = love.graphics.newImage('assets/room2/locker_steel.png')

    self.locker.upper = {}
    self.locker.upper.x = 330
    self.locker.upper.y = 500
    self.locker.upper.width = 125
    self.locker.upper.height = 60
    self.locker.upper.render = function ()
        --love.graphics.rectangle("line", self.locker.upper.x, self.locker.upper.y, self.locker.upper.width, self.locker.upper.height)
    end

    self.locker.lower = {}
    self.locker.lower.x = 330
    self.locker.lower.y = 590
    self.locker.lower.width = 125
    self.locker.lower.height = 60
    self.locker.lower.render = function ()
        --love.graphics.rectangle("line", self.locker.lower.x, self.locker.lower.y, self.locker.lower.width, self.locker.lower.height)
    end
    self.locker.render = function ()
        love.graphics.draw(self.locker.image, self.locker.x, self.locker.y, 0, self.locker.width/self.locker.image:getWidth(), self.locker.height/self.locker.image:getHeight())
    end

    -----------------------------------------------UPPER LOCKER POPUP--------------------------------------------------------------------------------------------

    self.UpperlockerPopup = PopupWindow(love.graphics.newImage('assets/room2/drawer_locker.png'), 1, 1)

    -------------------------------------------------LOWER LOCKER POPUP----------------------------------------------------------------------------------

    self.LowerlockerPopup = PopupWindow(love.graphics.newImage('assets/room2/drawer_locker.png'), 1, 1)

    self.LowerlockerPopup.rubber = InventoryPlacableItems(400, 400, 109, 70, 5, love.graphics.newImage('assets/room2/eraser.png'), "Eraser")


    ---------------------------------------------ITEMS THAT CAN BE ADDED TO THE INVENTORY-------------------------------------------------------------------

    self.screwdriver = InventoryPlacableItems(600, 350, 100, 200, 3, love.graphics.newImage('assets/room2/screwdriver.png'), "screwdriver")

    self.crowbar = InventoryPlacableItems(1000, 650, 100, 100, 4, love.graphics.newImage('assets/room2/crowbar.png'), "crowbar")


    --------------------items added to inventory saved--------------------------------
    if love.filesystem.getInfo('inventorySaved1.txt') then
        content, size = love.filesystem.read('inventorySaved1.txt')
        self.savedItems = json.decode(content)

        self.crowbar.addedToInventory = self.savedItems.crowbar
        self.carpet.key.addedToInventory = self.savedItems.brown_key

        if self.savedItems.crowbar == true then
            inventory:insertItem(self.crowbar)
        end
        if self.savedItems.brown_key == true then
            inventory:insertItem(self.carpet.key)
        end
        if self.savedItems.battery == true then
            inventory:insertItem(self.electricBoardPopup.battery)
        end
        if self.savedItems.eraser == true then
            inventory:insertItem(self.LowerlockerPopup.rubber)
        end
        if self.savedItems.screwDriver == true then
            inventory:insertItem(self.screwdriver)
        end
        if self.savedItems.storeRoomOpened == true then
            self.storeRoomOpened = self.savedItems.storeRoomOpened
        end
    else
        self.savedItems = {}
        self.savedItems.crowbar = false
        self.savedItems.brown_key = false
        self.savedItems.battery = false
        self.savedItems.eraser = false
        self.savedItems.screwDriver = false
        self.savedItems.storeRoomOpened = false

        love.filesystem.write('inventorySaved1.txt', json.encode(self.savedItems))
    end
end


function UpdateAlphaBlurVariables(object, dt)
    object.alphaProgress = object.alphaProgress + dt
    object.alphaInitial = object.lerp(0, 1, object.alphaProgress)

    if object.alphaInitial > object.alphaFinal then
        object.alphaInitial = object.alphaFinal
    end
end

function Room2:mousepressed(x, y, button, isTouch)
    if button == 1 then
        -- check if clicked on the photo
        if (not self.popUpDustbin.active) and (not self.popUpPaper.active) and (not self.UpperlockerPopup.active) and (not self.LowerlockerPopup.active) and (not self.electricBoardPopup.active) and (not self.enterPinPopup.active) then
            -- if clicked on dustbin
            if x > self.dustBinInteractable.x and x < self.dustBinInteractable.x + self.dustBinInteractable.width and y > self.dustBinInteractable.y and y < self.dustBinInteractable.y + self.dustBinInteractable.height then
                self.popUpDustbin.active = true
                self.popUpDustbin.blur.enable("boxblur")
            end

            -- if clicked on enter pin 
            if checkAABBCollision(x, y, self.enterPinInteractive) then
                self.enterPinPopup.active = true
                self.popUpDustbin.blur.enable("boxblur")
            end

            -- if clicked on paper
            if x > self.paperBallInteractable.x and x < self.paperBallInteractable.x + self.paperBallInteractable.width and y > self.paperBallInteractable.y and y < self.paperBallInteractable.y + self.paperBallInteractable.height then
                self.popUpPaper.active = true

                -- REMBERBER we are enabling the blur effect of the dustbin interface
                self.popUpDustbin.blur.enable("boxblur")
            end

            -- if clicked on upper locker
            if inventory.selectedItemId == 6 and x > self.locker.upper.x and x < self.locker.upper.x + self.locker.upper.width and y > self.locker.upper.y and y < self.locker.upper.y + self.locker.upper.height then
                self.UpperlockerPopup.active = true

                -- REMBERBER we are enabling the blur effect of the dustbin interface
                self.popUpDustbin.blur.enable("boxblur")
            end

            -- if clicked on lower locker
            if x > self.locker.lower.x and x < self.locker.lower.x + self.locker.lower.width and y > self.locker.lower.y and y < self.locker.lower.y + self.locker.lower.height then
                self.LowerlockerPopup.active = true

                -- REMBERBER we are enabling the blur effect of the dustbin interface
                self.popUpDustbin.blur.enable("boxblur")
            end

            -- if clicked on electric board
            if checkAABBCollision(x, y, self.electricBoard) then
                self.electricBoardPopup.active = true

                -- REMBERBER we are enabling the blur effect of the dustbin interface
                self.popUpDustbin.blur.enable("boxblur")
            end

            if self.carpet.slideCarpet then
                if  self.carpet.key.addedToInventory == false and checkAABBCollision(x, y, self.carpet.key) then
                    self.carpet.key.addedToInventory = true
                    inventory:insertItem(self.carpet.key)

                    self.savedItems.brown_key = true
                    love.filesystem.write('inventorySaved1.txt', json.encode(self.savedItems))
                end
            end

            -- if clicked on carpet
            if checkAABBCollision(x, y, self.carpet) then
                self.carpet.slideCarpet = true
            end

            if self.storeRoomOpened and checkAABBCollision(x, y, self.storeRoomDoorRevealed) then
                self.LeavingScene3 = true
                self.startingTransition.enable("vignette")
            end

            -- reveal the door to the basement
            if inventory.selectedItemId == 4 and self.storeRoomOpened == false and checkAABBCollision(x, y, self.storeRoomDoorInteractable) then
                self.storeRoomOpened = true
                self.savedItems.storeRoomOpened = true
                love.filesystem.write('inventorySaved1.txt', json.encode(self.savedItems))
            end

            -- if pressed on photo frame then disappear the photo frame
            if x > self.photoframeInteractable.x and x < self.photoframeInteractable.x + self.photoframeInteractable.width and y > self.photoframeInteractable.y and y < self.photoframeInteractable.y + self.photoframeInteractable.height and self.photoframeInteractable.disappear == false then
                self.photoframeInteractable.disappear = true
            end

            -- toggle the switch on and off
            if x > self.switchInteractable.x and x < self.switchInteractable.x + self.switchInteractable.width and y > self.switchInteractable.y and y < self.switchInteractable.y + self.switchInteractable.height then
                if self.switchInteractable.switchStatus == "on" then
                    self.switchInteractable.switchStatus = "off"
                    self.light.switchedOn = false
                else
                    self.switchInteractable.switchStatus = "on"
                    self.light.switchedOn = true
                end
            end

            -- add the screwbar once clicked on it
            if self.crowbar.addedToInventory == false and x > self.crowbar.x and x < self.crowbar.x + self.crowbar.width and y > self.crowbar.y and y < self.crowbar.y + self.crowbar.height then
                self.crowbar.addedToInventory = true
                inventory:insertItem(self.crowbar)

                self.savedItems.crowbar = true
                love.filesystem.write('inventorySaved1.txt', json.encode(self.savedItems))
            end
        else
            -- when dustbin popup is active
                if CloseActivePopUpWindow(x, y, self.popUpDustbin) then                
                self.popUpDustbin.blur.disable("boxblur")
            end

            -- if clicked outside the popUp paper disable the player
            if (self.popUpPaper.active) and (x < self.popUpPaper.x or x > self.popUpPaper.x + self.popUpPaper.width or y < self.popUpPaper.y or y > self.popUpPaper.y + self.popUpPaper.height) and (x < WINDOW_WIDTH - 100) then
                self.popUpPaper.active = false
                self.popUpDustbin.blur.disable("boxblur")
            end

            -- if clicked outside the popup of upper drawer close the drawer
            if CloseActivePopUpWindow(x, y, self.UpperlockerPopup) then
                self.popUpDustbin.blur.disable("boxblur")
            end

            -- if clicked outside the popup of lower drawer close the drawer
            if CloseActivePopUpWindow(x, y, self.LowerlockerPopup) then
                self.popUpDustbin.blur.disable("boxblur")
            end

            if CloseActivePopUpWindow(x, y, self.electricBoardPopup) then
                self.popUpDustbin.blur.disable("boxblur")
            end

            if CloseActivePopUpWindow(x, y, self.enterPinPopup) then
                self.popUpDustbin.blur.disable("boxblur")
            end

            if self.enterPinPopup.active then
                self:pinPressed(x, y, self.allButtons)
            end

            if self.popUpPaper.active then
                self.popUpPaper.eraserActive = true
            end

            if self.popUpDustbin.active and not self.screwdriver.addedToInventory then
                if checkAABBCollision(x, y, self.screwdriver) then
                    self.screwdriver.addedToInventory = true
                    inventory:insertItem(self.screwdriver)

                    self.savedItems.screwDriver = true
                    love.filesystem.write('inventorySaved1.txt', json.encode(self.savedItems))
                end
            end

            if self.LowerlockerPopup.active and not self.LowerlockerPopup.rubber.addedToInventory then
                if checkAABBCollision(x, y, self.LowerlockerPopup.rubber) then
                    self.LowerlockerPopup.rubber.addedToInventory = true
                    inventory:insertItem(self.LowerlockerPopup.rubber)

                    self.savedItems.eraser = true
                    love.filesystem.write('inventorySaved1.txt', json.encode(self.savedItems))
                end
            end

            if self.electricBoardPopup.active and not self.electricBoardPopup.battery.addedToInventory then
                if self.electricBoardPopup.battery.addedToInventory == false and checkAABBCollision(x, y, self.electricBoardPopup.battery) then
                    self.electricBoardPopup.battery.addedToInventory = true
                    inventory:insertItem(self.electricBoardPopup.battery)

                    self.savedItems.battery = true
                    love.filesystem.write('inventorySaved1.txt', json.encode(self.savedItems))
                end
            end
        end
    end
    inventory:mousepressed(x, y, button)
end

function Room2:mousemoved(x, y, dx, dy, isTouch)
    if self.popUpPaper.active and self.popUpPaper.eraserActive and inventory.selectedItemId == 5 then
        if x > self.popUpPaper.x and x < self.popUpPaper.x + self.popUpPaper.width and y > self.popUpPaper.y and y < self.popUpPaper.y + self.popUpPaper.height then
            self.popUpPaper.dirtyImageAlpha = self.popUpPaper.dirtyImageAlpha - 0.016 / 5
            self.popUpPaper.imageAlpha = self.popUpPaper.imageAlpha + 0.016 / 5
        end
    end

    inventory:mousemoved(x, y, dx, dy, isTouch)
end

function Room2:mousereleased(x, y, button, isTouch)
    if self.popUpPaper.active then
        self.popUpPaper.eraserActive = false
    end


    inventory:mousereleased(x, y, button, isTouch)
end

function Room2:update(dt)
    if self.EnteringScene then
        self.startingTransitionRadius = math.min(2, self.startingTransitionRadius + dt)
        self.startingTransition.vignette.radius = self.startingTransitionRadius
        if self.startingTransitionRadius >= 2 then
            self.EnteringScene = false
            self.startingTransition.disable("vignette")
        end
    end

    if self.LeavingScene4 then
        self.startingTransitionRadius = math.max(0, self.startingTransitionRadius - dt)
        self.startingTransition.vignette.radius = self.startingTransitionRadius

        if self.startingTransitionRadius <= 0 then
            self.startingTransition.disable("vignette")
            gStateMachine:change("room4")
        end
    end

    if self.LeavingScene3 then
        self.startingTransitionRadius = math.max(0, self.startingTransitionRadius - dt)
        self.startingTransition.vignette.radius = self.startingTransitionRadius

        if self.startingTransitionRadius <= 0 then
            self.startingTransition.disable("vignette")
            gStateMachine:change("room3")
        end
    end
    

    if self.photoframeInteractable.disappear then
        self.photoframeInteractable.alpha = self.photoframeInteractable.lerp(1, 0, self.photoframeInteractable.lerpProgress)
        self.photoframeInteractable.lerpProgress = self.photoframeInteractable.lerpProgress + dt

        if self.photoframeInteractable.lerpProgress > 1 then
            self.photoframeInteractable.lerpProgress = 1
        end
    end

    if self.popUpDustbin.active then
        UpdateAlphaBlurVariables(self.popUpDustbin, dt)
    end

    if self.UpperlockerPopup.active then
        UpdateAlphaBlurVariables(self.UpperlockerPopup, dt)
    end

    if self.LowerlockerPopup.active then
        UpdateAlphaBlurVariables(self.LowerlockerPopup, dt)
    end

    if self.electricBoardPopup.active then
        UpdateAlphaBlurVariables(self.electricBoardPopup, dt)
    end

    if self.enterPinPopup.active then
        UpdateAlphaBlurVariables(self.enterPinPopup, dt)
    end

    -- move the carpet down
    if self.carpet.slideCarpet then
        self.carpet.y = math.min(self.carpet.y + 50 * dt, 580)
    end
end

function Room2:render()
    self.startingTransition(
        function ()
            if self.light.switchedOn then
                love.graphics.setColor(1, 1, 1, 1)
            else
                love.graphics.setColor(0.6, 0.6, 0.6, 1)
            end

            self.popUpDustbin.blur(
                function ()
                    love.graphics.draw(self.backgroundImage, 0, 0, 0, WINDOW_WIDTH/self.backgroundImage:getWidth(), WINDOW_HEIGHT/self.backgroundImage:getHeight())
        
                    self.light.render()
        
                    self.dustBinInteractable.render()
                    self.switchInteractable.render()
                    if self.storeRoomOpened then
                        self.storeRoomDoorRevealed.render()
                    else
                        self.storeRoomDoorInteractable.render()
                    end
                    
                    self.locker.render()
                    self.locker.upper.render()
                    self.locker.lower.render()
        
                    self.carpet.key.render()
                    self.carpet.render()
        
                    self.beer_bottle.render()
        
                    self.electricBoard.render()
        
                    self.enterPinInteractive.render()
        
                    love.graphics.setColor(1, 1, 1, self.photoframeInteractable.alpha)
                    self.photoframeInteractable.render()
                    love.graphics.setColor(1, 1, 1)
                    self.paperBallInteractable.render()
        
                    self.crowbar.render()
                end
            )
        
            if self.popUpDustbin.active then
                love.graphics.setColor(1, 1, 1, self.popUpDustbin.alphaInitial)
                love.graphics.draw(self.popUpDustbin.image, self.popUpDustbin.x, self.popUpDustbin.y, 0, self.popUpDustbin.width/self.popUpDustbin.image:getWidth(), self.popUpDustbin.height/self.popUpDustbin.image:getHeight())
                if not self.screwdriver.addedToInventory then
                    self.screwdriver.render()
                end
                love.graphics.setColor(1, 1, 1, 1)
            end
        
            if self.popUpPaper.active then
                love.graphics.setColor(1, 1, 1, self.popUpPaper.imageAlpha)
                love.graphics.draw(self.popUpPaper.image, self.popUpPaper.x, self.popUpPaper.y, 0, self.popUpPaper.width/self.popUpPaper.image:getWidth(), self.popUpPaper.height/self.popUpPaper.image:getHeight())
                love.graphics.setColor(1, 1, 1, self.popUpPaper.dirtyImageAlpha)
                love.graphics.draw(self.popUpPaper.dirtyImage, self.popUpPaper.x, self.popUpPaper.y, 0, self.popUpPaper.width/self.popUpPaper.image:getWidth(), self.popUpPaper.height/self.popUpPaper.image:getHeight())
                love.graphics.setColor(1, 1, 1, 1)
            end
        
            if self.LowerlockerPopup.active then
                love.graphics.setColor(1, 1, 1, self.LowerlockerPopup.alphaInitial)
                love.graphics.draw(self.LowerlockerPopup.image, self.LowerlockerPopup.x, self.LowerlockerPopup.y, 0, self.LowerlockerPopup.width/self.LowerlockerPopup.image:getWidth(), self.LowerlockerPopup.height/self.LowerlockerPopup.image:getHeight())
                if not self.LowerlockerPopup.rubber.addedToInventory then
                    self.LowerlockerPopup.rubber.render()
                end
                love.graphics.setColor(1, 1, 1, 1)
            end
        
            if self.UpperlockerPopup.active then
                love.graphics.setColor(1, 1, 1, self.UpperlockerPopup.alphaInitial)
                love.graphics.draw(self.UpperlockerPopup.image, self.UpperlockerPopup.x, self.UpperlockerPopup.y, 0, self.UpperlockerPopup.width/self.UpperlockerPopup.image:getWidth(), self.UpperlockerPopup.height/self.UpperlockerPopup.image:getHeight())
                love.graphics.setColor(1, 1, 1, 1)
            end
        
            if self.electricBoardPopup.active then
                love.graphics.setColor(1, 1, 1, self.electricBoardPopup.alphaInitial)
                self.electricBoardPopup.render()
                self.electricBoardPopup.battery.render()
                love.graphics.setColor(1, 1, 1, 1)
            end
        
            if self.enterPinPopup.active then
                love.graphics.setColor(1, 1, 1, self.enterPinPopup.alphaInitial)
                self.enterPinPopup.render()
                love.graphics.setColor(1, 1, 1, 1)
                for key, value in pairs(self.allButtons) do
                    value:render()
                end
                for i = 1, math.min(4, #self.enterPinPopup.text) do
                    love.graphics.setColor(self.textColor[i])
                    love.graphics.printf(string.sub(self.enterPinPopup.text, i, i), self.enterPinPopup.x + i * 10, self.enterPinPopup.y, self.enterPinPopup.width, "center")
                end
            end

            if not self.light.switchedOn then
                self.digit_glow.render()
            end

            inventory:render()

            if MOUSE_ASSET ~= nil then
                --love.mouse.setVisible(false)
                local mouseX, mouseY = push:toGame(love.mouse.getPosition())
                love.graphics.draw(MOUSE_ASSET, mouseX, mouseY, 0, 100/MOUSE_ASSET:getWidth(), 100/MOUSE_ASSET:getHeight(), MOUSE_ASSET:getWidth()/2, MOUSE_ASSET:getHeight()/2)
            end
        end
    )
end