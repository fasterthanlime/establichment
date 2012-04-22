

use gobject, cairo, sdl, deadlogger, ldkit

// game deps
import ldkit/[Display, Input, Math, Sprites]
import Pass, FlashMessages

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
        display hideCursor()

        input = Input new()

        initPasses()
        initEvents()
    }

    // different UI passes
    rootPass := Pass new(this, "root")

    // name passes for later profiling
    bgPass := Pass new(this, "bg") // clear
    levelPass := Pass new(this, "level") // level terrain etc.
    hudPass := Pass new(this, "hud")  // human interface (windows/dialogs etc.)

    // status sprites
    statusPass := Pass new(this, "status") // various info
    levelTitle: LabelSprite

    // mouse pass (cursor)
    mousePass := Pass new(this, "mouse")
    cursor: GroupSprite

    flashMessages: FlashMessages

    initPasses: func {
        flashMessages = FlashMessages new(this)

        // temp code, no real art :'(
        bgPos := vec2(display getWidth() - 1920, display getHeight() - 1080)
        bgPass addSprite(ImageSprite new(bgPos, "assets/png/background-placeholder.png"))

        levelTitle = LabelSprite new(vec2(30, 30), "<level name>")
        levelTitle color set!(1.0, 1.0, 1.0)
        statusPass addSprite(levelTitle)
   
        // offset to make the hand correspond with the actual mouse
        cursorImage := ImageSprite new(vec2(-12, -10), "assets/png/cursor.png") 
        cursor = GroupSprite new()
        cursor add(cursorImage)

        mousePass addSprite(cursor)

        input onMouseMove(||
            cursor pos set!(input mousepos)
        )

        reset()
    }
    
    reset: func {
        flashMessages reset()

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
        rootPass addPass(statusPass)

        // no need to recreate either
        rootPass addPass(mousePass)
    }

    flash: func (msg: String) {
        flashMessages push(msg)
    }

    update: func {
        flashMessages update()

        display clear()
        rootPass draw()
        display blit()

        input _poll()
    }

    initEvents: func {
        // it's a better practice to turn on debug locally
        input debug = true

        input onExit(||
            // just exit bluntly. Let's rely on the OS to free all the resources :D
            exit(0)
        )
    }

}



