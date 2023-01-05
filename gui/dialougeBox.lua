DialougeSystem = Class{}
Dialouge = Class{}

function Dialouge:init(id, text, timeToWait)
    self.id = id
    self.text = text
    self.play = false
    self.current = 1
    self.finish = #self.text
    self.startWaitTimer = false
    self.currentTimeToWait = 0
    self.timeToWaitAfterFinish = timeToWait
end

function DialougeSystem:init()
    self.dialouges = {}

    -- this timer will move forawrd the dialouge
    self.timer = 0
    self.dialougeId = 1
    self.executeDialouges = false

    self.dialougeFont = love.graphics.newFont(30)
end

function DialougeSystem:update(dt)
    self.timer = self.timer + dt

    for key, value in pairs(self.dialouges) do
        if value.startWaitTimer then
            value.currentTimeToWait = value.currentTimeToWait + dt
        end
    end

    if self.executeDialouges then
        for key, value in pairs(self.dialouges) do
            if value.id == self.dialougeId then
                value.play = true
            end
        end
    end
end

function DialougeSystem:insertDialouge(dialouge)
    table.insert(self.dialouges, dialouge)
end

function DialougeSystem:playDialouge()
    self.executeDialouges = true
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


            if value.current >= value.finish then
                value.current = value.finish
                value.startWaitTimer = true
                if value.currentTimeToWait >= value.timeToWaitAfterFinish then
                    self.dialougeId = self.dialougeId + 1
                    value.play = false
                    value.startWaitTimer = false
                end
            end
        end
    end
end