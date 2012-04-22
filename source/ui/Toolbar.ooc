
import structs/[ArrayList]
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

    itemWidth := 100
    items := ArrayList<Item> new()

    pass: Pass
    
    placement := Placement EAST
    pos: Vec2

    init: func (=ui) {
        pos = vec2(40, 40)

        pass = Pass new(ui, "toolbar")

        match placement {
            case Placement EAST =>
                pos set!(ui display getWidth() - itemWidth / 2, 120)
        }
    }

    add: func (item: Item) {
        item sprite pos set!(nextItemPos())
        pass addSprite(item sprite)
        items add(item)
    }

    nextItemPos: func -> Vec2 {
        nextPos := vec2(pos x, pos y)        

        match placement {
            case Placement EAST => 
                nextPos y = getHeight()
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
    CLICKED
}

/*
 * An item of a toolbar
 */
Item: class {

    name: String
    icon: String
    state := ItemState IDLE

    sprite: GroupSprite

    init: func (=name) {
        sprite = GroupSprite new()

        ls := LabelSprite new(vec2(0, 0), name)
        ls centered = true

        sprite add(ls)
    }

    setWidth: func (width: Int) {

    }

}

