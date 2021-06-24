class Spaceship {
    var fuelName = 100
    var name = ""
    
    func cruise () {
        print("Cruising is initiated for \(name)")
    }
    
    func thrust () {
        print("Rocket thrusters initiated for \(name)")
    }
}

var myShip = Spaceship()
myShip.name = "Tom"
myShip.cruise()
