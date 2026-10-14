

values = {
    mapHeight = (love.graphics.getHeight() / 16) - 2,
    mapWidth = (love.graphics.getWidth() / 16) - 2,
    maxNeighbors = 4,
    minNeighbors = 2,
    tileSize = 16,
    delayTime = 2
}

--////////////--

cells = {}

for x = 1, values.mapWidth do
    cells[x] = {}
    for y = 1, values.mapHeight do
        cells[x][y] = {neighbors = 0, state = 0}
    end
end

--///////////--

functions = {}

function functions.getNeighborCells()
    for x = 1, values.mapWidth do
        for y = 1, values.mapHeight do
                local count = 0

            for dx = -1, 1 do
                for dy = -1,1 do

                    if dx ~= 0 or dy ~= 0 then
                        local nx = x + dx
                        local ny = y + dy
    
                        if cells[nx] and cells[nx][ny] then
                            if cells[nx][ny].state == 1 then
                                count = count + 1
                            end
                        end
                    end
                end    
            end
            cells[x][y].neighbors = count
        end
    end
end


function functions.setNextGeneration()
        for x = 1, values.mapWidth do
            for y = 1, values.mapHeight do
                if cells[x][y].neighbors > 4 and cells[x][y].neighbors < 2 then
                    cells[x][y].state = 0
                else
                    cells[x][y].state = 1
                end        
            end
        end
end

function functions.timer(dt)
    local timer = 0
    timer = timer * dt
    love.graphics.print(timer, 10, 10)
    if timer >= 2 then
        timer = 0
        functions.setNextGeneration()
    end    
end    
    
function functions.drawFrames()
    for x = 1, values.mapWidth do
        for y = 1, values.mapHeight do
            love.graphics.setColor(0.5,0.5,0.5)
            love.graphics.rectangle("line", x * values.tileSize, y * values.tileSize, values.tileSize, values.tileSize)
        end
    end
end

function functions.drawCells()
    for x = 1, values.mapWidth do
        for y = 1, values.mapHeight do
            if cells[x][y].state == 1 then
                love.graphics.setColor(1,1,1)
                love.graphics.rectangle("fill", x * values.tileSize, y * values.tileSize, values.tileSize, values.tileSize)
            else
                love.graphics.setColor(0,0,0)
                love.graphics.rectangle("fill", x * values.tileSize, y * values.tileSize, values.tileSize, values.tileSize)
            end
        end
    end
end

--////////////--

function love.load()
    cells[12][12] = {neighbors = 0, state = 1}
    functions.getNeighborCells()
end

function love.update(dt)
    functions.timer(dt)
end

function love.draw()
    functions.drawCells()
    functions.drawFrames()
end