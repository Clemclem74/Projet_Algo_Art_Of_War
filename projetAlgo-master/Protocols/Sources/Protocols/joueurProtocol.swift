//Type Joueur contenant une liste représentant son champ de bataille et d'autres élements utile pour une partie
public protocol JoueurProtocol{
    associatedtype Carte: CarteProtocol
    associatedtype ChampDeBataille: ChampDeBatailleProtocol
    associatedtype Joueur: CarteProtocol
    //permet de récuperer le nom du joueur
    var nom : String {get set}
    // init : -> Joueur
    // Création d'un Joueur, initalisé avec une pioche mélangée, une main possédant 1 roi + 3 cartes (qui seront pioché dans la pioche genéré),
    // un royaume de carte vide, un champ de bataille sous forme de tableau "2D" vide et un cimetière de carte vide.
    init(nom: String)
    init()

    // piocher :
    // Récupère la première carte dans la pioche et la met dans la main en la supprimant de la pioche
    // pre : la pioche ne doit pas être vide
    // post : la main a une carte en plus
    mutating func piocher()

    // peutAttaquer :
    // Permet de savoir si le joueur a au moins une de ses unités en position défensive
    // post : retourne vrai si le joueur peut attaquer, retourne faux sinon
    func peutAttaquer()->Bool

    // compterCarteChampDeBataille : -> Int
    // Compte le nombre de carte sur le champ de bataille
    // Retourne le nombre de carte sur le champ de bataille
    func compterCarteChampDeBataille()->Int

    // deployerCarte : Carte
    // pre : La main ne doit pas être vide
    // pre : X et Y sont les coordonnées sur laquelle la carte va être placé, il ne doit pas y avoir de carte sur ces coordonnées et doit pointer sur le champ de bataille (pas en dehors)
    // post : La carte est supprimé de la main
    mutating func deployerCarte(carte : Carte, x: Int, y: Int)

    // recupererChampDeBataille : -> ChampDeBataille
    // un joueur est placé en paramètre, cella permet de récuperer son camp de champ de bataille
    // renvoie le champ de bataille
    func recupererChampDeBataille()->ChampDeBataille

    // avancerCarte : Carte
    // Avance une carte positionnée en arrière sur le front correspondant
    // pre : La carte doit être sur une position d'arrière et ne pas avoir de carte devant elle
    // note: Cette fonction est appelé quand un carte du "front" est amené au cimetière, la carte du "fond" est donc amené l'avant
    mutating func avancerCarte(carte : Carte)

    // attaquer : Carte x Coordonnees
    // Attaque une carte ennemie avec une carte du champ de bataille
    // carteAttaquante : la carte attanquante
    // carteAttaque : la carte attaquée
    // Retourne true si la carte adverse est tuée ou capturée, false sinon
    mutating func attaquer(carteAttaquante : Carte, carteAttaque : Carte)->Bool

    // demobiliser : Carte
    // Place une carte dans le royaume en la supprimant de la main
    // pre : la main ne doit pas être vide
    mutating func demobiliser(carte : Carte)

    // capturer : Carte
    // Place une carte ennemie dans le royaume
    mutating func capturer(Carte : Carte)


    // ciblesDisponible : Joueur ->[Carte]
    // Calcul les cartes que le joueur peut attaquer
    // joueur : joueur adverse
    // Retourne la liste des cartes disponible à l'attaque, carte qui seront rangées dans l'ordre correspondant à la fonction "afficherCibleDisponibles()"
    func ciblesDisponible(joueur : Joueur)->[Carte]

    // UnitePouvantAttaquer : Carte -> [Carte]
    // Calcul les cartes que le joueur peut utiliser pour attaquer une carte adversaire donnée en paramètre et les place dans un tableau
    // carte : la carte ciblée
    // Retourne la liste des cartes que le joueur peut utiliser, sur leur position respective
    func unitePouvantAttaquer(carte : Carte)->[Carte]

}
