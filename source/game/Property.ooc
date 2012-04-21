
// libs deps
import structs/ArrayList

// game deps
import Citizen

Property: abstract class {

}

Rentable: class extends Property {

    rent: Int
    places: Int

    tenants := ArrayList<Citizen> new()

    init: func (=rent, =places) {
        
    }

    collect: func -> Int {
        total := 0

        tenants each (|t|
            total += t withdrawMoney(rent)
        )

        total
    }

}

Building: class extends Rentable {

    init: super func

}


