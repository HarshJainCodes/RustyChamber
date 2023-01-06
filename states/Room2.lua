Room2 = Class{__includes = BaseState}

function Room2:init()
    self.id = 2
    self.backgroundImage = love.graphics.newImage('assets/room2/room2.png')

    

    --------------------------------------------------- CONTAINS DUSTBIN INTERACTIVE AND POPUP WINDOW---------------------------------------------------------
    self.dustBinInteractable = {}
    self.dustBinInteractable.x = 450
    self.dustBinInteractable.y = 470
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
    self.storeRoomDoorInteractable.x = 550
    self.storeRoomDoorInteractable.y = 600
    self.storeRoomDoorInteractable.width = 225
    self.storeRoomDoorInteractable.height = 150
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
    self.paperBallInteractable.x = 400
    self.paperBallInteractable.y = 550
    self.paperBallInteractable.width = 40
    self.paperBallInteractable.height = 40
    self.paperBallInteractable.image = love.graphics.newImage('assets/room2/paper.png')
    self.paperBallInteractable.render = function ()
        love.graphics.draw(self.paperBallInteractable.image, self.paperBallInteractable.x, self.paperBallInteractable.y, 0, self.paperBallInteractable.width/self.paperBallInteractable.image:getWidth(), self.paperBallInteractable.height/self.paperBallInteractable.image:getHeight())
    end

    self.popUpPaper = {}
    self.popUpPaper.image = love.graphics.newImage('assets/room2/paper_pin.png')
    self.popUpPaper.active = false
    self.popUpPaper.width = 0.75 * self.popUpPaper.image:getWidth()
    self.popUpPaper.height = 0.75 * self.popUpPaper.image:getHeight()
    self.popUpPaper.x = WINDOW_WIDTH/2 - self.popUpPaper.width/2
    self.popUpPaper.y = WINDOW_HEIGHT/2 - self.popUpPaper.height/2
    self.popUpPaper.alphaInitial = 0
    self.popUpPaper.alphaFinal = 1
    self.popUpPaper.alphaProgress = 0
    self.popUpPaper.lerp = function (start, finish, t)
        return start + (finish - start) * t
    end
    
    ---------------------------------------------ITEMS THAT CAN BE ADDED TO THE INVENTORY
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
end

function Room2:mousepressed(x, y, button, isTouch)
    if button == 1 then
        -- check if clicked on the photo
        if (not self.popUpDustbin.active) and (not self.popUpPaper.active) then
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

            if x > self.photoframeInteractable.x and x < self.photoframeInteractable.x + self.photoframeInteractable.width and y > self.photoframeInteractable.y and y < self.photoframeInteractable.y + self.photoframeInteractable.height and self.photoframeInteractable.disappear == false then
                self.photoframeInteractable.disappear = true
            end

            if x > self.switchInteractable.x and x < self.switchInteractable.x + self.switchInteractable.width and y > self.switchInteractable.y and y < self.switchInteractable.y + self.switchInteractable.height then
                if self.switchInteractable.switchStatus == "on" then
                    self.switchInteractable.switchStatus = "off"
                else
                    self.switchInteractable.switchStatus = "on"
                end
            end
        else
            -- when dustbin popup is active
            if (self.popUpDustbin.active) and (x < self.popUpDustbin.x or x > self.popUpDustbin.x + self.popUpDustbin.width or y < self.popUpDustbin.y or y > self.popUpDustbin.y + self.popUpDustbin.height) and (x < WINDOW_WIDTH - 100) then
                self.popUpDustbin.active = false
                self.popUpDustbin.blur.disable("boxblur")
                self.popUpDustbin.aplhaInitial = 0
                self.popUpDustbin.alphaProgress = 0
            end

            if (self.popUpPaper.active) and (x < self.popUpPaper.x or x > self.popUpPaper.x + self.popUpPaper.width or y < self.popUpPaper.y or y > self.popUpPaper.y + self.popUpPaper.height) then
                self.popUpPaper.active = false
                self.popUpDustbin.blur.disable("boxblur")
                self.popUpPaper.aplhaInitial = 0
                self.popUpPaper.alphaProgress = 0
            end

            if not self.screwdriver.addedToInventory then
                if x > self.screwdriver.x and x < self.screwdriver.x + self.screwdriver.width and y > self.screwdriver.y and y < self.screwdriver.y + self.screwdriver.height then
                    self.screwdriver.addedToInventory = true
                    inventory:insertItem(self.screwdriver)
                end
            end
        end

        inventory:mousepressed(x, y)
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

    if self.popUpPaper.active then
        self.popUpPaper.alphaProgress = self.popUpPaper.alphaProgress + dt
        self.popUpPaper.alphaInitial = self.popUpPaper.lerp(0, 1, self.popUpPaper.alphaProgress)

        if self.popUpPaper.alphaInitial > self.popUpPaper.alphaFinal then
            self.popUpPaper.alphaInitial = self.popUpPaper.alphaFinal
        end
    end
end

function Room2:render()

    self.popUpDustbin.blur(
        function ()
            love.graphics.draw(self.backgroundImage, 0, 0, 0, WINDOW_WIDTH/self.backgroundImage:getWidth(), WINDOW_HEIGHT/self.backgroundImage:getHeight())

            self.dustBinInteractable.render()
            self.switchInteractable.render()
            self.storeRoomDoorInteractable.render()

            love.graphics.setColor(1, 1, 1, self.photoframeInteractable.aplha)
            self.photoframeInteractable.render()
            love.graphics.setColor(1, 1, 1)
            self.paperBallInteractable.render()
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
        love.graphics.setColor(1, 1, 1, self.popUpPaper.alphaInitial)
        love.graphics.draw(self.popUpPaper.image, self.popUpPaper.x, self.popUpPaper.y, 0, self.popUpPaper.width/self.popUpPaper.image:getWidth(), self.popUpPaper.height/self.popUpPaper.image:getHeight())
        love.graphics.setColor(1, 1, 1, 1)
    end
    
    inventory:render()
end