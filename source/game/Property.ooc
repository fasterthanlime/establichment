
// libs deps
import ldkit/[Sprites, Math]
import structs/ArrayList
import deadlogger/Log

// game deps
import Alien, Terrain, Level
import ui/MainUI

Property: class extends IsoThing {

    places: Int

    cost := 250

    tenants := 0
    tenantsLabel: LabelSprite
    glowingBulb: EllipseSprite

    slurpTime := 15
    leaseTime := 100
    counter := 0

    init: func (.level, =places) {
        super(level)

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

        sprite add(loadIsoImage("assets/png/phaser-100px.png"))

        tenantsLabel = LabelSprite new(offset, "")
        tenantsLabel fontSize = 18
        tenantsLabel color set!(0.1, 0.3, 0.7)
        tenantsLabel centered = true
        // sprite add(tenantsLabel)
    }

    updateLabel: func {
        percentage := tenants * 100 / places
        radius := level terrain tileWidth * (0.5 + percentage / 200.0)

        glowingBulb radius = radius
        // glowingBulb pos set!(-radius * 0.5, -radius * 0.5)
        glowingBulb color set!(percentage / 200.0, 0.3, 0.3)

        tenantsLabel setText("%d%%" format(percentage))
        tenantsLabel color set!(percentage / 200.0, 0.3, 0.3)
    }

    logic: func {
        updateLabel()
    }

}


