Room5 = Class{__includes = BaseState}

Gun = Class{}

function Gun:init(x, y, width, height, image)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.image = image
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
    self.speed = 60
    self.image = image
    self.jumpX = math.random(0, WINDOW_WIDTH)
    self.jumpProgress = 0
    self.currX = x

    self.jumpLerp = function (a, b, t)
        return a + (b - a) * t
    end

    self.currHealth = 100
    self.totalHealth = 100
end

function Kidnapper:update(dt)
    self.y = self.y + self.speed * dt

    if self.jumpProgress >= 1 then
        self.jumpX = math.random(0, WINDOW_WIDTH)
        self.jumpProgress = 0
        self.x = self.currX
    end

    self.jumpProgress = self.jumpProgress + dt / 2

    self.currX = self.jumpLerp(self.x, self.jumpX, self.jumpProgress)
end

function Kidnapper:render()
    love.graphics.rectangle("fill", self.currX, self.y, self.width, self.height)


    love.graphics.rectangle("line", 100, 50, 1000, 10)
    love.graphics.rectangle("fill", 100, 50, (self.currHealth / self.totalHealth) * 1000, 10)
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
        local mx, my = push:toGame(love.mouse.getPosition())
        self.laserShoot.x1 = mx
        self.laserShoot.x2 = mx
        self.laserShoot.y2 = my
        self.laserShoot.isPlaying = true
        self.laserShoot.animation:resume()

        if x > self.kidnapper.currX and x < self.kidnapper.currX + self.kidnapper.width and y > self.kidnapper.y and y < self.kidnapper.y + self.kidnapper.height then
            self.kidnapper.currHealth = self.kidnapper.currHealth - 10
        end
    end
end

function Room5:init()
    math.randomseed(os.time())

    self.anim8 = require 'libraries.anim8.anim8'

    self.gun_shoot = love.graphics.newImage('assets/room5/gun_shoot.png')

    g = self.anim8.newGrid(500, 500, self.gun_shoot:getWidth(), self.gun_shoot:getHeight())

    self.laserShoot = ElectricLaser(WINDOW_WIDTH/2, WINDOW_HEIGHT - 93, 0, 0, self.anim8.newAnimation(g('1-37', 1), 0.01), false, self.gun_shoot)

    ----------GUN-----------------

    self.gun = Gun(WINDOW_WIDTH/2 - 30, WINDOW_HEIGHT - 93, 60, 93, love.graphics.newImage('assets/room5/gun_top.png'))


    ----------------KIDNAPPER----------------------
    self.kidnapper = Kidnapper(WINDOW_HEIGHT/2, 0, 50, 100)
end


function Room5:update(dt)
    self.gun:update(dt)

    self.laserShoot:update(dt)

    self.kidnapper:update(dt)
end


function Room5:render()
    self.gun:render()

    self.kidnapper:render()
    self.laserShoot:render()
    
end