Inventory = Class{__includes = BaseState}

function Inventory:init()
    self.items = {}
    self.moveInventory = false
    self.selectedItemId = nil
    self.image = love.graphics.newImage('assets/inventory/inventory_box.png')
end


-- need to make them globals
knife = {}
knife.id = 1   -- use this id to access the items in an array 
knife.width = 80
knife.height = 80
knife.x = 800
knife.y = 580
knife.addedToInventory = false
knife.image = love.graphics.newImage('assets/knife.png')
knife.name = "knife"
knife.render = function ()
if not knife.addedToInventory then
    -- there is a problem in this line which causes problem in collision detection due to the rotation of the image
    love.graphics.draw(knife.image, knife.x, knife.y, 0.6, knife.width/knife.image:getWidth(), knife.height/knife.image:getHeight())
    end
end

key = {}
key.id = 2
key.width = 30
key.height = 30
key.x = 400
key.y = 550
key.addedToInventory = false
key.image = love.graphics.newImage('assets/key.png')
key.name = "key"
key.render = function ()
    if not key.addedToInventory then
        love.graphics.draw(key.image, key.x, key.y, 0, key.width/key.image:getWidth(), key.height/key.image:getHeight())
    end
end

crowbar = InventoryPlacableItems(1000, 650, 100, 100, 4, love.graphics.newImage('assets/room2/crowbar.png'), "crowbar")

brown_key = {}
brown_key.id = 6
brown_key.x = 650
brown_key.y = 560
brown_key.width = 40
brown_key.height = 40
brown_key.addedToInventory = false
brown_key.image = love.graphics.newImage('assets/room2/brown_key.png')
brown_key.name = "brown_key"
brown_key.render = function ()
    if not brown_key.addedToInventory then
        love.graphics.draw(brown_key.image, brown_key.x, brown_key.y, 0, brown_key.width/brown_key.image:getWidth(), brown_key.height/brown_key.image:getHeight())
    end
end

battery = InventoryPlacableItems(WINDOW_WIDTH/2 - 25, 550, 50, 100, 7, love.graphics.newImage('assets/room2/battery.png'), "battery")
eraser = InventoryPlacableItems(400, 400, 109, 70, 5, love.graphics.newImage('assets/room2/eraser.png'), "Eraser")
screwdriver = InventoryPlacableItems(600, 350, 100, 200, 3, love.graphics.newImage('assets/room2/screwdriver.png'), "screwdriver")
storeRoomOpened = false

wrench = InventoryPlacableItems(450, 350, 300, 100, 7, love.graphics.newImage('assets/room3/wrench.png'), "wrench")
soapAndWater = InventoryPlacableItems(400, 580, 80, 60, 8, love.graphics.newImage('assets/room3/soap.png'), "soap and water")
mirorHidden = false
dirtErased = false

function Inventory:mousepressed(x, y, button)
    if button == 1 then
        if x > WINDOW_WIDTH - 100 then
            self.moveInventory = true
        end
        for key, value in pairs(self.items) do
            if (x > WINDOW_WIDTH - 100 and y > value.y and y < value.y + 100) then
                self.selectedItemId = value.id
                MOUSE_ASSET = value.image
                -- print(self.selectedItemId)
            end
        end
    elseif button == 2 then
        self.selectedItemId = nil
        MOUSE_ASSET = nil
    end
end

function Inventory:mousereleased(x, y)
    self.moveInventory = false
end

function Inventory:mousemoved(x, y, dx, dy, isTouch)
    if x > WINDOW_WIDTH - 100 and self.moveInventory then
        for key, value in pairs(self.items) do
            value.y = value.y + dy
        end
    end
end


function Inventory:insertItem(name)
    -- name is the table of the object

    local itemToBeAdded = {}
    if #self.items == 0 then
        -- when inserting the very first item
        itemToBeAdded.x = WINDOW_WIDTH - 100
        itemToBeAdded.y = 100
        itemToBeAdded.width = name.width
        itemToBeAdded.height = name.height
        itemToBeAdded.image = name.image
        itemToBeAdded.id = name.id
    else
        -- the elements of the inventory can be moved this is necessary to make sure they appear in sequence
        local lastElementInInventory = self.items[#self.items]
        itemToBeAdded.x = lastElementInInventory.x
        itemToBeAdded.y = lastElementInInventory.y + 100
        itemToBeAdded.width = name.width
        itemToBeAdded.height = name.height
        itemToBeAdded.image = name.image
        itemToBeAdded.id = name.id
    end
    name.addedToInventory = true
    itemToBeAdded.name = name.name

    table.insert(self.items, itemToBeAdded)
end

function Inventory:render()
    for key, value in pairs(self.items) do
        if self.selectedItemId == value.id then

            love.graphics.setColor(1, 0, 1)
            -- love.graphics.rectangle("line", value.x, value.y, 100, 100)
            love.graphics.draw(self.image, value.x, value.y, 0, 100/self.image:getWidth(), 100/self.image:getHeight())
            love.graphics.setColor(1, 1, 1)
            --print(value.name)
            love.graphics.printf(value.name, value.x - #value.name * 30, value.y, #value.name + 100, "center")
        else
            --love.graphics.rectangle("line", value.x, value.y, 100, 100)
            love.graphics.draw(self.image, value.x, value.y, 0, 100/self.image:getWidth(), 100/self.image:getHeight())
        end

        love.graphics.draw(value.image, value.x, value.y, 0, 100/value.image:getWidth(), 100/value.image:getHeight())
    end
end