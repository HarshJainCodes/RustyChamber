Room2 = Class{__includes = BaseState}

function Room2:init()
    self.id = 2
end

function Room2:update(dt)
    
end

function Room2:render()
    love.graphics.print("this is room 2")

    inventory:render()
end