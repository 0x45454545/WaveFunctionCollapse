local tiles  = require "tiles"
local images = require "images"

local collapse = require "WaveFunctionCollapse"

local flr =   _G.math.floor
local rng = love.math.random

local tile_size = 64

local image_width  = 640
local image_height = 640

local map_width     = flr(image_width  / tile_size)
local map_height    = flr(image_height / tile_size)
local map_size      = map_width * map_height
local map           = { }

local pick = function(candidates) return candidates[rng(#candidates)] end

function love.load()

    -- Lib {
        local collapsable = true
        while collapsable
        do    collapsable = collapse(map, map_width, map_height, tiles, pick) end
    -- }

    local canvas = love.graphics.newCanvas(image_width, image_height)

    love.graphics.setCanvas(canvas)

    for y = 0, map_height - 1 do
        for x = 0, map_width - 1 do
            love.graphics.draw(
                images[map[x + y * map_width]],
                x * tile_size, 
                y * tile_size
            )
        end
    end

    love.graphics.setCanvas()

    canvas:newImageData():encode("png", "render.png")

    love.event.quit()

end
