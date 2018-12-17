// enumeration permettant de connaitre le statut d'une carte
public enum etatCarte{
    case Offensif,Defensif
}
// enumeration permettant de connaitre le rôle d'un carte existante
public enum uniteCarte{
    case Garde,Soldat,Archer,Roi
}

//TYPE carte contient toutes les informations d'une carte pour une utilisation en jeu. Identifiant,point d'attaque, points de défense
public protocol CarteProtocol{
    associatedtype Coordonnees : PorteeProtocol
    init()

    // init : Int x Int x Int x etatCarte x uniteCarte x [Coordonnees] -> Carte
    // Création d'une carte avec une valeur d'attaque, de défense défensive, de défense offensive, la liste des coordonnées relatives représentant la portée (case qu'il peut attaquer), son unité, il y a également une variable représentant la vie restante d'une unite permettant de voir la vie restant d'une carte après une attaque, qui sera reinitialisé en fin de tour de jeu
    // pre : l'id ne doit pas être négatif, l'id doit être unique pour chaque carte,la valeur d'attaque ne doit pas être négative, la valeur de défense Defensive ne doit pas être negative, la valeur de      défense Offensive ne doit pas être négative
    init(id : Int, attaque : Int, defDefensive : Int, defOffensive : Int, etat : etatCarte, unite : uniteCarte, portee : [Coordonnees])

    // changerEtat : etatCarte
    // etat : l'état de la carte
    // Permet le changement d'état d'une carte (de defensif à offensif et inversement)
    mutating func changerEtat(etat : etatCarte)


    //recupererUnite : -> UniteCarte
    //retourne l'unité de la carte
    func recupererUnite()->uniteCarte


    // recupererIdCarte : Id
    // retourne l'id de la carte
    func recupererIdCarte()->Int
}
