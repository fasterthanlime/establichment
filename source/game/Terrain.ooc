

import ui/[MainUI, Graphics, Pass]

import math/Random, structs/ArrayList
import ldkit/[Math, Sprites]

import Level

Orientation: enum {
    RIGHT
    UP
    LEFT
    DOWN
}

orientation2string: func (o: Orientation) -> String {
    match o {
        case Orientation RIGHT => "right"
        case Orientation UP    => "up"
        case Orientation LEFT  => "left"
        case Orientation DOWN  => "down"
    }
}

orientation2vec: func (o: Orientation) -> Vec2 {
    match o {
        case Orientation RIGHT => vec2( 1,  0)
        case Orientation UP    => vec2( 0,  1)
        case Orientation LEFT  => vec2(-1,  0)
        case Orientation DOWN  => vec2( 0, -1)
    }
}

vec2orientation: func (v: Vec2) -> Orientation {
    match {
        case v x < EPSILON => match {
            case v y < 0 => Orientation DOWN
            case         => Orientation UP
        }
        case => match {
            case v x < 0 => Orientation LEFT
            case         => Orientation RIGHT
        }
    }
}

IsoThing: class extends Thing {
    
    level: Level
    pos := vec2(0.0, 0.0)

    sprite: GroupSprite

    init: func (=level) {
        sprite = GroupSprite new()
        level terrain pass2 addSprite(sprite)

        loadSprite()
    }

    loadSprite: func {
        // overload with your own stuff
        ls := LabelSprite new(vec2(0, 0), class name)
        sprite add(ls)
    }

    loadIsoImage: func (path: String) -> Sprite {
        is := ImageSprite new(vec2(0, 0),path)
        is pos set!(0, - (is height - level terrain tileHeight))
        is
    }

    setPos: func ~vec (v: Vec2) {
        pos set!(v)
        sprite pos set!(level terrain getScreenPos(pos))
    }

    setPos: func ~floats (x, y: Float) {
        pos set!(x, y)
        sprite pos set!(level terrain getScreenPos(pos))
    }

    update: func {
        logic()
        sprite pos set!(level terrain getScreenPos(pos))
    }

    logic: func {
        // please override this one instead, or call super on update
    }

}

OrientedIsoThing: class extends IsoThing {

    dir := vec2(1.0, 0.0)

    init: func (.level, .dir) {
        super(level)
        dir set!(dir)
    }

    getDirection: func -> Vec2 {
        dir
    }

    getOrientation: func -> Orientation {
        vec2orientation(dir)
    }

}

Terrain: class {

    width := 8
    height := 8

    tileWidth := 50
    tileHeight := 25

    base: Vec2

    pass: Pass
    pass2: Pass

    passes: ArrayList<Pass>

    ui: MainUI

    xAxis, yAxis: Vec2

    tileTypes := [
        "concrete", "concrete", "concrete", "concrete", "concrete", "concrete", "concrete", "concrete", 
        "lava"
    ] as ArrayList<String>

    getScreenPos: func (isopos: Vec2) -> Vec2 {
            base add(xAxis mul(isopos x)) add(yAxis mul(isopos y))
    }

    init: func (=ui) {
        pass = Pass new(ui, "terrain")
        ui levelPass addPass(pass)

        pass2 = Pass new(ui, "inhabitants")
        ui levelPass addPass(pass2)

        offset := getOffset()
        base = vec2(offset x, offset x)
        xAxis = vec2( tileWidth, -tileHeight)
        yAxis = vec2(-tileWidth, -tileHeight)

        passCount := width + height - 1
        passes = ArrayList<Pass> new()
        for (i in 0..passCount) {
            p := Pass new(ui, "isometric %d" format(i))
            passes add(0, p)
            pass addPass(p)
        }

        spawnRandomTiles()
    }

    update: func {
        pass2 sprites sort(|s1, s2| s1 pos y > s2 pos y)
    }

    spawnRandomTiles: func {
        // lay terrain tiles
        for(x in 0..width) for (y in 0..height) {
            pos := getScreenPos(vec2(x, y))
            passes[x + y] addSprite(tile(pos, Random choice(tileTypes)))
        }        
    }

    getOffset: func -> Vec2 {
        totalWidth  := 0
        totalHeight := height * -1 * tileHeight

        vec2(
            ui display getWidth() / 2 - totalWidth / 2,
            ui display getHeight() / 2 - totalHeight / 2
        )
    }

    tile: func (pos: Vec2, name: String) -> Sprite {
        file := "assets/png/%s-100px.png" format(name)
        is := ImageSprite new(pos, file)
        is pos set!(is pos x, is pos y - (is height - tileHeight))
        is
    }

}


