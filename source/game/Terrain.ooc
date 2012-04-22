

import ui/[MainUI, Graphics, Pass]
import ldkit/[Math, Sprites]

Terrain: class {

    width := 10
    height := 10

    cellSize := 50

    pass: Pass
    ui: MainUI

    init: func (=ui) {
        pass := Pass new(ui, "terrain")
        ui levelPass addPass(pass)

        // build terrain tiles
        totalWidth := width * cellSize
        totalHeight := height * cellSize

        offsetX := ui display getWidth() / 2 - totalWidth / 2
        offsetY := ui display getHeight() / 2 - totalHeight / 2

        for (x in 0..width) for(y in 0..height) {
            pass addSprite(Graphics placeholder("cell", vec2(offsetX + x * cellSize, offsetY + y * cellSize), cellSize))
        }        
    }

}


