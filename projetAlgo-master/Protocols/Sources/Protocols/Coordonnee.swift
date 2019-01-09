import Foundation


struct Coordonnee : CoordonneeProtocol {
    private var x : Int
    private var y : Int
    
    init(x : Int, y : Int){
        self.x = x
        self.y = y
    }
    
    func positionX()->Int {
        return self.x
    }
    
    func positionY()->Int {
        return self.y
    }
    
	//modif spé
    func retournerCarte(chp : ChampDeBataille)->Carte? {
		if(chp.plateau[self.x][self.y]==Vide) {
			return Vide
		}
		else {
			return chp.plateau[self.x][self.y]
		}
    }
}
