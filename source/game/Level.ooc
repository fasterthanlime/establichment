
// game deps
import ui/MainUI
import game/Engine
import game/[Player, Alien, Dataset, Terrain, Portal]
import game/[Buildables]
import game/[Dropper]

// libs deps
import structs/[ArrayList]
import deadlogger/Log
import math/Random
import ldkit/[Math, Sprites, Input]

/**
 * Controls how the game unfolds.
 */

GameDate: class {

    day := 0

    logger := static Log getLogger(This name)
    
    update: func {
        day += 1
    }

    before?: func (other: This) -> Bool {
        day < other day
    }

    after?: func (other: This) -> Bool {
        day > other day
    }

    set: func (other: This) {
        day = other day
    }

    getActualDay: func -> Int {
        (day / 30) + 1
    }

}

withProbability: func (proba: Float, cb: Func) {
    precision := 1000
    v1 := Random randRange(0, precision)
    v2 := (proba * precision) as Int

    if (v1 < v2) {
        cb()
    }
}

Interval: class {

    length: Int
    counter := 0
    repeat: Bool

    cb: Func

    init: func (=length, =repeat, =cb) {
        counter = length
    }

    update: func -> Bool {
        counter -= 1
        if (counter <= 0) {
            cb()
            if (repeat) {
                counter = length
            } else {
                return false
            }
        }
        true
    }

}

Thing: class {

    logger := static Log getLogger(This name)
    intervals: ArrayList<Interval>

    init: func {
        // definitely overload this one
    }

    every: func (length: Int, cb: Func) {
        if (!intervals) intervals = ArrayList<Interval> new()
        intervals add(Interval new(length, true, cb))
    }

    in: func (length: Int, cb: Func) {
        if (!intervals) intervals = ArrayList<Interval> new()
        intervals add(Interval new(length, true, cb))
    }

    update: func {
        // run all intervals and remove expired ones
        if (!intervals) return
        iter := intervals iterator()
        while (iter hasNext?()) {
            interval := iter next() 
            if (!interval update()) {
                iter remove()
            }
        }
    }

    destroy: func {
        // overload if you wanna do special stuff here
    }

}

Condition: class {

    isTrue: func (l: Level) -> Bool {
        false // override
    }

    getMessage: func -> String {
        "Something happened!"
    }

}

/*
 * THE LEVEL CLASS. 
 */

Level: class {

    logger := static Log getLogger(This name)
    engine: Engine
    date := GameDate new()
    maxHomeless := 100

    lossConditions := ArrayList<Condition> new()
    winConditions := ArrayList<Condition> new()

    terrain: Terrain

    name := "<no name>"
    welcomeMessage := "level started!"
    objective := "Don't let the homeless surround you!"
    deathCount := 0

    // something used to display the world and manipulate it
    ui: MainUI

    // each player controls a part of the world
    player: Player
    things := ArrayList<Thing> new()
    terrain: Terrain

    won := false
    lost := false

    init: func (=engine) {
        ui = engine ui 
    
        terrain = Terrain new(ui)

        player = Player new(this, "William Tell")
        spawnPortals()

        ui input onKeyPress(Keys F12, ||
            logger info("Cheater!")
            player cash += 1000
        )

        ui input onKeyPress(Keys F11, ||
            logger info("Cheater!")
            date day += 30 * 10
        )
    }

    spawnPortals: func {
        for (i in 0..1) {
            p := Portal new(this, orientation2vec(Orientation LEFT))
            p setPos(terrain width / 2, terrain height / 2)

            add(p)
        }
    }

    countThing: func (T: Class) -> Int {
        count := 0
        for (t in things) {
            if (t instanceOf?(T)) count += 1
        }
        count
    }

    countHomeless: func -> Int {
        countThing(Alien)
    }

    add: func (t: Thing) {
        things add(t)
    }

    remove: func (t: Thing) {
        things remove(t)
        t destroy()
    }

    setup: func {
        ui levelTitle setText(name)
        ui objectiveLabel setText("Objective: " + objective)
        ui flash(welcomeMessage)
    }

    update: func {
        date update()
        ui dateLabel setText("Day %d" format(date getActualDay()))

        terrain update()
    
        things each (|t| t update())
        player update(date)

        homelessCount := countHomeless()

        ui homelessLabel setText("%d / %d homeless" format(
            homelessCount,
            maxHomeless
        ))
    

        if(won || lost) {
            // all good
        } else {
            for (lc in lossConditions) {
                if (lc isTrue(this)) {
                    logger info("Lost because of %s" format(lc getMessage()))
                    ui flash(lc getMessage())
                    in(4 * 30, || engine reload())
                    lost = true
                }
            }

            for (wc in winConditions) {
                if (wc isTrue(this)) {
                    logger info("Won because of %s" format(wc getMessage()))
                    ui flash(wc getMessage())
                    in(4 * 30, || engine jumpLevel(1))
                    won = true
                }
            }
        }
    }

    in: func (length: Int, cb: Func) {
        th := Thing new()
        th in(length, cb)
        add(th)
    }

    drop: func (type: String) {
        match type {
            case "tower" =>
                dropBuildable(Tower new(this, 40))
            case "building" =>
                dropBuildable(Building new(this, 15))
            case "house" =>
                dropBuildable(House new(this, 4))
            case "tree" =>
                dropBuildable(Tree new(this))
            case => 
                ui boombox play(ui nopeSound)
        }
    }

    dropBuildable: func (buildable: Buildable) {
        if (player cash <= buildable cost) {
            ui boombox play(ui nopeSound)
            buildable destroy()
        } else {
            drp := Dropper new(this, |pos|
                buildable pos set!(pos)
                add(buildable)
                ui boombox play(ui buildSound)
                player cash -= buildable cost
            )

            drp sprite add(buildable sprite)
        }
    }


} 




