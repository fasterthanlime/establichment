
// game deps
import ui/MainUI
import game/[Level, LevelLoader]

// libs deps
import sdl/Sdl // for timeouts

import ldkit/Timing
use zombieconfig
import zombieconfig

Engine: class {

    ui: MainUI
    level: Level
    currentLevel := ""

    FPS := 30.0 // let's target 30FPS

    init: func(config: ZombieConfig) {
        ui = MainUI new(this, config)

        load(config["startLevel"])

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

    load: func (levelName: String) {
        if (level) {
            ui reset()
        }

        currentLevel = levelName
        loader := LevelLoader new(this)
        level = loader load(levelName)
        level setup()
    }

    reload: func {
        load(currentLevel)
    }

    jumpLevel: func (offset: Int) {
        "Should jumplevel (%d)" printfln(offset)
    }

}


