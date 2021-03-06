
// libs deps
import ldkit/[Sprites, Math]
import structs/ArrayList
import deadlogger/Log

// game deps
import Alien, Terrain, Level

Portal: class extends OrientedIsoThing {

    rate := 40

    init: func (.level, .dir) {
        super(level, dir)

        every(rate, ||
            c := Alien new(level)
            c setPos(pos x, pos y)
            c target set!(pos add(dir))
            level add(c)
        )
    }

    loadSprite: func {
        sprite add(loadIsoImage("assets/png/portal.png"))
    }

}


