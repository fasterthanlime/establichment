
// game deps
import ui/MainUI
import game/Engine
import game/[Player, Citizen, Dataset, Terrain, Portal]

// libs deps
import structs/[ArrayList]
import deadlogger/Log
import math/Random
import ldkit/[Math]

/**
 * Controls how the game unfolds.
 */

GameDate: class {

    day := 0

    logger := static Log getLogger(This name)
    
    update: func {
        day += 1
    }

    before?: func (other: This) -> Bool {
        day < other day
    }

    after?: func (other: This) -> Bool {
        day > other day
    }

    set: func (other: This) {
        day = other day
    }

    isMonth?: func -> Bool {
        // it's a game, simplifications :D
        day % 30 == 0
    }

}

withProbability: func (proba: Float, cb: Func) {
    precision := 1000
    v1 := Random randRange(0, precision)
    v2 := (proba * precision) as Int

    if (v1 < v2) {
        cb()
    }
}

Orientation: enum {
    RIGHT
    UP
    LEFT
    DOWN
}

orientation2string: func (o: Orientation) -> String {
    match o {
        case Orientation RIGHT => "right"
        case Orientation UP    => "up"
        case Orientation LEFT  => "left"
        case Orientation DOWN  => "down"
    }
}

orientation2vec: func (o: Orientation) -> Vec2 {
    match o {
        case Orientation RIGHT => vec2( 1,  0)
        case Orientation UP    => vec2( 0,  1)
        case Orientation LEFT  => vec2(-1,  0)
        case Orientation DOWN  => vec2( 0, -1)
    }
}

vec2orientation: func (v: Vec2) -> Orientation {
    match {
        case v x < EPSILON => match {
            case v y < 0 => Orientation DOWN
            case         => Orientation UP
        }
        case => match {
            case v x < 0 => Orientation LEFT
            case         => Orientation RIGHT
        }
    }
}

Thing: class {

    logger := static Log getLogger(This name)

    init: func {
        // definitely overload this one
    }

    update: func {
        // do what you want cause a pirate is free
    }

    destroy: func {
        // overload if you wanna do special stuff here
    }

}

/**
 * A tiny, tiny world in itself: Switzerland :)
 */

Level: class {

    logger := static Log getLogger(This name)
    engine: Engine
    date := GameDate new()

    terrain: Terrain

    name := "<no name>"
    welcomeMessage := "level started!"

    // something used to display the world and manipulate it
    ui: MainUI

    // each player controls a part of the world
    player: Player
    things := ArrayList<Thing> new()
    terrain: Terrain

    init: func (=engine) {
        ui = engine ui 
    
        terrain = Terrain new(ui)

        player = Player new(this, "William Tell")
        spawnPortals()
    }

    spawnPortals: func {
        for (i in 0..3) {
            p := Portal new(this, orientation2vec(Orientation LEFT))
            p setPos(Random randRange(0, terrain width), Random randRange(0, terrain height))

            things add(p)
        }
    }

    setup: func {
        ui levelTitle setText(name)
        ui flash(welcomeMessage)
    }

    update: func {
        date update()

        terrain update()
    
        things each (|t| t update())
        player update(date)
    }

} 




