
// libs deps
import structs/ArrayList

// game deps
import Player, Property, Level

Agency: class {

    cash: Int
    player: Player

    name: String

    properties := ArrayList<Property> new()

    init: func (=player, =name) {
        
    }

    update: func (date: GameDate) {
        if(date isMonth?()) {
           collectRents() 
        } 
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

    getCash: func -> Int {
        cash
    }

}

