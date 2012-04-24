
// libs deps
use ldkit
import ldkit/Loader
import deadlogger/Log

// game deps
import Level, Engine, Player, Buildables

LevelLoader: class extends Loader {

    logger := static Log getLogger(This name)
    engine: Engine

    init: func (=engine)

    load: func (levelName: String) -> Level {
        logger info("Loading level %s" format(levelName))

        level := Level new(engine)
        level name = levelName
        level welcomeMessage = "Good luck!"

        // I am so ashamed of this.. hardcoded levels
        level lossConditions add(TooManyHomeless new())

        match (levelName) {
            case "Ticino" => loadTicino(level)
            case "St. Gall" => loadStGall(level)
            case "Zuerich" => loadZuerich(level)
            case "Romandy" => loadRomandy(level)
        }

        level
    }

    loadTicino: func (level: Level) {
        level maxHomeless = 100
        level player cash = 1000
        level objective = "Survive for 30 days"
        level winConditions add(SurvivedLongEnough new(30))
    }

    loadStGall: func (level: Level) {
        level maxHomeless = 80
        level objective = "Earn 3000 CHF"
        level winConditions add(EarnAtLeast new(3000))
    }

    loadZuerich: func (level: Level) {
        level maxHomeless = 40
        level objective = "Build 5 towers"
        level winConditions add(HaveNThings new(5, Tower))
    }

    loadRomandy: func (level: Level) {
        level maxHomeless = 20
        level objective = "Don't let any homeless die"
        level winConditions add(ZeroDeath new())
    }

}

// loss / win conditions here

TooManyHomeless: class extends Condition {

    isTrue: func (l: Level) -> Bool {
        l countHomeless() > l maxHomeless
    }

    getMessage: func -> String {
        "The homeless have surrounded you!"
    }

}


SurvivedLongEnough: class extends Condition {

    days: Int
    init: func (=days)

    isTrue: func (l: Level) -> Bool {
        l date getActualDay() >= days
    }

    getMessage: func -> String {
        "You've survived %d days!" format(days)
    }

}

EarnAtLeast: class extends Condition {

    money: Int
    init: func (=money)

    isTrue: func (l: Level) -> Bool {
        l player cash >= money
    }

    getMessage: func -> String {
        "You've earned at least %d CHF!" format(money)
    }

}


HaveNThings: class extends Condition {

    count: Int
    type: Class

    init: func (=count, =type)

    isTrue: func (l: Level) -> Bool {
        l countThing(type) >= count
    }

    getMessage: func -> String {
        "You have built %d %s" format(count, type name)
    }

}


ZeroDeath: class extends Condition {

    count: Int
    type: Class

    init: func (=count, =type)

    isTrue: func (l: Level) -> Bool {
        l deathCount > 0
    }

    getMessage: func -> String {
        "An alien died :("
    }

}
 

