
// game deps
import ui/MainUI
import game/Engine
import game/[Player, Alien, Dataset, Terrain, Portal]

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

Interval: class {

    length: Int
    counter := 0
    repeat: Bool

    cb: Func

    init: func (=length, =repeat, =cb) {
        counter = length
    }

    update: func -> Bool {
        counter -= 1
        if (counter <= 0) {
            cb()
            if (repeat) {
                counter = length
            } else {
                return false
            }
        }
        true
    }

}

Thing: class {

    logger := static Log getLogger(This name)
    intervals: ArrayList<Interval>

    init: func {
        // definitely overload this one
    }

    every: func (length: Int, cb: Func) {
        if (!intervals) intervals = ArrayList<Interval> new()
        intervals add(Interval new(length, true, cb))
    }

    in: func (length: Int, cb: Func) {
        if (!intervals) intervals = ArrayList<Interval> new()
        intervals add(Interval new(length, true, cb))
    }

    update: func {
        // run all intervals and remove expired ones
        if (!intervals) return
        iter := intervals iterator()
        while (iter hasNext?()) {
            interval := iter next() 
            if (!interval update()) {
                iter remove()
            }
        }
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

            add(p)
        }
    }

    add: func (t: Thing) {
        things add(t)
    }

    remove: func (t: Thing) {
        things remove(t)
        t destroy()
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




