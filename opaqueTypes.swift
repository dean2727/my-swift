// suppose im writing this module to draw ASCII art shapes, with the basic characteristic being draw() to represent string versions of the shape
protocol Shape {
    func draw() -> String
}

struct Triangle: Shape {
    var size: Int
    func draw() -> String {
        var result = [String]()
        for length in 1...size {
            result.append(String(repeating: "*", count: length))
        }
        return result.joined(separator: "\n")
    }
}
let smallTriangle = Triangle(size: 3)
print(smallTriangle.draw())
// *
// **
// ***

struct FlippedShape<T: Shape>: Shape {  // using generics we can flip the shape, but the limitation is that the result exposes the generic type
    var shape: T
    func draw() -> String {
        let lines = shape.draw().split(separator: "\n")
        return lines.reversed().joined(separator: "\n")
    }
}
let flippedTriangle = FlippedShape(shape: smallTriangle)
print(flippedTriangle.draw())
// ***
// **
// *

struct JoinedShape<T: Shape, U: Shape>: Shape {
    var top: T
    var bottom: U
    func draw() -> String {
        return top.draw() + "\n" + bottom.draw()
    }
}
let joinedTriangles = JoinedShape(top: smallTriangle, bottom: flippedTriangle)
print(joinedTriangles.draw())
// *
// **
// ***
// ***
// **
// *

// the code in this module can build up the same shape a variety of ways, and code outside of the module that uses the shape shouldnt have to account for the details about the transformations
// FlippedShape and JoinedShape shouldnt be visible because of operations that consist in the public interface


struct Square: Shape {
    var size: Int
    func draw() -> String {
        let line = String(repeating: "*", count: size)
        let result = Array<String>(repeating: line, count: size)
        return result.joined(separator: "\n")
    }
}


/* this function is written in a way to express the fundamental aspect of its public interface, not making the specific types that the shape is made from its public interface, it may use triangles and a square, but it can be done other ways */
func makeTrapezoid() -> some Shape {  /* e.g. of an opaque return type, the function determines the return instead of the caller, this type being any type that conforms to Shape */
    let top = Triangle(size: 2)
    let middle = Square(size: 2)
    let bottom = FlippedShape(shape: top)
    let trapezoid = JoinedShape(
        top: top,
        bottom: JoinedShape(top: middle, bottom: bottom)
    )
    return trapezoid
}
let trapezoid = makeTrapezoid()
print(trapezoid.draw())
// *
// **
// **
// **
// **
// *


func flip<T: Shape>(_ shape: T) -> some Shape {  // combining opaque and generics
    return FlippedShape(shape: shape)
}
func join<T: Shape, U: Shape>(_ top: T, _ bottom: U) -> some Shape {
    JoinedShape(top: top, bottom: bottom)
}

let opaqueJoinedTriangles = join(smallTriangle, flip(smallTriangle))
print(opaqueJoinedTriangles.draw())
// *
// **
// ***
// ***
// **
// *


func reepeat<T: Shape>(shape: T, count: Int) -> some Collection {
    return Array<T>(repeating: shape, count: count)
}


func protoFlip<T: Shape>(_ shape: T) -> Shape {  // e.g. of a protocol return type
    return FlippedShape(shape: shape)
}
