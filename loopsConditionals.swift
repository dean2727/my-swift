if (7 > 4)  //condition syntax
{
    print("true")
}
else
{
    print("nah")
}


var optionalString: String?  // optionals and if else
if optionalString != nil {
    print(optionalString!)
} else {
    print("myString has nil value")
}


let fr = 6
switch fr {  // switch statement
case 1...6:
    print("number is between 1 and 6")
case 7...10:
    print("number is between 7 and 10")
default:
    print("nah")
}


for i in 1...fr {
    print(i, terminator:"")
}
print()


var index = 10
repeat {  // repeat-while loop
    print( "Value of index is \(index)")
    index = index + 1
}
    while index < 20


let yetAnotherPoint = (1, -1)
switch yetAnotherPoint {
case let (x, y) where x == y:  // e.g. of "where" clause
    print("(\(x), \(y)) is on the line x == y")
case let (x, y) where x == -y:
    print("(\(x), \(y)) is on the line x == -y")
case let (x, y):
    print("(\(x), \(y)) is just some arbitrary point")
}
// Prints "(1, -1) is on the line x == -y"


let integerToDescribe = 5
var description = "The number \(integerToDescribe) is"
switch integerToDescribe {
case 2, 3, 5, 7, 11, 13, 17, 19:
    description += " a prime number, and also"
    fallthrough  // e.g. of fallthrough transfer statement
default:
    description += " an integer."
}
print(description)


