
// libs deps
import deadlogger/Log
import ldkit/[Math, Sprites]
import math/Random

// game deps
import Level, Terrain, ui/Graphics

DELTA := 0.01

Citizen: class {

    logger := static Log getLogger(This name)

    id: Int
    idSeed := static 1

    isopos := vec2(0.0, 0.0)
    isodst := vec2(0.0, 0.0)
    isodir := vec2(1.0, 0.0)

    sprite: GroupSprite

    speed := 0.05

    terrain: Terrain
    
    init: func (=terrain) {
        id = idSeed
        idSeed += 1

        sprite = GroupSprite new()

        ls := LabelSprite new(vec2(45, -30), "0")
        ls fontSize = 80
        ls color set!(1, 1, 1)
        ls centered = true
        sprite add(ls)

        terrain pass2 addSprite(sprite)
    }

    targetReached: func -> Bool {
        isodst dist(isopos) < DELTA
    }
    
    newTarget: func {
        // TODO: smarter moves, huh.
        if (Random randInt(1, 2) == 1) {
            isodst x += 1
        } else {
            isodst y += 1
        }
        isodir = isodst sub(isopos) normalized() mul(speed)
    }

    update: func (date: GameDate) {
        if (targetReached()) {
            newTarget()
        }

        isopos add!(isodir)

        sprite pos set!(terrain getScreenPos(isopos))
    }

    say: func (msg: String) {
        logger info("%s %s" format(toString(), msg))
    }    

    toString: func -> String {
        "Citizen #%d" format(id)
    }

}
