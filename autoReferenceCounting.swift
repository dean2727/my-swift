class Ah {
    let name: String
    init(name: String) {
        self.name = name
        print("\(name) is being initialized")
    }
    deinit {
        print("\(name) is being deinitialized")
    }
}

var reference1: Ah?
var reference2: Ah?
var reference3: Ah?

reference1 = Ah(name: "John Appleseed")
// Prints "John Appleseed is being initialized"
reference2 = reference1
reference3 = reference1  // there are now 3 strong references

reference1 = nil
reference2 = nil
reference3 = nil  // after the 3rd strong reference is set to nil, the Person instance is deallocated and freed from memory
// Prints "John Appleseed is being deinitialized"


class Person {
    let name: String
    init(name: String) { self.name = name }
    var apartment: Apartment?
    deinit { print("\(name) is being deinitialized") }
}

class Apartment {
    let unit: String
    init(unit: String) { self.unit = unit }
    weak var tenant: Person?
    deinit { print("Apartment \(unit) is being deinitialized") }
}
var john: Person?
var unit4A: Apartment?
john = Person(name: "John Appleseed")
unit4A = Apartment(unit: "4A")
john!.apartment = unit4A
unit4A!.tenant = john  // now the 2 are locked in a strong reference cycle

john = nil  // since its a weak var optional and deallocated first, the strong reference cycle is broken, tenant is nil
// Prints "John Appleseed is being deinitialized" (wouldnt print this if not a weak reference)
unit4A = nil
// Prints "Apartment 4A is being deinitialized"


class Customer {
    let name: String
    var card: CreditCard?
    init(name: String) {
        self.name = name
    }
    deinit { print("\(name) is being deinitialized") }
}

class CreditCard {
    let number: UInt64  // instead of Int so that the long number can be stored on 32 and 64-bit systems
    unowned let customer: Customer  // e.g. of an unknown reference, credit card will always have a customer
    init(number: UInt64, customer: Customer) {
        self.number = number
        self.customer = customer
    }
    deinit { print("Card #\(number) is being deinitialized") }
}
var bob: Customer?
bob = Customer(name: "Bob Atkins")
bob!.card = CreditCard(number: 1234_5678_9012_3456, customer: bob!)
bob = nil  // no more strong references to Customer instance, causing no more strong references to CreditCard instance
// Prints "John Appleseed is being deinitialized"
// Prints "Card #1234567890123456 is being deinitialized"


class Country {  // e.g. of the 3rd method, where both properties must be a value after initialization
    let name: String
    var capitalCity: City!  // declared as an implicitly unwrapped optional, default nil, thus only name and capital name are needed in this class for initalization to happen
    init(name: String, capitalName: String) {
        self.name = name
        self.capitalCity = City(name: capitalName, country: self)
    }
}
class City {
    let name: String
    unowned let country: Country  // delcared as an unknown
    init(name: String, country: Country) {
        self.name = name
        self.country = country
    }
}
var country = Country(name: "Canada", capitalName: "Ottawa")
print("\(country.name)'s capital city is called \(country.capitalCity.name)")
// Prints "Canada's capital city is called Ottawa"


class HTMLElement {  // a simple model for an element in an HTML doc
    let name: String  // such as "p" for a paragrapgh element or "h1" for a header element
    let text: String?
    lazy var asHTML: () -> String = {  /* for the closure, of type () -> String, or a function that takes no parameters and returns String,
                                        inwhich returns a String representation of an HTML tag */
        [unowned self] in  // "capture self as an unowned reference rather than a strong reference"
        if let text = self.text {  // can use self because its a lazy var, so used after initialization
            return "<\(self.name)>\(text)</\(self.name)>"
        } else {
            return "<\(self.name) />"
        }
    }
    init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
    }
    deinit {
        print("\(name) is being deinitialized")
    }
    
}

// the stuff below is if the closure capture list did not exist in the class body to represent the problem that occurs
let heading = HTMLElement(name: "h1")
let defaultText = "some default text"
heading.asHTML = {  // heres how you would use this method in global scope
    return "<\(heading.name)>\(heading.text ?? defaultText)</\(heading.name)>"
}

var paragraph: HTMLElement? = HTMLElement(name: "p", text: "hello, world")
print(paragraph!.asHTML())  // heres where the strong reference cycle happens
// Prints "<p>hello, world</p>"
paragraph = nil  // no deallocation occurs

// the stuff below corresponds to the current code, solving the problem
var header: HTMLElement? = HTMLElement(name: "h1", text: "hello, world")
print(header!.asHTML())
// Prints "<h1>hello, world</h1>"
header = nil
// Prints "h1 is being deinitialized"
