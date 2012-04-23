
// libs deps
import ldkit/[Sprites, Math]
import structs/ArrayList
import deadlogger/Log

// game deps
import Citizen, Terrain, Level

Property: class {

    logger := static Log getLogger(This name)

    id: Int
    idSeed := static 1

    isopos := vec2(0.0, 0.0)

    sprite: GroupSprite

    places: Int

    terrain: Terrain

    init: func (=terrain, =places) {
        id = idSeed
        idSeed += 1 

        sprite = GroupSprite new()

        sprite pos set!(terrain getScreenPos(isopos))        
        is := ImageSprite new(vec(0, 0), "assets/png/tower-100px.png")
        is pos set!(0, - (is height - terrain tileHeight))
        sprite add(is)

        terrain pass2 addSprite(sprite)
    }

    update: func (date: GameDate) {
        // TODO: do stuff
    }

    toString: func -> String {
        "Property %d" format(id)
    }

}


