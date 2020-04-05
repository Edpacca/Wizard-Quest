require 'Util'
Map = Class{}

DIRT = 1
SQUARE = 2
WALL = 4
WALL_TORCH = 5
WALL_WINDOW = 7
PILLAR = 23

TILE_EMPTY = 8

ALCOVE_ORB_ON = 6
ALCOVE_ORB_OFF = 24
SQUARE_ORB_ON = 26
SQUARE_ORB_OFF = 25

FIRE_TILE_ON = 3
FIRE_TILE_OFF = 20
ICE_TILE_ON = 22
ICE_TILE_OFF = 21

PORTCULLIS = {}
for i = 0, (19 * 2) do
    PORTCULLIS[i] = i
end

local SCROLL_SPEED = 300

function Map:init()

    self.spritesheet = love.graphics.newImage('master_graphics/Map/Map1_tilesheet_2.png')
    self.sprites = generateQuads(self.spritesheet, 32, 32)

    self.tileWidth = 32
    self.tileHeight = 32
    self.mapWidth = 61
    self.mapHeight = 61
    self.tiles = {}

    self.items = Items(self)
    self.wizard = Wizard(self)



    self.camX = 0
    self.camY = 0

    self.mapWidthPixels = self.mapWidth * self.tileWidth
    self.mapHeightPixels = self.mapHeight * self.tileHeight

    
    for y = 1, self.mapHeight do
        for x = 1, self.mapWidth do
            if (x > 8 and x < 53 and y > 2 and y < 14) or          -- top chamber

            ((y == 23 or y == 37) and x > 28 and x < 33) or     -- main circle
            ((y == 24 or y == 36) and x > 26 and x < 35) or
            ((y == 25 or y == 35) and x > 25 and x < 36) or
            ((y == 26 or y == 34) and x > 24 and x < 37) or
            (y > 26 and y < 34 and x > 23 and x < 38) or
            (y > 28 and y < 32 and (x == 23 or x == 38)) then              
                self:setTile(x, y, DIRT)
            else
                self:setTile(x, y, WALL)
            end
        end
    end

    -- self:draw_even_semicircle(30, 30, 8, 4, 1, DIRT)
    -- self:draw_even_semicircle(30, 30, 8, 4, -1, DIRT)

    self:draw_odd_circle(12, 30, 11, 3, DIRT)
    self:draw_odd_circle(49, 30, 11, 3, DIRT)
    self:draw_odd_circle(29, 46, 9, 3, DIRT)
    self:draw_odd_circle(32, 46, 9, 3, DIRT)

    self:draw_corridor(30, 2, 38, 6, DIRT)
    self:draw_corridor(18, 5, 29, 3, DIRT)
    self:draw_corridor(39, 5, 29, 3, DIRT)
    self:draw_corridor(30, 2, 14, 7, DIRT)


    self:setTile(30, 21, PORTCULLIS[8])
    self:setTile(31, 21, PORTCULLIS[9])
    self:setTile(30, 22, PORTCULLIS[27])
    self:setTile(31, 22, PORTCULLIS[28])

    self:setTile(12, 30, FIRE_TILE_OFF)
    self:setTile(7, 30, FIRE_TILE_OFF)
    self:setTile(49, 30, ICE_TILE_OFF)
    self:setTile(54, 30, ICE_TILE_OFF)

    -- x = 1
    -- for y = 9, self.mapHeight do
    --     if y == 11 or y == 13 or y == 15 then
    --         self:setTile(x, y, ALCOVE_ORB_OFF)
    --     else
    --         self:setTile(x, y, WALL)
    --     end
    -- end

    -- x = self.mapWidth
    -- for y = 9, self.mapHeight do
    --     self:setTile(x, y, WALL)
        
    -- end
    

end

-- return whether a given tile is collidable
function Map:collides(tile)
    -- define our collidable tiles
    local collidables = {
        WALL, WALL_TORCH, WALL_WINDOW, 
        ALCOVE_ORB_OFF, ALCOVE_ORB_ON, 
        -- PILLAR, PORTCULLIS[27], PORTCULLIS[28]
    }

    -- iterate and return true if our tile type matches
    for _, v in ipairs(collidables) do
        if tile.id == v then
            return true
        end
    end

    return false
end

function Map:update(dt)
    
    self.wizard:update(dt)

    -- self.camX = math.max(0, math.min(self.wizard.x - VIRTUAL_WIDTH / 2,
    --     math.min(self.mapWidthPixels - VIRTUAL_WIDTH, self.wizard.x)))
    -- self.camY = self.wizard.y - VIRTUAL_HEIGHT / 2
    self.camX = self.wizard.x - VIRTUAL_WIDTH / 2
    self.camY = self.wizard.y - VIRTUAL_HEIGHT / 2


    MOUSE_X = love.mouse.getX() + map.camX
    MOUSE_Y = love.mouse.getY() + map.camY

end

-- gets the tile type at a given pixel coordinate
function Map:tileAt(x, y)
    return {
        x = math.floor(x / self.tileWidth) + 1,
        y = math.floor(y / self.tileHeight) + 1,
        id = self:getTile(math.floor(x / self.tileWidth) + 1, 
        math.floor(y / self.tileHeight) + 1)
    }
end

-- returns an integer value for the tile at a given x-y coordinate
function Map:getTile(x, y)
    return self.tiles[(y - 1) * self.mapWidth + x]
end

-- sets a tile at a given x-y coordinate to an integer value
function Map:setTile(x, y, id)
    self.tiles[(y - 1) * self.mapWidth + x] = id
end


function Map:draw_odd_circle(cenx, ceny, diameter, thickness, atile)

    local wl = cenx - (thickness - 1)
    local wu = cenx + (thickness - 1)
    local xl = cenx - ((diameter - 1) / 2)
    local xu = cenx + ((diameter - 1) / 2)
    local xm1 = -1
    local xm2 = 1
    
    local hl = ceny - ((diameter - 1) / 2)
    local hu = ceny

    for c = 1, 3 do
            for y = hl, hu do
                    for x = xl, xu do
                        if x > wl and x < wu then
                            self:setTile(x, y, atile)
                        end
                    end
                wl = wl + xm1
                wu = wu + xm2
            end
            
        wl = cenx - ((diameter + 1) / 2)
        wu = cenx + ((diameter + 1) / 2)
        xl = cenx - ((diameter - 1) / 2)
        xu = cenx + ((diameter - 1) / 2)
        xm1 = 1
        xm2 = -1
        hl = ceny + 1
        hu = ceny + ((diameter - 1) / 2)
    end

end

-- cenx = 30
-- ceny = 30
-- radius = 8
-- thickness = 4
-- orientation = 1

function Map:draw_even_semicircle(cenx, ceny, radius, thickness, orientation, atile)


    local wl = cenx - (orientation * thickness / 2)
    local wu = cenx + (orientation * thickness / 2) + 1
    local xm1 = -1 * orientation
    local xm2 = 1 * orientation
     
    local yl = ceny - radius + 1
    local yu = ceny
    local xl = cenx - radius + 1
    local xu = cenx + radius
      
        for x = xl, xu do
            if x > wl and x < wu then
                self:setTile(x, yl, atile)
            end
        end
        wl = wl + ((thickness / 2) * xm1)
        wu = wu + ((thickness / 2) * xm2)
        for x = xl, xu do
            if x > wl and x < wu then
                self:setTile(x, yl + 1, atile)
            end
        end
        wl = wl + xm1
        wu = wu + xm2
        y = yl + 2
        for x = xl, xu do
            if x > wl and x < wu then
                self:setTile(x, y, atile)
            end
        end
        wl = wl + xm1
        wu = wu + xm2
        y = yl + 3
        for x = xl, xu do
            if x > wl and x < wu then
                self:setTile(x, y, atile)
            end
        end
        wl = wl + xm1
        wu = wu + xm2
        for y = yl + 4, yl + 5 do
            for x = xl, xu do
                if x > wl and x < wu then
                    self:setTile(x, y, atile)
                end
            end        
        end
        wl = wl + xm1
        wu = wu + xm2
        for y = yl + 5, yl + 6 do
            for x = xl, xu do
                if x > wl and x < wu then
                    self:setTile(x, y, atile)
                end
            end        
        end     
        
end

function Map:draw_corridor(x1, x_wide, y1, y_tall, atile)
    for y = y1, y1 + y_tall - 1 do
        for x = x1, x1 + x_wide - 1 do
            self:setTile(x, y, atile)
        end
    end
end


function Map:render()
    for y = 1, self.mapHeight do
        for x = 1, self.mapWidth do          
            local tile = self:getTile(x, y)
            love.graphics.draw(self.spritesheet, self.sprites[tile],
                (x - 1) * self.tileWidth, (y - 1) * self.tileHeight)
        end
    end


    self.wizard:render()
    -- love.graphics.draw(map.mouse_img, love.mouse.getX(), love.mouse.getY())
    love.graphics.draw(mouse_img, love.mouse.getX() + self.camX, love.mouse.getY() + self.camY)
end