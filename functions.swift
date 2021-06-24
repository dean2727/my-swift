func minMax(array: [Int]) -> (min: Int, max: Int) {  // functions
    var currentMin = array[0]
    var currentMax = array[0]
    for value in array[1..<array.count] {
        if value < currentMin {
            currentMin = value
        } else if value > currentMax {
            currentMax = value
        }
    }
    return (currentMin, currentMax)
}
let nums = [4,2,6,1,7,2,9]
let min_and_max = minMax(array: nums)
print("min is \(min_and_max.min) and max is \(min_and_max.max)")


func arithmeticMean(_ numbers: Double...) -> Double {  // e.g. of variadic parameters
    var total: Double = 0
    for number in numbers {
        total += number
    }
    return total / Double(numbers.count)
}
arithmeticMean(1, 2, 3, 4, 5)  // returns 3.0, which is the arithmetic mean of these five numbers

func swapTwoInts(_ a: inout Int, _ b: inout Int) {  // e.g. of inout parameters
    let temporaryA = a
    a = b
    b = temporaryA
}
var someInt = 3
var anotherInt = 107
swapTwoInts(&someInt, &anotherInt)
print("someInt is now \(someInt), and anotherInt is now \(anotherInt)")

func addTwoInts(_ a: Int, _ b: Int) -> Int {
    return a + b
}
var mathVar = addTwoInts  // assigning a variable to a function, aka renaming the function ((Int, Int) -> Int type inferred)

func chooseStepFunction(backward: Bool) -> (Int) -> Int {  // e.g. of return type as function type and nested functions
    func stepForward(_ input: Int) -> Int { return input + 1 }
    func stepBackward(_ input: Int) -> Int { return input - 1 }
    return backward ? stepBackward : stepForward
}
var currentValue = 3
let moveNearerToZero = chooseStepFunction(backward: currentValue > 0)  // when chooseStepFunction is called bool is True since   3 > 0, so it steps backward continuously until 0
print("Counting to zero:")
while currentValue != 0 {
    print("\(currentValue)... ")
    currentValue = moveNearerToZero(currentValue)
}
print("zero!")
