Room3 = Class{__includes = BaseState}

WaterDrop = Class{}

function WaterDrop:init(x, y, width, height, image)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.image = image
    self.speed = math.random(200, 400)
    self.update = function (dt)
        self.y = self.y + self.speed * dt
    end
    self.render = function ()
        love.graphics.draw(self.image, self.x, self.y, 0, self.width/self.image:getWidth(), self.height/self.image:getHeight())
    end
end

function Room3:init()
    self.backgroundImage = love.graphics.newImage('assets/room3/room3.png')

    --------background music----------------
    self.backgroundWaterSound = love.audio.newSource('assets/room3/water_dripping_sound.mp3', "stream")
    self.backgroundWaterSound:play()
    self.backgroundWaterSound:setLooping(true)

    ----------water_droplet------------
    self.allWaterDrops = {}
    self.waterDropletTimer = math.random(1, 2)
    self.waterDropletWaiting = 0
    self.waterDropletImage = love.graphics.newImage('assets/room3/water_droplet.png')

    -----------------------------------------------------LADDER---------------------------------------------------------------------------
    self.ladderToRoom2 = PlacableItems(560, 0, 180, 580, nil)
    self.ladderToRoom2.render = function ()
        love.graphics.rectangle("line", self.ladderToRoom2.x, self.ladderToRoom2.y, self.ladderToRoom2.width, self.ladderToRoom2.height)
    end

    -----------------------------------------WATER PIPELINE--------------------------------------------------------------------------------
    self.waterPipeLine = PlacableItems(450, 700, 150, 100, love.graphics.newImage('assets/room3/cock_off.png'))
    self.waterPipeLine.removedDirt = false
    self.waterPipeLine.wireOnPipeline = PlacableItems(450, 700, 150, 100, love.graphics.newImage('assets/room3/wire_on_cock.png'))
    self.waterPipeLine.wireOnPipeline.alpha = 1
    self.waterPipeLine.OnCock = PlacableItems(450, 700, 150, 100, love.graphics.newImage('assets/room3/cock.png'))
    self.waterPipeLine.PlaceOnCock = false
    self.waterPipeLine.render = function ()
        if not self.waterPipeLine.PlaceOnCock then
            love.graphics.draw(self.waterPipeLine.image, self.waterPipeLine.x, self.waterPipeLine.y, 0, self.waterPipeLine.width/self.waterPipeLine.image:getWidth(), self.waterPipeLine.height/self.waterPipeLine.image:getHeight())
        else
            self.waterPipeLine.OnCock.render()
        end
    end


    --------------------------------------------WATER TANK----------------------------------------------------------
    self.waterTankInteractable = PlacableItems(850, 400, 262, 300, love.graphics.newImage('assets/room3/water_tank.png'))
    self.waterTankPopup = PopupWindow(love.graphics.newImage('assets/room3/watertank_top_water.png'), 0.6, 0.6)
    self.waterTankPopup.emptyWater = false
    self.waterTankPopup.revealedImage = love.graphics.newImage('assets/room3/watertank_water_empty.png')
    self.waterTankPopup.render = function ()
        if not self.waterTankPopup.emptyWater then
            love.graphics.draw(self.waterTankPopup.image, self.waterTankPopup.x, self.waterTankPopup.y, 0, self.waterTankPopup.width/self.waterTankPopup.image:getWidth(), self.waterTankPopup.height/self.waterTankPopup.image:getHeight())
        else
            love.graphics.draw(self.waterTankPopup.revealedImage, self.waterTankPopup.x, self.waterTankPopup.y, 0, self.waterTankPopup.width/self.waterTankPopup.revealedImage:getWidth(), self.waterTankPopup.height/self.waterTankPopup.revealedImage:getHeight())
        end
    end
    self.waterTankPopup.alpha = 1

    --self.waterTankPopupRevealed = PopupWindow(love.graphics.newImage('assets/room3/watertank_water_empty.png'), 0.6, 0.6)
    -- self.waterTankPopupRevealed.yellow_key = InventoryPlacableItems(WINDOW_WIDTH/2, WINDOW_HEIGHT/2, 100, 100, )
    -----------------------------------------------SINK-----------------------------------------
    self.sinkInteractable = PlacableItems(230, 350, 200, 150, love.graphics.newImage('assets/room3/sink.png'))

    --------------------------------------------------MIRROR----------------------------------------------------------------------------------
    self.mirrorInteractable = PlacableItems(200, 210, 200, 200, love.graphics.newImage('assets/room3/mirror.png'))
    self.mirrorInteractable.hidden = false
    self.mirrorInteractable.alpha = 1

    ----------------------------------------------------------------------------------------------------------------------
    self.modifiedV = moonshine(WINDOW_WIDTH, WINDOW_HEIGHT, moonshine.effects.modified_vignette).chain(moonshine.effects.boxblur)
    self.modifiedV.modified_vignette.radius = 150
    self.modifiedV.modified_vignette.opacity = 0.3
    -- self.modifiedV.disable("modified_vignette")
    self.modifiedV.boxblur.radius = {20, 20}
    self.modifiedV.disable("boxblur")
end

function Room3:update(dt)
    local mouseX, mouseY = push:toGame(love.mouse.getPosition())
    if mouseX ~= nil and mouseY ~= nil then
        self.modifiedV.modified_vignette.position = {mouseX, mouseY}
    end

    if self.mirrorInteractable.hidden then
        self.mirrorInteractable.alpha = self.mirrorInteractable.alpha - dt
    end

    self.waterDropletWaiting = self.waterDropletWaiting + dt
    if self.waterDropletWaiting > self.waterDropletTimer then
        table.insert(self.allWaterDrops, WaterDrop(math.random(0, WINDOW_WIDTH), 0, 30, 30, self.waterDropletImage))
        self.waterDropletWaiting = 0
        self.waterDropletTimer = math.random(1, 3)
    end

    if self.waterPipeLine.removedDirt then
        self.waterPipeLine.wireOnPipeline.alpha = math.max(self.waterPipeLine.wireOnPipeline.alpha - dt, 0)
    end


    for key, value in pairs(self.allWaterDrops) do
        value.update(dt)
    end
end

function Room3:mousepressed(x, y, button, istouch)
    if button == 1 then
        if (not self.waterTankPopup.active) then
            -- if clicked on water tank
            if checkAABBCollision(x, y, self.waterTankInteractable) then
                self.modifiedV.enable("boxblur")
                -- self.modifiedV.disable("modified_vignette")
                self.waterTankPopup.active = true
            end  

            if checkAABBCollision(x, y, self.ladderToRoom2) then
                gStateMachine:change('room2')
            end

            if checkAABBCollision(x, y, self.mirrorInteractable) then
                self.mirrorInteractable.hidden = true
            end
            if self.waterPipeLine.removedDirt and checkAABBCollision(x, y, self.waterPipeLine) then
                self.waterPipeLine.PlaceOnCock = true
                self.waterTankPopup.emptyWater = true
            end

            if not self.waterPipeLine.removedDirt and checkAABBCollision(x, y, self.waterPipeLine.wireOnPipeline) then
                self.waterPipeLine.removedDirt = true
            end
        else
            if self.waterTankPopup.active then
                if CloseActivePopUpWindow(x, y, self.waterTankPopup) then
                    self.modifiedV.disable("boxblur")
                    self.modifiedV.enable("modified_vignette")
                end
            end
        end
    end
end

function Room3:render()
    self.modifiedV(
        function ()
            love.graphics.draw(self.backgroundImage)

            self.ladderToRoom2.render()


            love.graphics.setColor(1, 1, 1, self.mirrorInteractable.alpha)
            self.mirrorInteractable.render()
            love.graphics.setColor(1, 1, 1, 1)
            

            self.sinkInteractable.render()

            self.waterTankInteractable.render()

            self.waterPipeLine.render()
            love.graphics.setColor(1, 1, 1, self.waterPipeLine.wireOnPipeline.alpha)
            self.waterPipeLine.wireOnPipeline.render()
            love.graphics.setColor(1, 1, 1, 1)

            for key, value in pairs(self.allWaterDrops) do
                value.render()
            end
        end
    )

    if self.waterTankPopup.active then
        love.graphics.setColor(1, 1, 1, self.waterTankPopup.alpha)
        self.waterTankPopup.render()
        love.graphics.setColor(1, 1, 1, 1)
    end

    -- if self.waterTankPopupRevealed.active then
    --     self.waterTankPopupRevealed.render()
    -- end
end

function Room3:exit()
    self.backgroundWaterSound:stop()
end