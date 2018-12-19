import Foundation
// Type Pioche contient une liste de carte et un itérateur permettant de la parcourir
struct Pioche : PiocheProtocol {
    var pioche : PilePioche
    // id 1 : Roi 1
    // id 2 : Roi 2
    // id 3 : Soldat 1
    // id 4 : Soldat 2
    // id 5 : Soldat 3
    // id 6 : Soldat 4
    // id 7 : Soldat 5
    // id 8 : Soldat 6
    // id 9 : Soldat 7
    // id 10 : Soldat 8
    // id 11 : Soldat 9
    // id 12 : Garde 1
    // id 13 : Garde 2
    // id 14 : Garde 3
    // id 15 : Garde 4
    // id 16 : Garde 5
    // id 17 : Garde 6
    // id 18 : Archer 1
    // id 19 : Archer 2
    // id 20 : Archer 3
    // id 21 : Archer 4
    // id 22 : Archer 5
    
    init() {
        var ensemble_cord : [Coordonnees]=[]
        var coord = Coordonnees(x : 0 , y : 1)
        ensemble_cord.append(coord)
        var carte : Carte
        for i in 3 ... 11 {
            carte = Carte(id : i , attaque : 0 , defDefensive : 2 , defOffensive : 1 , etat : Defensif , unite : Soldat , portee : ensemble_cord)
            self.pioche.empiler(carte : carte)
        }
        
        for i in 12 ... 17 {
            carte = Carte(id : i , attaque : 1 , defDefensive : 3 , defOffensive : 2 , etat : Defensif , unite : Garde , portee : ensemble_cord)
            self.pioche.empiler(carte : carte)
        }
        
        coord = Coordonnees(x : -2 , y : 1)
        ensemble_cord[0] = coord
        coord = Coordonnees(x : -1 , y : 2)
        ensemble_cord.append(coord)
        coord = Coordonnees(x : 1 , y : 2)
        ensemble_cord.append(coord)
        coord = Coordonnees(x : 2 , y : 1)
        ensemble_cord.append(coord)
       
        for i in 18 ... 22 {
            carte = Carte(id : i , attaque : 1 , defDefensive : 2 , defOffensive : 1 , etat : Defensif , unite : Archer , portee : ensemble_cord)
            self.pioche.empiler(carte : carte)
        }
    }
    
    mutating func supprimerCarte(){
        if !estVide() {
            self.pioche.depiler()
        }
        else {
            fatalError("Supprimer carte d'une pioche vide")
        }
    }
    
    func nombreOccurence()->Int {
        return self.pioche.nombre
    }
    
    func estVide()->Bool {
        return nombreOccurence()==0
    }
    
    
    
 }


class PilePioche {
    
    var pile : [Carte] = []
    var nombre : Int
    
    mutating func empiler(carte : Carte){
        nombre=nombre+1
    }
    
    mutating func depiler() {
        
    }
    
    func sommet()->Carte{
        
    }
}






