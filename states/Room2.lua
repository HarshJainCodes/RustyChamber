Room2 = Class{__includes = BaseState}

function Room2:init()
    self.id = 2
    self.backgroundImage = love.graphics.newImage('assets/room2/room2background.png')

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
    self.dustBinInteractable = {}
    self.dustBinInteractable.x = 150
    self.dustBinInteractable.y = 550
    self.dustBinInteractable.width = 80
    self.dustBinInteractable.height = 120
    self.dustBinInteractable.image = love.graphics.newImage('assets/room2/dustbin.png')
    self.dustBinInteractable.render = function ()
        love.graphics.draw(self.dustBinInteractable.image, self.dustBinInteractable.x, self.dustBinInteractable.y, 0, self.dustBinInteractable.width/self.dustBinInteractable.image:getWidth(), self.dustBinInteractable.height/self.dustBinInteractable.image:getHeight())
        -- love.graphics.rectangle("fill", self.dustBinInteractable.x, self.dustBinInteractable.y, self.dustBinInteractable.width, self.dustBinInteractable.height)
    end

    self.popUpDustbin = {}
    self.popUpDustbin.image = love.graphics.newImage('assets/room2/dustbin_close_up.png')
    self.popUpDustbin.active = false
    self.popUpDustbin.x = WINDOW_WIDTH/2 - self.popUpDustbin.image:getWidth()/2
    self.popUpDustbin.y = WINDOW_HEIGHT/2 - self.popUpDustbin.image:getHeight()/2
    self.popUpDustbin.width = self.popUpDustbin.image:getWidth()
    self.popUpDustbin.height = self.popUpDustbin.image:getHeight()
    self.popUpDustbin.aplhaInitial = 0
    self.popUpDustbin.alphaFinal = 1
    self.popUpDustbin.alphaProgress = 0
    self.popUpDustbin.lerp = function (start, finish, t)
        return start + (finish - start) * t
    end
    self.popUpDustbin.blur = moonshine(WINDOW_WIDTH, WINDOW_HEIGHT, moonshine.effects.boxblur)
    self.popUpDustbin.blur.boxblur.radius = {20, 20}
    self.popUpDustbin.blur.disable("boxblur")


    ------------------------------------------------CONTAINS SWITCH INTERACTIVE CODE----------------------------------------------------------------------
    self.switchInteractable = {}
    self.switchInteractable.x = 470
    self.switchInteractable.y = 260
    self.switchInteractable.width = 40
    self.switchInteractable.height = 40
    self.switchInteractable.switchStatus = "off"
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
    self.storeRoomDoorInteractable = {}
    self.storeRoomDoorInteractable.x = 560
    self.storeRoomDoorInteractable.y = 650
    self.storeRoomDoorInteractable.width = 200
    self.storeRoomDoorInteractable.height = 133
    self.storeRoomDoorInteractable.image = love.graphics.newImage('assets/room2/store_room_door.png')
    self.storeRoomDoorInteractable.render = function ()
        love.graphics.draw(self.storeRoomDoorInteractable.image, self.storeRoomDoorInteractable.x, self.storeRoomDoorInteractable.y, 0, self.storeRoomDoorInteractable.width/self.storeRoomDoorInteractable.image:getWidth(), self.storeRoomDoorInteractable.height/self.storeRoomDoorInteractable.image:getHeight())
    end

    ---------------------------------------------CONTAINS PHOTO FRAME INTERACTIVE CODE --------------------------------------------------------------------
    self.photoframeInteractable = {}
    self.photoframeInteractable.x = 230
    self.photoframeInteractable.y = 200
    self.photoframeInteractable.width = 150
    self.photoframeInteractable.height = 200
    self.photoframeInteractable.disappear = false
    self.photoframeInteractable.aplha = 1
    self.photoframeInteractable.lerpProgress = 0
    self.photoframeInteractable.lerp = function (start, finish, t)
        return start + (finish - start) * t
    end
    self.photoframeInteractable.image = love.graphics.newImage('assets/room2/photo_frame.png')
    self.photoframeInteractable.render = function ()
        love.graphics.draw(self.photoframeInteractable.image, self.photoframeInteractable.x, self.photoframeInteractable.y, 0, self.photoframeInteractable.width/self.photoframeInteractable.image:getWidth(), self.photoframeInteractable.height/self.photoframeInteractable.image:getHeight())
    end

    ---------------------------------------------CONTAINS PAPER BALL INTERACTIVE WINDOW --------------------------------------------------------------------
    self.paperBallInteractable = {}
    self.paperBallInteractable.x = 100
    self.paperBallInteractable.y = 650
    self.paperBallInteractable.width = 40
    self.paperBallInteractable.height = 40
    self.paperBallInteractable.image = love.graphics.newImage('assets/room2/paper.png')
    self.paperBallInteractable.render = function ()
        love.graphics.draw(self.paperBallInteractable.image, self.paperBallInteractable.x, self.paperBallInteractable.y, 0, self.paperBallInteractable.width/self.paperBallInteractable.image:getWidth(), self.paperBallInteractable.height/self.paperBallInteractable.image:getHeight())
    end

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
        love.graphics.rectangle("line", self.locker.upper.x, self.locker.upper.y, self.locker.upper.width, self.locker.upper.height)
    end

    self.locker.lower = {}
    self.locker.lower.x = 330
    self.locker.lower.y = 590
    self.locker.lower.width = 125
    self.locker.lower.height = 60
    self.locker.lower.render = function ()
        love.graphics.rectangle("line", self.locker.lower.x, self.locker.lower.y, self.locker.lower.width, self.locker.lower.height)
    end
    self.locker.render = function ()
        love.graphics.draw(self.locker.image, self.locker.x, self.locker.y, 0, self.locker.width/self.locker.image:getWidth(), self.locker.height/self.locker.image:getHeight())
    end

    -----------------------------------------------UPPER LOCKER POPUP--------------------------------------------------------------------------------------------
    self.UpperlockerPopup = {}
    self.UpperlockerPopup.image = love.graphics.newImage('assets/room2/drawer_locker.png')
    self.UpperlockerPopup.rubber = {}
    self.UpperlockerPopup.rubber.id = 5
    self.UpperlockerPopup.rubber.width = 109
    self.UpperlockerPopup.rubber.height = 70
    self.UpperlockerPopup.rubber.x = 400
    self.UpperlockerPopup.rubber.y = 400
    self.UpperlockerPopup.rubber.addedToInventory = false
    self.UpperlockerPopup.rubber.name = "Eraser"
    self.UpperlockerPopup.rubber.image = love.graphics.newImage('assets/room2/eraser.png')
    self.UpperlockerPopup.rubber.render = function ()
        love.graphics.draw(self.UpperlockerPopup.rubber.image, self.UpperlockerPopup.rubber.x, self.UpperlockerPopup.rubber.y, 0, self.UpperlockerPopup.rubber.width/self.UpperlockerPopup.rubber.image:getWidth(), self.UpperlockerPopup.rubber.height/self.UpperlockerPopup.rubber.image:getHeight())
    end

    self.UpperlockerPopup.width = self.UpperlockerPopup.image:getWidth()
    self.UpperlockerPopup.height = self.UpperlockerPopup.image:getHeight()
    self.UpperlockerPopup.x = WINDOW_WIDTH/2 - self.UpperlockerPopup.width/2
    self.UpperlockerPopup.y = WINDOW_HEIGHT/2 - self.UpperlockerPopup.height/2
    self.UpperlockerPopup.aplhaInitial = 0
    self.UpperlockerPopup.alphaProgress = 0
    self.UpperlockerPopup.aplhaFinal = 1
    self.UpperlockerPopup.active = false
    self.UpperlockerPopup.lerp = function (start, finish, t)
        return start + (finish - start) * t
    end

    -------------------------------------------------LOWER LOCKER POPUP----------------------------------------------------------------------------------
    self.LowerlockerPopup = {}
    self.LowerlockerPopup.image = love.graphics.newImage('assets/room2/drawer_locker.png')
    self.LowerlockerPopup.width = self.LowerlockerPopup.image:getWidth()
    self.LowerlockerPopup.height = self.LowerlockerPopup.image:getHeight()
    self.LowerlockerPopup.x = WINDOW_WIDTH/2 - self.LowerlockerPopup.width/2
    self.LowerlockerPopup.aplhaInitial = 0
    self.LowerlockerPopup.y = WINDOW_HEIGHT/2 - self.LowerlockerPopup.height/2
    self.LowerlockerPopup.alphaProgress = 0
    self.LowerlockerPopup.aplhaFinal = 1
    self.LowerlockerPopup.active = false
    self.LowerlockerPopup.lerp = function (start, finish, t)
        return start + (finish - start) * t
    end

    ---------------------------------------------ITEMS THAT CAN BE ADDED TO THE INVENTORY-------------------------------------------------------------------
    -- items that can be added to inventory
    self.screwdriver = {}
    self.screwdriver.id = 3
    self.screwdriver.width = 100
    self.screwdriver.height = 200
    self.screwdriver.x = 600
    self.screwdriver.y = 350
    self.screwdriver.addedToInventory = false
    self.screwdriver.image = love.graphics.newImage('assets/room2/screwdriver.png')
    self.screwdriver.name = "screwdriver"
    self.screwdriver.render = function ()
        if not self.screwdriver.addedToInventory then
            love.graphics.draw(self.screwdriver.image, self.screwdriver.x, self.screwdriver.y, 0, self.screwdriver.width/self.screwdriver.image:getWidth(), self.screwdriver.height/self.screwdriver.image:getHeight())
        end
    end


    self.crowbar = {}
    self.crowbar.id = 4
    self.crowbar.width = 100
    self.crowbar.height = 100
    self.crowbar.x = 1000
    self.crowbar.y = 650
    self.crowbar.addedToInventory = false
    self.crowbar.image = love.graphics.newImage('assets/room2/crowbar.png')
    self.crowbar.name = "crowbar"
    self.crowbar.render = function ()
        if not self.crowbar.addedToInventory then
            love.graphics.draw(self.crowbar.image, self.crowbar.x, self.crowbar.y, 0, self.crowbar.width/self.crowbar.image:getWidth(), self.crowbar.height/self.crowbar.image:getHeight())
        end
    end
end

function CloseActivePopUpWindow(x, y, popupWindow)
    if (popupWindow.active) and (x < popupWindow.x or x > popupWindow.x + popupWindow.width or y < popupWindow.y or y > popupWindow.y + popupWindow.height) and (x < WINDOW_WIDTH - 100) then
        popupWindow.active = false
        popupWindow.alphaProgress = 0
        popupWindow.alphaInitial = 0
        return true
    end
    return false
end

function checkAABBCollision(x, y, object)
    return x > object.x and x < object.x + object.width and y > object.y and y < object.y + object.height
end

function Room2:mousepressed(x, y, button, isTouch)
    if button == 1 then
        -- check if clicked on the photo
        if (not self.popUpDustbin.active) and (not self.popUpPaper.active) and (not self.UpperlockerPopup.active) and (not self.LowerlockerPopup.active) then
            -- if clicked on dustbin
            if x > self.dustBinInteractable.x and x < self.dustBinInteractable.x + self.dustBinInteractable.width and y > self.dustBinInteractable.y and y < self.dustBinInteractable.y + self.dustBinInteractable.height then
                self.popUpDustbin.active = true
                self.popUpDustbin.blur.enable("boxblur")
            end

            -- if clicked on paper
            if x > self.paperBallInteractable.x and x < self.paperBallInteractable.x + self.paperBallInteractable.width and y > self.paperBallInteractable.y and y < self.paperBallInteractable.y + self.paperBallInteractable.height then
                self.popUpPaper.active = true

                -- REMBERBER we are enabling the blur effect of the dustbin interface
                self.popUpDustbin.blur.enable("boxblur")
            end

            -- if clicked on upper locker
            if x > self.locker.upper.x and x < self.locker.upper.x + self.locker.upper.width and y > self.locker.upper.y and y < self.locker.upper.y + self.locker.upper.height then
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

            -- if clicked on carpet
            if checkAABBCollision(x, y, self.carpet) then
                self.carpet.slideCarpet = true
            end

            if self.carpet.slideCarpet then
                if checkAABBCollision(x, y, self.carpet.key) then
                    self.carpet.key.addedToInventory = true
                    inventory:insertItem(self.carpet.key)
                end
            end

            -- if pressed on photo frame then disappear the photo frame
            if x > self.photoframeInteractable.x and x < self.photoframeInteractable.x + self.photoframeInteractable.width and y > self.photoframeInteractable.y and y < self.photoframeInteractable.y + self.photoframeInteractable.height and self.photoframeInteractable.disappear == false then
                self.photoframeInteractable.disappear = true
            end

            -- toggle the switch on and off
            if x > self.switchInteractable.x and x < self.switchInteractable.x + self.switchInteractable.width and y > self.switchInteractable.y and y < self.switchInteractable.y + self.switchInteractable.height then
                if self.switchInteractable.switchStatus == "on" then
                    self.switchInteractable.switchStatus = "off"
                else
                    self.switchInteractable.switchStatus = "on"
                end
            end

            -- add the screwbar once clicked on it
            if self.crowbar.addedToInventory == false and x > self.crowbar.x and x < self.crowbar.x + self.crowbar.width and y > self.crowbar.y and y < self.crowbar.y + self.crowbar.height then
                self.crowbar.addedToInventory = true
                inventory:insertItem(self.crowbar)
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
 
            if self.popUpPaper.active then
                self.popUpPaper.eraserActive = true
            end

            if self.popUpDustbin.active and not self.screwdriver.addedToInventory then
                if checkAABBCollision(x, y, self.screwdriver) then
                    self.screwdriver.addedToInventory = true
                    inventory:insertItem(self.screwdriver)
                end
            end

            if self.UpperlockerPopup.active and not self.UpperlockerPopup.rubber.addedToInventory then
                if checkAABBCollision(x, y, self.UpperlockerPopup.rubber) then
                    self.UpperlockerPopup.rubber.addedToInventory = true
                    inventory:insertItem(self.UpperlockerPopup.rubber)
                end
            end
        end

        inventory:mousepressed(x, y)
    end
end

function Room2:mousemoved(x, y, dx, dy, isTouch)
    if self.popUpPaper.active and self.popUpPaper.eraserActive and inventory.selectedItemId == 5 then
        if x > self.popUpPaper.x and x < self.popUpPaper.x + self.popUpPaper.width and y > self.popUpPaper.y and y < self.popUpPaper.y + self.popUpPaper.height then
            self.popUpPaper.dirtyImageAlpha = self.popUpPaper.dirtyImageAlpha - 0.016 / 5
            self.popUpPaper.imageAlpha = self.popUpPaper.imageAlpha + 0.016 / 5
        end
    end
end

function Room2:mousereleased(x, y, button, isTouch)
    if self.popUpPaper.active then
        self.popUpPaper.eraserActive = false
    end
end

function Room2:update(dt)
    if self.photoframeInteractable.disappear then
        self.photoframeInteractable.aplha = self.photoframeInteractable.lerp(1, 0, self.photoframeInteractable.lerpProgress)
        self.photoframeInteractable.lerpProgress = self.photoframeInteractable.lerpProgress + dt
        if self.photoframeInteractable.lerpProgress > 1 then
            self.photoframeInteractable.lerpProgress = 1
        end
    end

    if self.popUpDustbin.active then
        self.popUpDustbin.alphaProgress = self.popUpDustbin.alphaProgress + dt
        self.popUpDustbin.aplhaInitial = self.popUpDustbin.lerp(0, 1, self.popUpDustbin.alphaProgress)

        if self.popUpDustbin.aplhaInitial > self.popUpDustbin.alphaFinal then
            self.popUpDustbin.aplhaInitial = self.popUpDustbin.alphaFinal
        end
    end

    if self.UpperlockerPopup.active then
        self.UpperlockerPopup.alphaProgress = self.UpperlockerPopup.alphaProgress + dt
        self.UpperlockerPopup.aplhaInitial = self.UpperlockerPopup.lerp(0, 1, self.UpperlockerPopup.alphaProgress)

        if self.UpperlockerPopup.aplhaInitial > self.UpperlockerPopup.aplhaFinal then
            self.UpperlockerPopup.aplhaInitial = self.UpperlockerPopup.aplhaFinal
        end
    end

    if self.LowerlockerPopup.active then
        self.LowerlockerPopup.alphaProgress = self.LowerlockerPopup.alphaProgress + dt
        self.LowerlockerPopup.aplhaInitial = self.LowerlockerPopup.lerp(0, 1, self.LowerlockerPopup.alphaProgress)

        if self.LowerlockerPopup.aplhaInitial > self.LowerlockerPopup.aplhaFinal then
            self.LowerlockerPopup.aplhaInitial = self.LowerlockerPopup.aplhaFinal
        end
    end

    if self.carpet.slideCarpet then
        self.carpet.y = math.min(self.carpet.y + 50 * dt, 580)
    end
end

function Room2:render()

    self.popUpDustbin.blur(
        function ()
            love.graphics.draw(self.backgroundImage, 0, 0, 0, WINDOW_WIDTH/self.backgroundImage:getWidth(), WINDOW_HEIGHT/self.backgroundImage:getHeight())

            self.dustBinInteractable.render()
            self.switchInteractable.render()
            self.storeRoomDoorInteractable.render()
            self.locker.render()
            self.locker.upper.render()
            self.locker.lower.render()

            self.carpet.key.render()
            self.carpet.render()

            love.graphics.setColor(1, 1, 1, self.photoframeInteractable.aplha)
            self.photoframeInteractable.render()
            love.graphics.setColor(1, 1, 1)
            self.paperBallInteractable.render()

            self.crowbar.render()
        end
    )

    if self.popUpDustbin.active then
        love.graphics.setColor(1, 1, 1, self.popUpDustbin.aplhaInitial)
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

    if self.UpperlockerPopup.active then
        love.graphics.setColor(1, 1, 1, self.UpperlockerPopup.aplhaInitial)
        love.graphics.draw(self.UpperlockerPopup.image, self.UpperlockerPopup.x, self.UpperlockerPopup.y, 0, self.UpperlockerPopup.width/self.UpperlockerPopup.image:getWidth(), self.UpperlockerPopup.height/self.UpperlockerPopup.image:getHeight())
        if not self.UpperlockerPopup.rubber.addedToInventory then
            self.UpperlockerPopup.rubber.render()
        end
        love.graphics.setColor(1, 1, 1, 1)
    end

    if self.LowerlockerPopup.active then
        love.graphics.setColor(1, 1, 1, self.LowerlockerPopup.aplhaInitial)
        love.graphics.draw(self.LowerlockerPopup.image, self.LowerlockerPopup.x, self.LowerlockerPopup.y, 0, self.LowerlockerPopup.width/self.LowerlockerPopup.image:getWidth(), self.LowerlockerPopup.height/self.LowerlockerPopup.image:getHeight())
        love.graphics.setColor(1, 1, 1, 1)
    end
    inventory:render()
end