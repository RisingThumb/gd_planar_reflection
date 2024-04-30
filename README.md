# gd_planar_reflections
## Motive

Godot has screenspace reflections and similar solutions but no planar reflections. This exists to fix that.

## Use
Should be self-explanatory. You will probably want to change the resolution for the reflected viewport from 1920x1080 to a resolution of your choice. This is on line 14 of the script. Note that this does involve rendering the scene again from another camera, so if you take this approach, be prepared for the graphics cost in doing this. A different reflection solution like Screenspace reflections, or just making a flipped copy of the mesh in the mirror might be a better solution.

Additionally this is set up to be like water currently. As a result the shader has a lot of settings to distort it like water. Feel free to turn these down if you want a pure mirror, or turn them up if you want rippling water.
