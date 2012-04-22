
import structs/[ArrayList, HashMap]
import ldkit/[Sprites, Input, Math]

import ui/[MainUI, Pass]

Placement: enum {
    WEST
    NORTH
    EAST
    SOUTH
}



/*
 * A toolbar is a set of items that are clickable
 */
Toolbar: class {
    ui: MainUI

    itemWidth := 140
    padding := 10

    items := ArrayList<Item> new()

    pass: Pass
    
    placement := Placement EAST
    pos: Vec2

    init: func (=ui) {
        pos = vec2(40, 40)

        pass = Pass new(ui, "toolbar")

        match placement {
            case Placement EAST =>
                pos set!(ui display getWidth() - itemWidth / 2, itemWidth + 80)
        }

        ui input onMouseMove(||
            point := ui input mousepos
            items each(|item|
                if(item rect containsPoint(point)) {
                    item _changeState(ItemState HOVER)
                } else {
                    item _changeState(ItemState IDLE)
                }
            )
        )
    }

    add: func (item: Item) {
        item sprite pos set!(nextItemPos())
        item setSize(itemWidth - padding, itemWidth - padding)

        pass addSprite(item sprite)
        items add(item)
    }

    nextItemPos: func -> Vec2 {
        nextPos := vec2(pos x, pos y)        

        match placement {
            case Placement EAST => 
                nextPos y = pos y + getHeight()
        }
        nextPos
    }

    getWidth: func -> Int {
        itemWidth
    }

    getHeight: func -> Int {
        itemWidth * items size
    }

}



ItemState: enum {
    IDLE
    HOVER
    PRESSED
}

/*
 * An item of a toolbar
 */
Item: class {

    name: String
    icon: String
    width, height: Int

    colors := static HashMap<ItemState, Vec3> new()

    state := ItemState IDLE

    sprite: GroupSprite
    rect: RectSprite

    init: func (=name) {
        // FIXME: static initialization workaround suxxorz
        if (colors empty?()) {
            colors add(s1 := ItemState IDLE,    vec3(0.5, 0.5, 0.5))
            colors add(s2 := ItemState HOVER,   vec3(0.7, 0.7, 0.7))
            colors add(s3 := ItemState PRESSED, vec3(0.4, 0.4, 0.4))
        }

        sprite = GroupSprite new()

        rect = RectSprite new(vec2(0, 0))
        rect color set!(0.8, 0.8, 0.8)
        rect filled = true
        sprite add(rect)

        rect2 := RectSprite new(vec2(0, 0))
        rect2 size = rect size
        rect2 color set!(0.5, 0.5, 0.5)
        rect2 thickness = 1.0
        rect2 filled = false
        sprite add(rect2)

        ls := LabelSprite new(vec2(0, 0), name)
        ls color set!(0.2, 0.2, 0.2)
        ls centered = true
        sprite add(ls)
    }

    setSize: func (=width, =height) {
        rect  size set!(width, height) 
    }

    _changeState: func (=state) {
        // TODO: validate state?
        // TODO: notify listeners?
        rect color set!(colors get(state))
    }

}


