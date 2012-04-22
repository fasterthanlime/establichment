

import ui/[MainUI, Graphics, Pass]

import math/Random, structs/ArrayList
import ldkit/[Math, Sprites]

Terrain: class {

    width := 8
    height := 8

    tileWidth := 50
    tileHeight := 25

    pass: Pass
    passes: ArrayList<Pass>
    ui: MainUI

    xAxis, yAxis: Vec2

    tileTypes := [
        "concrete", "concrete", "concrete", "concrete", "concrete", "concrete", "concrete", "concrete", 
        "lava"
        "tower"
    ] as ArrayList<String>


    init: func (=ui) {
        pass = Pass new(ui, "terrain")
        ui levelPass addPass(pass)

        xAxis = vec2( tileWidth, -tileHeight)
        yAxis = vec2(-tileWidth, -tileHeight)

        passCount := width + height - 1
        passes = ArrayList<Pass> new()
        for (i in 0..passCount) {
            p := Pass new(ui, "isometric %d" format(i))
            passes add(0, p)
            pass addPass(p)
        }

        spawnRandomTiles()
    }

    spawnRandomTiles: func {
        // build terrain tiles
        offset := getOffset()

        /*
            The coordinates work like this:

                   o
                  / \   
                 /   \
             y  /     \ x

         */

        base := vec2(offset x, offset x)

        for(x in 0..width) for (y in 0..height) {
            pos := base add(xAxis mul(x)) add(yAxis mul(y))
            passes[x + y] addSprite(tile(pos, Random choice(tileTypes)))
        }        
    }

    getOffset: func -> Vec2 {
        totalWidth  := 0
        totalHeight := height * -1 * tileHeight

        vec2(
            ui display getWidth() / 2 - totalWidth / 2,
            ui display getHeight() / 2 - totalHeight / 2
        )
    }

    tile: func (pos: Vec2, name: String) -> Sprite {
        file := "assets/png/%s-100px.png" format(name)
        is := ImageSprite new(pos, file)
        is pos set!(is pos x, is pos y - (is height - tileHeight))
        is
    }

}


