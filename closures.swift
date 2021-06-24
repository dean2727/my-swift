let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
func backward(_ s1: String, _ s2: String) -> Bool {
    return s1 > s2
}
var reversedNames = names.sorted(by: backward)  // e.g. of closure as parameter of sorted method
// reversedNames is equal to ["Ewa", "Daniella", "Chris", "Barry", "Alex"]
reversedNames = names.sorted(by: { (s1: String, s2: String) -> Bool in return s1 > s2 } )
reversedNames = names.sorted(by: { s1, s2 in return s1 > s2 } )  // closure expression syntax without the types being supplied because it's inferred

reversedNames = names.sorted { $0 > $1 }  // trailing closure syntax, value of return supplied and only parameter is closure so no ( )

let digitNames = [
    0: "Zero", 1: "One", 2: "Two",   3: "Three", 4: "Four",
    5: "Five", 6: "Six", 7: "Seven", 8: "Eight", 9: "Nine"
]
let numbers = [16, 58, 510]
let strings = numbers.map { (number) -> String in  // e.g. of map function and trailing closure to turn numbers into words, number type is inferred
    var number = number
    var output = ""
    repeat {
        output = digitNames[number % 10]! + output
        number /= 10
    } while number > 0
    return output
}

func makeIncrementer(forIncrement amount: Int) -> () -> Int {  // e.g. of a closure capturing values
    var runningTotal = 0
    func incrementer() -> Int {
        runningTotal += amount
        return runningTotal
    }
    return incrementer
}
let inc_by_10 = makeIncrementer(forIncrement: 10)
inc_by_10()  // returns 10

var completionHandlers: [() -> Void] = []
func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {  // e.g. of an escaping closure
    completionHandlers.append(completionHandler)
}
func someFunctionWithNonescapingClosure(closure: () -> Void) {
    closure()
}
class SomeClass {
    var x = 10
    func doSomething() {
        someFunctionWithEscapingClosure { self.x = 100 }
        someFunctionWithNonescapingClosure { x = 200 }
    }
}
let instance = SomeClass()
instance.doSomething()
print(instance.x)  // Prints "200"
completionHandlers.first?()
print(instance.x)  // Prints "100"

var customersInLine = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]  // e.g. of how an autoclosure delays evaluation
print(customersInLine.count)  // Prints "5"
let customerProvider = { customersInLine.remove(at: 0) }
print(customersInLine.count)  // Prints "5"
print("Now serving \(customerProvider())!")  // Prints "Now serving Chris!"
print(customersInLine.count)  // Prints "4"
func serve(customer customerProvider: @autoclosure () -> String) {
    print("Now serving \(customerProvider())!")
}
serve(customer: customersInLine.remove(at: 0))
