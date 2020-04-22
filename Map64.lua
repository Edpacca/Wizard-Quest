Map64 = Class{}

PORTCULLIS = {}
for i = 1, 7 do
    PORTCULLIS[i] = i
end

function Map64:init(map)

    self.spritesheet64 = love.graphics.newImage('master_graphics/Map/Portcullis_spritesheet.png')
    self.sprites64 = generateQuads(self.spritesheet64, 64, 64)

    tiles64 = {}

    self:set64Tile(30, 21, PORTCULLIS[1])
    self:set64Tile(30, 14, PORTCULLIS[1])

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