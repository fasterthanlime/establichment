
// libs deps
import deadlogger/Log

// game deps
import Level

Citizen: class {

    logger := static Log getLogger(This name)

    id: Int
    idSeed := static 1

    income: Int
    cash := 0
    
    init: func (=income) {
        id = idSeed
        idSeed += 1

        cash = 3000
    }

    update: func (date: GameDate) {
        // collect salary
        cash += income

        // spend money

        // contract loans
    }

    withdrawMoney: func (amount: Int) -> Int {
        collected := amount
        cash -= amount
        
        if (cash < 0) {
            say("ran out of money")
            collected += cash
            cash = 0
        }

        collected
    }

    say: func (msg: String) {
        logger info("%s %s" format(toString(), msg))
    }    

    toString: func -> String {
        "Citizen #%d (income = %d, cash = %d)" format(id, income, cash)
    }

}
