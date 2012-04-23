
import ldkit/[Math, Input, Sprites]
import game/[Engine, Level, Terrain]
import ui/[MainUI]

Dropper: class {

    level: Level
    ui: MainUI
    input: Input
    moveListener, clickListener: Listener

    sprite: GroupSprite
    pos := vec2(0, 0)

    cb: Func (Vec2)

    offsetX, offsetY: Int

    init: func (=level, =cb) {
        ui = level ui
        input = ui input

        offsetX = - level terrain tileWidth / 2
        offsetY = - level terrain tileHeight / 2

        sprite = GroupSprite new()

        moveListener = input onMouseMove(||
            mp := input mousepos
            pos set!(mp)

            // from screen to iso then back to screen. Yay!
            isopos := getIsoPos()
            screenpos := level terrain getScreenPos(isopos)
            sprite pos set!(screenpos)
        )

        clickListener = input onMousePress(1, ||
            mp := input mousepos
            pos set!(mp)

            cleanup()
            cb(getIsoPos())
        )

        level terrain pass2 addSprite(sprite)
    }

    
    getIsoPos: func -> Vec2 {
        level terrain getIsoPos(vec2(pos x + offsetX, pos y + offsetY)) snap(1)
    }

    cleanup: func {
        level terrain pass2 removeSprite(sprite)
        input unsubscribe(moveListener)
        input unsubscribe(clickListener)
    }

}



