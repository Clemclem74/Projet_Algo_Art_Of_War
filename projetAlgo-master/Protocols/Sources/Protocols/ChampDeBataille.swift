import Foundation
class ChampDeBataille: ChampDeBatailleProtocol {
    var plateau: [[Carte?]] = [[Vide,Vide,Vide],[Vide,Vide,Vide]]
    
    init() {
        
    }
    
    func positionLibre(cord : Coordonnees)->Bool{
        return plateau[cord.positionY()][cord.positionX()]==Vide
    }
    
    func insererCarte(carte : Carte, cord : Coordonnes) {
        if !positionLibre(cord){
            fatalError("Insertion sur une carte non vide")
        }
        self.plateau[cord.positionY()][cord.positionX()] = carte
    }
    
    func supprimerCarte(cord : Coordonnees) {
        if positionLibre(cord){
            fatalError("Suppression d'une case vide")
        }
        self.plateau[cord.positionY()][cord.positionX()] = Vide
    }
    
    func avancerCarte(cord : Coordonnees) {
        if cord.positionY() == 0 {
            fatalError("On essaie d'avancer une carte en position avant")
        }
        cordFinale = Coordonnees(x : cord.positionX(), y : cord.positionY()-1)
        if !positionLibre(cordFinale){
            fatalError("On essaie d'avancer une carte sur une position non libre")
        }
        var tmp : Carte = self.plateau[cord.positionY()][cord.positionX()]
        self.plateau[cord.positionY()][cord.positionX()] = Vide
        self.plateau[cord.positionY()-1][cord.positionX()] = tmp
    }
    
    func recupererPosition(carte : Carte)->Coordonnees {
        for i in 0 ... 1 {
            for j in 0 ... 2 {
                if self.plateau[i][j]==carte {
                    return Coordonnees(x : j, y : i)
                }
            }
        }
        fatalError("La carte n'est pas sur le champs de bataille")
    }
    
    func champDeBatailleEstVide()->Bool {
        for i in 0 ... 1 {
            for j in 0 ... 2 {
                if self.plateau[i][j] != Vide {
                    return False
                }
            }
        }
        return True
    }
    
    
}


