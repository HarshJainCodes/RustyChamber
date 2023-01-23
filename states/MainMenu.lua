MainMenu = Class{__includes = BaseState}

MainMenu_Button = Class{}

function MainMenu_Button:init(x, y, widthU, heightU, widthS, heightS, selectedImage, normalImage, onPressedFunction, name)
    self.x = x
    self.y = y
    self.widthU = widthU
    self.heightU = heightU
    self.widthS = widthS
    self.heightS = heightS
    self.selected = false
    self.selectedImage = selectedImage
    self.normalImage = normalImage
    self.onPressedFunction = onPressedFunction
    self.name = name
end

function MainMenu:init()
    self.helpOn = false
    self.helpOnPopup = love.graphics.newImage('assets/main_menu/menu_background.png')
    self.background = love.graphics.newImage('assets/main_menu/menu_background.png')
    self.play_icon = love.graphics.newImage('assets/main_menu/play_icon.png')
    self.play_icon_selected = love.graphics.newImage('assets/main_menu/play_icon_selected.png')
    self.help_icon = love.graphics.newImage('assets/main_menu/help_icon.png')
    self.help_icon_selected = love.graphics.newImage('assets/main_menu/help_icon_selected.png')
    self.exit_icon = love.graphics.newImage('assets/main_menu/exit_icon.png')
    self.exit_icon_selected = love.graphics.newImage('assets/main_menu/exit_icon_selected.png')
    self.continue_icon = love.graphics.newImage('assets/main_menu/continue_icon.png')
    self.continue_icon_selected = love.graphics.newImage('assets/main_menu/continue_icon_selected.png')

    self.helpFont = love.graphics.newFont('assets/room2/oxanium_semiBold.ttf', 20)

    self.MainMenuButtons = {}
    self.playButton = MainMenu_Button(200, 100, 300, 150, 300, 150, self.play_icon_selected, self.play_icon, function ()
        gStateMachine:change('roomSelect')
    end, "play")

    -- self.continueButton = MainMenu_Button(170, 250, 500, 150, 500, 150, self.continue_icon_selected, self.continue_icon, function ()
        
    -- end, "continue")

    self.helpButton = MainMenu_Button(200, 320, 300, 150, 300, 150, self.help_icon_selected, self.help_icon, function ()
        self.helpOn = true
    end, "help")

    self.exitButton = MainMenu_Button(200, 550, 300, 150, 300, 150, self.exit_icon_selected, self.exit_icon, function ()
        love.event.quit()
    end, "exit")

    table.insert(self.MainMenuButtons, self.playButton)
    -- table.insert(self.MainMenuButtons, self.continueButton)
    table.insert(self.MainMenuButtons, self.helpButton)
    table.insert(self.MainMenuButtons, self.exitButton)

    -- hover sound
    self.hoverSound = love.audio.newSource('assets/sounds/hover_sound_metal_scraping.mp3', 'static')

    -- so that the sound dosnt keep on repeating
    self.prev = nil
    self.curr = nil
end

function MainMenu:mousepressed(x, y, button)
    if button == 1 then
        if self.helpOn then
            if x < 200 or y < 200 or x > 1000 or y > 600 then
                self.helpOn = false
            end
        else
            for key, button in pairs(self.MainMenuButtons) do
                if x > button.x and x < button.x + button.widthS and y > button.y and y < button.y + button.heightS then
                    button.onPressedFunction()
                end
            end
        end
        

        
    end
end

function MainMenu:checkMouseHover(x, y)
    for key, button in pairs(self.MainMenuButtons) do
        if x > button.x and x < button.x + button.widthU and y > button.y and y < button.y + button.heightU then
            button.selected = true
            self.curr = button.name

            -- if we changed the hover then only play the sound
            if self.curr ~= self.prev then
                -- stop curr sound first otherwise it sometimes dont play
                self.hoverSound:stop()
                self.hoverSound:play()
                self.prev = self.curr
            end
        else
            button.selected = false
        end
    end
end

function MainMenu:update(dt)
    local mx, my = love.mouse.getPosition()
    local mrx, mry = push:toGame(mx, my)

    if mrx ~= nil and mry ~= nil then
        self:checkMouseHover(mrx, mry)
    end
end

function MainMenu:render()
    love.graphics.draw(self.background, 0, 0, 0, WINDOW_WIDTH/self.background:getWidth(), WINDOW_HEIGHT/self.background:getHeight())

    for key, button in pairs(self.MainMenuButtons) do
        if button.selected then
            love.graphics.draw(button.selectedImage, button.x, button.y, 0, button.widthS/button.selectedImage:getWidth(), button.heightS/button.selectedImage:getHeight())
        else
            love.graphics.draw(button.normalImage, button.x, button.y, 0, button.widthU/button.normalImage:getWidth(), button.heightU/button.normalImage:getHeight())
        end
    end

    if self.helpOn then
        love.graphics.draw(self.helpOnPopup, 200, 200, 0, 800/self.helpOnPopup:getWidth(), 400/self.helpOnPopup:getHeight())
        love.graphics.setFont(self.helpFont)
        love.graphics.printf([[
            Room 1 is just a basic tutorial

            Room2 is a bit tricky explore all the keys and locks and try to figure out the combination
            Its not guaranteed that the solution to the problem will be in the same room.

            Room 3 is in darkness be carefull and make sure to not miss anything in the darkness

            Room4 is all about electricity and puzzles where one thing depends on another to unlock

            If you have made till room 5 then congrats now your only goal is to defeat the kidnapper.
        ]], 200, 200, 800, "center")
    end
end