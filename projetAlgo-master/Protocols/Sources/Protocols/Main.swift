import Foundation


class MainIterator : IteratorProtocol {
    var main: Main
    var i : Int = 0

    init(main: Main) {
        self.main = main
    }

    func next() -> Carte? {
    	let liste = self.main.recupererMain()
        if self.i < 0 || self.i >= self.main.nombreOccurence(){
        	return nil 
        }
        else {
        	self.i = self.i+1
        	return liste[self.i-1]
        }
    }
}



class Main : Sequence {
    var main : [Carte]?
   
   
   init(numeroRoi : Int){
		var ensemble_cord : [Coordonnee]=[]
        var coord = Coordonnee(x : -2 , y : 1)
        ensemble_cord.append(coord)
		coord = Coordonnee(x : -1 , y : 1)
        ensemble_cord.append(coord)
		coord = Coordonnee(x : 0 , y : 1)
        ensemble_cord.append(coord)
		coord = Coordonnee(x : 1 , y : 1)
        ensemble_cord.append(coord)
		coord = Coordonnee(x : 2 , y : 1)
        ensemble_cord.append(coord)
		if numeroRoi == 1 {
			coord = Coordonnee(x : 0 , y : 2)
			ensemble_cord.append(coord)
		}
		else {
			Roi = Carte(id : 2, attaque : 1, defDefensive : 5, defOffensive : 4, etat : Defensif, unite : Roi, portee : ensemble_cord)
			self.main = [Roi]
		}
   }
   
   
   func makeIterator() -> MainIterator {
		return MainIterator(main:self)
	}

	func recupererCarte(type : uniteCarte)->Carte {
		for carte in self.main {
			if carte.recupererUnite() == type {
				return carte
			}
		}
	}
	
	func ajouterCarte(carte : Carte) {
		for carte_main in self.main {
			if carte_main.recupererIdCarte() == carte.recupererIdCarte() {
				fatalError("Carte déjà dans la main")
			}
		}
		
		self.main.append(carte)
	}
	
	func enleverCarte(carte : Carte) {
		var i : Int = 0
		var trouve : Bool = True
		if self.estVide() {
			fatalError("Main Vide")
		}
		for carte_main in self.main {
			if carte_main.recupererIdCarte() == carte.recupererIdCarte() {
				self.main.remove(at : i)
			}
			i = i + 1
		}
	}
	
	func recupererMain()->[Carte]?{
		return self.main
	}
	
	func nombreOccurence()->Int {
		var nb : Int = 0
		for i in self.main {
			nb=nb+1
		}
		return nb
	}
	
	func estVide()->Bool {
		if self.main==Vide {
			return true
		}
		else {
			return false
		}
	}
	

}

    







