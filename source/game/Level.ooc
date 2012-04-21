
// game deps
import ui/MainUI
import game/Engine
import game/[Player, Agency, Citizen, Dataset]

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
    
        if (isMonth?()) {
            logger info("Day %d" format(day))
        }
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

    name := "<no name>"
    welcomeMessage := "level started!"

    // something used to display the world and manipulate it
    ui: MainUI

    // each player controls a part of the world
    mainPlayer: Player
    players := ArrayList<Player> new()

    // citizens make their own decision on how to spend their money
    citizens := ArrayList<Citizen> new()
    citizenHistory := Dataset new()

    init: func (=engine) {
        ui = engine ui 

        // single-player mode: test code
        mainPlayer = Player new("Gob")
        players add(mainPlayer)

        spawnCitizens()
    }

    spawnCitizens: func {
        // test code
        dummyIncome := 3000

        for (i in 0..100) {
            c := Citizen new(dummyIncome)
            citizens add(c)

            withProbability(0.2, ||
                logger debug("Finding shelter...")
                findShelter(c)
            )
        }

        logger info("Added %d citizens." format(citizens size))
    }

    findShelter: func (c: Citizen) {
        // fair way to distribute citizen in shelters
        // test code
        player := Random choice(players)
        agency := Random choice(player agencies)
        agency findShelter(c)
    }

    setup: func {
        ui levelTitle setText(name)
        ui flash(welcomeMessage)
    }

    ticks: Long = 0
    DAY_LENGTH := 2

    update: func {
        ticks += 1
        if (ticks >= DAY_LENGTH) {
            ticks = 0
            date update()
        
            citizens each (|c| c update(date))
            players each (|p| p update(date))
        
            // TODO: make citizen die and breed
            citizenHistory add(date, citizens size) 
        }
    }

} 
