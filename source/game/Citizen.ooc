
// libs deps
import deadlogger/Log
import ldkit/[Math, Sprites]
import math/Random

// game deps
import Level, Terrain, ui/Graphics

Citizen: class extends OrientedIsoThing {

    target := vec2(0.0, 0.0)

    epsilon := static 0.1
    speed := 0.03

    init: func (.level) {
        super(level, vec2(1, 0))
    }

    loadSprite: func {
        sprite add(loadIsoImage("assets/png/alien-x-100px.png"))
    }

    setPos: func (x, y: Float) {
        super(x, y)
        target set!(pos)
        newTarget()
    }

    logic: func {
        if (targetReached()) {
            newTarget()
        }

        pos add!(dir normalized() mul(speed))
    }

    targetReached: func -> Bool {
        target dist(pos) < epsilon
    }
    
    newTarget: func {
        // TODO: smarter moves, huh.
        if (Random randInt(1, 2) == 1) {
            target x += 1
        } else {
            target y += 1
        }
        dir set!(target sub(pos) normalized())
    }

}
