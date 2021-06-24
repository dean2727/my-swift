import UIKit

var str = "Hello, playground"


var sampleVariable = 1  // variable
let sampleConstant = "Constant"  // constant
var sampleInteger: Int = 5  // specified type variables
let sampleString: String = "Another constant"
let sumString = "The sum is: \(sampleVariable + sampleInteger)"


var sampleList = ["1", "2", "3"]
var sampleDict = ["1":"3", "2":"4"]
sampleList[1] = "5"


var sam = [String]()  //empty string
sam.append("1")
print(sam)


// string and list functions
let word = "backwards"
print(String(word.reversed()))


var poop = ["sdg", "12", "dg", "eaew"]
poop.insert("t", at: 2)
poop[2] = "wd"
print(poop)


var optionalString: Int? = 5


let multilineString = """
heyyy
whats uppppppp
"""


var tupl = (1, 2)
print(tupl.0)


// shoots and ladders game
let finalSquare = 25
var board = [Int](repeating: 0, count: finalSquare + 1)  // initializing a list with no repeating values and a total number of elements
board[03] = +08; board[06] = +11; board[09] = +09; board[10] = +02
board[14] = -10; board[19] = -11; board[22] = -02; board[24] = -08
var square = 0
var diceRoll = 0
gameLoop: while square != finalSquare {  // e.g. of labeled statements
    diceRoll += 1
    if diceRoll == 7 { diceRoll = 1 }
    switch square + diceRoll {
    case finalSquare:
        // diceRoll will move us to the final square, so the game is over
        break gameLoop
    case let newSquare where newSquare > finalSquare:
        // diceRoll will move us beyond the final square, so roll again
        continue gameLoop
    default:
        // this is a valid move, so find out its effect
        square += diceRoll
        square += board[square]
    }
}
print("Game over!")


func greet(person: [String: String]) {
    guard let name = person["name"] else {  // e.g. of guard statements
        return
    }
    print("Hello \(name)!")
    guard let location = person["location"] else {
        print("I hope the weather is nice near you.")
        return
    }
    print("I hope the weather is nice in \(location).")
}
greet(person: ["name": "John"])
// Prints "Hello John!"
// Prints "I hope the weather is nice near you."
greet(person: ["name": "Jane", "location": "Cupertino"])
// Prints "Hello Jane!"
// Prints "I hope the weather is nice in Cupertino."
