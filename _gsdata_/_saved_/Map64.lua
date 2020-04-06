Map64 = Class{}

TILE_EMPTY = 40

DIRT = 1
SQUARE = 21
WALL = 4
WALL_TORCH = 5
WALL_WINDOW = 25
PILLAR = 24
PILLAR_2 = 28
WALL_TL = 14
WALL_TR = 15
WALL_BL = 34
WALL_BR = 35

BOOKSHELF = 36

WOOD_H = 16
WOOD_V = 17
WOOD_H_BURNT = 27
WOOD_V_BURNT = 28
WOOD_H_FROZEN = 18
WOOD_V_FROZEN = 19

ALCOVE_ORB_OFF_N = 10
ALCOVE_ORB_OFF_S = 12
ALCOVE_ORB_OFF_E = 6
ALCOVE_ORB_OFF_W = 8
ALCOVE_ORB_ON_N = 11
ALCOVE_ORB_ON_S = 13
ALCOVE_ORB_ON_E = 7
ALCOVE_ORB_ON_W = 9

FLOOR_ORB_OFF = 26
FLOOR_ORB_ON = 27

FIRE_TILE_OFF = 2
FIRE_TILE_ON = 3
ICE_TILE_OFF = 22
ICE_TILE_ON = 23

PORTCULLIS = {}
for i = 1, 7 do
    PORTCULLIS[i] = i
end

function Map64:init(map)

    self.spritesheet64 = love.graphics.newImage('master_graphics/Map/Portcullis_spritesheet.png')
    self.sprites64 = generateQuads(self.spritesheet64, 64, 64)

    tiles64 = {}

    self:set64Tile(30, 21, PORTCULLIS[1])

end


function Map64:collides(tile)

    local collidables = {

    }

    for _, v in ipairs(collidables) do
        if tile.id == v then
            return true
        end
    end

    return false
end

function Map64:update(dt)
    
end

-- sets a tile at a given x-y coordinate to an integer value
function Map64:set64Tile(tile_x, tile_y, id)

    table.insert(tiles64, {tile64_id = id, tile64_x = (tile_x - 1) * 32, tile64_y = (tile_y - 1) * 32})

end

function Map64:render()

    for i, v in ipairs(tiles64) do
        love.graphics.draw(self.spritesheet64, self.sprites64[v.tile64_id], v.tile64_x, v.tile64_y)
    end

end