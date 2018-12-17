import Foundation
// Type Cimetiere contient une liste de carte, pouvant etre parcouru par un itérateur
public protocol CimetiereProtocol : Sequence {
  associatedtype Carte: CarteProtocol
  associatedtype CimetiereIteratorProtocol : IteratorProtocol
  where CimetiereIteratorProtocol.Element == CarteProtocol


  // ajouterCarte : Carte
  // carte : la carte à ajouter sur dans le cimetière
  // pre : la carte ajoutée ne doit pas déja être présente dans le cimetière
  // ajouter un carte au cimetière
  mutating func ajouterCarte(carte : Carte)

  // nombreOccurence:
  // calcule le nombre de carte dans le cimetière
  // retourne le nombre de carte présent dans le cimetière
  func nombreOccurence()->Int

  // estVide:
  // retourne vrai si le cimetiere est vide
  func estVide()->Bool

  // makeIterator : Cimetier -> CimetiereIteratorProtocol
  // crée un itérateur sur la collection pour itérer les cartes
  func makeIterator()->CimetiereIteratorProtocol


}

public protocol CimetiereIteratorProtocol : IteratorProtocol{
        associatedtype Carte: CarteProtocol
	func next()->Carte?
}
