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
    self.backgroundImage = love.graphics.newImage('assets/room3/room3_background.png')

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
    -- self.ladderToRoom2.render = function ()
    --     love.graphics.rectangle("line", self.ladderToRoom2.x, self.ladderToRoom2.y, self.ladderToRoom2.width, self.ladderToRoom2.height)
    -- end

    -----------------------------------------WATER PIPELINE--------------------------------------------------------------------------------
    self.waterPipeLine = PlacableItems(450, 700, 150, 100, love.graphics.newImage('assets/room3/cock_off.png'))
    self.waterPipeLine.removedDirt = false
    self.waterPipeLine.wireOnPipeline = PlacableItems(450, 700, 150, 100, love.graphics.newImage('assets/room3/wire_on_cock.png'))
    self.waterPipeLine.wireOnPipeline.alpha = 1
    self.waterPipeLine.OnCock = PlacableItems(450, 700, 150, 100, love.graphics.newImage('assets/room3/cock.png'))
    self.waterPipeLine.PlaceOnCock = false
    self.waterPipeLine.water_tank_sound = love.audio.newSource('assets/room3/water_tank_empty_sound.mp3', 'static')
    self.waterPipeLine.render = function ()
        if not self.waterPipeLine.PlaceOnCock then
            love.graphics.draw(self.waterPipeLine.image, self.waterPipeLine.x, self.waterPipeLine.y, 0, self.waterPipeLine.width/self.waterPipeLine.image:getWidth(), self.waterPipeLine.height/self.waterPipeLine.image:getHeight())
        else
            self.waterPipeLine.OnCock.render()
        end
    end

    --------------------------------------------------DIRT--------------------------------------------------------------------
    self.Dirt = PlacableItems(430, 330, 140, 140, love.graphics.newImage('assets/room3/dirt.png'))
    self.Dirt.visibleAlpha = 1
    self.Dirt.render = function ()
        love.graphics.setColor(1, 1, 1, self.Dirt.visibleAlpha)
        love.graphics.draw(self.Dirt.image, self.Dirt.x, self.Dirt.y, 0, self.Dirt.width/self.Dirt.image:getWidth(), self.Dirt.height/self.Dirt.image:getHeight())
        love.graphics.setColor(1, 1, 1)
    end

    -----------------------------------------TOOL BOX----------------------------------------------------------------------------------
    self.toolBox = PlacableItems(200, 580, 150, 100, love.graphics.newImage('assets/room3/toolBox.png'))
    self.toolBoxPopup = PopupWindow(love.graphics.newImage('assets/room3/toolbox_closeup.png'), 2, 2)

    --------------------------------------------WATER TANK----------------------------------------------------------
    self.waterTankInteractable = PlacableItems(850, 400, 262, 300, love.graphics.newImage('assets/room3/water_tank.png'))
    self.waterTankPopup = PopupWindow(love.graphics.newImage('assets/room3/watertank_top_water.png'), 0.6, 0.6)
    self.waterTankPopup.emptyWater = false
    self.waterTankPopup.revealedImage = love.graphics.newImage('assets/room3/watertank_water_empty.png')
    self.waterTankPopup.yellow_key = InventoryPlacableItems(620, 400, 80, 80, 12, love.graphics.newImage('assets/room3/key_yellow.png'), "yellow key")

    self.waterTankPopup.render = function ()
        if not self.waterTankPopup.emptyWater then
            love.graphics.draw(self.waterTankPopup.image, self.waterTankPopup.x, self.waterTankPopup.y, 0, self.waterTankPopup.width/self.waterTankPopup.image:getWidth(), self.waterTankPopup.height/self.waterTankPopup.image:getHeight())
        else
            love.graphics.draw(self.waterTankPopup.revealedImage, self.waterTankPopup.x, self.waterTankPopup.y, 0, self.waterTankPopup.width/self.waterTankPopup.revealedImage:getWidth(), self.waterTankPopup.height/self.waterTankPopup.revealedImage:getHeight())
            if not self.waterTankPopup.yellow_key.addedToInventory then
                if yellow_key == true then 
                    self.waterTankPopup.yellow_key.render()
                    --yellow_key=false
                end 
            end
        end
    end
    self.waterTankPopup.alpha = 1

    --self.waterTankPopupRevealed = PopupWindow(love.graphics.newImage('assets/room3/watertank_water_empty.png'), 0.6, 0.6)
    -- self.waterTankPopupRevealed.yellow_key = InventoryPlacableItems(WINDOW_WIDTH/2, WINDOW_HEIGHT/2, 100, 100, )
    -----------------------------------------------SINK-----------------------------------------
    self.sinkInteractable = PlacableItems(230, 350, 200, 150, love.graphics.newImage('assets/room3/sink.png'))

    --------------------------------------------------MIRROR----------------------------------------------------------------------------------
    self.mirrorInteractable = PlacableItems(200, 210, 200, 200, love.graphics.newImage('assets/room3/mirror.png'))
    self.mirrorInteractable.glass_sound = love.audio.newSource('assets/room3/glass_smash.mp3', 'static')
    -- self.mirrorInteractable.hidden = false
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

    if mirrorHidden then
        self.mirrorInteractable.alpha = self.mirrorInteractable.alpha - dt
    end

    if dirtErased then
        self.Dirt.visibleAlpha = math.max(0, self.Dirt.visibleAlpha - dt)
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
        if (not self.waterTankPopup.active) and (not self.toolBoxPopup.active) then
            -- if clicked on water tank
            if checkAABBCollision(x, y, self.waterTankInteractable) then
                self.modifiedV.enable("boxblur")
                -- self.modifiedV.disable("modified_vignette")
                self.waterTankPopup.active = true
            end

            if checkAABBCollision(x, y, self.toolBox) then
                self.modifiedV.enable("boxblur")
                self.toolBoxPopup.active = true
            end

            if checkAABBCollision(x, y, self.ladderToRoom2) then
                gStateMachine:change('room2')
            end

            if inventory.selectedItemId == 8 and  not dirtErased and checkAABBCollision(x, y, self.Dirt) then
                dirtErased = true

                savedItems2.dirtErased = true
                love.filesystem.write('inventorySaved2.txt', json.encode(savedItems2))
            end

            if not soapAndWater.addedToInventory and checkAABBCollision(x, y, soapAndWater) then
                inventory:insertItem(soapAndWater)
                soapAndWater.addedToInventory = true

                savedItems2.soapAndWater = true
                love.filesystem.write('inventorySaved2.txt', json.encode(savedItems2))
            end

            if not mirorHidden and checkAABBCollision(x, y, self.mirrorInteractable) then
                mirrorHidden = true
                self.mirrorInteractable.glass_sound:play()
                savedItems2.mirrorHidden = true
                love.filesystem.write('inventorySaved2.txt', json.encode(savedItems2))
            end
            if self.waterPipeLine.removedDirt and checkAABBCollision(x, y, self.waterPipeLine) then
                self.waterPipeLine.PlaceOnCock = true
                self.waterTankPopup.emptyWater = true
                self.waterPipeLine.water_tank_sound:play()
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

                if not self.waterTankPopup.yellow_key.addedToInventory and checkAABBCollision(x, y, self.waterTankPopup.yellow_key) then
                    self.waterTankPopup.yellow_key.addedToInventory = true

                    if yellow_key == true then 
                        inventory:insertItem(self.waterTankPopup.yellow_key)
                        yellow_key=false 
                    end 
                end
            end

            if self.toolBoxPopup.active then
                if CloseActivePopUpWindow(x, y, self.toolBoxPopup) then
                    self.modifiedV.disable("boxblur")
                end

                if not wrench.addedToInventory and checkAABBCollision(x, y, wrench) then
                    inventory:insertItem(wrench)
                    wrench.addedToInventory = true

                    savedItems2.wrench = true
                    love.filesystem.write('inventorySaved2.txt', json.encode(savedItems2))
                end
            end
        end        
    end
    inventory:mousepressed(x, y, button, istouch)
end

function Room3:mousemoved(x, y, dx, dy, isTouch)
    inventory:mousemoved(x, y, dx, dy, isTouch)
end

function Room3:mousereleased(x, y, button, isTouch)
    inventory:mousereleased(x, y, button, isTouch)
end

function Room3:render()
    self.modifiedV(
        function ()
            love.graphics.draw(self.backgroundImage)

            self.Dirt.render()

            self.ladderToRoom2.render()

            love.graphics.setColor(1, 1, 1, self.mirrorInteractable.alpha)
            self.mirrorInteractable.render()
            love.graphics.setColor(1, 1, 1, 1)

            self.sinkInteractable.render()

            self.waterTankInteractable.render()

            self.toolBox.render()

            soapAndWater.render()

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

    if self.toolBoxPopup.active then
        self.toolBoxPopup.render()
        if not wrench.addedToInventory then
            wrench.render()
        end
    end

    inventory:render()

    if MOUSE_ASSET ~= nil then
        --love.mouse.setVisible(false)
        local mouseX, mouseY = push:toGame(love.mouse.getPosition())
        if mouseX ~= nil and mouseY ~= nil then
            love.graphics.draw(MOUSE_ASSET, mouseX, mouseY, 0, 100/MOUSE_ASSET:getWidth(), 100/MOUSE_ASSET:getHeight(), MOUSE_ASSET:getWidth()/2, MOUSE_ASSET:getHeight()/2)
        end
    end
end

function Room3:exit()
    self.backgroundWaterSound:stop()
end