
// libs deps
import structs/ArrayList
import deadlogger/Log

// game deps
import Citizen

Property: abstract class {

    logger := static Log getLogger(This name)

    id: Int
    idSeed := static 1

    places: Int

    init: func (=places) {
        id = idSeed
        idSeed += 1 
    }

    toString: func -> String {
        "Property %d" format(id)
    }

}

Building: class extends Rentable {

    init: super func

}


