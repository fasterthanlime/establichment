
import ldkit/[Math, Sprites]

Graphics: class {

    // create a new placeholder sprite
    placeholder: static func (name: String, pos: Vec2, size: Int) -> Sprite {
        // TODO add a square
        gs := GroupSprite new()
        gs pos set!(pos)
    
        rs := RectSprite new(vec2(0, 0))
        rs size set!(size, size)
        rs color set!(0.2, 0.5, 0.9)
        gs add(rs)

        rs2 := RectSprite new(vec2(0, 0))
        rs2 size set!(size, size)
        rs2 color set!(0.9, 0.5, 0.3)
        rs2 filled = false
        gs add(rs2)

        ls := LabelSprite new(vec2(0, 0), name)
        ls color set!(0.8, 0.7, 0.8)
        ls centered = true
        gs add(ls)

        gs
    }

}



