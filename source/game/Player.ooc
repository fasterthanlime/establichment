
// libs deps
import structs/ArrayList

// game deps
import Agency, Level, Dataset

Player: class {

    name: String
    cashHistory := Dataset new()

    agencies := ArrayList<Agency> new()

    init: func(=name) {
        // test code
        agencies add(Agency new(this, "Foncia"))

        agencies add(Agency new(this, "Cogestim"))
    }

    update: func (date: GameDate) {
        agencies each(|a| a update(date))

        cashHistory add(date, getCash())
    }

    getCash: func -> Int {
        sum := 0
        for (a in agencies) { sum += a getCash() }
        // todo: add other assets
        sum
    }

}


