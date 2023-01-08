PlacableItems = Class{}
InventoryPlacableItems = Class{}
PopupWindow = Class{}

function PlacableItems:init(x, y, width, height, image)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.image = image
    self.render = function ()
        if self.image then
            love.graphics.draw(self.image, self.x, self.y, 0, self.width/self.image:getWidth(), self.height/self.image:getHeight())
        end
    end
end

function InventoryPlacableItems:init(x, y, width, height, id, image, name)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.image = image
    self.id = id
    self.addedToInventory = false
    self.name = name
    self.render = function ()
        if not self.addedToInventory then
            love.graphics.draw(self.image, self.x, self.y, 0, self.width/self.image:getWidth(), self.height/self.image:getHeight())
        end
    end
end

function PopupWindow:init(image, width, height)
    self.image = image
    self.width = self.image:getWidth() * width
    self.height = self.image:getHeight() * height
    self.x = WINDOW_WIDTH/2 - self.width/2
    self.y = WINDOW_HEIGHT/2 - self.height/2
    self.active = false
    self.alphaInitial = 0
    self.alphaProgress = 0
    self.alphaFinal = 1
    self.lerp = function (start, finish, t)
        return start + (finish - start) * t
    end
    self.render = function ()
        love.graphics.draw(self.image, self.x, self.y, 0, self.width/self.image:getWidth(), self.height/self.image:getHeight())
    end
end

function CloseActivePopUpWindow(x, y, popupWindow)
    if (popupWindow.active) and (x < popupWindow.x or x > popupWindow.x + popupWindow.width or y < popupWindow.y or y > popupWindow.y + popupWindow.height) and (x < WINDOW_WIDTH - 100) then
        popupWindow.active = false
        popupWindow.alphaProgress = 0
        popupWindow.alphaInitial = 0
        return true
    end
    return false
end

function checkAABBCollision(x, y, object)
    return x > object.x and x < object.x + object.width and y > object.y and y < object.y + object.height
end