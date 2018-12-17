import Foundation
// Type Main contient une liste de carte et est parcourru par un itérateur
public protocol MainProtocol : Sequence {
  associatedtype Carte: CarteProtocol
	associatedtype MainIteratorProtocol : IteratorProtocol
	where MainIteratorProtocol.Element == CarteProtocol
 

  // init:
  // doit créer une liste contenant un Roi (à définir parmis les 2 disponible)
  init()

  // recupererCarte: Int -> Carte
  // type : recuperer un type de carte
  // permet de récuperer la n-ième carte d'une main
  // cette fonction retourne une carte
  // post : une carte est retourné
  func recupererCarte(type : uniteCarte)->Carte

  // ajouterCarte : Carte
  // permet d'ajouter une carte dans la main d'un joueur
  // carte : carte à ajouter dans la main
  // pre : on ne peut pas ajouter une carte qui est deja présente dans la main
  // post : ajoute une carte à la liste
  mutating func ajouterCarte(carte : Carte)

  // enleverCarte : Carte
  // permet d'enlever une carte de la main d'un joueur
  // carte : la carte à enlever de la main
  // pre : la carte doit être présente dans la main
  // post : la carte est enlevée de la liste de carte de la main
  // note : la liste de carte ne doit pas être vide pour permettre la suppression d'une carte
  mutating func enleverCarte(carte : Carte)

  // recupererMain -> [Carte]?
  // retourne : une chaine de caractère correspondant au carte
  // pre : la main ne doit pas être vide
  // fonction retournant un string correspondant au nom des cartes (avec numéro pour selection via input) présentes dans la main
  // note : faire en sorte de permettre au joueur de choisir parmis les cartes en rendant l'affichage le plus intuitif et visible possible
  func recupererMain()->[Carte]?

  // nombreOccurence -> Int
  // permet de calculer le nombre de carte présent dans la main d'un joueur
  // post : retourne un nombre correspondant au nombre de carte dans la main
  func nombreOccurence()->Int

  // estVide : -> Bool
  // retourne vrai si la main est vide
  func estVide()->Bool

  // makeIterator : MainProtocol -> MainIteratorProtocol
  // crée un itérateur sur la collection pour itérer avec for in
  func makeIterator()->MainIteratorProtocol
}

public protocol MainIteratorProtocol : IteratorProtocol{
    associatedtype Carte: CarteProtocol
    func next()->Carte?
}
