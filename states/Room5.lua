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
end

function ElectricLaser:update(dt)
    if self.isPlaying then
        self.animation:update(dt)
    end

    local mx, my = push:toGame(love.mouse.getPosition())
    self.x1 = mx
    self.x2 = mx
end

function ElectricLaser:render()
    if self.isPlaying then
        self.animation:draw(self.laserSprite, self.x1, self.y1, -1.57, (self.y1 - self.y2) / self.laserSprite:getHeight(), 1, 0, self.laserSprite:getHeight()/2)
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
        self.laserShoot.y2 = my
        self.laserShoot.isPlaying = true
        self.laserShoot.animation:resume()
    end
end

function Room5:init()
    self.anim8 = require 'libraries.anim8.anim8'

    self.gun_shoot = love.graphics.newImage('assets/room5/gun_shoot.png')

    g = self.anim8.newGrid(500, 500, self.gun_shoot:getWidth(), self.gun_shoot:getHeight())

    self.laserShoot = ElectricLaser(WINDOW_WIDTH/2, WINDOW_HEIGHT - 93, 0, 0, self.anim8.newAnimation(g('1-37', 1), 0.1), false, self.gun_shoot)

    ----------GUN-----------------

    self.gun = Gun(WINDOW_WIDTH/2 - 30, WINDOW_HEIGHT - 93, 60, 93, love.graphics.newImage('assets/room5/gun_top.png'))
end


function Room5:update(dt)
    self.gun:update(dt)

    self.laserShoot:update(dt)
end


function Room5:render()
    self.gun:render()

    self.laserShoot:render()
end