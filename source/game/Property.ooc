
// libs deps
import ldkit/[Sprites, Math]
import structs/ArrayList
import deadlogger/Log

// game deps
import Citizen, Terrain, Level

Property: class extends IsoThing {

    places: Int

    init: func (.level, =places) {
        super(level)
    }

    loadSprite: func {
        sprite add(loadIsoImage("assets/png/phaser-100px.png"))
    }

}


