Inventory = Class{__includes = BaseState}

function Inventory:init()
    self.items = {}
    self.moveInventory = false
    self.selectedItemId = nil
end

function Inventory:mousepressed(x, y)

    if x > WINDOW_WIDTH - 100 then
        self.moveInventory = true
    end

    for key, value in pairs(self.items) do
        if (x > WINDOW_WIDTH - 100 and y > value.y and y < value.y + 100) then
            self.selectedItemId = value.id
            print(self.selectedItemId)
        end
    end
end

function Inventory:mousereleased(x, y)
    self.moveInventory = false
end

function Inventory:mousemoved(x, y, dx, dy, isTouch)
    if x > WINDOW_WIDTH - 100 and self.moveInventory then
        for key, value in pairs(self.items) do
            value.y = value.y + dy / 2
        end
    end
end


function Inventory:insertItem(name)
    -- name is the table of the object

    local itemToBeAdded = {}
    if #self.items == 0 then
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

    itemToBeAdded.name = name

    table.insert(self.items, itemToBeAdded)
end

function Inventory:render()
    for key, value in pairs(self.items) do
        if self.selectedItemId == value.id then
            love.graphics.setColor(1, 0, 0)
            love.graphics.rectangle("line", value.x, value.y, 100, 100)
            love.graphics.setColor(1, 1, 1)
        else
            love.graphics.rectangle("line", value.x, value.y, 100, 100)
        end

        love.graphics.draw(value.image, value.x, value.y, 0, 100/value.image:getWidth(), 100/value.image:getHeight())
    end
end