
import ldkit/[Math, Input, Sprites]
import game/[Engine, Level, Terrain]
import ui/[MainUI]

Dropper: class {

    level: Level
    ui: MainUI
    input: Input
    moveListener, clickListener: Listener

    sprite: GroupSprite
    outline: RectSprite

    cb: Func (Vec2)

    init: func (=level, =cb) {
        ui = level ui
        input = ui input

        sprite = GroupSprite new()

        rs := RectSprite new(vec2(0, 0))
        rs color set!(1, 1, 1)
        rs filled = false
        rs thickness = 1
        rs size set!(level terrain tileWidth, level terrain tileHeight)
        level terrain pass2 addSprite(rs)
        outline = rs

        moveListener = input onMouseMove(||
            mp := input mousepos
            sprite pos set!(mp)

            // update outline position:
            isopos := level terrain getIsoPos(sprite pos) snap(1)
            screenpos := level terrain getScreenPos(isopos)
            outline pos set!(screenpos)
        )

        clickListener = input onMousePress(1, ||
            mp := input mousepos
            sprite pos set!(mp)

            cleanup()
            cb(level terrain getIsoPos(sprite pos))
        )

        level terrain pass2 addSprite(sprite)
    }

    cleanup: func {
        level terrain pass2 removeSprite(sprite)
        input unsubscribe(moveListener)
        input unsubscribe(clickListener)
    }

}



