
// libs deps
import ldkit/[Sprites, Math]
import structs/ArrayList
import deadlogger/Log

// game deps
import Alien, Terrain, Level, Player
import ui/MainUI

/*
 * TOWER !
 */

Tower: class extends Buildable {

    places: Int

    tenants := 0
    glowingBulb: EllipseSprite

    slurpTime := 10
    leaseTime := 150

    init: func (.level, =places) {
        super(level)

        cost = 1300

        every(leaseTime, ||
            if (tenants > 0) {
                tenants -= 1
            }
        )

        every(slurpTime, ||
            if (tenants < places) {
                level // workaround
                findInBox(3, false, Alien, |alien|
                    level ui boombox play(level ui zapSound)
                    level player cash += alien reward
                    level remove(alien)
                    tenants += 1
                )
            }
        )
    }

    loadSprite: func {
        offset := vec2(level terrain tileWidth, -65)

        glowingBulb = EllipseSprite new(offset)
        glowingBulb filled = true
        glowingBulb alpha = 0.7
        sprite add(glowingBulb)

        sprite add(loadIsoImage("assets/png/phaser.png"))
    }

    updateGfx: func {
        percentage := tenants * 100 / places
        radius := level terrain tileWidth * (0.5 + percentage / 200.0)

        glowingBulb radius = radius
        glowingBulb color set!(percentage / 200.0, 0.3, 0.3)
    }

    logic: func {
        updateGfx()
    }

}


/*
 * BUILDING !
 */

Building: class extends Buildable {

    places: Int

    tenants := 0
    glowingBulb: RectSprite

    slurpTime := 10
    leaseTime := 150

    init: func (.level, =places) {
        super(level)

        cost = 600

        every(leaseTime, ||
            if (tenants > 0) {
                tenants -= 1
            }
        )

        every(slurpTime, ||
            if (tenants < places) {
                level // workaround
                findInBox(3, false, Alien, |alien|
                    level ui boombox play(level ui landingSound)
                    level player cash += alien reward
                    level remove(alien)
                    tenants += 1
                )
            }
        )
    }

    loadSprite: func {
        offset := vec2(level terrain tileWidth, -35)

        glowingBulb = RectSprite new(offset)
        glowingBulb size set!(50, 0)
        glowingBulb filled = true
        glowingBulb color set!(0.9, 0.9, 0.1)
        sprite add(glowingBulb)

        sprite add(loadIsoImage("assets/png/building.png"))
    }

    updateGfx: func {
        percentage := tenants * 100 / places
        radius := level terrain tileWidth * (0.5 + percentage / 200.0)

        glowingBulb size y = radius
        glowingBulb pos y = - radius / 2 + 10
    }

    logic: func {
        updateGfx()
    }

}


/*
 * HOUSE !
 */

House: class extends Buildable {

    places: Int

    tenants := 0
    glowingBulb: EllipseSprite

    slurpTime := 10
    leaseTime := 150

    init: func (.level, =places) {
        super(level)

        cost = 250

        every(leaseTime, ||
            if (tenants > 0) {
                tenants -= 1
            }
        )

        every(slurpTime, ||
            if (tenants < places) {
                level // workaround
                findInBox(3, false, Alien, |alien|
                    level ui boombox play(level ui criekSound)
                    level player cash += alien reward
                    level remove(alien)
                    tenants += 1
                )
            }
        )
    }

    loadSprite: func {
        offset := vec2(level terrain tileWidth, -65)

        glowingBulb = EllipseSprite new(offset)
        glowingBulb filled = true
        glowingBulb alpha = 1.0
        sprite add(glowingBulb)

        sprite add(loadIsoImage("assets/png/house.png"))
    }

    updateGfx: func {
        percentage := tenants * 100 / places
        radius := level terrain tileWidth * (0.5 + percentage / 200.0)

        glowingBulb radius = radius
        glowingBulb color set!(percentage / 200.0, percentage / 200.0, 0)
    }

    logic: func {
        updateGfx()
    }

}



/*
 * TREE !
 */

Tree: class extends Buildable {

    init: func (.level) {
        super(level)

        cost = 100
    }

    loadSprite: func {
        sprite add(loadIsoImage("assets/png/tree.png"))
    }

}


/*
 * LAVA ! (unfinished :( )
 */

Lava: class extends Buildable {

    init: func (.level) {
        super(level)

        cost = 100
    }

    loadSprite: func {
        sprite add(loadIsoImage("assets/png/lava.png"))
    }

}

