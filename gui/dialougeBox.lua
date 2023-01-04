DialougeSystem = Class{}

function DialougeSystem:init()
    self.dialouges = {}

    -- this timer will move forawrd the dialouge
    self.timer = 0

    self.dialougeFont = love.graphics.newFont(30)
end

function DialougeSystem:update(dt)
    self.timer = self.timer + dt
end

function DialougeSystem:insertDialouge(dialouge)
    table.insert(self.dialouges, dialouge)
end

function DialougeSystem:playDialouge(key)
    for k, value in pairs(self.dialouges) do
        if (value.id == key) then
            value.play = true
        end
    end
end

function DialougeSystem:render()
    for key, value in pairs(self.dialouges) do
        if value.play then

            --love.graphics.rectangle("line", 100, WINDOW_HEIGHT - 120, WINDOW_WIDTH - 200, 100, 25, 25)

            love.graphics.setFont(self.dialougeFont)
            love.graphics.printf(string.sub(value.text, 1, value.current), 100, WINDOW_HEIGHT - 120, WINDOW_WIDTH - 200, "center")

            if self.timer > 0.05 then
                value.current = value.current + 1
                self.timer = 0
            end


            if value.current > value.finish then
                value.current = value.finish
            end
        end
    end
end