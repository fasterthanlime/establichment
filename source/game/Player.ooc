
// libs deps
import structs/ArrayList
import math/Random

// game deps
import Level, Dataset, Terrain
import ui/[MainUI]

Player: class {

    name: String
    level: Level
    
    cash := 600

    init: func(=level, =name) {
    }

    update: func (date: GameDate) {
        // TODO: update cash?
        level ui cashLabel setText("%d CHF" format(cash))
    }

}


