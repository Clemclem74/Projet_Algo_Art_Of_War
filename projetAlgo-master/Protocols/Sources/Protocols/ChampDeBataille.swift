class ChampIterator : IteratorProtocol {
    var plateau: [[Carte?]]
    var i : Int = 0
    var j : Int = 0

    init(plateau: ChampDeBataille) {
        self.plateau = plateau
    }

    func next() -> Carte? {
    	let tab = self.plateau
        if self.i < 0 || self.i >= 2 || self.j>=3{
        	return nil 
        }
        else {
        	if self.j == 2{
                self.j = 0
                self.i = self.i + 1
            }
            else{
                self.j = self.j + 1
            }
        	return tab[i][j]
        }
    }
}


import Foundation
class ChampDeBataille: ChampDeBatailleProtocol {
    var plateau: [[Carte?]] = [[nil,nil,nil],[nil,nil,nil]]
    
    init() {
        
    }
    
    func makeIterator() -> ChampIterator{
        return ChampIterator(plateau:self)
    }
    
    func positionLibre(cord : Coordonnee)->Bool{
        return plateau[cord.positionY()][cord.positionX()]==nil
    }
    
    func insererCarte(carte : Carte, cord : Coordonnee) {
        if !positionLibre(cord : cord){
            fatalError("Insertion sur une carte non vide")
        }
        self.plateau[cord.positionY()][cord.positionX()] = carte
    }
    
    func supprimerCarte(cord : Coordonnee) {
        if positionLibre(cord : cord){
            fatalError("Suppression d'une case vide")
        }
        self.plateau[cord.positionY()][cord.positionX()] = nil
    }
    
    func avancerCarte(cord : Coordonnee) {
        if cord.positionY() == 0 {
            fatalError("On essaie d'avancer une carte en position avant")
        }
        var cordFinale = Coordonnee(x : cord.positionX(), y : cord.positionY()-1)
        if !positionLibre(cord : cordFinale){
            fatalError("On essaie d'avancer une carte sur une position non libre")
        }
        var tmp : Carte? = self.plateau[cord.positionY()][cord.positionX()]
        self.plateau[cord.positionY()][cord.positionX()] = nil
        self.plateau[cord.positionY()-1][cord.positionX()] = tmp
    }
    
    func recupererPosition(carte : Carte?)->Coordonnee {
        for i in 0 ... 1 {
            for j in 0 ... 2 {
                if self.plateau[i][j]==carte {
                    return Coordonnee(x : j, y : i)
                }
            }
        }
        fatalError("La carte n'est pas sur le champs de bataille")
    }
    
    func champDeBatailleEstVide()->Bool {
        for i in 0 ... 1 {
            for j in 0 ... 2 {
                if self.plateau[i][j] != nil {
                    return false
                }
            }
        }
        return true
    }
    
    
}


