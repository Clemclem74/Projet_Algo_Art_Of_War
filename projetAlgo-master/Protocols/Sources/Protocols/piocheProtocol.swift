import Foundation
// Type Pioche contient une liste de carte et un itérateur permettant de la parcourir
public protocol PiocheProtocol : Sequence {

  associatedtype Carte: CarteProtocol
	associatedtype PiocheIteratorProtocol : IteratorProtocol
	where PiocheIteratorProtocol.Element == CarteProtocol

  // melangerPioche :
  // Mélange la pioche du joueur
  // post : les cartes ont un ordre différent dans la liste
  mutating func melangerPioche()

  // supprimerCarte:
  // Supprime la première carte de la pioche
  // post : supprime la derniere carte de la pioche
  // notes : la pioche ne doit pas être vide sinon renvoie une erreur
  mutating func supprimerCarte()

  // nombreOccurence:
  // calcul le nombre de carte dans une pioche
  // post : retourne le nombre de carte présent dans la pioche même si le nombre d'occurence est 0
  func nombreOccurence()->Int

  // init:
  // la pioche doit être initialisée avec les 20 cartes (aucun roi) dont 9 Soldats,6 Gardes, 5 Archers
  init()

  // estVide()
  // retourne vrai si la pioche est vide
  func estVide()->Bool

  // makeIterator : PiocheProtcol -> PiocheIteratorProtocol
  // crée un itérateur sur la collection pour itérer avec for in
  func makeIterator()->PiocheIteratorProtocol

}

public protocol PiocheIteratorProtocol : IteratorProtocol{
    associatedtype Carte: CarteProtocol
    func next()->Carte?
}
