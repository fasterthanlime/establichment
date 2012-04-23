
// libs deps
import ldkit/[Sprites, Math]
import structs/ArrayList
import deadlogger/Log

// game deps
import Citizen, Terrain, Level

Portal: class {

    logger := static Log getLogger(This name)

    id: Int
    idSeed := static 1

    isopos := vec2(0.0, 0.0)

    sprite: GroupSprite

    terrain: Terrain

    init: func (=terrain) {
        id = idSeed
        idSeed += 1 

        sprite = GroupSprite new()

        is := ImageSprite new(vec(0, 0), "assets/png/portal-x-100px.png")
        is pos set!(0, - (is height - terrain tileHeight))
        sprite add(is)

        terrain pass2 addSprite(sprite)
    }

    setPos: func (x, y: Int) {
        isopos set!(x, y)
        update()
    }

    update: func {
        // TODO: spawn citizens once and then
        sprite pos set!(terrain getScreenPos(isopos))        
    }

    toString: func -> String {
        "Property %d" format(id)
    }

}


