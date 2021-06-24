struct Resolution {
    var width = 0
    var height = 0
}
class VideoMode {
    var resolution = Resolution()  // property type: Resolution
    var interlaced = false
    var frameRate = 0.0
    var name: String?
}
let someResolution = Resolution()
let someVideoMode = VideoMode()
print("The width of someResolution is \(someResolution.width)")
someVideoMode.resolution.width = 1280
print("The width of someVideoMode is now \(someVideoMode.resolution.width)")


let vga = Resolution(width: 640, height: 480)
let hd = Resolution(width: 1920, height: 1080)
var cinema = hd  // cinema is another instance with same width and height


let tenEighty = VideoMode()
tenEighty.resolution = hd
tenEighty.interlaced = true
tenEighty.name = "1080i"
tenEighty.frameRate = 25.0
let alsoTenEighty = tenEighty
alsoTenEighty.frameRate = 30.0  // tenEighty and alsoTenEighty now have the framerate changed (class = reference type)
if tenEighty === alsoTenEighty {  // identity operator
    print("tenEighty and alsoTenEighty refer to the same VideoMode instance.")
}


struct FixedLengthRange {  // showing how properties cannot be changed for constant instances of structures
    var firstValue: Int
    let length: Int
}
let rangeOfFourItems = FixedLengthRange(firstValue: 0, length: 4)
//  rangeOfFourItems.firstValue = 6  <-- cant do


class DataImporter {
    var filename = "data.txt"
    // insert data importing functionality here
}
class DataManager {
    lazy var importer = DataImporter()  // e.g. of using a lazy property
    var data = [String]()
    // insert data management functionality here
}
let manager = DataManager()
manager.data.append("Some data")
manager.data.append("Some more data")
print(manager.importer.filename)


struct Coordinate {
    var x = 0.0, y = 0.0
}
struct Size {
    var width = 0.0, height = 0.0
}
struct Rect {
    var origin = Coordinate()
    var size = Size()
    var center: Coordinate {  // computed property
        get {
            let centerX = origin.x + (size.width / 2)
            let centerY = origin.y + (size.height / 2)
            return Coordinate(x: centerX, y: centerY)
            /* shorthand notation:
            Point(x: origin.x + (size.width / 2),
                  y: origin.y + (size.height / 2)) */
        }
        set(newCenter) {  // shorthand notation omits "(newCenter)"
            origin.x = newCenter.x - (size.width / 2)
            origin.y = newCenter.y - (size.height / 2)
        }
    }
    // e.g. of the forms of init
    init() {}  // default values
    init(origin: Coordinate, size: Size) {  // same as the memberwise initializer the structure would have received
        self.origin = origin
        self.size = size
    }
    init(center: Coordinate, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin: Coordinate(x: originX, y: originY), size: size)  // e.g. of initializer delegation
    }
}
var square = Rect(origin: Coordinate(x: 0.0, y: 0.0),
                  size: Size(width: 10.0, height: 10.0))
let initialSquareCenter = square.center  // get
square.center = Coordinate(x: 15.0, y: 15.0)  // set
print("square.origin is now at (\(square.origin.x), \(square.origin.y))")
let centerRect = Rect(center: Coordinate(x: 4.0, y: 4.0),
                      size: Size(width: 3.0, height: 3.0))
// centerRect's origin is (2.5, 2.5) and its size is (3.0, 3.0)


struct Cuboid {
    var width = 0.0, height = 0.0, depth = 0.0
    var volume: Double {  // e.g. of read-only computed property
        return width * height * depth
    }
}
let fourByFiveByTwo = Cuboid(width: 4.0, height: 5.0, depth: 2.0)
print("the volume of fourByFiveByTwo is \(fourByFiveByTwo.volume)")


class StepCounter {  // e.g. of property observers
    var totalSteps: Int = 0 {
        willSet(newTotalSteps) {
            print("About to set totalSteps to \(newTotalSteps)")
        }
        didSet {
            if totalSteps > oldValue  {
                print("Added \(totalSteps - oldValue) steps")
            }
        }
    }
}
let stepCounter = StepCounter()
stepCounter.totalSteps = 200
// About to set totalSteps to 200
// Added 200 steps
stepCounter.totalSteps = 360
// About to set totalSteps to 360
// Added 160 steps


enum SomeEnumeration {  // type properties
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 6
    }
}
class SomeClass {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 27
    }
    class var overrideableComputedTypeProperty: Int {  // allow subclass to override superclass implementation
        return 107
    }
}
print(SomeClass.storedTypeProperty)
// Prints "Some value."
SomeClass.storedTypeProperty = "Another value."
print(SomeClass.storedTypeProperty)
// Prints "Another value."


struct AudioChannel {  // e.g. of querying and referencing type properties
    static let thresholdLevel = 10
    static var maxInputLevelForAllChannels = 0  // keeps track of the highest input level received by any of the instances of the class
    var currentLevel: Int = 0 {
        didSet {
            if currentLevel > AudioChannel.thresholdLevel {  // notice the dot notation
                // cap the new audio level to the threshold level
                currentLevel = AudioChannel.thresholdLevel
            }
            if currentLevel > AudioChannel.maxInputLevelForAllChannels {
                // store this as the new overall maximum input level
                AudioChannel.maxInputLevelForAllChannels = currentLevel
            }
        }
    }
}
var leftChannel = AudioChannel()
var rightChannel = AudioChannel()
leftChannel.currentLevel = 7
print(leftChannel.currentLevel)
// Prints "7"
rightChannel.currentLevel = 11
print(rightChannel.currentLevel)
// Prints "10"
print(AudioChannel.maxInputLevelForAllChannels)
// Prints "10"


class Counter {  // class with methods
    var count = 0
    func increment() {
        count += 1
    }
    func increment(by amount: Int) {
        count += amount
    }
    func reset() {
        count = 0
    }
}


struct Point {
    var x = 0.0, y = 0.0
    func isToTheRightOf(x: Double) -> Bool {
        return self.x > x  // // e.g. of using self
    }
    mutating func moveBy(x deltaX: Double, y deltaY: Double) {  // e.g. of mutating behavior function that can modify values
        x += deltaX
        y += deltaY
        // or assign to self
        // self = Point(x: x + deltaX, y: y + deltaY)
    }
}
var somePoint = Point(x: 4.0, y: 5.0)
if somePoint.isToTheRightOf(x: 1.0) {
    print("This point is to the right of the line where x == 1.0")
}
somePoint.moveBy(x: 2.0, y: 3.0)
print("The point is now at (\(somePoint.x), \(somePoint.y))")


enum TriStateSwitch {  // e.g. of mutating function in enumeration
    case off, low, high
    mutating func next() {
        switch self {
        case .off:
            self = .low
        case .low:
            self = .high
        case .high:
            self = .off
        }
    }
}
var ovenLight = TriStateSwitch.low
ovenLight.next()
// ovenLight is now equal to .high
ovenLight.next()
// ovenLight is now equal to .off


struct LevelTracker {
    static var highestUnlockedLevel = 1  // type property
    var currentLevel = 1
    static func unlock(_ level: Int) {  // type method that unlocks a level
        if level > highestUnlockedLevel {
            highestUnlockedLevel = level
        }
    }
    static func isUnlocked(_ level: Int) -> Bool {  // convenience type method that checks if level unlocked
        return level <= highestUnlockedLevel
    }
    mutating func advance(to level: Int) -> Bool {  // "to" is argument label, "level" is parameter name
        if LevelTracker.isUnlocked(level) {
            currentLevel = level
            return true
        } else {
            return false
        }
    }
}
class Player {
    var tracker = LevelTracker()
    let playerName: String
    func complete(level: Int) {
        LevelTracker.unlock(level + 1)  // not "tracker." because "unlock" is a type method
        tracker.advance(to: level + 1)
    }
    init(name: String) {
        playerName = name
    }
}
var player = Player(name: "Argyrios")
player.complete(level: 1)
print("highest unlocked level is now \(LevelTracker.highestUnlockedLevel)")
player = Player(name: "Beto")
if player.tracker.advance(to: 6) {
    print("player is now on level 6")
} else {
    print("level 6 has not yet been unlocked")
}


struct TimesTable {
    let multiplier: Int
    subscript(index: Int) -> Int {  // e.g. of a subscript
        return multiplier * index
    }
}
let threeTimesTable = TimesTable(multiplier: 3)
print("six times three is \(threeTimesTable[6])")


struct Matrix {
    let rows: Int, columns: Int
    var grid: [Double]
    init(rows: Int, columns: Int) {  // e.g. of init
        self.rows = rows
        self.columns = columns
        grid = Array(repeating: 0.0, count: rows * columns)
    }
    func indexIsValid(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    subscript(row: Int, column: Int) -> Double {
        get {
            assert(indexIsValid(row: row, column: column), "Index out of range")  // outside of matrix bounds, index is not valid
            return grid[(row * columns) + column]
        }
        set {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            grid[(row * columns) + column] = newValue
        }
    }
}
var matrix = Matrix(rows: 2, columns: 2)
matrix[0, 1] = 1.5  // e.g. of instance subscript
let someValue = matrix[2, 2]


class Vehicle {
    var currentSpeed = 0.0  // e.g. of no initializer (default initializer)
    var numberOfWheels = 0
    var description: String {
        return "traveling at \(currentSpeed) miles per hour"
    }
    func makeNoise() {
        // do nothing - customized by subclasses later on    }
    }
}
class Bicycle: Vehicle {  // e.g. of inheritance
    var hasBasket = false
    override init() {  // e.g. of an overriden designated init which first calls the superclass designated init
        super.init()  // not ommitted because modification takes place
        numberOfWheels = 2
    }
}
class Tandem: Bicycle {  // further inhertance for a 2-seated bike
    var currentNumberOfPassengers = 0
}
class Train: Vehicle {
    override func makeNoise() {  // e.g. of overriding a method
        print("Choo Choo")
    }
}
class Car: Vehicle {
    var gear = 1
    override var description: String {
        return super.description + " in gear \(gear)"  // e.g. of overriding a property and using "super"
    }
}
class AutomaticCar: Car {
    override var currentSpeed: Double {  // e.g. overriding property observers
        didSet {
            gear = Int(currentSpeed / 10.0) + 1
        }
    }
}
let tandem = Tandem()
tandem.hasBasket = true
tandem.currentNumberOfPassengers = 2
tandem.currentSpeed = 22.0
print("Tandem: \(tandem.description)")
let train = Train()
train.makeNoise()
let car = Car()
car.currentSpeed = 25.0
car.gear = 3
print("Car: \(car.description)")
let automatic = AutomaticCar()
automatic.currentSpeed = 35.0
print("AutomaticCar: \(automatic.description)")
// AutomaticCar: traveling at 35.0 miles per hour in gear 4


struct Celsius {
    var temperatureInCelsius: Double
    init(fromFahrenheit fahrenheit: Double) {  // e.g. of init (<argument label> <parameter name>)
        temperatureInCelsius = (fahrenheit - 32.0) / 1.8
    }
    init(fromKelvin kelvin: Double) {
        temperatureInCelsius = kelvin - 273.15
    }
}
let boilingPointOfWater = Celsius(fromFahrenheit: 212.0)
let freezingPointOfWater = Celsius(fromKelvin: 273.15)


struct Color {
    let red, green, blue: Double
    init(red: Double, green: Double, blue: Double) {  // e.g. of using no parameter names
        self.red   = red
        self.green = green
        self.blue  = blue
    }
    init(white: Double) {
        red   = white
        green = white
        blue  = white
    }
}
let magenta = Color(red: 1.0, green: 0.0, blue: 1.0)
let halfGray = Color(white: 0.5)


class SurveyQuestion {
    var text: String
    var response: String?
    init(text: String) {
        self.text = text
    }
    func ask() {
        print(text)  // self.text or text
    }
}
let cheeseQuestion = SurveyQuestion(text: "Do you like cheese?")
cheeseQuestion.ask()


class Food {
    var name: String
    init(name: String) {
        self.name = name
    }
    convenience init() {  // e.g. of a convienence init, which delegates across by calling the designated init
        self.init(name: "[Unnamed]")
    }
}
let mysteryMeat = Food()
// mysteryMeat's name is "[Unnamed]"
class RecipeIngredient: Food {
    var quantity: Int
    init(name: String, quantity: Int) {  // "override" not typed due to no changed values
        self.quantity = quantity  // assigning value to new property before delegating up
        super.init(name: name)
    }
    override convenience init(name: String) {  // overriding (since there are additional changes) the convenience init for a special case of instances with just names, avoids code duplication for multiple instances of the same quantity
        self.init(name: name, quantity: 1)
    }
}
class ShoppingListItem: RecipeIngredient {  // RecipeIngridient inits automatically inherited
    var purchased = false
    var description: String {
        var output = "\(quantity) x \(name)"
        output += purchased ? " ✔" : " ✘"
        return output
    }
}
var breakfastList = [
    ShoppingListItem(),
    ShoppingListItem(name: "Bacon"),
    ShoppingListItem(name: "Eggs", quantity: 6),
]
breakfastList[0].name = "Orange juice"
breakfastList[0].purchased = true
for item in breakfastList {
    print(item.description)
}
// 1 x Orange juice ✔
// 1 x Bacon ✘
// 6 x Eggs ✘


class Bank {  // manage some currency for a simple game
    static var coinsInBank = 10_000
    static func distribute(coins numberOfCoinsRequested: Int) -> Int {
        let numberOfCoinsToVend = min(numberOfCoinsRequested, coinsInBank)
        coinsInBank -= numberOfCoinsToVend
        return numberOfCoinsToVend
    }
    static func receive(coins: Int) {
        coinsInBank += coins
    }
}
class Playerr {  // player in the game
    var coinsInPurse: Int
    init(coins: Int) {
        coinsInPurse = Bank.distribute(coins: coins)
    }
    func win(coins: Int) {
        coinsInPurse += Bank.distribute(coins: coins)
    }
    deinit {
        Bank.receive(coins: coinsInPurse)
    }
}
var player1: Playerr? = Playerr(coins: 100)
print("New player! Has \(player1!.coinsInPurse) coins!")
print("There are now \(Bank.coinsInBank) coins left in the bank")
player1!.win(coins: 2_000)
print("PlayerOne won 2000 coins & now has \(player1!.coinsInPurse) coins")
player1 = nil  // deallocation leads to deinitialization
print("PlayerOne has left the game")
print("The bank now has \(Bank.coinsInBank) coins")
// Prints "The bank now has 10000 coins"
