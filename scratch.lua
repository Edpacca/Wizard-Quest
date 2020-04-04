self.spritesheet = love.graphics.newImage('Graphics/Map/Map1_tilesheet_2.png')
-- gets the image sheet as spritesheet

self.sprites = generateQuads(self.spritesheet, 32, 32)
-- inputs spritesheet into quads to give sprites. Is this an array?? 
-- where is this called

function generateQuads(atlas, tilewidth, tileheight)
   local sheetWidth = atlas:getWidth() / tilewidth      --gets the total sheetwidth in tiles
   local sheetHeight = atlas:getHeight() / tileheight    --gets sheetheight in tiles

   local sheetCounter = 1
   local quads = {}

   for y = 0, sheetHeight - 1 do
       for x = 0, sheetWidth - 1 do
           -- this quad represents a square cutout of our atlas that we can
           -- individually draw instead of the whole atlas
           quads[sheetCounter] =
               love.graphics.newQuad(x * tilewidth, y * tileheight, tilewidth,
               tileheight, atlas:getDimensions())
           sheetCounter = sheetCounter + 1
       end
   end

   return quads -- returns the array of quads from 1 to whatever 
end



self.tileWidth = 32    -- tilewidth in pixels
self.tileHeight = 32   -- tileheight in pixels
self.mapWidth = 61     -- number of tiles across the map
self.mapHeight = 61    -- number of tiles high
self.tiles = {}        -- initialise tiles array (empty)

self.mapWidthPixels = self.mapWidth * self.tileWidth       -- mapwidth in pixels is tiles * tilewidth in pixels
self.mapHeightPixels = self.mapHeight * self.tileHeight    -- mapheight in pixels is tiles *tilehieght in pixels


function Map:tileAt(x, y) --tile At, takes x and y (in pixels)
return {
      x = math.floor(x / self.tileWidth) + 1,  --returns x tile position, floor of pixels / tilew + 1 because array starts at 1
      y = math.floor(y / self.tileHeight) + 1, -- returns y tile position
      id = self:getTile(math.floor(x / self.tileWidth) + 1, -- returns ID from getTile(returned x and y)
      math.floor(y / self.tileHeight) + 1)                   -- I don't see why this couldn't be x and y..
}
end

function Map:getTile(x, y) -- get tile takes x and y in TILE POSITION
return self.tiles[(y - 1) * self.mapWidth + x] -- returns the tile at a point on the map. If the map is considered an array of tiles
                                                --y - 1 gives the row (if first row then = 0)
                                                -- multiply by map width in tiles, and add x in tiles.
end

function Map:setTile(x, y, id)
   self.tiles[(y - 1) * self.mapWidth + x] = id   -- does the opposite where it takes x and y in tile position
                                                   -- and sets tile at array point to the NAME that is assigned to it
end

function Map:render()
   for y = 1, self.mapHeight do     -- iterate down map in tiles
       for x = 1, self.mapWidth do    -- iterate across map in tiles
           local tile = self:getTile(x, y)     -- tile = getTile -> returns the tile[array]
           love.graphics.draw(self.spritesheet, self.sprites[tile],  -- draws the tiles from spritesheet at the tile position.
               (x - 1) * self.tileWidth, (y - 1) * self.tileHeight)    -- reverses the assignemtn of number to ID. 
       end                       -- draws the tile at pixel x - 1* the width and y-1 * height to start at 0,0
   end
end


function Wizard:check_map_Up_collision()

    if self.dy < 0 then

        if self.map:collides(self.map:tileAt(self.x, self.y - 1)) then

            self.dy = 0
            self.y = self.map:tileAt(self.x, self.y - 1).y * self.map.tileHeight
            -- tile_collision _id = self.map:tileAt(self.x, self.y - 1).id
            -- return tile_collision_id

        elseif self.map:collides(self.map:tileAt(self.x1 - 1, self.y - 1)) then
            
            self.dy = 0
            self.y = self.map:tileAt(self.x - 1, self.y - 1).y * self.map.tileHeight
            -- tile_collision_id = self.map:tileAt(self.x, self.y - 1).id
            -- return tile_collision_id

        end
    end
end

function Wizard:check_map_Down_collision()
    
    if self.dy > 0 then
 
        if self.map:collides(self.map:tileAt(self.x, self.y1)) then
        
            self.dy = 0
            self.y = (self.map:tileAt(self.x, self.y1).y - 1) * self.map.tileHeight - self.height


        elseif self.map:collides(self.map:tileAt(self.x1 - 1, self.y1)) then

            self.dy = 0
            self.y = (self.map:tileAt(self.x - 1, self.y1).y - 1) * self.map.tileHeight - self.height

        end
    end
end

function Wizard:check_map_Left_collision()
    
    if self.dx < 0 then

        if self.map:collides(self.map:tileAt(self.x - 1, self.y)) then

            self.dx = 0
            self.x = self.map:tileAt(self.x - 1, self.y).x * self.map.tileWidth

        elseif self.map:collides(self.map:tileAt(self.x - 1, self.y1 - 1)) then
           
            self.dx = 0
            self.x = self.map:tileAt(self.x - 1, self.y).x * self.map.tileWidth

        end
    end
end

function Wizard:check_map_Right_collision()
    
    if self.dx > 0 then
 
        if self.map:collides(self.map:tileAt(self.x1, self.y)) then

            self.dx = 0
            self.x = (self.map:tileAt(self.x1, self.y).x - 1) * self.map.tileWidth - self.width

        elseif self.map:collides(self.map:tileAt(self.x1, self.y1 - 1)) then

            self.dx = 0
            self.x = (self.map:tileAt(self.x1, self.y - 1).x - 1) * self.map.tileWidth - self.width

        end
    end
end


function Wizard:check_target_tile_Up_collision()


    if self.map:target_tile(self.map:tileAt(self.x, self.y - 1)) then

        check_tile = self.map:tileAt(self.x, self.y - 1).id
        return check_tile, true

    elseif self.map:target_tile(self.map:tileAt(self.x1 - 1, self.y - 1)) then
        
        check_tile = self.map:tileAt(self.x1 - 1, self.y - 1).id
        return check_tile, true

    else
        check_tile = 0
        return check_tile, false
        
    end

end

function Wizard:check_target_tile_Down_collision()


    if self.map:target_tile(self.map:tileAt(self.x, self.y1))  then
    
        check_tile = self.map:tileAt(self.x, self.y1).id
        return check_tile, true

    elseif self.map:target_tile(self.map:tileAt(self.x1 - 1, self.y1))  then

        check_tile = self.map:tileAt(self.x1 - 1, self.y1).id
        return check_tile, true

    else
        check_tile = 0
        return check_tile, false
    end


end

function Wizard:check_target_tile_Left_collision()


    if self.map:target_tile(self.map:tileAt(self.x - 1, self.y))  then

        check_tile = self.map:tileAt(self.x - 1, self.y).id
        return check_tile, true

    elseif self.map:target_tile(self.map:tileAt(self.x - 1, self.y1 - 1)) then

        check_tile = self.map:tileAt(self.x - 1, self.y1 - 1).id
        return check_tile, true
    else
        check_tile = 0
        return check_tile, false
    end

end

function Wizard:check_target_tile_Right_collision()


    if self.map:target_tile(self.map:tileAt(self.x1, self.y)) then

        check_tile = self.map:tileAt(self.x1, self.y).id
        return check_tile, true

    elseif self.map:target_tile(self.map:tileAt(self.x1, self.y1 - 1)) then

        check_tile = self.map:tileAt(self.x1, self.y1 - 1).id
        return check_tile, true

    else
        check_tile = 0
        return check_tile, false
    end

end