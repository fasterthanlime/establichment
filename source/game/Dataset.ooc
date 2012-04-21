
// libs deps
import structs/ArrayList

// game deps
import game/Level

DataPoint: class {

    date := GameDate new()
    value: Int

    init: func (date: GameDate, value: Float) {
        this date set(date)
    }

}

Dataset: class {

    points := ArrayList<DataPoint> new()

    start: GameDate = null
    end: GameDate = null

    add: func (d: GameDate, value: Int) {
        points add(DataPoint new(d, value))
        if (!start) {
            start = d
            end = d
        } else {
            if (d before?(start)) start = d
            if (d after?(end)) end = d
        }
    }

    each: func (f: Func (DataPoint)) {
        points each(|p|
            if (p date before?(end) && p date after?(start)) f(p)
        )
    }

    daterange: func (start, end: GameDate) -> Dataset {
        subset := This new()
        subset points = points
        subset start = start
        subset end = end
        subset
    }

    getMin: func -> Int {
        min := points[0] value
        each(|p| 
            if (p value < min) min = p value
        )
        min
    }

    getMax: func -> Int {
        max := points[0] value
        each(|p| 
            if (p value > max) max = p value
        )
        max
    }

    getMean: func -> Float {
        max := points[0] value
        each(|p| 
            if (p value > max) max = p value
        )
        max
    }

}


