
// game deps
import ui/MainUI
import game/Engine
import game/[Player, Agency, Citizen]

// libs deps
import structs/[ArrayList]
import deadlogger/Log

/**
 * A tiny, tiny world in itself: Switzerland :)
 */

Level: class {

    logger := static Log getLogger(This name)
    engine: Engine

    // something used to display the world and manipulate it
    ui: MainUI

    // each player controls a part of the world
    players := ArrayList<Player> new()

    // citizens make their own decision on how to spend their money
    citizens := ArrayList<Citizen> new()

    init: func (=engine) {
        ui = engine ui 

        // single-player mode
        players add(Player new("Gob"))
    }

    update: func {
        citizens each (|c| c update())
    }

}
