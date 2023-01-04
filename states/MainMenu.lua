MainMenu = Class{__includes = BaseState}

MainMenu_Button = Class{}

function MainMenu_Button:init(x, y, widthU, heightU, widthS, heightS, selectedImage, normalImage)
    self.x = x
    self.y = y
    self.widthU = widthU
    self.heightU = heightU
    self.widthS = widthS
    self.heightS = heightS
    self.selected = false
    self.selectedImage = selectedImage
    self.normalImage = normalImage
end

function MainMenu:init()
    self.background = love.graphics.newImage('assets/main_menu/menu_background.png')
    self.play_icon = love.graphics.newImage('assets/main_menu/play_icon.png')
    self.play_icon_selected = love.graphics.newImage('assets/main_menu/play_icon_selected.png')
    self.help_icon = love.graphics.newImage('assets/main_menu/help_icon.png')
    self.help_icon_selected = love.graphics.newImage('assets/main_menu/help_icon_selected.png')
    self.exit_icon = love.graphics.newImage('assets/main_menu/exit_icon.png')
    self.exit_icon_selected = love.graphics.newImage('assets/main_menu/exit_icon_selected.png')
    self.continue_icon = love.graphics.newImage('assets/main_menu/continue_icon.png')
    self.continue_icon_selected = love.graphics.newImage('assets/main_menu/continue_icon_selected.png')

    self.MainMenuButtons = {}
    self.playButton = MainMenu_Button(200, 100, 150, 150, 150, 150, self.play_icon_selected, self.play_icon)
    self.continueButton = MainMenu_Button(200, 250, 200, 200, 200, 200, self.continue_icon_selected, self.continue_icon)
    self.helpButton = MainMenu_Button(200, 400, 150, 150, 150, 150, self.help_icon_selected, self.help_icon)
    self.exitButton = MainMenu_Button(200, 550, 150, 150, 150, 150, self.exit_icon_selected, self.exit_icon)

    table.insert(self.MainMenuButtons, self.playButton)
    table.insert(self.MainMenuButtons, self.continueButton)
    table.insert(self.MainMenuButtons, self.helpButton)
    table.insert(self.MainMenuButtons, self.exitButton)

end

function MainMenu:checkMouseHover(x, y)
    for key, button in pairs(self.MainMenuButtons) do
        if x > button.x and x < button.x + button.widthU and y > button.y and y < button.y + button.heightU then
            button.selected = true
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
end