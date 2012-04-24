
// libs deps
use ldkit
import ldkit/Loader
import deadlogger/Log

// game deps
import Level, Engine, Player

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
    }

    loadStGall: func (level: Level) {
        level maxHomeless = 80
    }

    loadZuerich: func (level: Level) {
        level maxHomeless = 40
    }

    loadRomandy: func (level: Level) {
        level maxHomeless = 20
    }

}

