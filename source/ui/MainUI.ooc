

use gobject, cairo, sdl, deadlogger, ldkit

// game deps
import ldkit/[Display, Input, Math, Sprites, Sound]
import game/Engine
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

    // something we can control level loading with
    engine: Engine

    /*
     * Constructors
     */
    init: func (=engine, config: ZombieConfig) {
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
    clickSound, startSound, buildSound, landingSound: Sample
    nopeSound, arghSound, criekSound, zapSound: Sample

    initSound: func {
        logger info("Initializing sound system")
        boombox = Boombox new()

        bgMusic = boombox load("assets/music/quiet-dignity.ogg")
        boombox loop(bgMusic)

        clickSound = boombox load("assets/sounds/click.ogg")

        startSound = boombox load("assets/sounds/gamestart.ogg")
        buildSound = boombox load("assets/sounds/build.ogg")
        landingSound = boombox load("assets/sounds/landing.ogg")
        nopeSound = boombox load("assets/sounds/nope.ogg")
        arghSound = boombox load("assets/sounds/argh.ogg")
        zapSound = boombox load("assets/sounds/zap.ogg")
        criekSound = boombox load("assets/sounds/criek.ogg")
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
    dateLabel: LabelSprite
    deathLabel: LabelSprite
    cashLabel: LabelSprite
    objectiveLabel: LabelSprite
    homelessLabel: LabelSprite

    // mouse pass (cursor)
    mousePass := Pass new(this, "mouse")
    cursor: GroupSprite

    flashMessages: FlashMessages

    lToolbar, rToolbar: Toolbar

    initPasses: func {
        flashMessages = FlashMessages new(this)

        // temp code, no real art :'(
        bgPos := vec2(display getWidth() - 1920, display getHeight() - 1080)
        bgPass addSprite(ImageSprite new(bgPos, "assets/png/background-placeholder.png"))

        levelTitle = LabelSprite new(vec2(40, 35), "<level name>")
        levelTitle color set!(1.0, 1.0, 1.0)
        levelTitle fontSize = 30.0
        statusPass addSprite(levelTitle)

        deathLabel = LabelSprite new(vec2(240, 35), "0 deaths")
        deathLabel color set!(1.0, 0.2, 0.2)
        deathLabel fontSize = 30.0
        statusPass addSprite(deathLabel)

        dateLabel = LabelSprite new(vec2(display getWidth() - 100, 70), "Day 0")
        dateLabel color set!(0.4, 0.4, 1.0)
        dateLabel centered = true
        dateLabel fontSize = 30.0
        statusPass addSprite(dateLabel)

        cashLabel = LabelSprite new(vec2(display getWidth() - 100, 30), "0 CHF")
        cashLabel centered = true
        cashLabel fontSize = 30.0
        cashLabel color set!(0.2, 1.0, 0.2)
        statusPass addSprite(cashLabel)

        homelessLabel = LabelSprite new(vec2(display getWidth() - 350, 30), "0 / ? homeless")
        homelessLabel centered = true
        homelessLabel fontSize = 30.0
        homelessLabel color set!(1.0, 1.0, 1.0)
        statusPass addSprite(homelessLabel)

        objectiveLabel = LabelSprite new(vec2(40, 80), "<level objective>")
        objectiveLabel fontSize = 30.0
        objectiveLabel color set!(1.0, 1.0, 0.4)
        statusPass addSprite(objectiveLabel)
   
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
        if (lToolbar) lToolbar destroy()
        lToolbar = createLeftToolbar()
        rootPass addPass(lToolbar pass)

        if (rToolbar) rToolbar destroy()
        rToolbar = createRightToolbar()
        rootPass addPass(rToolbar pass)

        // status is just a few text fields, no need to recreate
        rootPass addPass(statusPass)

        // no need to recreate either
        rootPass addPass(mousePass)
    }

    createLeftToolbar: func -> Toolbar {
        tb := Toolbar new(this, vec2(180, 70), Placement WEST)
        tb add(Item new("Restart level",  null, || engine reload()))
        tb add(Item new("Previous level", null, || engine jumpLevel(-1) ))
        tb add(Item new("Next level",    null, || engine jumpLevel(1) ))
        tb add(Item new("Exit", null, || exit(0)))
        tb
    }

    createRightToolbar: func -> Toolbar {
        tb := Toolbar new(this, vec2(140, 140), Placement EAST)
        tb add(Item new("100 CHF",     "assets/png/tree.png", || engine level drop("tree")))
        tb add(Item new("250 CHF",    "assets/png/house.png",   || engine level drop("house")))
        tb add(Item new("600 CHF",  "assets/png/building.png",  || engine level drop("building")))
        tb add(Item new("1300 CHF",      "assets/png/phaser.png", || engine level drop("tower")))
        tb
    }

    flash: func (msg: String) {
        flashMessages push(msg)
    }

    update: func {
        boombox update()
        flashMessages update()

        display clear()
        rootPass draw()
        display blit()

        input _poll()
    }

    initEvents: func {
        // it's a better practice to turn on debug locally
        //input debug = true

        input onExit(||
            // just exit bluntly. Let's rely on the OS to free all the resources :D
            exit(0)
        )
    }

}



