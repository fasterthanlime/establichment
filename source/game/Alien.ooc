
// libs deps
import deadlogger/Log
import ldkit/[Math, Sprites]
import math/Random

// game deps
import Level, Terrain, ui/Graphics

Alien: class extends OrientedIsoThing {

    target := vec2(0.0, 0.0)

    reward := 20

    epsilon := static 0.1
    speed := 0.03

    init: func (.level) {
        super(level, vec2(1, 0))
    }

    loadSprite: func {
        sprite add(loadIsoImage("assets/png/alien.png"))
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

        dir set!(target sub(pos) normalized())
        pos add!(dir mul(speed))
    }

    targetReached: func -> Bool {
        target dist(pos) < epsilon
    }
    
    newTarget: func {
        good := false
        newTarget := pos clone()

        tries := 10
        while (!good && tries > 0) {
            tries -= 1
            good = true

            newTarget = target add(match (Random randInt(1, 4)) {
                case 1 => vec2(1, 0)
                case 2 => vec2(0, 1)
                case 3 => vec2(-1, 0)
                case   => vec2( 0, -1)
            })

            if (newTarget x >= level terrain width ||
                newTarget x < 0 ||
                newTarget y >= level terrain height ||
                newTarget y < 0) {
                good = false
                continue
            }
            
            findInRectangle(newTarget sub(0.5, 0.5), newTarget add(0.5, 0.5), true, IsoThing, |thing|
               if (!thing instanceOf?(Alien)) good = false
            )
        }
        // logger info("Alrighty, new target %s it is! (width/height = %d, %d)" format(
        //     newTarget _, level terrain width, level terrain height
        // ))
        target set!(newTarget)
    }

}
