protocol SomeProtocol {
    var mustBeSettable: Int { get set }
    var doesNotNeedToBeSettable: Int { get }
}


protocol FullyNamed {  // any type that conforms to this must have a property called "fullName" with type String and only gettable
    var fullName: String { get }
}
struct Person: FullyNamed {  // simple e.g. of a structure that conforms to it
    var fullName: String
}
let john = Person(fullName: "John Appleseed")


protocol RandomNumberGenerator {  // e.g. of a method in a protocol, requires that the class/etc. have a method called random that returns a Double
    func random() -> Double
}
class LinearCongruentialGenerator: RandomNumberGenerator {
    var lastRandom = 42.0
    let m = 139968.0
    let a = 3877.0
    let c = 29573.0
    func random() -> Double {
        lastRandom = ((lastRandom * a + c).truncatingRemainder(dividingBy:m))
        return lastRandom / m
    }
}
let generator = LinearCongruentialGenerator()
print("Here's a random number: \(generator.random())")


protocol Togglable {  // e.g. of mutating method
    mutating func toggle()
}
enum OnOffSwitch: Togglable {
    case off, on
    mutating func toggle() {
        switch self {
        case .off:
            self = .on
        case .on:
            self = .off
        }
    }
}
var lightSwitch = OnOffSwitch.off
lightSwitch.toggle()


class Dice {
    let sides: Int
    let generator: RandomNumberGenerator  // e.g. of protocol used as a type, meaning you can
    init(sides: Int, generator: RandomNumberGenerator) {
        self.sides = sides
        self.generator = generator
    }
    func roll() -> Int {
        return Int(generator.random() * Double(sides)) + 1  // returns number between 1 and # of sides, random() outputs Double between 0.0 and 1.0
    }
}
var d6 = Dice(sides: 6, generator: LinearCongruentialGenerator())  // using a call to a class that conforms which is the protocol type
for _ in 1...5 {
    print("Random dice roll is \(d6.roll())")
}
// Random dice roll is 3
// Random dice roll is 5
// Random dice roll is 4
// Random dice roll is 5
// Random dice roll is 4


// e.g. of delegation
protocol DiceGame {  // adopted by any game that involves dice
    var dice: Dice { get }
    func play()
}
protocol DiceGameDelegate: AnyObject {  // to track the progress of a dice game, e.g. of a class-only protocol
    func gameDidStart(_ game: DiceGame)
    func game(_ game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int)
    func gameDidEnd(_ game: DiceGame)
}
class SnakesAndLadders: DiceGame {
    let finalSquare = 25
    let dice = Dice(sides: 6, generator: LinearCongruentialGenerator())
    var square = 0
    var board: [Int]
    init() {
        board = Array(repeating: 0, count: finalSquare + 1)
        board[03] = +08; board[06] = +11; board[09] = +09; board[10] = +02
        board[14] = -10; board[19] = -11; board[22] = -02; board[24] = -08
    }
    weak var delegate: DiceGameDelegate?  // declared to track the game progress, "weak" typed to prevent reference cycles, optional because the instantiator doesnt have to start the game, for example, halfway through, automatically nil = autatically starting at the start
    func play() {
        square = 0
        delegate?.gameDidStart(self)
        gameLoop: while square != finalSquare {  // gameLoop is a labeled statement for break/continue
            let diceRoll = dice.roll()
            delegate?.game(self, didStartNewTurnWithDiceRoll: diceRoll)
            switch square + diceRoll {
            case finalSquare:
                break gameLoop
            case let newSquare where newSquare > finalSquare:
                continue gameLoop
            default:
                square += diceRoll
                square += board[square]
            }
        }
        delegate?.gameDidEnd(self)
    }
}

class DiceGameTracker: DiceGameDelegate {  // this class conforms to DiceGameDelegate this time
    var numberOfTurns = 0
    func gameDidStart(_ game: DiceGame) {  // this function can only use methods and functions that are implemented as part of DiceGame protocol
        numberOfTurns = 0
        if game is SnakesAndLadders {
            print("Started a new game of Snakes and Ladders")
        }
        print("The game is using a \(game.dice.sides)-sided dice")
    }
    func game(_ game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int) {
        numberOfTurns += 1
        print("Rolled a \(diceRoll)")
    }
    func gameDidEnd(_ game: DiceGame) {
        print("The game lasted for \(numberOfTurns) turns")
    }
}
let tracker = DiceGameTracker()  // this is the delegate for SnakesAndLadders game
let game = SnakesAndLadders()
game.delegate = tracker
game.play()
// Started a new game of Snakes and Ladders
// The game is using a 6-sided dice
// Rolled a 3
// Rolled a 5
// Rolled a 4
// Rolled a 5
// The game lasted for 4 turns


protocol TextRepresentable {
    var textualDescription: String { get }
}
extension Dice: TextRepresentable {  // extension for Dice which adds a requirement that conforms to the protocol
    var textualDescription: String {
        return "A \(sides)-sided dice"
    }
}
extension SnakesAndLadders: TextRepresentable {
    var textualDescription: String {
        return "A game of Snakes and Ladders that has \(finalSquare) squares"
    }
}
let d12 = Dice(sides: 12, generator: LinearCongruentialGenerator())
print(d12.textualDescription)


let things: [TextRepresentable] = [game, d12]  // e.g. of a collection of protocol types


protocol PrettyTextRepresentable: TextRepresentable {  // e.g. of inherited protocol
    var prettyTextualDescription: String { get }
}
extension SnakesAndLadders: PrettyTextRepresentable {  // adopt the inherited protocol and provide an implemtation of the new property
    var prettyTextualDescription: String {
        var output = textualDescription + ":\n"
        for index in 1...finalSquare {
            switch board[index] {
            case let ladder where ladder > 0:
                output += "▲ "
            case let snake where snake < 0:
                output += "▼ "
            default:
                output += "○ "
            }
        }
        return output
    }
}
print(game.prettyTextualDescription)
// A game of Snakes and Ladders with 25 squares:
// ○ ○ ▲ ○ ○ ▲ ○ ○ ▲ ▲ ○ ○ ○ ▼ ○ ○ ○ ○ ▼ ○ ○ ▼ ○ ▼ ○


protocol Named {
    var name: String { get }
}
protocol Aged {
    var age: Int { get }
}
struct Human: Named, Aged {  // conforms to multiple protocols
    var name: String
    var age: Int
}
func wishHappyBirthday(to celebrator: Named & Aged) {  // e.g. of protocol composition, this means “any type that conforms to both the Named and Aged protocols.”
    print("Happy birthday, \(celebrator.name), you're \(celebrator.age)!")
}
let birthdayPerson = Human(name: "Malcolm", age: 21)
wishHappyBirthday(to: birthdayPerson)
// Prints "Happy birthday, Malcolm, you're 21!"

class Location {  // another e.g. of protocol composition
    var latitude: Double
    var longitude: Double
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
class City: Location, Named {
    var name: String
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        super.init(latitude: latitude, longitude: longitude)
    }
}
func beginConcert(in location: Location & Named) {  // “any type that’s a subclass of Location and that conforms to the Named protocol.”
    print("Hello, \(location.name)!")
}

let seattle = City(name: "Seattle", latitude: 47.6, longitude: -122.3)
beginConcert(in: seattle)
// Prints "Hello, Seattle!"


protocol HasArea {
    var area: Double { get }
}
class Circle: HasArea {
    let pi = 3.1415927
    var radius: Double  // stored property
    var area: Double { return pi * radius * radius }  // computed property
    init(radius: Double) { self.radius = radius }
}
class Country: HasArea {
    var area: Double
    init(area: Double) { self.area = area }
}
class Animal {
    var legs: Int
    init(legs: Int) { self.legs = legs }
}
let objects: [AnyObject] = [
    Circle(radius: 2.0),
    Country(area: 243_610),
    Animal(legs: 4)
]
for object in objects {  // e.g. of checking for conformance
    if let objectWithArea = object as? HasArea {  // the optional value returned by as? is unwrapped with optional binding into objectWithArea, which is of type HasArea, so area can be accessed (only area because objects are stored in that constant)
        print("Area is \(objectWithArea.area)")
    } else {
        print("Something that doesn't have an area")
    }
}


@objc protocol CounterDataSource {  // e.g. of optional requirements, it is so that data sources provide appropriate increments for a Counter instance
    @objc optional func increment(forCount count: Int) -> Int
    @objc optional var fixedIncrement: Int { get }
}
class Counter {
    var count = 0
    var dataSource: CounterDataSource?
    func increment() {
        if let amount = dataSource?.increment?(forCount: count) {
            count += amount
        } else if let amount = dataSource?.fixedIncrement {
            count += amount
        }
    }
}
class ThreeSource: CounterDataSource {  // in practice there would be a specified superclass before the specified protocol
    let fixedIncrement = 3  // implements 1 of the 2 optional requirements
}
var counter = Counter()
counter.dataSource = ThreeSource()  // using an instance of ThreeSource as the data source for a new Counter instance
for _ in 1...4 {
    counter.increment()
    print(counter.count)
}
// 3
// 6
// 9
// 12
class TowardsZeroSource: CounterDataSource {
    func increment(forCount count: Int) -> Int {  // implements the other optional requirement
        if count == 0 {
            return 0
        } else if count < 0 {
            return 1
        } else {
            return -1
        }
    }
}
counter.count = -4
counter.dataSource = TowardsZeroSource()
for _ in 1...5 {
    counter.increment()
    print(counter.count)
}
// -3
// -2
// -1
// 0
// 0


extension RandomNumberGenerator {  // e.g. of a protocol extension, uses the already random()
    func randomBool() -> Bool {
        return random() > 0.5
    }
}


extension PrettyTextRepresentable  {  // using extension to provide default implementation
    var prettyTextualDescription: String {
        return textualDescription
    }
}


extension Collection where Element: Equatable {  // extension to type "Collection" where the elements of whatever conforms must conform to the Equatable protocol (this is in standard library)
    func allEqual() -> Bool {
        for element in self {
            if element != self.first {  // .first is in the Equatable protocol
                return false
            }
        }
        return true
    }
}
let equalNumbers = [100, 100, 100, 100, 100]
let differentNumbers = [100, 100, 200, 100, 200]
print(equalNumbers.allEqual())
// Prints "true"
print(differentNumbers.allEqual())
// Prints "false"
