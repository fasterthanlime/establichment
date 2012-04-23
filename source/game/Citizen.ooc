
// libs deps
import deadlogger/Log
import ldkit/[Math, Sprites]

// game deps
import Level, Terrain, ui/Graphics

Citizen: class {

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

        ls := LabelSprite new(vec2(0, 0), "\o/")
        ls fontSize = 42
        ls color set!(1, 1, 1)
        ls centered = true
        sprite add(ls)
    }

    update: func (date: GameDate) {
        // TODO: move!
        sprite pos set!(terrain getScreenPos(isopos))
    }

    say: func (msg: String) {
        logger info("%s %s" format(toString(), msg))
    }    

    toString: func -> String {
        "Citizen #%d" format(id)
    }

}
