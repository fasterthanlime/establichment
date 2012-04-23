
// game deps
import ui/MainUI
import game/Engine
import game/[Player, Citizen, Dataset, Terrain, Portal]

// libs deps
import structs/[ArrayList]
import deadlogger/Log
import math/Random

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
    mainPlayer: Player
    players := ArrayList<Player> new()

    citizens := ArrayList<Citizen> new()
    portals := ArrayList<Portal> new()

    terrain: Terrain

    init: func (=engine) {
        ui = engine ui 
    
        terrain = Terrain new(ui)

        // single-player mode: test code
        mainPlayer = Player new(this, "Gob")
        players add(mainPlayer)

        spawnPortals()
        spawnCitizens()
    }

    spawnPortals: func {
        for (i in 0..5) {
            p := Portal new(terrain)
            p setPos(Random randRange(0, 2), Random randRange(0, 2))

            portals add(p)
        }

        logger info("Added %d portals." format(portals size))
    }

    spawnCitizens: func {
        for (i in 0..5) {
            c := Citizen new(terrain)
            c setPos(Random randRange(0, 2), Random randRange(0, 2))

            citizens add(c)
        }

        logger info("Added %d citizens." format(citizens size))
    }

    setup: func {
        ui levelTitle setText(name)
        ui flash(welcomeMessage)
    }

    ticks: Long = 0

    update: func {
        terrain update()

        date update()
    
        portals each (|p| p update())

        citizens each (|c| c update(date))
        players each (|p| p update(date))
    }

} 




