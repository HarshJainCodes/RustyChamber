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
    self.waterPipeLine = PlacableItems(500, 700, 150, 100, love.graphics.newImage('assets/room3/cock_off.png'))

    --------------------------------------------WATER TANK----------------------------------------------------------
    self.waterTankInteractable = PlacableItems(850, 400, 262, 300, love.graphics.newImage('assets/room3/water_tank.png'))

    -----------------------------------------------SINK-----------------------------------------
    self.sinkInteractable = PlacableItems(230, 350, 200, 150, love.graphics.newImage('assets/room3/sink.png'))

    --------------------------------------------------MIRROR----------------------------------------------------------------------------------
    self.mirrorInteractable = PlacableItems(200, 210, 200, 200, love.graphics.newImage('assets/room3/mirror.png'))
    self.mirrorInteractable.hidden = false
    self.mirrorInteractable.alpha = 1

    ----------------------------------------------------------------------------------------------------------------------
    self.modifiedV = moonshine(WINDOW_WIDTH, WINDOW_HEIGHT, moonshine.effects.modified_vignette)
    self.modifiedV.modified_vignette.radius = 150
    self.modifiedV.modified_vignette.opacity = 0
    -- self.modifiedV.disable("modified_vignette")
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


    for key, value in pairs(self.allWaterDrops) do
        value.update(dt)
    end
end

function Room3:mousepressed(x, y, button, istouch)
    if checkAABBCollision(x, y, self.ladderToRoom2) then
        gStateMachine:change('room2')
    end

    if checkAABBCollision(x, y, self.mirrorInteractable) then
        self.mirrorInteractable.hidden = true
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

            for key, value in pairs(self.allWaterDrops) do
                value.render()
            end
        end
    )
end

function Room3:exit()
    self.backgroundWaterSound:stop()
end