// portee(0,0) correspond aux coordonnées de la carte
// Type Coordonnees est un couple de coodonnées RELATIVES à une carte servant à definir la portée d'attaque d'une carte
public protocol PorteeProtocol {
    // init : Int x Int
    // Création d'un couple de coordonnées x et y relative par rapport aux joueurs

    init(x : Int, y : Int)

}
