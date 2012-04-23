
// libs deps
import structs/ArrayList
import math/Random

// game deps
import Level, Dataset, Terrain, Property
import ui/[MainUI]

Player: class {

    name: String
    level: Level
    
    cash := 3000

    init: func(=level, =name) {
        for(i in 0..3) {
            p := Property new(level, 10)
            p pos set!(Random randRange(0, level terrain width),
                       Random randRange(0, level terrain height))
            level add(p)
        }
    }

    update: func (date: GameDate) {
        // TODO: update cash?
        level ui cashLabel setText("%d CHF" format(cash))
    }

}


