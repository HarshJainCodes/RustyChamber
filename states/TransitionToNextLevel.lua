TransitionToNextLevel = Class{__includes = BaseState}

function TransitionToNextLevel:enter(nextLevel)
    self.nextLevel = nextLevel
end

function TransitionToNextLevel:init()

end

function TransitionToNextLevel:update(dt)
end

function TransitionToNextLevel:render()
    
end