
// game deps
import game/Engine

// libs deps
use zombieconfig, deadlogger
import zombieconfig
import deadlogger/[Log, Handler, Formatter, Filter]


main: func (argc: Int, argv: CString*) {
    // setup logging
    console := StdoutHandler new()
    console setFormatter(ColoredFormatter new(NiceFormatter new()))
    Log root attachHandler(console)

    logger := Log getLogger("main")
    logger info("establichment starting up!")

    // load config
    configPath := "config/establichment.config"
    config := ZombieConfig new(configPath, |base|
        base("title", "establichment")
        base("fullScreen", "false")
        base("screenWidth", "1024")
        base("screenHeight", "768")
        base("startLevel", "tutorial")
    )

    logger info("configuration loaded from %s" format(configPath))
    
    Engine new(config)
}



