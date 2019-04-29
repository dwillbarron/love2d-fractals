# love2d-fractals
Rendering the Mandelbrot and Julia set in Love2D.

# Requirements
 - Running on Windows:
   - Tested primarily on Windows 10
   - The latest version of Love2D is required from love2d.org
   - love-nuklear is required, but is included in this project as nuklear.dll.
 - Running on Linux:
   - Not supported but if you're willing it should be possible
   - Get the latest version of Love2D (you may have to compile from source)
     - DO NOT get the version from the Ubuntu repos, it is too old to compile these shaders correctly
   - You will need to manually compile love-nuklear and place the .so file inside the same folder as `main.lua`.

# Running
With Love2D installed and love.exe installed in your path, you can run `love .` in the same directory as `main.lua`.  
If you do not know how to add love.exe to the path or where it is located, check this guide: https://love2d.org/wiki/PATH

# Navigation
 - Move fractal: Arrow Keys
 - Zoom In: + key
 - Zoom Out: - key

 UI dialogs are movable and collapsable. Resizing the window smaller such that a dialog is cut off of the screen will require you to increase the size again to recover the dialogs. Do keep that in mind.