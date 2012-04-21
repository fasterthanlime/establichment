
// libs deps
import structs/ArrayList
import deadlogger/Log

// game deps
import Citizen

Property: abstract class {

    logger := static Log getLogger(This name)

    id: Int
    idSeed := static 1

    // a citizen tries to move in.
    // return true on success 
    moveIn: abstract func (c: Citizen) -> Bool

    moveOut: abstract func (c: Citizen) -> Bool

}

Rentable: class extends Property {

    rent: Int
    places: Int

    tenants := ArrayList<Citizen> new()

    init: func (=rent, =places) {
        id = idSeed
        idSeed += 1 
    }

    collect: func -> Int {
        total := 0

        tenants each (|t|
            total += t withdrawMoney(rent)
        )

        total
    }

    moveIn: func (c: Citizen) -> Bool {
        if (tenants size < places) {
            logger info("%s moved into %s" format(c toString(), toString()))
            tenants add(c)
            true
        } else {
            false
        }
    }

    moveOut: func (c: Citizen) -> Bool {
        c2 := tenants remove(c)
        c == c2
    }

    toString: func -> String {
        "Property %d" format(id)
    }

}

Building: class extends Rentable {

    init: super func

}


