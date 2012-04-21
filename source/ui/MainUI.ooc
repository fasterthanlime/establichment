

use gobject, cairo, sdl, deadlogger, ldkit

// game deps
import ldkit/[Display, Input]
import Pass

// libs deps
import deadlogger/Log
import zombieconfig

MainUI: class {

    // note to viewers: 'This' refers to the current class in ooc.
    logger := static Log getLogger(This name)

    // something we can draw on using Cairo
    display: Display

    // something we can read events from
    input: Input

    /*
     * Constructors
     */
    init: func (config: ZombieConfig) {
        // note: all config entries are String, so we just have to cheat a bit ;)
        width  := config["screenWidth"]  toInt()
        height := config["screenHeight"] toInt()
        fullScreen := (config["fullScreen"] == "true")
        title := config["title"]

        display = Display new(width, height, fullScreen, title)

        input = Input new()

        initPasses()
    }

    // different UI passes
    rootPass := Pass new(this, "root")

    // name passes for later profiling
    bgPass := Pass new(this, "bg") // clear
    levelPass := Pass new(this, "level") // level terrain etc.
    hudPass := Pass new(this, "hud")  // human interface (windows/dialogs etc.)
    statusPass := Pass new(this, "status") // various info

    initPasses: func {
        // TODO: setup bg pass & status pass

        reset()
    }
    
    reset: func {
        rootPass reset()

        // nothing to reset
        rootPass addPass(bgPass)

        // everything will be re-created when loading the level
        levelPass reset()
        rootPass addPass(levelPass)

        // close all windows
        hudPass reset()
        rootPass addPass(hudPass)

        // status is just a few text fields, no need to recreate
        statusPass reset()
        rootPass addPass(statusPass)
    }

    redraw: func {
        rootPass draw()
    }

}



