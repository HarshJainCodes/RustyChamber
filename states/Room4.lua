Room4 = Class{__includes = BaseState}

StackPiece = Class{}
function StackPiece:init(x, y, width, height, image, id)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.image = image
    self.id = id
end


function Room4:init()
    self.background = love.graphics.newImage('assets/room4/background.png')

    self.miniGame1 = {}
    self.miniGame1.x = 250
    self.miniGame1.y = 130
    self.miniGame1.width = 80
    self.miniGame1.height = 80
    self.miniGame1.render = function ()
        love.graphics.rectangle("line", self.miniGame1.x, self.miniGame1.y, self.miniGame1.width, self.miniGame1.height)
    end

    self.miniGame1Popup = PopupWindow(love.graphics.newImage('assets/room4/ic_background.png'), 0.5, 0.5)
    self.miniGame1PopupStack = {}
    self.miniGame1PopupStackWord = ""

    self.miniGame1zero1 = StackPiece(200, 600, 200, 200, love.graphics.newImage('assets/room4/ic_0.png'), "0")
    self.miniGame1zero2 = StackPiece(400, 600, 200, 200, love.graphics.newImage('assets/room4/ic_0.png'), "0")
    self.miniGame1two = StackPiece(600, 600, 200, 200, love.graphics.newImage('assets/room4/ic_2.png'), "2")
    self.miniGame1three = StackPiece(800, 600, 200, 200, love.graphics.newImage('assets/room4/ic_3.png'), "3")

    self.miniGame1Stack = {}
    table.insert(self.miniGame1Stack, self.miniGame1zero1)
    table.insert(self.miniGame1Stack, self.miniGame1zero2)
    table.insert(self.miniGame1Stack, self.miniGame1two)
    table.insert(self.miniGame1Stack, self.miniGame1three)

    -- blur effect
   self.blurEff = moonshine(moonshine.effects.boxblur)
   self.blurEff.boxblur.radius = {20, 20}
   self.blurEff.disable('boxblur')

end

function Room4:mousepressed(x, y, button, isTouch)

    if not self.miniGame1Popup.active then
        if checkAABBCollision(x, y, self.miniGame1) then
            self.miniGame1Popup.active = true
            self.blurEff.enable('boxblur')
        end
    else
        if self.miniGame1Popup.active then
            if x < self.miniGame1Popup.x or x > self.miniGame1Popup.x + self.miniGame1Popup.width or y < self.miniGame1Popup.y and x < WINDOW_WIDTH - 100 then
                self.miniGame1Popup.active = false
                self.blurEff.disable("boxblur")
            end

            for key, value in pairs(self.miniGame1Stack) do
                assert(value.x ~= nil and value.y ~= nil and value.width ~= nil and value.height ~= nil, "invalid value")
                if checkAABBCollision(x, y, value) then
                    table.insert(self.miniGame1PopupStack, table.remove(self.miniGame1Stack, key))
                    self.miniGame1PopupStackWord = self.miniGame1PopupStackWord .. value.id
                    bigStackX = 200
                    bigStackY = 300

                    for key, value in pairs(self.miniGame1PopupStack) do
                        value.x = bigStackX
                        value.y = bigStackY
                        bigStackX = bigStackX + 200
                    end
                    startX = 200
                    startY = 600
                    for key1, value1 in pairs(self.miniGame1Stack) do
                        value1.x = startX
                        value1.y = startY
                        startX = startX + 200
                    end
                    goto continue
                end
            end

            for key, value in pairs(self.miniGame1PopupStack) do
                if checkAABBCollision(x, y, value) then
                    table.insert(self.miniGame1Stack ,table.remove(self.miniGame1PopupStack, #self.miniGame1PopupStack))
                    if #self.miniGame1Stack == 1 then
                        self.miniGame1Stack[#self.miniGame1Stack].x = 200
                        self.miniGame1Stack[#self.miniGame1Stack].y = 600
                    else
                        self.miniGame1Stack[#self.miniGame1Stack].x = self.miniGame1Stack[#self.miniGame1Stack - 1].x + 200
                        self.miniGame1Stack[#self.miniGame1Stack].y = self.miniGame1Stack[#self.miniGame1Stack - 1].y
                    end
                end
            end

            ::continue::
        end
    end
end

function Room4:update(dt)
    if self.miniGame1PopupStackWord == "2003" then
        print("target reached")
    end
end

function Room4:render()
    self.blurEff(
        function ()
            love.graphics.draw(self.background, 0, 0, 0, WINDOW_WIDTH/self.background:getWidth(), WINDOW_HEIGHT/self.background:getHeight())
        end
    )

    if self.miniGame1Popup.active then
        self.miniGame1Popup.render()

        for key, value in pairs(self.miniGame1Stack) do
            love.graphics.draw(value.image, value.x, value.y, 0, value.width/value.image:getWidth(), value.height/value.image:getHeight())
        end

        for key, value in pairs(self.miniGame1PopupStack) do
            love.graphics.draw(value.image, value.x, value.y, 0, value.width/value.image:getWidth(), value.height/value.image:getHeight())
        end
    end

    inventory:render()

end