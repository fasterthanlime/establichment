
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

GameDate: class {

    day := 0

    logger := static Log getLogger(This name)
    
    update: func {
        day += 1

        logger info("Day %d" format(day))
    }

    isMonth?: func -> Bool {
        // it's a game, simplifications :D
        day % 30 == 0
    }

}

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

    init: func (=engine) {
        ui = engine ui 

        // single-player mode
        mainPlayer = Player new("Gob")
        players add(mainPlayer)
    }

    setup: func {
        ui levelTitle setText(name)
        ui flash(welcomeMessage)
    }

    ticks: Long = 0
    DAY_LENGTH := 10

    update: func {
        ticks += 1
        if (ticks >= DAY_LENGTH) {
            ticks = 0
            date update()
        
            citizens each (|c| c update(date))
            players each (|p| p update(date))
        }
    }

} 
