//Definition de la structure Portee, qui correspond a la portee d'une carte. (0,0) correspond a la carte elle meme.
import Foundation



class RoyaumeIterator : IteratorProtocol {
    var royaume : Royaume
    var i : Int = 0

    init(royaume : Royaume) {
        self.royaume = royaume
    }

    func next() -> Carte? {
    	let liste = self.royaume
        if self.i < 0 || self.i >= self.royaume.nombreOccurence(){
        	return nil 
        }
        else {
        	self.i = self.i+1
			guard let ret : Carte =  liste[self.i-1] else {fatalError("Erreur")}
        	return ret
        }
    }
}





class Royaume : Sequence{
	var royaume : [Carte]
   
   
	init() {
		royaume = []
	}
   
	func ajouterCarte(carte:Carte){
		self.royaume.append(carte)
	}
	
	func nombreOccurence()->Int {
		var i : Int = 0
		for carte in self.royaume {
			i=i+1
		}
		return i
	}
	
	func enleverCarte(carte : Carte) {
		var i : Int = 0
		var trouve : Bool = true
		if self.estVide() {
			fatalError("Royaume Vide")
		}
		for carte_royaume in self.royaume {
			if carte_royaume.recupererIdCarte() == carte.recupererIdCarte() {
				self.royaume.remove(at : i)
			}
			i = i + 1
		}
	}
	
	func estVide()->Bool {
		if self.royaume == nil {
			return true
		}
		else {
			return false
		}
	}
	
	func makeIterator() -> RoyaumeIterator {
		return RoyaumeIterator(royaume:self)
	}
	
}
