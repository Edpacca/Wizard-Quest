-- Class.lua Copyright (c) 2010-2013 Matthias Richter
Class = require 'class'
-- push.lua Copyright (c) 2018 Ulysse Ramage
push = require 'push'

require 'Animation'
require 'Fireball'
require 'Frostray'
require 'Items'
require 'Map64'
require 'Map'
require 'Wizard'
require 'Books'

SCALE = 2.5

-- Screen window global variables / virtutal sizes enables easy scaling
WINDOW_WIDTH = 1920
WINDOW_HEIGHT = 1080
VIRTUAL_WIDTH = WINDOW_WIDTH / SCALE
VIRTUAL_HEIGHT = WINDOW_HEIGHT / SCALE

-- WIZARD SPAWN TILE
SPAWNX = 29.5
SPAWNY = 29


love.graphics.setDefaultFilter('nearest', 'nearest')
map = Map()

-- initialisation of objects and data
function love.load()
    love.window.setTitle('Wizard Quest')

    defaultfont = love.graphics.getFont()
    fancyfont = love.graphics.newFont('master_fonts/CaviarDreams.ttf', 12)
    nicefont = love.graphics.newFont('master_fonts/Oswald-Regular.ttf', 12)
    
    -- love.graphics.setFont(fancyfont)
    

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })

    love.keyboard.keysPressed = {}
    love.keyboard.keysReleased = {}

    love.mouse.setVisible(false)
    love.mouse.setRelativeMode(false)

    
    mouse_img = love.graphics.newImage('master_graphics/Map/pointer.png')

    sounds = {
        ['tile1'] = love.audio.newSource('master_sounds/WQ_tile1.wav', 'static'),
        ['tile2'] = love.audio.newSource('master_sounds/WQ_tile2.wav', 'static'),
        ['tile3'] = love.audio.newSource('master_sounds/WQ_tile3.wav', 'static'),
        ['knock'] = love.audio.newSource('master_sounds/WQ_knock.wav', 'static'),

        ['scroll'] = love.audio.newSource('master_sounds/WQ_scroll.wav', 'static'),

        ['fireball'] = love.audio.newSource('master_sounds/WQ_fireball.wav', 'static'),
        ['firecharge'] = love.audio.newSource('master_sounds/WQ_firecharge.wav', 'static'),
        ['firecharge_big'] = love.audio.newSource('master_sounds/WQ_firecharge_big.wav', 'static'),
        ['firehit'] = love.audio.newSource('master_sounds/WQ_firehit.wav', 'static'),
        ['nocast'] = love.audio.newSource('master_sounds/WQ_nocast.wav', 'static'),
        ['frostray'] = love.audio.newSource('master_sounds/WQ_frostray.wav', 'static'),

        ['magic_swoosh'] = love.audio.newSource('master_sounds/WQ_magic1.wav', 'static'),
        ['magic_chord'] = love.audio.newSource('master_sounds/WQ_magic_hit_chord.wav', 'static'),

        ['orb1'] = love.audio.newSource('master_sounds/WQ_magic_hit1.wav', 'static'),
        ['orb2'] = love.audio.newSource('master_sounds/WQ_magic_hit2.wav', 'static'),
        ['orb3'] = love.audio.newSource('master_sounds/WQ_magic_hit3.wav', 'static'),
        ['orb4'] = love.audio.newSource('master_sounds/WQ_magic_hit4.wav', 'static'),
        ['orb5'] = love.audio.newSource('master_sounds/WQ_magic_hit5.wav', 'static'),

        ['portcullis'] = love.audio.newSource('master_sounds/WQ_portcullis.wav', 'static'),

        ['potion_grab'] = love.audio.newSource('master_sounds/WQ_potion_cork.wav', 'static'),
        ['potion_gone'] = love.audio.newSource('master_sounds/WQ_potiongone.wav', 'static'),

        ['wiz_cast'] = love.audio.newSource('master_sounds/wizard_cast.wav', 'static'),
        ['wiz_nocast'] = love.audio.newSource('master_sounds/wizard_nocast.wav', 'static'),
        ['wiz_ooh1'] = love.audio.newSource('master_sounds/wizard_ooh1.wav', 'static'),
        ['wiz_ooh2'] = love.audio.newSource('master_sounds/wizard_ooh2.wav', 'static'),
        ['wiz_hit1'] = love.audio.newSource('master_sounds/wizard_hit1.wav', 'static'),
        ['wiz_hit2'] = love.audio.newSource('master_sounds/wizard_hit2.wav', 'static'),
        ['wiz_hit3'] = love.audio.newSource('master_sounds/wizard_hit3.wav', 'static')

    }


end

-- called whenever window is resized
function love.resize(w, h)
    push:resize(w, h)
end

-- global key pressed function
function love.keyboard.wasPressed(key)
    if (love.keyboard.keysPressed[key]) then
        return true
    else
        return false
    end
end

-- -- global key released function
function love.keyboard.wasReleased(key)
    if (love.keyboard.keysReleased[key]) then
        return true
    else
        return false
    end
end

-- called whenever a key is pressed
function love.keypressed(key)    
    if key == 'escape' then
        love.event.quit()
    end
    love.keyboard.keysPressed[key] = true
end

-- -- called whenever a key is released
function love.keyreleased(key)
    love.keyboard.keysReleased[key] = true  
end

-- called every frame, with dt passed in as delta in time since last frame
function love.update(dt)
    map:update(dt)

    -- reset all keys pressed and released this frame
    love.keyboard.keysPressed = {}
    love.keyboard.keysReleased = {}
end

-- called each frame, used to render to the screen
function love.draw()
    push:apply('start')

    -- camera tracking
    love.graphics.translate(math.floor(-map.camX + 0.5), math.floor(-map.camY + 0.5))
    -- colour out background
    love.graphics.clear(168/255, 154/255, 154/255, 1)
    
    -- calls map render, which renders everything else
    map:render()

    push:apply('end')
end