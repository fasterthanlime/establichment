

use gobject, cairo, sdl, deadlogger, ldkit

// game deps
import ldkit/[Display, Input, Math, Sprites, Sound]
import Pass, FlashMessages, Toolbar

// libs deps
import deadlogger/Log
import zombieconfig
import os/Time

MainUI: class {

    // note to viewers: 'This' refers to the current class in ooc.
    logger := static Log getLogger(This name)

    // something we can draw on using Cairo
    display: Display

    // something we can read events from
    input: Input

    // something we can make noise with
    boombox: Boombox

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

        initSound()
        initPasses()
        initEvents()
    }

    bgMusic: Sample
    clickSound, startSound, buildSound: Sample

    initSound: func {
        logger info("Initializing sound system")
        boombox = Boombox new()

        bgMusic = boombox load("assets/music/MistsOfTime.ogg")
        boombox play(bgMusic)

        clickSound = boombox load("assets/sounds/click.ogg")
        input onMousePress(1, || boombox play(clickSound))

        startSound = boombox load("assets/sounds/gamestart.ogg")
        buildSound = boombox load("assets/sounds/build.ogg")
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
    cashLabel: LabelSprite

    // mouse pass (cursor)
    mousePass := Pass new(this, "mouse")
    cursor: GroupSprite

    flashMessages: FlashMessages

    toolbar: Toolbar

    initPasses: func {
        flashMessages = FlashMessages new(this)

        // temp code, no real art :'(
        bgPos := vec2(display getWidth() - 1920, display getHeight() - 1080)
        bgPass addSprite(ImageSprite new(bgPos, "assets/png/background-placeholder.png"))

        levelTitle = LabelSprite new(vec2(100, 30), "<level name>")
        levelTitle color set!(1.0, 1.0, 1.0)
        levelTitle centered = true
        levelTitle fontSize = 30.0
        statusPass addSprite(levelTitle)

        cashLabel = LabelSprite new(vec2(display getWidth() - 100, 30), "0 CHF")
        cashLabel centered = true
        cashLabel fontSize = 30.0
        cashLabel color set!(1.0, 1.0, 1.0)
        statusPass addSprite(cashLabel)
   
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

        // toolbar
        toolbar = createToolbar()
        rootPass addPass(toolbar pass)

        // status is just a few text fields, no need to recreate
        rootPass addPass(statusPass)

        // no need to recreate either
        rootPass addPass(mousePass)
    }

    createToolbar: func -> Toolbar {
        tb := Toolbar new(this)
        tb add(Item new("Pisshole"))
        tb add(Item new("Rat house"))
        tb add(Item new("Golden cage"))
        tb
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



