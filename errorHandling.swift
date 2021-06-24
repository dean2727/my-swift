enum VendingMachineError: Error {  // error conditions of a vending machine in a game
    case invalidSelection
    case insufficientFunds(coinsNeeded: Int)
    case outOfStock
}

struct Item {
    var price: Int
    var count: Int
}

class VendingMachine {
    var inventory = [
        "Candy Bar": Item(price: 12, count: 7),
        "Chips": Item(price: 10, count: 4),
        "Pretzels": Item(price: 7, count: 11)
    ]
    var coinsDeposited = 0
    
    func vend(itemNamed name: String) throws {  // function that can throw errors, so must pass all 3 tests to continue
        guard let item = inventory[name] else {  // if the item is in the machine
            throw VendingMachineError.invalidSelection
        }
        
        guard item.count > 0 else {  // if there are still some left
            throw VendingMachineError.outOfStock
        }
        
        guard item.price <= coinsDeposited else {  // if the price is met with the money deposited
            throw VendingMachineError.insufficientFunds(coinsNeeded: item.price - coinsDeposited)
        }
        
        coinsDeposited -= item.price
        
        var newItem = item
        newItem.count -= 1
        inventory[name] = newItem
        
        print("Dispensing \(name)")
    }
}

let favoriteSnacks = [
    "Alice": "Chips",
    "Bob": "Licorice",
    "Eve": "Pretzels",
]
// this function looks up a persons favorite snack and tries to buy it for them
func buyFavoriteSnack(person: String, vendingMachine: VendingMachine) throws {
    let snackName = favoriteSnacks[person] ?? "Candy Bar"
    try vendingMachine.vend(itemNamed: snackName)  // uses try because method can throw an error
}


var vendingMachine = VendingMachine()
vendingMachine.coinsDeposited = 8
do {  // e.g. of do-catch
    try buyFavoriteSnack(person: "Alice", vendingMachine: vendingMachine)  // function called because it can throw an error, if error thrown, go to catch clauses
    print("Success! Yum.")
} catch VendingMachineError.invalidSelection {
    print("Invalid Selection.")
} catch VendingMachineError.outOfStock {
    print("Out of Stock.")
} catch VendingMachineError.insufficientFunds(let coinsNeeded) {
    print("Insufficient funds. Please insert an additional \(coinsNeeded) coins.")
} catch {
    print("Unexpected error: \(error).")
}
// Prints "Insufficient funds. Please insert an additional 2 coins."

func nourish(with item: String) throws {  // code from above written to catch non vending machine errors
    do {
        try vendingMachine.vend(itemNamed: item)
    } catch is VendingMachineError {
        print("Invalid selection, out of stock, or not enough money.")
    }
}

do {
    try nourish(with: "Beet-Flavored Chips")
} catch {
    print("Unexpected non-vending-machine-related error: \(error)")
}
// Prints "Invalid selection, out of stock, or not enough money."


func someThrowingFunction() throws -> Int {  // e.g. of handling errors with optionals (try?)
    return 8
}
let x = try? someThrowingFunction()  // x and y have the type of optional integer

let y: Int?
do {
    y = try someThrowingFunction()
} catch {
    y = nil
}
/*  more practical use of this error handling method
 func fetchData() -> Data? {
    if let data = try? fetchDataFromDisk() { return data }
    if let data = try? fetchDataFromServer() { return data }
    return nil
}
*/

/*
func processFile(filename: String) throws {
    if exists(filename) {
        let file = open(filename)
        defer {
            close(file)
        }
        while let line = try file.readline() {
            // Work with the file.
        }
        // close(file) is called here, at the end of the scope.
    }
}
*/
