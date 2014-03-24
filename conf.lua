function love.conf(t)
    t.identity = "the-hunger-planes"
    t.version = "0.9.0"
    t.console = false
    t.window.title = "The Hunger Planes"
    t.window.width = 1000
    t.window.height = 700
    t.window.resizable = true         -- Let the window be user-resizable (boolean)
    t.window.minwidth = 600              -- Minimum window width if the window is resizable (number)
    t.window.minheight = 400             -- Minimum window height if the window is resizable (number)
    t.window.fullscreen = false        -- Enable fullscreen (boolean)
    t.window.fullscreentype = "normal" -- Standard fullscreen or desktop fullscreen mode (string)
    t.window.vsync = true              -- Enable vertical sync (boolean)
    t.window.fsaa = 4                  -- The number of samples to use with multi-sampled antialiasing (number)
    t.window.display = 1               -- Index of the monitor to show the window in (number)
    t.window.highdpi = false           -- Enable high-dpi mode for the window on a Retina display (boolean). Added in 0.9.1
    t.window.srgb = false              -- Enable sRGB gamma correction when drawing to the screen (boolean). Added in 0.9.1
end