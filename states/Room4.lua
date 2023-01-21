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

PuzzlePiece = Class{}

function PuzzlePiece:init(x, y, width, height, value, red_image, yellow_image, id)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.value = value
    self.red_image = red_image
    self.yellow_image = yellow_image
    self.id = id
end


function Room4:init()
    self.background = love.graphics.newImage('assets/room4/background.png')
    self.background_phase1 = love.graphics.newImage('assets/room4/electricity_on_phase1.png')
    self.background_phase2 = love.graphics.newImage('assets/room4/electricity_on_phase2.png')

    ------------------------------DEBRIS------------------------------
    self.debrisBox = PlacableItems(730, 550, 180, 133, love.graphics.newImage('assets/room4/box.png'))

    ------------------------------RESISTOR BOX---------------------------
    self.resisterBox = PlacableItems(800, 460, 120, 69, love.graphics.newImage('assets/room4/box_resistors.png'))


    ------------------------------IC BOX-----------------------------------
    self.icBox = PlacableItems(430, 250, 100, 100, love.graphics.newImage('assets/room4/closed_box.png'))

    ------------------------------MINI GAME--------------------------------
    self.miniGame1Popup = PopupWindow(love.graphics.newImage('assets/room4/ic_background.png'), 0.5, 0.5)
    self.miniGame1Popup.bg_image = love.graphics.newImage('assets/room4/open_box.png')
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

    ------------------------------IC CLOSED---------------------------------
    self.lockIC = PlacableItems(430, 400, 100, 209, love.graphics.newImage('assets/room4/board.png'))
    self.lockIC.unlockedImage = love.graphics.newImage('assets/room4/board_unlock.png')

    -------------------------------SWITCHBOARD-----------------------------
    self.switchBoard = {}
    self.switchBoard.x = 250
    self.switchBoard.y = 130
    self.switchBoard.width = 80
    self.switchBoard.height = 80

    self.switchBoardPopup = PopupWindow(love.graphics.newImage('assets/room4/background_board.png'), 1, 1)

    self.switchBoardPopup.quizArray = {}
    self.switchBoardPopup.completedPhase1 = false
    self.switchBoardPopup.completedPhase2 = false

    local id = 1
    local col = 100
    for i = 1, 3 do
        local row = 300
        for j = 1, 3 do
            table.insert(self.switchBoardPopup.quizArray, PuzzlePiece(row, col, 200, 200, 0, love.graphics.newImage('assets/room4/button_switch.png'), love.graphics.newImage('assets/room4/button_switch_on.png'), id))
            row = row + 200
            id = id + 1
        end
        col = col + 200
    end

    -------------------------------PAPER-----------------------------------------
    self.paper = PlacableItems(260, 480, 100, 52, love.graphics.newImage('assets/room4/paper.png'))

    -- blur effect
   self.blurEff = moonshine(moonshine.effects.boxblur)
   self.blurEff.boxblur.radius = {20, 20}
   self.blurEff.disable('boxblur')

   self.miniGameBlur = moonshine(moonshine.effects.boxblur)
   self.miniGameBlur.boxblur.radius = {5, 5}

end

function Room4:mousepressed(x, y, button, isTouch)

    if not self.miniGame1Popup.active and not self.switchBoardPopup.active then
        if checkAABBCollision(x, y, self.icBox) then
            self.miniGame1Popup.active = true
            self.blurEff.enable('boxblur')
        end

        if checkAABBCollision(x, y, self.switchBoard) then
            self.switchBoardPopup.active = true
            self.blurEff.enable("boxblur")
        end

        if checkAABBCollision(x, y, self.debrisBox) then
            -- self.debrisPopup.active = true
        end
    else
        if self.miniGame1Popup.active then
            if (x < self.miniGame1Popup.x or x > self.miniGame1Popup.x + self.miniGame1Popup.width or y < self.miniGame1Popup.y) and (x < WINDOW_WIDTH - 100) then
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

        if self.switchBoardPopup.active then
            if CloseActivePopUpWindow(x, y, self.switchBoardPopup) then
                self.blurEff.disable("boxblur")
            end

            for key, v in pairs(self.switchBoardPopup.quizArray) do
                if checkAABBCollision(x, y, v) then
                    if v.value == 0 then
                        v.value = 1
                    else
                        v.value = 0
                    end
                    local checkSum = 0
                    for p, q in pairs(self.switchBoardPopup.quizArray) do
                        if q.value == 1 and (q.id == 4 or q.id == 5 or q.id == 8) then
                            checkSum = checkSum + 1
                        elseif q.value == 1 then
                            break
                        end
                    end
                    print(checkSum)
                    if checkSum == 3 then
                        self.switchBoardPopup.completedPhase1 = true
                        self.switchBoardPopup.active = false
                        self.blurEff.disable('boxblur')
                    end
                end
            end
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
            if self.switchBoardPopup.completedPhase2 then
                love.graphics.draw(self.background_phase2, 0, 0, 0, WINDOW_WIDTH/self.background:getWidth(), WINDOW_HEIGHT/self.background:getHeight())
            elseif self.switchBoardPopup.completedPhase1 then
                love.graphics.draw(self.background_phase1, 0, 0, 0, WINDOW_WIDTH/self.background:getWidth(), WINDOW_HEIGHT/self.background:getHeight())
            else
                love.graphics.draw(self.background, 0, 0, 0, WINDOW_WIDTH/self.background:getWidth(), WINDOW_HEIGHT/self.background:getHeight())
            end

            self.debrisBox.render()

            self.resisterBox.render()

            self.icBox.render()

            self.lockIC.render()

            self.paper.render()
        end
    )

    if self.miniGame1Popup.active then
        self.miniGameBlur(
            function ()
                love.graphics.draw(self.miniGame1Popup.bg_image, 0, 0, 0, WINDOW_WIDTH/self.miniGame1Popup.bg_image:getWidth(), WINDOW_HEIGHT/self.miniGame1Popup.bg_image:getHeight())
            end
        )
        self.miniGame1Popup.render()

        for key, value in pairs(self.miniGame1Stack) do
            love.graphics.draw(value.image, value.x, value.y, 0, value.width/value.image:getWidth(), value.height/value.image:getHeight())
        end

        for key, value in pairs(self.miniGame1PopupStack) do
            love.graphics.draw(value.image, value.x, value.y, 0, value.width/value.image:getWidth(), value.height/value.image:getHeight())
        end
    end

    if self.switchBoardPopup.active then
        self.switchBoardPopup.render()

        for key, v in pairs(self.switchBoardPopup.quizArray) do
            if v.value == 0 then
                love.graphics.draw(v.red_image, v.x, v.y, 0, v.width/v.red_image:getWidth(), v.height/v.red_image:getHeight())
            else
                love.graphics.draw(v.yellow_image, v.x, v.y, 0, v.width/v.red_image:getWidth(), v.height/v.red_image:getHeight())
            end
        end
    end

    inventory:render()

end