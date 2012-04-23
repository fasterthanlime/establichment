
// libs deps
import structs/ArrayList

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
        properties add(Property new(level terrain, 10))
    }

    update: func (date: GameDate) {
        // TODO: update cash?
        level ui cashLabel setText("%d CHF" format(cash))
    }

}


