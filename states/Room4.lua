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

Resistors = Class{}
function Resistors:init(x, y, width, height, image, value)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.image = image
    self.value = value
end

CircuitResistor = Class{}
function CircuitResistor:init(x, y, width, height, image, value)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.image = image
    self.value = value

    self.render = function ()
        if self.image == nil then
            -- love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
        else
            love.graphics.draw(self.image, self.x, self.y, 0, self.width/self.image:getWidth(), self.height/self.image:getHeight())
        end
    end
end


function Room4:init()
    self.background = love.graphics.newImage('assets/room4/background.png')
    self.background_phase1 = love.graphics.newImage('assets/room4/electricity_on_phase1.png')
    self.background_phase2 = love.graphics.newImage('assets/room4/electricity_on_phase2.png')

    self.doorLockedButton = PlacableItems(500, 500, 50, 50, love.graphics.newImage('assets/room4/button_door_red.png'))
    self.doorOpenButton = PlacableItems(500, 500, 50, 50, love.graphics.newImage('assets/room4/button_door_yellow.png'))


    ------------------------------DEBRIS------------------------------
    self.debrisBox = PlacableItems(730, 550, 180, 133, love.graphics.newImage('assets/room4/box.png'))
    self.debrisBoxPopup = PopupWindow(love.graphics.newImage('assets/room4/box_debris.png'), 0.8, 0.8)
    self.debrisBoxPopup.ammeter = PlacableItems(700, 400, 100, 200, love.graphics.newImage('assets/room4/tester.png'))
    self.debrisBoxPopup.ammeter.collected = false

    ------------------------------RESISTOR BOX---------------------------
    self.resisterBox = PlacableItems(800, 460, 120, 69, love.graphics.newImage('assets/room4/box_resistors.png'))
    self.resisterBoxPopup = PopupWindow(love.graphics.newImage('assets/room4/resisterBG.png'), 0.7, 0.7)
    self.resisterBoxPopup.render = function ()
        love.graphics.draw(self.resisterBoxPopup.image, self.resisterBoxPopup.x - 80, self.resisterBoxPopup.y, 0, self.resisterBoxPopup.width/self.resisterBoxPopup.image:getWidth(), self.resisterBoxPopup.height/self.resisterBoxPopup.image:getHeight())
    end
    self.resisterBoxPopup.ohm21 = Resistors(200, 700, 200, 50, love.graphics.newImage('assets/room4/2ohm.png'), 2)
    self.resisterBoxPopup.ohm41 = Resistors(600, 700, 200, 50, love.graphics.newImage('assets/room4/4ohm.png'), 4)
    self.resisterBoxPopup.selectableResistors = {}

    self.resisterBoxPopup.ammeterValue = function ()
        if self.resisterBoxPopup.r1.value == nil or self.resisterBoxPopup.r2.value == nil or self.resisterBoxPopup.r3.value == nil then
            return nil
        else
            return self.resisterBoxPopup.r1.value + ((self.resisterBoxPopup.r2.value * self.resisterBoxPopup.r3.value) / (self.resisterBoxPopup.r2.value + self.resisterBoxPopup.r3.value))
        end
    end

    self.resisterBoxPopup.ammeterFont = love.graphics.newFont(40)

    self.resisterBoxPopup.putResistors = {}
    self.resisterBoxPopup.r1 = CircuitResistor(200, 375, 200, 50, nil, nil)
    self.resisterBoxPopup.r2 = CircuitResistor(550, 300, 200, 50, nil, nil)
    self.resisterBoxPopup.r3 = CircuitResistor(550, 440, 200, 50, nil, nil)

    table.insert(self.resisterBoxPopup.putResistors, self.resisterBoxPopup.r1)
    table.insert(self.resisterBoxPopup.putResistors, self.resisterBoxPopup.r2)
    table.insert(self.resisterBoxPopup.putResistors, self.resisterBoxPopup.r3)

    self.resisterBoxPopup.MouseSelect = {}
    self.resisterBoxPopup.MouseSelect.MouseAsset = nil
    self.resisterBoxPopup.MouseSelect.ResistorValue = 0


    table.insert(self.resisterBoxPopup.selectableResistors, self.resisterBoxPopup.ohm21)
    table.insert(self.resisterBoxPopup.selectableResistors, self.resisterBoxPopup.ohm41)

    self.resisterBoxPopup.ammeter = love.graphics.newImage('assets/room4/tester.png')

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

    self.lockICPopup = PopupWindow(love.graphics.newImage('assets/room4/ic_background_open.png'), 1, 1)
    self.lockICPopup.gun = InventoryPlacableItems(600, 480, 200, 173, 9, love.graphics.newImage('assets/room4/gun.png'), "electric gun")
    self.lockICPopup.gunBattery = InventoryPlacableItems(400, 500, 100, 155, 10, love.graphics.newImage('assets/room4/gun_battery.png'), "gun battery")

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

    if not self.miniGame1Popup.active and not self.switchBoardPopup.active and not self.debrisBoxPopup.active and not self.resisterBoxPopup.active and not self.lockICPopup.active then
        if self.switchBoardPopup.completedPhase1 and not self.switchBoardPopup.completedPhase2 and checkAABBCollision(x, y, self.icBox) then
            self.miniGame1Popup.active = true
            self.blurEff.enable('boxblur')
        end

        if not self.switchBoardPopup.completedPhase1 and checkAABBCollision(x, y, self.switchBoard) then
            self.switchBoardPopup.active = true
            self.blurEff.enable("boxblur")
        end

        if checkAABBCollision(x, y, self.debrisBox) then
            self.debrisBoxPopup.active = true
            self.blurEff.enable("boxblur")
        end

        if self.switchBoardPopup.completedPhase1 and checkAABBCollision(x, y, self.resisterBox) then
            self.resisterBoxPopup.active = true
            self.blurEff.enable("boxblur")
        end

        if checkAABBCollision(x, y, self.lockIC) then
            self.lockICPopup.active = true
            self.blurEff.enable("boxblur")
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
                    -- self.miniGame1PopupStackWord = self.miniGame1PopupStackWord .. value.id
                    
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

            self.miniGame1PopupStackWord = ""
            for key, v in pairs(self.miniGame1PopupStack) do
                self.miniGame1PopupStackWord = self.miniGame1PopupStackWord .. v.id
            end

            if self.miniGame1PopupStackWord == "2003" then
                self.switchBoardPopup.completedPhase2 = true
                self.miniGame1Popup.active = false
                self.blurEff.disable("boxblur")
            end
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
                    if checkSum == 3 then
                        self.switchBoardPopup.completedPhase1 = true
                        self.switchBoardPopup.active = false
                        self.blurEff.disable('boxblur')
                    end
                end
            end
        end

        if self.debrisBoxPopup.active then
            if CloseActivePopUpWindow(x, y, self.debrisBoxPopup) then
                self.debrisBoxPopup.active = false
                self.blurEff.disable("boxblur")
            end

            if not self.debrisBoxPopup.ammeter.collected and checkAABBCollision(x, y, self.debrisBoxPopup.ammeter) then
                self.debrisBoxPopup.ammeter.collected = true
            end
        end

        if self.resisterBoxPopup.active then
            for key, selectableR in pairs(self.resisterBoxPopup.selectableResistors) do
                if checkAABBCollision(x, y, selectableR) then
                    self.resisterBoxPopup.MouseSelect.MouseAsset = selectableR.image
                    self.resisterBoxPopup.MouseSelect.ResistorValue = selectableR.value
                end
            end

            for key, putR in pairs(self.resisterBoxPopup.putResistors) do
                if checkAABBCollision(x, y, putR) then
                    putR.value = self.resisterBoxPopup.MouseSelect.ResistorValue
                    putR.image = self.resisterBoxPopup.MouseSelect.MouseAsset
                    self.resisterBoxPopup.MouseSelect.MouseAsset = nil
                    self.resisterBoxPopup.MouseSelect.ResistorValue = nil
                end
            end

            if x < 135 or y < 260 then
                self.blurEff.disable("boxblur")
                self.resisterBoxPopup.active = false
            end
        end

        if self.lockICPopup.active then
            if CloseActivePopUpWindow(x, y, self.lockICPopup) then
                self.blurEff.disable("boxblur")
            end

            if not self.lockICPopup.gun.addedToInventory and checkAABBCollision(x, y, self.lockICPopup.gun) then
                self.lockICPopup.gun.addedToInventory = true
                inventory:insertItem(self.lockICPopup.gun)
            end

            if not self.lockICPopup.gunBattery.addedToInventory and checkAABBCollision(x, y, self.lockICPopup.gunBattery) then
                self.lockICPopup.gunBattery.addedToInventory = true
            end
        end
    end

    inventory:mousepressed(x, y, button, isTouch)
end

function Room4:keypressed(key)
end


function Room4:mousemoved(x, y, dx, dy, isTouch)
    inventory:mousemoved(x, y, dx, dy, isTouch)
end

function Room4:mousereleased(x, y, button, isTouch)
    inventory:mousereleased(x, y, button, isTouch)
end

function Room4:update(dt)
    
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

    if self.debrisBoxPopup.active then
        self.debrisBoxPopup.render()

        if not self.debrisBoxPopup.ammeter.collected then
            self.debrisBoxPopup.ammeter.render()
        end
    end

    if self.resisterBoxPopup.active then
        self.resisterBoxPopup.render()
        love.graphics.draw(self.resisterBoxPopup.ammeter, 900, WINDOW_HEIGHT/2 - self.resisterBoxPopup.ammeter:getHeight()/2)

        for key, resistor in pairs(self.resisterBoxPopup.selectableResistors) do
            love.graphics.draw(resistor.image, resistor.x, resistor.y, 0, resistor.width/resistor.image:getWidth(), resistor.height/resistor.image:getHeight())
        end

        self.resisterBoxPopup.r1.render()
        self.resisterBoxPopup.r2.render()
        self.resisterBoxPopup.r3.render()

        love.graphics.setFont(self.resisterBoxPopup.ammeterFont)

        ammValue = self.resisterBoxPopup.ammeterValue()
        if ammValue == nil then
            ammValue = "nil"
        else
            ammValue = tonumber(string.format("%.3f", ammValue))
        end
        love.graphics.printf(ammValue, 920, 240, 150, "center")

        if self.resisterBoxPopup.MouseSelect.MouseAsset ~= nil then
            local mx, my = push:toGame(love.mouse.getPosition())
            love.graphics.draw(self.resisterBoxPopup.MouseSelect.MouseAsset, mx - 100, my - 25, 0, 200/self.resisterBoxPopup.MouseSelect.MouseAsset:getWidth(), 50/self.resisterBoxPopup.MouseSelect.MouseAsset:getHeight())
        end
    end

    if self.lockICPopup.active then
        self.lockICPopup.render()
        self.lockICPopup.gun.render()
        self.lockICPopup.gunBattery.render()
    end

    inventory:render()

end