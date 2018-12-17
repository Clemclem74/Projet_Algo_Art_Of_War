import Foundation
// Type Royaume contient une liste de Carte , un itérateur permet de parcourir cette liste
public protocol RoyaumeProtocol : Sequence {
  associatedtype Carte: CarteProtocol
  associatedtype RoyaumeIteratorProtocol : IteratorProtocol
  where RoyaumeIteratorProtocol.Element == CarteProtocol

  // le Royaume est initialisé avec une liste de carte vide représentant son peuple
  init()

  // ajouterCarte : Carte
  // ajoute un carte au royaume à la fin de la liste
  // pre : la carte ne doit pas déja être présente dans le royaume
  mutating func ajouterCarte(carte : Carte)

  // nombreOccurence ->Int
  // compte le nombre de carte présent dans un royaume et renvoie la donnée
  func nombreOccurence()->Int 

  // enleverCarte: -> Carte
  // precondition: le royaume ne doit pas être vide
  // permet d'enlever la première carte d'un royaume si celui-ci n'est pas vide, dans le cas contraire affiche un message,
  // retourne la carte supprimée qui va être posée sur le champ de bataille
  mutating func enleverCarte()->Carte

  // estVide: ->Bool
  // retourne vrai si le royaume est vide
  // notes: va être utilisé pour la verification de victoire
  func estVide()->Bool

  // makeIterator : RoyaumeProtocol -> RoyaumeIteratorProtocol
  // crée un itérateur sur la collection pour itérer avec for in
  func makeIterator()->RoyaumeIteratorProtocol
}

public protocol RoyaumeIteratorProtocol : IteratorProtocol{
    associatedtype Carte: CarteProtocol
    func next()->Carte?
}
