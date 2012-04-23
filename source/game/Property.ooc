
// libs deps
import ldkit/[Sprites, Math]
import structs/ArrayList
import deadlogger/Log

// game deps
import Citizen, Terrain, Level

Property: class extends IsoThing {

    places: Int

    tenants := 0
    tenantsLabel: LabelSprite

    slurpTime := 15
    leaseTime := 150
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
                findInBox(3, false, Citizen, |citz|
                    logger info ("Found citizen %x around property %x!" format(citz, this)) 
                    level remove(citz)
                    tenants += 1
                )
            }
        )
    }

    loadSprite: func {
        sprite add(loadIsoImage("assets/png/phaser-100px.png"))

        tenantsLabel = LabelSprite new(vec2(level terrain tileWidth, -30), "")
        tenantsLabel color set!(0.9, 0.9, 0.9)
        tenantsLabel centered = true
        sprite add(tenantsLabel)
    }

    updateLabel: func {
        tenantsLabel setText("%d / %d" format(tenants, places))
    }

    logic: func {
        // TODO: optimize
        updateLabel()
    }

}


