func swapTwoValues<T>(_ a: inout T, _ b: inout T) {  // using the placeholder T
    let temporaryA = a
    a = b
    b = temporaryA
}
var someString = "hello"
var anotherString = "world"
swapTwoValues(&someString, &anotherString)


struct IntStack {  // e.g. of a stack that is nongeneric
    var items = [Int]()
    mutating func push(_ item: Int) {
        items.append(item)
    }
    mutating func pop() -> Int {
        return items.removeLast()
    }
}

struct Stack<Element> {  // generic version  <------------------------- used a lot below
    var items = [Element]()
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
}
var stackOfStrings = Stack<String>()
stackOfStrings.push("uno")
stackOfStrings.push("dos")
stackOfStrings.push("tres")
stackOfStrings.push("cuatro")
let fromTheTop = stackOfStrings.pop()
// fromTheTop is equal to "cuatro", and the stack now contains 3 strings

extension Stack {  // generic extension to get the last element without removing it
    var topItem: Element? {
        return items.isEmpty ? nil : items[items.count - 1]  // optional returns nil if empty, last element if not
    }
}
if let topItem = stackOfStrings.topItem {
    print("The top item on the stack is \(topItem).")
}
// Prints "The top item on the stack is tres."


func findIndex(ofString valueToFind: String, in array: [String]) -> Int? {  // nongeneric for returning index of string if its in a list
    for (index, value) in array.enumerated() {  // another array function enumerated()
        if value == valueToFind {
            return index
        }
    }
    return nil
}
let strings = ["cat", "dog", "llama", "parakeet", "terrapin"]
if let foundIndex = findIndex(ofString: "llama", in: strings) {
    print("The index of llama is \(foundIndex)")
}
func findIndex<T: Equatable>(of valueToFind: T, in array:[T]) -> Int? {  // generic version, e.g. of a type constraint that will conform to                                                                            the built in Equatable protocol so any type can use == and !=
    for (index, value) in array.enumerated() {
        if value == valueToFind {
            return index
        }
    }
    return nil
}
let doubleIndex = findIndex(of: 9.3, in: [3.14159, 0.1, 0.25])
// doubleIndex is an optional Int with no value, because 9.3 isn't in the array
let stringIndex = findIndex(of: "Andrea", in: ["Mike", "Malcolm", "Andrea"])
// stringIndex is an optional Int containing a value of 2


protocol Container {  // <---------------------- used a lot below
    associatedtype Item  // e.g. of an associated type, so the conforming thing can have container of Ints/Strings/etc.
    mutating func append(_ item: Item)  // must be possible to add new item
    var count: Int { get }  // must be able to get the number of items in the container
    subscript(i: Int) -> Item { get }  // must be able to retrieve each item in the container with an Int index value
}

extension IntStack: Container {  // extending the IntStack type to conform to this protocol
    mutating func append(_ item: Int) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Int {
        return items[i]
    }
}


protocol SuffixableContainer: Container {  // a protocol that adds on to the Container protocol
    associatedtype Suffix: SuffixableContainer where Suffix.Item == Item  // e.g. of using the protocol in the constraints, it must conform to                                                                      it where its Item type is the same as Containers Item type
    func suffix(_ size: Int) -> Suffix  // returns a given number of elements at the end, storing them in an instance of type Suffix
}
extension Stack: Container {  // extending Stack type to conform to Container so we could extend to conform to the protocol that inherits Container
    mutating func append(_ item: Element) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Element {
        return items[i]
    }
}
extension Stack: SuffixableContainer {  // and here it is
    func suffix(_ size: Int) -> Stack {  // associated type is also Stack
        var result = Stack()
        for index in (count-size)..<count {
            result.append(self[index])
        }
        return result  // returns another Stack
    }
    // Inferred that Suffix is Stack.
}
var stackOfInts = Stack<Int>()
stackOfInts.append(10)
stackOfInts.append(20)
stackOfInts.append(30)
let suffix = stackOfInts.suffix(2)
// suffix contains 20 and 30


func allItemsMatch<C1: Container, C2: Container>
    (_ someContainer: C1, _ anotherContainer: C2) -> Bool
    where C1.Item == C2.Item, C1.Item: Equatable {  // e.g. of a generic where clause, associated types must match and that type must conform                                                 to Equatable so != can be used
        // Check that both containers contain the same number of items.
        if someContainer.count != anotherContainer.count {
            return false
        }
        // Check each pair of items to see if they're equivalent.
        for i in 0..<someContainer.count {
            if someContainer[i] != anotherContainer[i] {
                return false
            }
        }
        // All items match, so return true.
        return true
}
stackOfStrings = Stack<String>()
stackOfStrings.push("uno")
stackOfStrings.push("dos")
stackOfStrings.push("tres")
var arrayOfStrings = ["uno", "dos", "tres"]
if allItemsMatch(stackOfStrings, arrayOfStrings) {  // idk why this is an error lol
    print("All items match.")
} else {
    print("Not all items match.")
}


extension Stack where Element: Equatable {  // e.g. of generic where clause in an extension
    func isTop(_ item: Element) -> Bool {
        guard let topItem = items.last else {  // see if stack is empty
            return false
        }
        return topItem == item  // True if the item on top of the stack, false if not
    }
}
if stackOfStrings.isTop("tres") {
    print("Top element is tres.")
} else {
    print("Top element is something else.")
}
// Prints "Top element is tres."

extension Container where Item: Equatable {  // another e.g.
    func startsWith(_ item: Item) -> Bool {
        return count >= 1 && self[0] == item  // both conditions must be true to return true
    }
}


extension Container where Item == Double {  // e.g. of generic where clause that doesnt mention conformance to a protocol
    func average() -> Double {
        var sum = 0.0
        for index in 0..<count {
            sum += self[index]
        }
        return sum / Double(count)
    }
}
print([1260.0, 1200.0, 98.6, 37.0].average())  // again idk why
// Prints "648.9"


extension Container {  // extending the Container protocol
    associatedtype Iterator: IteratorProtocol where Iterator.Element == Item  // e.g. of using a where clause for associated type,                                                                                      requiring it to be able to transverse over elements                                                                                    of the same item type as the container's items
    func makeIterator() -> Iterator  // provides access to a container's iterator
}


extension Container {
    subscript<Indices: Sequence>(indices: Indices) -> [Item] where Indices.Iterator.Element == Int { // e.g. of a generic in a subscript, type                                                                          parameter must conform to Sequence (built-in protocol),                                                                                subscript parameter is an instance of Indices, where clause                                                                            requires that the passed in Indices are same type as                                                                                   container indices
            var result = [Item]()
            for index in indices {
                result.append(self[index])
            }
            return result
    }
}
