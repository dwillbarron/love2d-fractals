local sh_ripple;
local sh_mbrot;
local cv_checkers;
local cv_mbrot;
local num_shadertime = 0;

local last_dt;

local window_w;
local window_h;

function love.load()
    love.window.setMode(800, 600, {resizable=true, vsync=true, minwidth=400, minheight=300})
    window_w = 800;
    window_h = 600;
end

function love.resize(w, h)
    if cv_mbrot ~= nil then
        cv_mbrot:release()
        cv_mbrot = nil
    end
    window_w = w
    window_h = h
end

function love.update(dt)
    last_dt = dt
    local cx, cy;
    cx = love.mouse.getX() / window_w;
    cy = love.mouse.getY() / window_h;

    if sh_ripple ~= nil then
        sh_ripple:send('t', num_shadertime)
    end
    if sh_mbrot ~= nil then
        sh_mbrot:send('t', num_shadertime)
        sh_mbrot:send('movexy', {cx*2-1, cy*2-1})
    end
    num_shadertime = num_shadertime + dt;
end

function mbrot_make()
    if (sh_mbrot == nil) then
        sh_mbrot = love.graphics.newShader('mbrot.glsl')
    end
end

function ripple()
    if (sh_ripple == nil) then
        sh_ripple = love.graphics.newShader('ripple.glsl');
    end
    --sh_ripple:send('wh', {love.graphics.getWidth(), love.graphics.getHeight()})

end

function checkers()
    cv_checkers = love.graphics.newCanvas()
    love.graphics.setCanvas(cv_checkers)
    love.graphics.setColor(0, 0, 0, 1);
    love.graphics.rectangle('fill', 0, 0, 330, 330);
    love.graphics.setColor(1, 1, 1, 1);
    local i, j, flip;
    for i = 0, 30, 1 do
        flip = (math.fmod(i, 2) == 0)
        for j = 0, 30, 1 do
            if (flip) then
                love.graphics.rectangle('fill', i*30, j*30, 30, 30)
            end
            if (flip) then
                flip = false
            else
                flip = true
            end
        end
    end
    love.graphics.setCanvas()
end

function mbrot()
    if cv_mbrot == nil then
        cv_mbrot = love.graphics.newCanvas()
    end
    love.graphics.setCanvas(cv_mbrot)
    love.graphics.setShader(sh_mbrot)
    love.graphics.setColor(1,1,1,1);
    love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight());
    love.graphics.setShader()
    love.graphics.setCanvas()
end


function rmap()
    cv_rmap = love.graphics.newCanvas()
end

function love.draw()
    if cv_checkers == nil then
        checkers();
    end
    --ripple()
    mbrot_make()
    mbrot()
    --love.graphics.setShader(sh_ripple)
    love.graphics.draw(cv_mbrot);
    --love.graphics.setShader()
    love.graphics.print(last_dt*1000 .. "ms", 0, 0);
end