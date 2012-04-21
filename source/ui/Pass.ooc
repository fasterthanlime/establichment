
// libs deps
import ldkit/[Sprites, Display]

// game deps
import structs/[ArrayList]
import MainUI

Pass: class {

    ui: MainUI
    name: String // for debug

    parent: This // can be null (for root pass)

    passes := ArrayList<This> new()
    sprites := ArrayList<Sprite> new()

    /*
     * Constructor
     */
    init: func (=ui, =name) {
        // not much here
    }

    reset: func {
        sprites each(|s| s free())
        sprites clear()

        passes each(|p| p reset())
        passes clear()
    }

    addPass: func (pass: This) {
        passes add(pass)
        pass parent = this
    }

    addSprite: func (sprite: Sprite) {
        sprites add(sprite)
    }

    draw: func {
        sprites each(|s| s draw(ui display))
        passes each(|p| p draw())
    }

    toString: func -> String { if (parent) {
            "%s / %s" format(parent toString(), name)
        } else {
            name
        }
    }

}

