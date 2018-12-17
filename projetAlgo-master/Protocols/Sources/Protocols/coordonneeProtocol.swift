// Coordonnee (0,0) correspond à la position F1
// Type Coordonnees est un couple de coodonnées représentant la position de la carte sur un champ de bataille
public protocol CoordonneeProtocol {
    associatedtype Carte: CarteProtocol
    // init : Int x Int
    // Création d'un couple de coordonnées x et y
    init(x : Int, y : Int)

    //positionX : ->Int
    //retourne la position X d'une coordonnée
    func positionX()->Int
    //retourne la position Y d'une coordonnée
    func positionY()->Int

    //retournerCarte : ->Carte ?
    //retourne la carte associée à la coordonnée, retourne vide si il y en a pas
    func retournerCarte()->Carte?

    //lierCarte : Coordonnee x Carte
    //lie une carte à une coordonnée
    func lierCarte(carte : Carte)

}
