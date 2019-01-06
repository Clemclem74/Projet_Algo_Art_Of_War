
class Joueur : JoueurProtocol {
    var main = Main()
    var champ_de_bataille = ChampDeBataille()
    var pioche = Pioche()
    var royaume = Royaume()
    var cimetiere = Cimetiere()
    
    
    init(nom : String) {
        var i = 0
        self.nom = nom
        self.pioche.melangerPioche()
        for i in 0 ... 3 {
            self.piocher()
        }
    }
    
    init() {
        var i = 0
        self.nom = "Joueur"
        self.pioche.melangerPioche()
        for i in 0 ... 3 {
            self.piocher()
        }
    }
    
    mutating func piocher(){
        if self.pioche.estVide(){
            fatalError("On essaie de piocher dans une pioche vide")
        }
        
        ajouterCarte(carte : Sommet(self.pioche))
        pioche.supprimerCarte()
    }
    
    func peutAttaquer()->Bool {
        for carte in self.champ_de_bataille.plateau {
            if carte != Vide {
                if carte.etat == Offensif {
                    return True
                }
            }
        }
        return False
    }
    
    func compterCarteChampDeBataille() -> Int{
        var cmp : Int = 0 
        for carte in self.champ_de_bataille.plateau {
            if carte != Vide {
                cmp = cmp + 1
            }
        }
        return cmp
    }
    
    mutating func deployerCarte(carte : Carte, cord : Coordonnees) {
        if self.main.estVide() {
            fatalError("On veut deployer avec une main vide")
        }
        if cord.positionX()>2 || cord.positionX()<0 {
            fatalError("Coordonne x pas compris entre 0 et 2")
        }
        if cord.positionY()>1 || cord.positionY()<0 {
            fatalError("Coordonne y pas compris entre 0 et 1")
        }
        if !self.champ_de_bataille.positionLibre(cord : cord){
            fatalError("La position n'est pas libre")
        }
        carte.etat=Defensif
        self.champ_de_bataille.insererCarte(carte : carte, cord : cord)
        self.main.enleverCarte(carte : carte)
    }
    
	
	func avancerCarte(carte : Carte) {
		var pos: Position = self.champ_de_bataille.recupererPosition(carte : carte)
		self.champ_de_bataille.avancerCarte(cord : pos)
	}
	
	
    func recupererChampDeBataille()->ChampDeBataille {
        return self.champ_de_bataille
    }
	
	
	//Modif des spécifs
	 func attaquer(joueuradverse : Joueur ,carteAttaquante : Carte, carteAttaque : Carte)->Bool {
		if carteAttaquante.recupererEtat() == Offensif {
			fatalError("On veut attaquer avec une carte déjà en posiion offensive")
		}
		carteAttaquante.changerEtat(etat:Offensif)
		if carteAttaque.recupererEtat() == Defensif {
			var AttaqueDefense : Int = carteAttaquante.recupererDefDefensive
		}
		else {
			var AttaqueDefense : Int = carteAttaquante.recupererDefOffensive
		}
		if carteAttaquante.recupererAttaque == AttaqueDefense {
			self.capturer(joueurAdverse : joueurAdverse , carte : carteAttaque)		
			return true
		}
		else if (carteAttaquante.recupererAttaque > AttaqueDefense || carteAttaquante.recupererAttaque > carteAttaque.recupererSante) {
			var pos : Coordonnees = joueuradverse.champ_de_bataille.recupererPosition(carte : carteAttaque)
			joueuradverse.champ_de_bataille.supprimerCarte(cord : pos)
			if pos.positionY()==0 {
				var derriere = Coordonnees(x : pos.positionX(), y : pos.positionY()+1)
				if !joueuradverse.champ_de_bataille.positionLibre(cord:derriere){
					joueuradverse.champ_de_bataille.avancerCarte(cord : derriere)
				}
			}
			self.cimetiere.ajouterCarte(carte:carteAttaque)
			return true
		}
		else {
			carteAttaquante.diminuerSante(attaque : carteAttaquante.recupererAttaque)
			return false
		}
	 }
	 
	 //Modif des spécif
	 mutating func capturer(joueurAdverse : Joueur , carte : Carte){
		var pos : Coordonnees = joueuradverse.champ_de_bataille.recupererPosition(carte : carte)
		joueuradverse.champ_de_bataille.supprimerCarte(cord : pos)	 
		self.royaume.ajouterCarte(carte : carte)
	}
	
    mutating func demobiliser(carte : Carte) {
        if self.main.estVide() {
            fatalError("On veut demobiliser une main avec une main vide")
        }
        //il faudrait vérifier que la carte est bien dans la main mais il faut donc rajouter une fonction dans le type Main
        self.royaume.ajouterCarte(carte : Carte)
        self.main.enleverCarte(carte : carte)
    }
	
	func ciblesDisponible(joueuraverse : Joueur)->[Carte]{
		
	}
    
    
    
}
