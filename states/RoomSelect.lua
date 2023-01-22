RoomSelect = Class{__includes = BaseState}

RoomCard = Class{}

-- class for defining a room card
function RoomCard:init(x, y, width, height, number, name, stateName)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.number = number
    self.name = name
    self.stateName = stateName
    self.imageUnselected = love.graphics.newImage('assets/room_level_thumbnail/unselected_text/level-' .. number .. '_icon.png')
    self.imageSelected = love.graphics.newImage('assets/room_level_thumbnail/selected_text/level-' .. number .. '_icon.png')
end

function RoomSelect:init()
    self.initialMoutxt = nil
    self.initialMouseY = nil
    self.finalMoutxt = nil
    self.finalMouseY = nil

    self.moveAllRoomCards = false

    self.rooms = {}
    
    -- initialize the rooms
    self.roomWidth = WINDOW_WIDTH/6
    self.roomHeight = WINDOW_WIDTH/6

    -- background image
    self.background = love.graphics.newImage('assets/levelSelect/background.png')


    -- make those room cards
    self.room1 = RoomCard(-300+WINDOW_WIDTH/6 + self.roomWidth/2, WINDOW_HEIGHT/2 - self.roomHeight/2, self.roomWidth, self.roomHeight, 1, "Room 1", "room1")
    self.room2 = RoomCard(-250+WINDOW_WIDTH/6 + 3 * self.roomWidth/2, WINDOW_HEIGHT/2 - self.roomHeight/2, self.roomWidth, self.roomHeight, 2, "Room 2", "room2")
    self.room3 = RoomCard(-200+WINDOW_WIDTH/6 + 5 * self.roomWidth/2, WINDOW_HEIGHT/2 - self.roomHeight/2, self.roomWidth, self.roomHeight, 3, "Room 3", "room3")
    self.room4 = RoomCard(-150+WINDOW_WIDTH/6 + 7 * self.roomWidth/2, WINDOW_HEIGHT/2 - self.roomHeight/2, self.roomWidth, self.roomHeight, 4, "Room 4", "room4")
    self.room5 = RoomCard(-100+WINDOW_WIDTH/6 + 9 * self.roomWidth/2, WINDOW_HEIGHT/2 - self.roomHeight/2, self.roomWidth, self.roomHeight, 5, "Room 5", "room5")

    self.lockedRoomImage = love.graphics.newImage('assets/room_level_thumbnail/locked/locked_icon.png')

    -- insert them into the table containing all the room cards
    table.insert(self.rooms, self.room1)
    table.insert(self.rooms, self.room2)
    table.insert(self.rooms, self.room3)
    table.insert(self.rooms, self.room4)
    table.insert(self.rooms, self.room5)
end

function RoomSelect:mousepressed(x, y, button)
    if button == 1 then
        -- to register a click and not to confuse with sliding the rooms
        self.initialMoutxt = x
        self.initialMouseY = y

        -- check if you clicked to move the cards
        if y > WINDOW_HEIGHT/2 - self.roomHeight/2 and y < WINDOW_HEIGHT/2 + self.roomHeight/2 then
            self.moveAllRoomCards = true
        end
    end
end

function RoomSelect:mousereleased(x, y, button)
    if button == 1 then
        -- to register a click and not to confuse with sliding the rooms
        self.finalMoutxt = x
        self.finalMouseY = y

        -- stop moving the rooms
        self.moveAllRoomCards = false

        -- only check for mouse click if pressed on a room and not moved the room
        if self.initialMoutxt == self.finalMoutxt and self.initialMouseY == self.finalMouseY then
            for key, room in pairs(self.rooms) do
                if x > room.x and x < room.x + room.width and y > room.y and y < room.y + room.height then
                    if room.number <= LOCKED_ROOMS then
                        gStateMachine:change(room.stateName)                        
                    end
                end
            end
        end
    end
end

function RoomSelect:mousemoved(x, y, dx, dy)
    if self.moveAllRoomCards then
        -- move all the rooms as where the mouse is 
        for key, room in pairs(self.rooms) do
            room.x = room.x + dx
        end
    end
end

function RoomSelect:checkIfHoverOnAnyRoom()
    local mx, my = love.mouse.getPosition()
    local rmx, rmy = push:toGame(mx, my)

    if rmx ~= nil and rmy ~= nil then
        for key, room in pairs(self.rooms) do
            if rmx > room.x and rmx < room.x + room.width and rmy > room.y and rmy < room.y + room.height then
                room.isSelected = true
            else
                room.isSelected = false
            end
        end
    end
end

function RoomSelect:update(dt)
    self:checkIfHoverOnAnyRoom()
end

function RoomSelect:render()
    love.graphics.draw(self.background, 0, 0, 0, WINDOW_WIDTH/self.background:getWidth(), WINDOW_HEIGHT/self.background:getHeight())
    love.graphics.printf("Select the Room", 0, 100, WINDOW_WIDTH, "center")

    -- love.graphics.line(0, WINDOW_HEIGHT/2 - self.roomHeight/2, WINDOW_WIDTH, WINDOW_HEIGHT/2 - self.roomHeight/2)
    -- love.graphics.line(0, WINDOW_HEIGHT/2 + self.roomHeight/2, WINDOW_WIDTH, WINDOW_HEIGHT/2 + self.roomHeight/2)

    for key, room in pairs(self.rooms) do
        if room.number > LOCKED_ROOMS then
            love.graphics.draw(self.lockedRoomImage, room.x, room.y, 0, room.width/self.lockedRoomImage:getWidth(), room.height/self.lockedRoomImage:getHeight())
        else
            if room.isSelected then
                love.graphics.draw(room.imageSelected, room.x, room.y, 0, room.width/room.imageSelected:getWidth(), room.height/room.imageSelected:getHeight())
            else
                love.graphics.draw(room.imageUnselected, room.x, room.y, 0, room.width/room.imageSelected:getWidth(), room.height/room.imageSelected:getHeight())
            end
        end
    end
end