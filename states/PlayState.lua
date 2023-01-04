PlayState = Class{__includes = BaseState}

require 'states.Room1'
require 'states.Room2'

function PlayState:init()
    demo_img = love.graphics.newImage('assets/demo_img.jpg')
end

function PlayState:update(dt)
    
end

function PlayState:keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function PlayState:mousepressed(x, y)
    
end

function PlayState:render()
   love.graphics.draw(demo_img, 0, 0, 0, WINDOW_WIDTH/demo_img:getWidth(), WINDOW_HEIGHT/demo_img:getHeight())
end
