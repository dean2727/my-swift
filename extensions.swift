extension Double {
    var km: Double { return self * 1_000.0 }  // e.g. of computed properties in extensions
    var m: Double { return self }
    var cm: Double { return self / 100.0 }
    var mm: Double { return self / 1_000.0 }
    var ft: Double { return self / 3.28084 }
}
let oneInch = 25.4.mm
print("One inch is \(oneInch) meters")
// Prints "One inch is 0.0254 meters"
let threeFeet = 3.ft
print("Three feet is \(threeFeet) meters")
// Prints "Three feet is 0.914399970739201 meters"
let aMarathon = 42.km + 195.m
print("A marathon is \(aMarathon) meters long")
// Prints "A marathon is 42195.0 meters long"


struct Size {  // the rectangle shit from before but with an extension acting as a convenience init to take a specific center point and size
    var width = 0.0, height = 0.0
}
struct Point {
    var x = 0.0, y = 0.0
}
struct Rect {
    var origin = Point()
    var size = Size()
}
extension Rect {
    init(center: Point, size: Size) {  // e.g. of init in expressions
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
}
let centerRect = Rect(center: Point(x: 4.0, y: 4.0),
                      size: Size(width: 3.0, height: 3.0))
// centerRect's origin is (2.5, 2.5) and its size is (3.0, 3.0)


extension Int {
    func repetitions(task: () -> Void) {  // e.g. of methods in extensions, takes an arg of type () -> Void (no parameters or Return)
        for _ in 0..<self {
            task()
        }
    }
}
3.repetitions {
    print("Hello!")
}
// Hello!
// Hello!
// Hello!


extension Int {
    mutating func square() {  // e.g. of mutating instance method
        self = self * self
    }
}
var someInt = 3  // make a variable since literals (Int) are not mutable
someInt.square()
// someInt is now 9


extension Int {
    subscript(digitIndex: Int) -> Int {  // e.g. of a subscript that returns the value of the index of an int but from the right
        var decimalBase = 1
        for _ in 0..<digitIndex {
            decimalBase *= 10
        }
        return (self / decimalBase) % 10
    }
}
746381295[0]
// returns 5
746381295[1]
// returns 9
746381295[9]
// returns 0, as if you had requested:
0746381295[9]


extension Int {
    enum Kind {  // e.g. of nested types
        case negative, zero, positive
    }
    var kind: Kind {
        switch self {
        case 0:
            return .zero
        case let x where x > 0:
            return .positive
        default:
            return .negative
        }
    }
}
func printIntegerKinds(_ numbers: [Int]) {
    for number in numbers {
        switch number.kind {  // using the extension
        case .negative:
            print("- ", terminator: "")
        case .zero:
            print("0 ", terminator: "")
        case .positive:
            print("+ ", terminator: "")
        }
    }
}
printIntegerKinds([3, 19, -27, 0, -6, 0, 7])
// Prints "+ + - 0 - 0 +"
