
// libs deps
import structs/ArrayList
import deadlogger/Log
import math/Random

// game deps
import Player, Property, Level, Citizen, Dataset

Agency: class {

    logger := static Log getLogger(This name)

    cash: Int
    cashHistory := Dataset new()

    player: Player

    name: String

    properties := ArrayList<Property> new()

    init: func (=player, =name) {
        // test code

        // add a few buildings
        dummyRent := 800
        standardPlaces := 12 // 4 floors, 3 ap. / floor

        for (i in 0..10) {
            properties add(Building new(dummyRent, standardPlaces))
        }
    }

    update: func (date: GameDate) {
        if(date isMonth?()) {
           collectRents() 
            logger info("Agency %s now has %d in cash." format(name, cash))
        } 

        cashHistory add(date, cash)
    }

    collectRents: func {
        for(p in properties) {
            match p {
                case r: Rentable => {
                    cash += r collect()
                }
            }
        }
    }

    findShelter: func (c: Citizen) {
        for (i in 0..(properties size)) {
            property := Random choice(properties)
            if (property moveIn(c)) {
                break
            }
        }
    }

    getCash: func -> Int {
        cash
    }

}

