
// game deps
import ui/MainUI
import game/[Level, LevelLoader]

// libs deps
import sdl/Sdl // for timeouts
import structs/[ArrayList]

import ldkit/Timing
use zombieconfig
import zombieconfig

Engine: class {

    ui: MainUI
    level: Level

    FPS := 30.0 // let's target 30FPS

    levelName: String
    levelIndex := 0
    levelNames := [
        "Ticino" 
        "St. Gall"
        "Zuerich"
        "Romandy"
    ] as ArrayList<String>

    init: func(config: ZombieConfig) {
        ui = MainUI new(this, config)

        levelName = levelNames[levelIndex]
        load(levelName)

        ticks: Int
        delta := 1000.0 / 30.0 // try 30FPS

        // main loop
        while (true) {
            ticks = LTime getTicks()

            level update()
            ui update()

            // teleport ourselves in the future when the next frame is due
            roadToFuture := ticks + delta - LTime getTicks()
            if(roadToFuture > 0) {
                LTime delay(roadToFuture)
            }
        }
    }

    load: func (name: String) {
        if (level) {
            ui reset()
        }

        levelName = name
        loader := LevelLoader new(this)
        level = loader load(name)
        level setup()
    }

    reload: func {
        load(levelName)
    }

    jumpLevel: func (offset: Int) {
        levelIndex += offset
        levelIndex = levelIndex % (levelNames size)
        load(levelNames[levelIndex])
    }

}


