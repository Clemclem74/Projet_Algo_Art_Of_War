import Foundation
// Type ChampDeBataille est une collection de positions contenant des cartes
//(0,0) correspond à F1
public protocol ChampDeBatailleProtocol : Sequence {
  associatedtype Carte: CarteProtocol
	associatedtype ChampIteratorProtocol : IteratorProtocol
	where ChampIteratorProtocol.Element == CarteProtocol


  // init:
  // initialisé à vide
  init()

  //insererCarte : ChampDeBataille x Carte x Int x Int
  //pre: la case de doit pas être deja occupé
  //post: une carte est ajouté sur le terrain
  mutating func insererCarte(carte: Carte, X: Int,Y: Int)

  //supprimerCarte : ChampDeBataille Int x Int
  //pre: la case de doit pas être vide
  //post: une carte est supprimé du champ de bataille
  mutating func supprimerCarte(X: Int,Y: Int)

  //avancerCarte : ChampDeBataille Int x Int
  //les coordonnées en paramètre correspondent aux coordonnée actuel de la carte
  //pre: la carte doit être en position arrière, et la position devant elle doit être libre(vide)
  //post: une carte est avancé au front
  mutating func avancerCarte(X: Int,Y: Int)

  //positionLibre: Int x Int -> Bool
  //les paramètres sont des int correspondant à des coordonnées
  //retourne vrai si les coordonnées ne sont pas prise par une carte, faux sinon
  func positionLibre(x: Int,y: Int)->Bool

  //recupererPositionX : Carte -> Int
  //pre: la carte doit exister dans le champ de bataille
  //post: retour de la position X de la carte
  func recupererPositionX(carte : Carte)->Int

  //recupererPositionX : Carte -> Int
  //pre: la carte doit exister dans le champ de bataille
  //post: retour de la position Y de la carte
  func recupererPositionY(carte : Carte)->Int

  // champDeBatailleVide : -> Bool
  // Regarde si il y des cartes sur le champ de bataille
  // Retourne true si la champ de bataille est rempli de nil
  func champDeBatailleEstVide()->Bool


  // makeIterator : ChampBatailleProtocol -> MainIteratorProtocol
  // crée un itérateur sur la collection pour itérer avec for in
  func makeIterator()->ChampIteratorProtocol
}

public protocol ChampIteratorProtocol : IteratorProtocol{

}
