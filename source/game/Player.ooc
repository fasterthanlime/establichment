
// libs deps
import structs/ArrayList
import math/Random

// game deps
import Level, Dataset, Terrain
import ui/[MainUI]

Player: class {

    name: String
    level: Level

    counter := 0
    
    cash := 600

    init: func(=level, =name) {
    }

    update: func (date: GameDate) {
        counter += 1
        if (counter >= 60) {
            counter = 0
            cash += 20 // huhu
        }

        level ui cashLabel setText("%d CHF" format(cash))
    }

}


