

import ui/[MainUI, Graphics, Pass]

import math/Random, structs/ArrayList
import ldkit/[Math, Sprites]

Terrain: class {

    width := 8
    height := 8

    tileWidth := 50
    tileHeight := 25

    pass: Pass
    ui: MainUI

    init: func (=ui) {
        pass := Pass new(ui, "terrain")
        ui levelPass addPass(pass)

        tileTypes := [
            "concrete", "concrete", "concrete", "concrete", "concrete", "concrete", "concrete", "concrete", 
            "lava"
            "tower"
        ] as ArrayList<String>

        passCount := width + height - 1
        passes := ArrayList<Pass> new()
        for (i in 0..passCount) {
            p := Pass new(ui, "isometric %d" format(i))
            passes add(0, p)
            pass addPass(p)
        }

        // build terrain tiles
        totalWidth  := width  * 0 * tileWidth
        totalHeight := height * -1 * tileHeight

        offsetX := ui display getWidth() / 2 - totalWidth / 2
        offsetY := ui display getHeight() / 2 - totalHeight / 2

        /*

            The coordinates work like this:

                   o
                  / \   
                 /   \
             y  /     \ x

         */
        xAxis := vec2( tileWidth, -tileHeight)
        yAxis := vec2(-tileWidth, -tileHeight)

        base := vec2(offsetX, offsetY)

        for(x in 0..width) for (y in 0..height) {
            pos := base add(xAxis mul(x)) add(yAxis mul(y))
            passes[x + y] addSprite(tile(pos, Random choice(tileTypes)))
        }        
    }

    tile: func (pos: Vec2, name: String) -> Sprite {
        file := "assets/png/%s-100px.png" format(name)
        is := ImageSprite new(pos, file)
        is pos set!(is pos x, is pos y - (is height - tileHeight))
        is
    }

}


