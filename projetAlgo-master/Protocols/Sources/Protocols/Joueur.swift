
class Joueur : JoueurProtocol {
	var nom : String
    var main : Main
    var champ_de_bataille = ChampDeBataille()
    var pioche = Pioche()
    var royaume = Royaume()
    var cimetiere = Cimetiere()
    
    
    init(nom : String, num : Int) {
        var i = 0
        self.nom = nom
		self.main=Main(numeroRoi : num)
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
    
    func piocher(){
        if self.pioche.estVide(){
            fatalError("On essaie de piocher dans une pioche vide")
        }
        
        main.ajouterCarte(carte : Sommet(self.pioche.pioche))
        self.pioche.supprimerCarte()
    }
    
    func peutAttaquer()->Bool {
        for cartes in self.champ_de_bataille.plateau {
			for carte in cartes {
            if carte != [nil] {
				guard let carte2:Carte = carte else{fatalError("Carte Vide")}
                if carte2.etat == etat {
                    return true
                }
            }
			}
        }
        return false
		
    }
    
    func compterCarteChampDeBataille() -> Int{
        var cmp : Int = 0 
        for carte in self.champ_de_bataille.plateau {
            if carte != nil {
                cmp = cmp + 1
            }
        }
        return cmp
    }
    
    func deployerCarte(carte : Carte, cord : Coordonnee) {
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
        carte.changerEtat(etat : etatCarte.Defensif)
        self.champ_de_bataille.insererCarte(carte : carte, cord : cord)
        self.main.enleverCarte(carte : carte)
    }
    
	
	func avancerCarte(carte : Carte) {
		var pos: Coordonnee = self.champ_de_bataille.recupererPosition(carte : carte)
		self.champ_de_bataille.avancerCarte(cord : pos)
	}
	
	
    func recupererChampDeBataille()->ChampDeBataille {
        return self.champ_de_bataille
    }
	
	
	//Modif des spécifs
	 func attaquer(joueuradverse : Joueur ,carteAttaquante : Carte, carteAttaque : Carte)->Bool {
		var AttaqueDefense : Int
		if carteAttaquante.recupererEtat() == etatCarte.Offensif {
			fatalError("On veut attaquer avec une carte déjà en posiion offensive")
		}
		carteAttaquante.changerEtat(etat:etatCarte.Offensif)
		if carteAttaque.recupererEtat() == etatCarte.Defensif {
			AttaqueDefense = carteAttaquante.recupererDefDefensive()
		}
		else {
			AttaqueDefense = carteAttaquante.recupererDefOffensive()
		}
		if carteAttaquante.recupererAttaque() == AttaqueDefense {
			self.capturer(joueuradverse : joueuradverse , carte : carteAttaque)		
			return true
		}
		else if (carteAttaquante.recupererAttaque() > AttaqueDefense || carteAttaquante.recupererAttaque() > carteAttaque.recupererSante()) {
			var pos : Coordonnee = joueuradverse.champ_de_bataille.recupererPosition(carte : carteAttaque)
			joueuradverse.champ_de_bataille.supprimerCarte(cord : pos)
			if pos.positionY()==0 {
				var derriere = Coordonnee(x : pos.positionX(), y : pos.positionY()+1)
				if !joueuradverse.champ_de_bataille.positionLibre(cord:derriere){
					joueuradverse.champ_de_bataille.avancerCarte(cord : derriere)
				}
			}
			self.cimetiere.ajouterCarte(carte:carteAttaque)
			return true
		}
		else {
			carteAttaquante.diminuerSante(attaque : carteAttaquante.recupererAttaque())
			return false
		}
	 }
	 
	 
	
    func demobiliser(carte : Carte) {
        if self.main.estVide() {
            fatalError("On veut demobiliser une main avec une main vide")
        }
        //il faudrait vérifier que la carte est bien dans la main mais il faut donc rajouter une fonction dans le type Main
        self.royaume.ajouterCarte(carte : carte)
        self.main.enleverCarte(carte : carte)
    }
	
	private func position_portee(position : Coordonnee, portee : Portee) -> Coordonnee? {
		var cord : Coordonnee
			if (position.positionX()==0 && position.positionY()==0) {
					if (portee.positionY()<1) {
						return nil
						}
					else if (portee.positionX()==-2 && portee.positionY()==1 ) {
						return nil
						}
					else if (portee.positionX()==-1 && portee.positionY()==1 ) {
						return nil
						}
					else if (portee.positionX()==0 && portee.positionY()==1 ) {
						cord=Coordonnee(x:2 , y:0)
						return cord
						}
					else if (portee.positionX()==1 && portee.positionY()==1 ) {
						cord=Coordonnee(x:1 , y:0)
						return cord
						}
					else if (portee.positionX()==2 && portee.positionY()==1 ) {
						cord=Coordonnee(x:0 , y:0)
						return cord
						}
					else if (portee.positionX()==-2 && portee.positionY()==2 ) {
						return nil
						}
					else if (portee.positionX()==-1 && portee.positionY()==2 ) {
						return nil
						}
					else if (portee.positionX()==0 && portee.positionY()==2 ) {
						cord=Coordonnee(x:2 , y:1)
						return cord
						}
					else if (portee.positionX()==1 && portee.positionY()==2 ) {
						cord=Coordonnee(x:1 , y:1)
						return cord
						}
					else if (portee.positionX()==2 && portee.positionY()==2 ) {
						cord=Coordonnee(x:0 , y:1)
						return cord
						}
						
				}
			else if (position.positionX()==1 && position.positionY()==0) {
					if (portee.positionY()<1) {
						return nil
						}
					else if (portee.positionX()==-2 && portee.positionY()==1 ) {
						return nil
						}
					else if (portee.positionX()==-1 && portee.positionY()==1 ) {
						cord=Coordonnee(x:2 , y:0)
						return cord
						}
					else if (portee.positionX()==0 && portee.positionY()==1 ) {
						cord=Coordonnee(x:1 , y:0)
						return cord
						}
					else if (portee.positionX()==1 && portee.positionY()==1 ) {
						cord=Coordonnee(x:0 , y:0)
						return cord
						}
					else if (portee.positionX()==2 && portee.positionY()==1 ) {
						return nil
						}
					else if (portee.positionX()==-2 && portee.positionY()==2 ) {
						return nil
						}
					else if (portee.positionX()==-1 && portee.positionY()==2 ) {
						cord=Coordonnee(x:2 , y:1)
						return cord
						}
					else if (portee.positionX()==0 && portee.positionY()==2 ) {
						cord=Coordonnee(x:1 , y:1)
						return cord
						}
					else if (portee.positionX()==1 && portee.positionY()==2 ) {
						cord=Coordonnee(x:0 , y:1)
						return cord
						}
					else if (portee.positionX()==2 && portee.positionY()==2 ) {
						return nil	
						}
				}
			else if (position.positionX()==2 && position.positionY()==0) {
					if (portee.positionY()<1) {
						return nil
						}
					else if (portee.positionX()==-2 && portee.positionY()==1 ) {
						cord=Coordonnee(x:2 , y:0)
						return cord
						}
					else if (portee.positionX()==-1 && portee.positionY()==1 ) {
						cord=Coordonnee(x:1 , y:0)
						return cord
						}
					else if (portee.positionX()==0 && portee.positionY()==1 ) {
						cord=Coordonnee(x:0 , y:0)
						return cord
						}
					else if (portee.positionX()==1 && portee.positionY()==1 ) {
						return nil
						}
					else if (portee.positionX()==2 && portee.positionY()==1 ) {
						return nil
						}
					else if (portee.positionX()==-2 && portee.positionY()==2 ) {
						cord=Coordonnee(x:2 , y:1)
						return cord
						}
					else if (portee.positionX()==-1 && portee.positionY()==2 ) {
						cord=Coordonnee(x:1 , y:1)
						return cord
						}
					else if (portee.positionX()==0 && portee.positionY()==2 ) {
						cord=Coordonnee(x:0 , y:1)
						return cord
						}
					else if (portee.positionX()==1 && portee.positionY()==2 ) {
						return nil
						}
					else if (portee.positionX()==2 && portee.positionY()==2 ) {
						return nil
						}
						
				}
			else if (position.positionX()==0 && position.positionY()==1) {
					if (portee.positionY()<2) {
						return nil
						}
					else if (portee.positionX()==-2 && portee.positionY()==2 ) {
						return nil
						}
					else if (portee.positionX()==-1 && portee.positionY()==2 ) {
						return nil
						}
					else if (portee.positionX()==0 && portee.positionY()==2 ) {
						cord=Coordonnee(x:2 , y:0)
						return cord
						}
					else if (portee.positionX()==1 && portee.positionY()==2 ) {
						cord=Coordonnee(x:1 , y:0)
						return cord
						}
					else if (portee.positionX()==2 && portee.positionY()==2 ) {
						cord=Coordonnee(x:0 , y:0)
						return cord	
						}
				}
			else if (position.positionX()==1 && position.positionY()==1) {
					if (portee.positionY()<2) {
						return nil
						}
					else if (portee.positionX()==-2 && portee.positionY()==2 ) {
						return nil
						}
					else if (portee.positionX()==-1 && portee.positionY()==2 ) {
						cord=Coordonnee(x:2 , y:0)
						return cord
						}
					else if (portee.positionX()==0 && portee.positionY()==2 ) {
						cord=Coordonnee(x:1 , y:0)
						return cord
						}
					else if (portee.positionX()==1 && portee.positionY()==2 ) {
						cord=Coordonnee(x:1 , y:0)
						return cord
						}
					else if (portee.positionX()==2 && portee.positionY()==2 ) {
						return 
						}
				}
			else if (position.positionX()==2 && position.positionY()==1) {
					if (portee.positionY()<2) {
						return nil
						}
					else if (portee.positionX()==-2 && portee.positionY()==2 ) {
						cord=Coordonnee(x:2 , y:0)
						return cord
						}
					else if (portee.positionX()==-1 && portee.positionY()==2 ) {
						cord=Coordonnee(x:1 , y:0)
						return cord
						}
					else if (portee.positionX()==0 && portee.positionY()==2 ) {
						cord=Coordonnee(x:0 , y:0)
						return cord
						}
					else if (portee.positionX()==1 && portee.positionY()==2 ) {
						return nil
						}
					else if (portee.positionX()==2 && portee.positionY()==2 ) {
						return nil
					}
				}
		
	}
	
	//Modif des spécif
	func capturer(joueuradverse : Joueur , carte : Carte){
		var pos : Coordonnee = joueuradverse.champ_de_bataille.recupererPosition(carte : carte)
		joueuradverse.champ_de_bataille.supprimerCarte(cord : pos)	 
		self.royaume.ajouterCarte(carte : carte)
	}
	
  
	
	func ciblesDisponible(joueuradverse : Joueur)->[Carte]{
        
        var unites: [Carte]
        var champ_de_bataille_adverse : ChampDeBataille
        var champ_de_bataille : ChampDeBataille
        var position:Coordonnee
		var carte : Carte
		
        unites = []
        champ_de_bataille_adverse = joueuradverse.recupererChampDeBataille()
        champ_de_bataille = self.champ_de_bataille
        
        for i in 0 ... 1 {
            for j in 0 ... 2 {
                position = Coordonnee(x:j,y:i)
                if !champ_de_bataille_adverse.positionLibre(cord:position) {
                    guard let carte = champ_de_bataille.plateau[i][j] else {fatalError("Vide")};
                    if unitePouvantAttaquer(joueuradverse : joueuradverse, carte : carte)!=[]{
                        unites.append(carte)
                    }
                }
            }
        }
        return unites
	}
    
    
    
    //Modif specif ? On doit avoir acces au plateau du joueur adverse ?
    func unitePouvantAttaquer(joueuradverse : Joueur, carte : Carte)->[Carte]{
        
        var champ_de_bataille_adverse : ChampDeBataille
        var champ_de_bataille : ChampDeBataille
        var position_carte : Coordonnee
        var carte_attaquante : Carte
        var portee: Portee
        var unites: [Carte]
        var position:Coordonnee
        
        unites = []
        champ_de_bataille_adverse = joueuradverse.recupererChampDeBataille()
        position_carte = champ_de_bataille_adverse.recupererPosition(carte : carte)
        champ_de_bataille = self.champ_de_bataille
        
        for i in 0 ... 1 {
            for j in 0 ... 2 {
                position = Coordonnee(x:j,y:i)
                if !champ_de_bataille.positionLibre(cord:position) {
                    carte_attaquante = champ_de_bataille.plateau[i][j];
                    for portee in carte_attaquante.portee{
                        if(position_portee(position : position, portee : portee) == position_carte){
                            unites.append(carte_attaquante)
                        }
                    }
                }
            }
        }
        return unites
    }
    
    
    
}
