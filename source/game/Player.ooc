
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

    properties := ArrayList<Property> new()

    init: func(=level, =name) {
        // test code: add a property for fun
        for(i in 0..5) {
            p := Property new(level terrain, 10)
            p isopos set!(Random randRange(0, level terrain width),
                          Random randRange(0, level terrain height))
            properties add(p)
        }
    }

    update: func (date: GameDate) {
        // TODO: update cash?
        level ui cashLabel setText("%d CHF" format(cash))
        
        properties each(|p| p update())
    }

}


