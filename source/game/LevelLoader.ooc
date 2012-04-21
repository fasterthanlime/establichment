
// libs deps
use ldkit
import ldkit/Loader
import deadlogger/Log

// game deps
import Level, Engine

LevelLoader: class extends Loader {

    logger := static Log getLogger(This name)
    engine: Engine

    init: func (=engine)

    load: func (levelName: String) -> Level {
        path := "assets/levels/%s.json" format(levelName)
        json := readJSON(path)

        level := Level new(engine)
        level name = json get("name", String)
        level welcomeMessage = json get("welcomeMessage", String)

        level
    }

}

