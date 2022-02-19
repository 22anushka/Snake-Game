-- code adapted from cs50 (by Harvard) Games track (mario)

-- Utility Class

function generateQuads(atlas, tilewidth, tileheight)
    -- atlas is the spritesheet or texturesheet containing stored information
    -- here atlas takes in the texture data

    --[[
        to chop up the sheet (here, spritesheet) into blocks
    ]] 

    -- local variables local to this function
    local sheetWidth = atlas:getWidth() / tilewidth
    local sheetHeight = atlas:getHeight() / tileheight

    -- numbering begins with 1 
    local sheetCounter = 1

    --[[
        table squaring quads that are created
        quads are rectangles representing a chunck of texture
        lua default index begins at 1 - for arrays etc
    ]] 
    local quads = {}

    -- pixel index begins at 0
    --[[
        left to right
        top to bottom
    ]]
    for y = 0, sheetHeight - 1 do 
        for x = 0, sheetWidth - 1 do 
            --atlas:getDimensions gets dimensions of the texture
            quads[sheetCounter] = 
                love.graphics.newQuad(x * tilewidth, y * tileheight, tilewidth, tileheight,
                    atlas:getDimensions())
            sheetCounter = sheetCounter + 1
        end
    end

    return quads
end