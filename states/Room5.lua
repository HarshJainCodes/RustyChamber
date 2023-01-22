Room5 = Class{__includes = BaseState}

Gun = Class{}

tryAgainFont = love.graphics.newFont('assets/room5/oxanium_semiBold.ttf', 40)

function Gun:init(x, y, width, height, image)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.image = image
end

Button = Class{}
function Button:init(x, y, width, height, text)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.text = text
    self.render = function ()
        love.graphics.rectangle("line", self.x, self.y, self.width, self.height, 5)

        love.graphics.setFont(tryAgainFont)
        love.graphics.printf(self.text, self.x, self.y + 40, self.width, "center")
    end
end

ElectricLaser = Class{}
function ElectricLaser:init(x1, y1, x2, y2, animation, isPlaying, laserSprite)
    self.x1 = x1
    self.y1 = y1
    self.x2 = x2
    self.y2 = y2
    self.animation = animation
    self.animation:pauseAtStart()
    self.isPlaying = isPlaying
    self.laserSprite = laserSprite
    self.animationTimer = 0.37
    self.currAnimationTimeElapsed = 0
end

Kidnapper = Class{}
function Kidnapper:init(x, y, width, height, image)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.speed = 5
    self.image = image
    self.jumpX = math.random(200, 1000)
    self.jumpProgress = 1
    self.currX = x
    self.kidnapperState = "idle"
    self.idleImage = love.graphics.newImage('assets/room5/idle.png')
    self.left_jump_image = love.graphics.newImage('assets/room5/left_jump.png')
    self.right_jump_image = love.graphics.newImage('assets/room5/right_jump.png')
    self.waitBeforeJump = 1

    self.jumpLerp = function (a, b, t)
        return a + (b - a) * t
    end

    self.currHealth = 100
    self.totalHealth = 100
end

function Kidnapper:update(dt)
    self.y = self.y + self.speed * dt

    if self.waitBeforeJump > 0 then
        self.kidnapperState = "idle"
        self.waitBeforeJump = self.waitBeforeJump - dt
        self.jumpProgress = 0
    else
        if self.jumpProgress >= 1 then
            self.waitBeforeJump = 1
            self.jumpX = math.random(200, 1000)
            
            self.jumpProgress = 0
            self.x = self.currX
        else
            if self.jumpX < self.currX then
                self.kidnapperState = "left_jump"
            else
                self.kidnapperState = "right_jump"
            end
            self.currX = self.jumpLerp(self.x, self.jumpX, self.jumpProgress)
        end
        self.jumpProgress = self.jumpProgress + dt
    end

    -- now i must also increase the xscale and yscale of the kidnapper
    self.width = self.jumpLerp(50, 1300, (self.y - 450)/ 350)
    self.height = self.jumpLerp(100, 2400, (self.y - 450)/350)

    
end

function Kidnapper:render()
    -- love.graphics.rectangle("fill", self.currX, self.y, self.width, self.height)
    if self.kidnapperState == "idle" then
        love.graphics.draw(self.idleImage, self.currX, self.y, 0, self.width/self.idleImage:getWidth(), self.height/self.idleImage:getHeight())
    elseif self.kidnapperState == "left_jump" then
        love.graphics.draw(self.left_jump_image, self.currX, self.y, 0, self.width/self.idleImage:getWidth(), self.height/self.idleImage:getHeight())
    else
        love.graphics.draw(self.right_jump_image, self.currX, self.y, 0, self.width/self.idleImage:getWidth(), self.height/self.idleImage:getHeight())

    end

    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.rectangle("line", 100, 50, 1000, 10)
    love.graphics.rectangle("fill", 100, 50, (self.currHealth / self.totalHealth) * 1000, 10)
    love.graphics.setColor(1, 1, 1, 1)
end

function ElectricLaser:update(dt)
    if self.isPlaying then
        self.animation:update(dt)
        self.currAnimationTimeElapsed = self.currAnimationTimeElapsed + dt

        if self.currAnimationTimeElapsed > self.animationTimer then
            self.currAnimationTimeElapsed = 0
            self.animation:pauseAtStart()
            self.isPlaying = false
        end
    end

    local mx, my = push:toGame(love.mouse.getPosition())
    self.x1 = mx
end

function ElectricLaser:render()
    if self.isPlaying then
        self.animation:draw(self.laserSprite, self.x1, self.y1, math.atan2(self.y2 - self.y1, self.x2 - self.x1), (math.sqrt((math.pow(self.y1 - self.y2, 2) + math.pow(self.x1 - self.x2, 2)))) / self.laserSprite:getHeight(), 1, 0, self.laserSprite:getHeight()/2)
    end
end

function Gun:update(dt)
    local x, y = push:toGame(love.mouse.getPosition())
    self.x = x - self.width/2
end

function Gun:render()
    love.graphics.draw(self.image, self.x, self.y, 0, self.width/self.image:getWidth(), self.height/self.image:getHeight())
end

function Room5:mousepressed(x, y, button, isTouch)
    if button == 1 then
        if not self.Lost then
            local mx, my = push:toGame(love.mouse.getPosition())
            self.laserShoot.x1 = mx
            self.laserShoot.x2 = mx
            self.laserShoot.y2 = my
            self.laserShoot.isPlaying = true
            self.laserShoot.animation:resume()
            self.gun.sound:stop()
            self.gun.sound:play()

            if x > self.kidnapper.currX and x < self.kidnapper.currX + self.kidnapper.width and y > self.kidnapper.y and y < self.kidnapper.y + self.kidnapper.height then
                self.kidnapper.currHealth = self.kidnapper.currHealth - 5
                -- self.kidnapper.y = self.kidnapper.y - 1
            end
        else
            if checkAABBCollision(x, y, self.tryAgainButton) then
                -- restart the game
                self.Lost = false
                self.vignetteEff.disable("vignette")
                self.kidnapper.y = 450
                self.kidnapper.width = 50
                self.kidnapper.height = 100
                self.vignetteEff.VigRadius = 1.5
                self.kidnapper.currHealth = self.kidnapper.totalHealth
            end
        end
    end
end

function Room5:init()
    math.randomseed(os.time())

    self.background = love.graphics.newImage('assets/room5/background.png')

    self.anim8 = require 'libraries.anim8.anim8'

    self.gun_shoot = love.graphics.newImage('assets/room5/gun_shoot.png')

    g = self.anim8.newGrid(500, 500, self.gun_shoot:getWidth(), self.gun_shoot:getHeight())

    self.laserShoot = ElectricLaser(WINDOW_WIDTH/2, WINDOW_HEIGHT - 93, 0, 0, self.anim8.newAnimation(g('1-37', 1), 0.01), false, self.gun_shoot)

    ----------GUN-----------------

    self.gun = Gun(WINDOW_WIDTH/2 - 30, WINDOW_HEIGHT - 93, 60, 93, love.graphics.newImage('assets/room5/gun_top.png'))
    self.gun.sound = love.audio.newSource('assets/room5/electric_sound2.mp3', 'static')

    ----------------KIDNAPPER----------------------
    self.kidnapper = Kidnapper(WINDOW_WIDTH/2, 450, 50, 100)


    self.vignetteEff = moonshine(moonshine.effects.vignette)
    self.vignetteEff.vignette.radius = 1.5
    self.vignetteEff.vignette.opacity = 1
    self.vignetteEff.disable("vignette")
    self.Lost = false
    self.vignetteEff.VigRadius = 1.5

    self.runAwayVideo = love.graphics.newVideo('assets/room5/runaway.ogg')
    self.safelyEscaped = love.graphics.newImage('assets/room5/escapedpng.png')

    self.LostFont = love.graphics.newFont('assets/room5/oxanium_semiBold.ttf', 100)
    self.Won = false

    self.tryAgainButton = Button(WINDOW_WIDTH/2 - 150, WINDOW_HEIGHT/2 + 100, 300, 100, "TRY AGAIN")
end


function Room5:update(dt)
    self.gun:update(dt)

    self.laserShoot:update(dt)

    if not self.Won and not self.Lost then
        self.kidnapper:update(dt)
    end
    

    if self.Lost then
        self.vignetteEff.VigRadius = self.vignetteEff.VigRadius - dt
        self.vignetteEff.vignette.radius = self.vignetteEff.VigRadius
    end

    if self.kidnapper.y > 500 then
        self.vignetteEff.enable("vignette")
        self.Lost = true
    end

    if self.Won == false and self.kidnapper.currHealth <= 0 then
        self.Won = true
        self.runAwayVideo:play()
    end
end


function Room5:render()
    if self.vignetteEff.VigRadius >= 0 then
        self.vignetteEff(
            function ()
                love.graphics.draw(self.background, 0, 0, 0, WINDOW_WIDTH/self.background:getWidth(), WINDOW_HEIGHT/self.background:getHeight())
                self.gun:render()

                self.kidnapper:render()
                self.laserShoot:render()
            end
        )

        if self.Won then
            if self.runAwayVideo:isPlaying() then
                love.graphics.draw(self.runAwayVideo, 0, 0, 0, WINDOW_WIDTH/self.runAwayVideo:getWidth(), WINDOW_HEIGHT/self.runAwayVideo:getHeight())
            else
                love.graphics.draw(self.safelyEscaped, 0, 0, 0, WINDOW_WIDTH/self.safelyEscaped:getWidth(), WINDOW_HEIGHT/self.safelyEscaped:getHeight())
            end
        end
    else
        if self.Lost then
            love.graphics.setFont(self.LostFont)
            love.graphics.setColor(1, 0, 0, 1)
            love.graphics.printf([[YOU LOST !! KIDNAPPER GOT YOU]], 0, WINDOW_HEIGHT/2 - 200, WINDOW_WIDTH, "center")
            love.graphics.setColor(1, 1, 1, 1)

            self.tryAgainButton.render()
        end
    end
end