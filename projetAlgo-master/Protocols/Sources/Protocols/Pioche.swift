import Foundation


class PiocheIterator : IteratorProtocol {
    var pioche: Pioche
    var i : Int = 0

    init(pioche: Pioche) {
        self.pioche = pioche
    }

    func next() -> Pioche? {
    	let pile = self.pioche
        if self.i < 0 || self.i >= self.pioche.nombreOccurence(){
        	return nil 
        }
        else {
        	self.i = self.i+1
            for j in 0 ..< i{
        	    Depiler(pioche : pile)
            }
            return pile[self.i-1]
        }
    }
}

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
        var ensemble_cord : [Coordonnee]=[]
        var coord = Coordonnee(x : 0 , y : 1)
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
        
        coord = Coordonnee(x : -2 , y : 1)
        ensemble_cord[0] = coord
        coord = Coordonnee(x : -1 , y : 2)
        ensemble_cord.append(coord)
        coord = Coordonnee(x : 1 , y : 2)
        ensemble_cord.append(coord)
        coord = Coordonnee(x : 2 , y : 1)
        ensemble_cord.append(coord)
       
        for i in 18 ... 22 {
            carte = Carte(id : i , attaque : 1 , defDefensive : 2 , defOffensive : 1 , etat : Defensif , unite : Archer , portee : ensemble_cord)
            self.pioche.empiler(carte : carte)
        }
    }
	
    
    func supprimerCarte(){
        if !estVide() {
            Depiler(pile : pile)
        }
        else {
            fatalError("Supprimer carte d'une pioche vide")
        }
    }
    
    func nombreOccurence()->Int {
        return self.pioche.nb
    }
    
    func estVide()->Bool {
        return Pioche_Vide(pioche : self.pioche)
    }
	
    func makeIterator() -> Self{
        return PiocheIterator(pioche:Self)
    }

    
    func melangerPioche(){
        var tmp : [Piece] = []
        while !self.estVide() {
            tmp.append(Sommet(pioche : self.pioche))
            Depiler(pioche : self.pioche)
        }
        tmp.shuffle()
        for i in 0 ... tmp.count-1 {
            Empiler(pioche : self.pioche , carte : tmp[i])
        }
	}
 }


fileprivate class PilePiocheNV {
    var val : Carte 
    var suiv : PilePioche 
    var nb : Int
    
    init(carte : Carte, suiv : PilePioche = nil){
        self.val = val
        self.suiv = suiv
        self.nb = 1
    }
}


typealias PilePioche = PilePiocheNV?

func Creer_Pioche() -> PilePioche {
    return nil
}

func Pioche_Vide(pioche : PilePioche) -> Bool {
    return pioche == nil
}

func Sommet(pioche : PilePioche)->Carte{
    guard let p = PilePioche else {return nil}
    return pioche.val
}


func Empiler(pioche : PilePioche , carte : Carte){
    pioche.nb = pioche.nb + 1
    pioche = PilePiocheNV(carte : carte, suiv : pioche) 
}

func Depiler(pioche : PilePioche) {
    guard let p = pioche else {
        fatalError("Erreur depile une pile vide")
    }
    pioche.nb = pioche.nb - 1
    return p.suiv
}

    







