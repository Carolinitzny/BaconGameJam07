function table.removeValue(t, value)
    for k,v in pairs(t) do
        if v == value then
            table.remove(t, k)
            return
        end
    end
end

-- Converts HSL to RGB (input range: 0 - 1, output range: 0 - 1)end
function hsl2rgb(h, s, l)
    local r, g, b = nil, nil, nil

    if s == 0 then
        r, g, b = l, l ,l -- achromatic
    else
        local hue2rgb = function(p, q, t)
            if t < 0 then
                t = t + 1
            end
            if t > 1 then
                t = t - 1
            end
            if t < 1/6 then
                return p + (q - p) * 6 * t
            end
            if t < 1/2 then
                return q
            end
            if t < 2/3 then
                return p + (q - p) * (2/3 - t) * 6
            end
            return p
        end

        local q = nil
        if l < 0.5 then
            q = l * (1 + s)
        else
            q = l + s - l * s
        end
        local p = 2 * l - q
        r = hue2rgb(p, q, h + 1/3)
        g = hue2rgb(p, q, h)
        b = hue2rgb(p, q, h - 1/3)
    end

    return r, g, b
end

function toggleMute()
    love.audio.setVolume(1 - love.audio.getVolume())
end

function math.clamp(value, a, b)
    if b < a then a, b = b, a end
    return math.min(b, math.max(a, value))
end

function getTouches()
    local function _getTouches()
        local touches = {}
        for i=1,love.touch.getTouchCount() do
            local id, x, y, p = love.touch.getTouch(i)
            local touch = {}
            touch.id = id
            touch.x = x * love.graphics.getWidth()
            touch.y = y * love.graphics.getHeight()
            touch.p = p
            table.insert(touches, touch)
        end
        return touches
    end

    local e, r = pcall(_getTouches)
    return e and r or {}
end
