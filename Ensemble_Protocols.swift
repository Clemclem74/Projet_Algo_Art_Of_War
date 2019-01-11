import Foundation






enum etatCarte{
    case Offensif,Defensif
}
// enumeration permettant de connaitre le rôle d'un carte existante
enum uniteCarte{
    case Garde,Soldat,Archer,Roi
}







































class Coordonnee {
    var x : Int
    var y : Int
	var carte : Carte?
    
    init(x : Int, y : Int){
        self.x = x
        self.y = y
		self.carte = nil
    }
    
    func positionX()->Int {
        return self.x
    }
    
    func positionY()->Int {
        return self.y
    }
    
	//modif spé
    func retournerCarte()->Carte? {
		if(self.carte==nil) {
			return nil
		}
		else {
			return self.carte
		}
    }
	
	func lierCarte(carte:Carte){
		self.carte = carte
	}
	
	static func == (c1 : Coordonnee,c2 : Coordonnee) -> Bool {
        return ((c2.x == c1.x) && (c2.y == c1.y))
    }
}








































class Joueur{
	var nom : String
    var main : Main
    var champ_de_bataille = ChampDeBataille()
    var pioche = Pioche()
    var royaume = Royaume()
    var cimetiere = Cimetiere()
    
    
    init(nom : String, num : Int) {
        self.nom = nom
		self.main=Main(numeroRoi : num)
        self.pioche.melangerPioche()
        for _ in 0 ... 3 {
            self.piocher()
        }
    }

    
    func piocher(){
        if self.pioche.estVide(){
            fatalError("On essaie de piocher dans une pioche vide")
        }
        guard let carte : Carte = self.pioche.pioche.first else{fatalError("pioche vide")}
        main.ajouterCarte(carte : carte)
        self.pioche.supprimerCarte()
    }
    
    func peutAttaquer()->Bool {
        for coords in self.champ_de_bataille.plateau {
            for coord in coords{
                if coord.carte != nil {
                    guard let carte2 : Carte = coord.carte else{fatalError("Carte vide")}
                    if carte2.etat == etatCarte.Defensif {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    func compterCarteChampDeBataille() -> Int{
        var cmp : Int = 0
		var ChampIt : ChampIterator
		ChampIt = self.champ_de_bataille.makeIterator()
        while ChampIt.next() != nil {
            if ChampIt.plateau[ChampIt.j][ChampIt.i].carte != nil{
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
		let pos: Coordonnee = self.champ_de_bataille.recupererPosition(carte : carte)
		self.champ_de_bataille.avancerCarte(cord : pos)
	}
	
	
    func recupererChampDeBataille()->ChampDeBataille {
        return self.champ_de_bataille
    }
	
	
	//Modif des spécifs
	 func attaquer(joueuradverse : Joueur ,carteAttaquante : Carte, carteAttaque : Carte)->Bool {
		var AttaqueDefense : Int
		if carteAttaquante.recupererUnite() == uniteCarte.Soldat{
			carteAttaquante.attaque = self.main.nombreOccurence()
		}
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
			let pos : Coordonnee = joueuradverse.champ_de_bataille.recupererPosition(carte : carteAttaque)
			joueuradverse.champ_de_bataille.supprimerCarte(cord : pos)
			if pos.positionY()==0 {
				let derriere = Coordonnee(x : pos.positionX(), y : pos.positionY()+1)
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
            fatalError("On veut demobiliser une carte avec une main vide")
        }
        //il faudrait vérifier que la carte est bien dans la main mais il faut donc rajouter une fonction dans le type Main
        self.royaume.ajouterCarte(carte : carte)
        self.main.enleverCarte(carte : carte)
    }
	
	func position_portee(position : Coordonnee, portee : Portee) -> Coordonnee? {
		var cord : Coordonnee
			if (position.positionX()==0 && position.positionY()==0) {
					if (portee.positionY()<1) {
						return nil
						}
					else if (portee.positionX()==(-2) && portee.positionY()==1 ) {
						return nil
						}
					else if (portee.positionX()==(-1) && portee.positionY()==1 ) {
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
					else if (portee.positionX()==(-2) && portee.positionY()==2 ) {
						return nil
						}
					else if (portee.positionX()==(-1) && portee.positionY()==2 ) {
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
					else if (portee.positionX()==(-2) && portee.positionY()==1 ) {
						return nil
						}
					else if (portee.positionX()==(-1) && portee.positionY()==1 ) {
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
					else if (portee.positionX()==(-2) && portee.positionY()==2 ) {
						return nil
						}
					else if (portee.positionX()==(-1) && portee.positionY()==2 ) {
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
					else if (portee.positionX()==(-2) && portee.positionY()==1 ) {
						cord=Coordonnee(x:2 , y:0)
						return cord
						}
					else if (portee.positionX()==(-1) && portee.positionY()==1 ) {
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
					else if (portee.positionX()==(-2) && portee.positionY()==2 ) {
						cord=Coordonnee(x:2 , y:1)
						return cord
						}
					else if (portee.positionX()==(-1) && portee.positionY()==2 ) {
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
					else if (portee.positionX()==(-2) && portee.positionY()==2 ) {
						return nil
						}
					else if (portee.positionX()==(-1) && portee.positionY()==2 ) {
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
					print("Test")
					if (portee.positionY()>2) {
						return nil
						}
					else if (portee.positionX()==(-2) && portee.positionY()==2 ) {
						return nil
						}
					else if (portee.positionX()==(-1) && portee.positionY()==2 ) {
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
						return  nil
						}
				}
			else if (position.positionX()==2 && position.positionY()==1) {
					if (portee.positionY()<2) {
						return nil
						}
					else if (portee.positionX()==(-2) && portee.positionY()==2 ) {
						cord=Coordonnee(x:2 , y:0)
						return cord
						}
					else if (portee.positionX()==(-1) && portee.positionY()==2 ) {
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
			return nil
	}
	
	//Modif des spécif
	func capturer(joueuradverse : Joueur , carte : Carte){
		let pos : Coordonnee = joueuradverse.champ_de_bataille.recupererPosition(carte : carte)
		joueuradverse.champ_de_bataille.supprimerCarte(cord : pos)	 
		self.royaume.ajouterCarte(carte : carte)
	}
	
  
	
	func ciblesDisponible(joueuradverse : Joueur)->[Carte]{
        
        var unites: [Carte]
		var cmp: [Carte]
        var champ_de_bataille_adverse : ChampDeBataille
        var position : Coordonnee
        unites = []
        champ_de_bataille_adverse = joueuradverse.recupererChampDeBataille()
        
        for i in 0 ... 1 {
            for j in 0 ... 2 {
                position = Coordonnee(x:j,y:i)
                if !champ_de_bataille_adverse.positionLibre(cord:position) {
						guard let c : Carte = champ_de_bataille_adverse.plateau[i][j].carte else{fatalError("erreur cible")}
						cmp = unitePouvantAttaquer(joueuradverse : joueuradverse, carte : c)
						if(cmp.count != 0){
							unites.append(c)
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
					
                    carte_attaquante = champ_de_bataille.plateau[i][j].carte!;
					print(carte_attaquante.portee)
                    for portee in carte_attaquante.portee{
						if (position_portee(position : position, portee : portee) != nil) {
							guard let pos : Coordonnee = position_portee(position : position, portee : portee) else{fatalError("mauvaise coord")}
							if(pos == position_carte){
								unites.append(carte_attaquante)
							}
						}
                    }
                }
            }
        }
        return unites
    }
    
    
    
}









































//Definition de la structure Portee, qui correspond a la portee d'une carte. (0,0) correspond a la carte elle meme.
import Foundation



class RoyaumeIterator : IteratorProtocol{
    var royaume : Royaume
    var i : Int = 0

    init(royaume: Royaume) {
        self.royaume = royaume
    }

    func next() -> Carte? {
    	let liste = self.royaume.royaume
        if self.i < 0 || self.i >= self.royaume.nombreOccurence(){
        	return nil 
        }
        else {
        	self.i = self.i+1
            return liste[self.i-1]
        }
    }
}





class Royaume {
	var royaume : [Carte]
   
   
	init() {
		royaume = []
	}
   
	func ajouterCarte(carte:Carte){
		self.royaume.append(carte)
	}
	
	func nombreOccurence()->Int {
		var i : Int = 0
		for _ in self.royaume {
			i=i+1
		}
		return i
	}
	
	func enleverCarte(carte : Carte) {
		var i : Int = 0
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
		if self.royaume.count == 0 {
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










































class Carte {
    var id: Int
    var attaque: Int
    var defDefensive: Int
    var defOffensive: Int
	var sante : Int
    var etat: etatCarte
    var unite: uniteCarte
    var portee: [Portee]
    
    init(id : Int, attaque : Int, defDefensive : Int, defOffensive : Int, etat : etatCarte, unite : uniteCarte, portee : [Portee]){
        self.id = id
        self.attaque = attaque
        self.defDefensive = defDefensive
        self.defOffensive = defOffensive
		self.sante=self.defDefensive
        self.etat = etat
        self.unite = unite
        self.portee = portee
    }
    
    func changerEtat(etat: etatCarte){
        self.etat=etat
    }
    
    func recupererUnite()->uniteCarte{
        return self.unite
    }
    
    func recupererIdCarte()->Int{
        return self.id
    }
	
	//Rajouté des spécif 
	func recupererEtat()->etatCarte {
		return self.etat
	}
	
	//Rajouté des spécifs
	func recupererSante()->Int {
		return self.sante
	}
	
	//Rajouté des spécifs
	func diminuerSante(attaque : Int){
		self.sante = self.sante - attaque
	}
	
	//Rajouté des spécifs 
	func recupererAttaque()->Int{
		return self.attaque
	}
	
	//Rajouté des spécifs
	func recupererDefDefensive()->Int{
		return self.defDefensive
	}
	
	//Rajouté des spécifs
	func recupererDefOffensive()->Int{
		return self.defOffensive
	}
	
	static func == (c1 : Carte,c2 : Carte) -> Bool {
        return c1.id == c2.id
    }
}







































class ChampIterator : IteratorProtocol  {
    var plateau: [[Coordonnee]]
    var i : Int = 0
    var j : Int = -1

    init(plateau: ChampDeBataille) {
        self.plateau = plateau.plateau
    }

    func next() -> Coordonnee? {
    	let tab = self.plateau
        if self.i >= 1 && self.j >= 2{
        	return nil 
        }
        else {
			j=j+1
			if j==3{
				i=i+1
				j=0	
			}
			return tab[i][j]
		}
    }
}


class ChampDeBataille : Sequence{
    var plateau: [[Coordonnee]] = [[]]
    
	init() {
	var tmp : [Coordonnee] = []
	var tmp2 : [Coordonnee] = []
	var cord = Coordonnee(x:0,y:0)
	tmp.append(cord)
	cord = Coordonnee(x:1,y:0)
	tmp.append(cord)
	cord = Coordonnee(x:2,y:0)
	tmp.append(cord)
	
	cord = Coordonnee(x:0,y:1)
	tmp2.append(cord)
	cord = Coordonnee(x:1,y:1)
	tmp2.append(cord)
	cord = Coordonnee(x:2,y:1)
	tmp2.append(cord)
	self.plateau=[tmp,tmp2]
       
    }
    
    func makeIterator() -> ChampIterator{
        return ChampIterator(plateau:self)
    }
    
    func positionLibre(cord : Coordonnee)->Bool{
        return self.plateau[cord.positionY()][cord.positionX()].carte==nil
    }
    
    func insererCarte(carte : Carte, cord : Coordonnee) {
        if !positionLibre(cord:cord){
            fatalError("Insertion sur une carte non vide")
        }
		self.plateau[cord.positionY()][cord.positionX()].carte=carte
    }
    
    func supprimerCarte(cord : Coordonnee) {
        if positionLibre(cord:cord){
            fatalError("Suppression d'une case vide")
        }
        self.plateau[cord.positionY()][cord.positionX()].carte = nil
    }
    
    func avancerCarte(cord : Coordonnee) {
        var cordFinale:Coordonnee
        if cord.positionY() == 0 {
            fatalError("On essaie d'avancer une carte en position avant")
        }
        cordFinale = Coordonnee(x : cord.positionY()-1, y : cord.positionX())
        if !positionLibre(cord:cordFinale){
            fatalError("On essaie d'avancer une carte sur une position non libre")
        }
        let tmp : Carte? = self.plateau[cord.positionY()][cord.positionX()].carte
        self.plateau[cord.positionY()][cord.positionX()].carte = nil
        self.plateau[cord.positionY()-1][cord.positionX()].carte = tmp
    }
    
    func recupererPosition(carte : Carte?)->Coordonnee {
		guard let carte : Carte = carte else{fatalError("carte vide")}
		var c = -1
		for i in 0 ... 1 {
            for j in 0 ... 2 {
				if self.plateau[i][j].carte != nil{
					guard let carte2 : Carte = self.plateau[i][j].carte else{fatalError("carte champ vide")}
					c=carte2.id
				}
				if(carte.id == c){
					return self.plateau[i][j]
				}
            }
        }
        
        fatalError("La carte n'est pas sur le champs de bataille")
    }
    
    func champDeBatailleEstVide()->Bool {
        for i in 0 ... 1 {
            for j in 0 ... 2 {
				if(self.plateau[i][j].carte != nil){
					return false
				}
            }
        }
		return true
	}
}



































class Cimetiere{
    fileprivate var cimetiere:[Carte]
    init(){
        cimetiere=[]
    }
    
    
    func ajouterCarte(carte : Carte){
        self.cimetiere.append(carte)
    }
    
    func nombreOccurence()->Int{
        return self.cimetiere.count
    }
    
    func estVide()->Bool{
        return self.cimetiere.isEmpty
    }
    
    
}









































class MainIterator : IteratorProtocol{
    var main: Main
    var i : Int = 0

    init(main: Main) {
        self.main = main
    }

    func next() -> Carte? {
    	let l : [Carte] = self.main.recupererMain()
        if self.i < 0 || self.i >= self.main.nombreOccurence(){
        	return nil 
        }
        else {
        	self.i = self.i+1
        	return l[self.i-1]
        }
    }
}



class Main  {
    var main : [Carte] = []
   
   
   init(numeroRoi : Int){
		self.main = []
		var ensemble_cord : [Portee]=[]
        var coord = Portee(x : -2 , y : 1)
        ensemble_cord.append(coord)
		coord = Portee(x : -1 , y : 1)
        ensemble_cord.append(coord)
		coord = Portee(x : 0 , y : 1)
        ensemble_cord.append(coord)
		coord = Portee(x : 1 , y : 1)
        ensemble_cord.append(coord)
		coord = Portee(x : 2 , y : 1)
        ensemble_cord.append(coord)
		if numeroRoi == 1 {
			coord = Portee(x : 0 , y : 2)
			ensemble_cord.append(coord)
			let Roi = Carte(id : 2, attaque : 1, defDefensive : 5, defOffensive : 4, etat : etatCarte.Defensif, unite : uniteCarte.Roi, portee : ensemble_cord)
			self.main.append(Roi)
		}
		else {
            let Roi = Carte(id : 2, attaque : 1, defDefensive : 5, defOffensive : 4, etat : etatCarte.Defensif, unite : uniteCarte.Roi, portee : ensemble_cord)
			self.main.append(Roi)
		}
   }
   
   
   func makeIterator() -> MainIterator {
		return MainIterator(main:self)
	}

	func recupererCarte(type : uniteCarte)->Carte? {
		for carte in self.main {
			if carte.recupererUnite() == type {
				return carte
			}
		}
		return nil
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
	
	func recupererMain()->[Carte]{
		return self.main
	}
	
	func nombreOccurence()->Int {
		var nb : Int = 0
		for _ in self.main {
			nb=nb+1
		}
		return nb
	}
	
	func estVide()->Bool {
		let main = self.main
		if main.count == 0{
			return true
		}
		else {
			return false
		}
	}
	

}

    









	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
//Definition de la structure Portee, qui correspond a la portee d'une carte. (0,0) correspond a la carte elle meme.


struct Portee{
    fileprivate var x:Int
    fileprivate var y:Int
    
    init(x: Int,y: Int){
        self.x=x
        self.y=y
    }
	
	func positionX()->Int {
        return self.x
    }
    
    func positionY()->Int {
        return self.y
    }
	
}












































class PiocheIterator : IteratorProtocol {
    private var pioche: Pioche
    private var i : Int = 0

    fileprivate init(pioche: Pioche) {
        self.pioche = pioche
    }

    func next() -> Carte? {
		let l : [Carte] = self.pioche.pioche
        if self.i < 0 || self.i >= self.pioche.nombreOccurence(){
        	return nil 
        }
        else {
        	self.i = self.i+1
        	return l[self.i-1]
        }
	}
}

// Type Pioche contient une liste de carte et un itérateur permettant de la parcourir
class Pioche : Sequence{
    var pioche : [Carte]
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
		pioche = []
        var ensemble_cord : [Portee]=[]
        var coord = Portee(x : 0 , y : 1)
        ensemble_cord.append(coord)
        var carte : Carte
        for i in 3 ... 11 {
            carte = Carte(id : i , attaque : 0 , defDefensive : 2 , defOffensive : 1 , etat : etatCarte.Defensif , unite : uniteCarte.Soldat , portee : ensemble_cord)
            self.pioche.append(carte)
        }
        
        for i in 12 ... 17 {
            carte = Carte(id : i , attaque : 1 , defDefensive : 3 , defOffensive : 2 , etat : etatCarte.Defensif , unite : uniteCarte.Garde , portee : ensemble_cord)
            self.pioche.append(carte)
        }
        
        coord = Portee(x : -2 , y : 1)
        ensemble_cord[0] = coord
        coord = Portee(x : -1 , y : 2)
        ensemble_cord.append(coord)
        coord = Portee(x : 1 , y : 2)
        ensemble_cord.append(coord)
        coord = Portee(x : 2 , y : 1)
        ensemble_cord.append(coord)
       
        for i in 18 ... 22 {
            carte = Carte(id : i , attaque : 1 , defDefensive : 2 , defOffensive : 1 , etat : etatCarte.Defensif , unite : uniteCarte.Archer , portee : ensemble_cord)
            self.pioche.append(carte)
        }
    }
	
    
    func supprimerCarte(){
        if !estVide() {
            self.pioche.remove(at:0)
        }
        else {
            fatalError("Supprimer carte d'une pioche vide")
        }
    }
    
    func nombreOccurence()->Int {
			return self.pioche.count
    }
    
    func estVide()->Bool {
        return self.pioche.count == 0
    }
	
    func makeIterator() -> PiocheIterator{
        return PiocheIterator(pioche:self)
    }

    
    func melangerPioche(){
        //self.pioche.shuffle()
	}
 }




































	
/* ------- Programme Main ------- */

//afficherChampBataile : Joueur
//permet d'afficher le camp d'un joueur
func afficherChampBataile(joueur: Joueur){
	let champ = joueur.recupererChampDeBataille()
	let champIT = champ.makeIterator()
	var element : Coordonnee
	var ligne : String
	print("********************************************")
	while champIT.next() != nil{
		element = champIT.plateau[champIT.i][champIT.j]
		ligne = "carte :"
		if(element.retournerCarte() != nil){
			ligne += " \(element.retournerCarte()!.recupererUnite()) "
		}
		else{
			ligne += "        "
		}
		ligne += "->[" + String(element.positionX()) + ";" + String(element.positionY()) + "]"
		print(ligne)
	}
	print("********************************************")
}


//afficherMain : Joueur
//permet d'afficher la  main d'un joueur
func afficherMain(joueur: Joueur){
	print("**********************************************")
	var ligne : String = ""
	for i in 0 ... joueur.main.nombreOccurence()-1{
		ligne = "\(joueur.main.recupererMain()[i].recupererUnite())" + "(id:" + "\(joueur.main.recupererMain()[i].recupererIdCarte())" + ")"
		print(ligne)
	}
	print(ligne)
	print("********************************************")

}


//afficherUnites: [Carte]
//correspond a afficher graphiquement une liste de carte
func afficherUnites(unite: [Carte]){
	print("**********************************************")
	var ligne : String = ""
	for i in 0 ..< unite.count{
		ligne = "\(unite[i].recupererUnite())" + "(id:" + "\(unite[i].recupererIdCarte())" + ")"
		print(ligne)
	}
	print("********************************************")

}

//permet de selectionner une coordonnée X et Y
func choisirCoordonneeXY(JoueurSelectionner: Joueur,X : inout Int, Y : inout Int){
	var cord : Coordonnee
	repeat{
		print("Choisissez une coordonnee X:")

		if let typed = readLine(){
			if let n = Int(typed){
				X = n
			}
		}

		print("Choisissez une coordonnee Y:")
		if let typed = readLine(){
			if let n = Int(typed){
				Y = n
			}
		}
	cord = Coordonnee(x:X,y:Y)
	}while(!(X < 3 && X >= 0 && Y < 2 && Y>=0 && JoueurSelectionner.recupererChampDeBataille().positionLibre(cord:cord)))
}


func choisirTypeCarte()->uniteCarte{
	print("choisissez entre : 1- Soldat 2- Archer 3- Garde")
	var choix = ""
	while(choix != "Soldat" && choix != "Archer" && choix != "Garde"){
		if let typed = readLine(){
				choix = typed

		} else {
			print("votre choix est incorrecte")
		}
	}

	var type : uniteCarte = uniteCarte.Soldat
	if(choix=="Soldat"){
		type = uniteCarte.Soldat
	}
	else if(choix=="Archer"){
		type = uniteCarte.Archer
	}
	else if(choix=="Garde"){
		type = uniteCarte.Garde
	}
	return type
}

/* Initialisation de la partie */
print("Joueur 1 : Veuillez saisir un nom pour votre joueur : ")
var choix2 : String = ""

if let typed = readLine(){
	choix2=typed
}
var joueur1 = Joueur(nom : choix2, num:1)

print("Joueur 2 : Veuillez saisir un nom pour votre joueur : ")
if let typed = readLine(){
	choix2=typed
}
var joueur2 = Joueur(nom : choix2, num:2)

var joueurGagnant = Joueur(nom : "", num:1)
var partiFini = false
var X : Int = -1
var Y : Int = -1
print("Joueur 1 : veuillez selectionner une carte a mettre au royaume")
afficherMain(joueur : joueur1)

var choix_carte : Carte? = joueur1.main.recupererCarte(type : choisirTypeCarte())
while choix_carte == nil{
	print("Vous ne possedez pas cette carte, veuillez en choisir une autre")
	choix_carte = joueur1.main.recupererCarte(type : choisirTypeCarte())
}	
joueur1.demobiliser(carte : choix_carte!)

print("mettre un carte au front")
afficherMain(joueur : joueur1)

choisirCoordonneeXY(JoueurSelectionner: joueur1,X : &X, Y : &Y)
var cord = Coordonnee(x:X,y:Y)
choix_carte = joueur1.main.recupererCarte(type : choisirTypeCarte())
while choix_carte == nil{
	print("Vous ne possedez pas cette carte, veuillez en choisir une autre")
	choix_carte = joueur1.main.recupererCarte(type : choisirTypeCarte())
}	
joueur1.deployerCarte(carte : choix_carte!,cord:cord)

print("Joueur 2 : veuillez selectionner (un numero) une carte a mettre au royaume")
afficherMain(joueur : joueur2)
choix_carte = joueur2.main.recupererCarte(type : choisirTypeCarte())
while choix_carte == nil{
	print("Vous ne possedez pas cette carte, veuillez en choisir une autre")
	choix_carte = joueur2.main.recupererCarte(type : choisirTypeCarte())
}
joueur2.demobiliser(carte: choix_carte!)

print("mettre un carte au front")
print(afficherMain(joueur : joueur2))

choisirCoordonneeXY(JoueurSelectionner: joueur2,X : &X, Y : &Y)
cord = Coordonnee(x:X,y:Y)
choix_carte = joueur2.main.recupererCarte(type : choisirTypeCarte())
while choix_carte == nil{
	print("Vous ne possedez pas cette carte, veuillez en choisir une autre")
	choix_carte = joueur2.main.recupererCarte(type : choisirTypeCarte())
}
joueur2.deployerCarte(carte : choix_carte!,cord:cord)





/* Boucle principale du jeu */
var tour=1
var input : Int
var joueurActuel : Joueur
var joueurAdverse : Joueur
var changerCible = false
var cibleMorte = false
var valide = false
var cibleDisponible : [Carte]
var unite : [Carte]
var pouvantAttaquer : Bool
var attaquer : Carte //carte qui est attaqué
var attaquant : Carte //Carte attaquante
var attaque = false //permettant de lancer une attaque
while(!partiFini){
	if(tour%2 == 0){
		joueurActuel = joueur2 //attention le joueur doit être de type réference et non pas de type valeur !!!
		joueurAdverse = joueur1
		print("a toi de jouer joueur 2 !")

	} else {
		joueurActuel = joueur1
		joueurAdverse = joueur2
		print("a toi de joueur joueur 1 !")
	}
	/* Mise en position défensive de toutes les cartes du champ de bataille du joueur */
	let champ = joueurActuel.recupererChampDeBataille()
	let champIT = champ.makeIterator()
	var c : Coordonnee
	while champIT.next() != nil{
		c = champIT.plateau[champIT.i][champIT.j]
		if c.carte != nil{
			guard let carte : Carte = c.carte else{fatalError("Carte vide")}
			carte.changerEtat(etat: etatCarte.Defensif)
			//Supprimer la carte avant
			joueurActuel.champ_de_bataille.supprimerCarte(cord : c)
			joueurActuel.champ_de_bataille.insererCarte(carte : carte, cord : c)
		}
	}
	if(joueurActuel.pioche.nombreOccurence()>0){
		joueurActuel.piocher()

	/* Si les deux joueurs n'ont plus de carte dans leur pioche, on regarde qui à le plus de carte dans son royaume pour désigner le gagnant*/
	} else if (joueurAdverse.pioche.nombreOccurence() == 0){
		if(joueurActuel.royaume.nombreOccurence()>joueurAdverse.royaume.nombreOccurence()){
			joueurGagnant = joueurActuel

		} else {
			joueurGagnant = joueurAdverse
		}

		partiFini = true;
		break

	}
	print("champ de bataille adverse : ")
	afficherChampBataile(joueur: joueurAdverse)
	print("votre main : ")
	afficherMain(joueur : joueurActuel)
	var choix:String = ""
	//phase action
	print("Veuillez saisir une action a faire (attaquer / deployer / rien) : ")
	if let typed = readLine(){
		choix=typed
	}
	/* Choix de l'action à faire pour ce tour */
	while(choix != "rien" && choix != "deployer" && choix != "attaquer"){
		print("saisi non valide, veuillez reiterer")
		if let typed = readLine(){
			choix = typed
		}
	}
	/* Choix de ne rien faire */
	if(choix == "rien"){
		print("vous decidez de passer votre tour")

	/* Choix d'attaquer l'adversaire */
	} 
	else if (choix == "attaquer"){
	//-----------------------------------------------RAJOUTER REMPLISSAGE SANTE CARTES---------------------------------------------------------------------------------------------------------------------------
		attaque = true
		let ensemble_cord : [Portee]=[]
		var attaquer = Carte(id : -1 , attaque : 0 , defDefensive : 0 , defOffensive : 0 , etat : etatCarte.Defensif , unite : uniteCarte.Soldat , portee : ensemble_cord)
		while(attaque){
			print("...............................")
	 		let pouvantAttaquer : Bool = joueurActuel.peutAttaquer()
			print(pouvantAttaquer)
			cibleDisponible = joueurActuel.ciblesDisponible(joueuradverse : joueurAdverse)
			print(cibleDisponible)
			print(cibleDisponible.count)
			if(cibleDisponible.count>0 && pouvantAttaquer){
				afficherUnites(unite: cibleDisponible)
				print("Choisir une cible ou arreter l'attaque avec \"stop\"")
				valide = false

				while(!valide){
					if let typed = readLine(){
						if let n = Int(typed){
							input = n
							if (n>=0 && n<cibleDisponible.count){
								valide = true
								attaquer = cibleDisponible[input]
							}
							else{
								print("veuillez choisir une action correcte")
							}

						} else if (typed == "stop"){
							valide = true
							print("l'attaque est stoppee !")
							attaque = false

						} else {
							print("veuillez choisir une action correcte")
						}
					}
				}

				if(attaque==true){
					changerCible = false
					cibleMorte = false
					while(changerCible == false && cibleMorte == false){
						unite = joueurActuel.unitePouvantAttaquer(joueuradverse : joueurAdverse , carte : attaquer) //ne montrer que les soldats qui sont en mode defensif
						if(unite.count>0){ // Si le joueur possède des cartes capable d'atteindre des cartes ennemis
							print(afficherUnites(unite: unite))
							print("Avec quelle carte voulez vous attaquer ? (tapez la position du soldat dans la liste (commence par 0) ou changer de cible ? (tapez \"changer\")")
							valide=false
							let typed : String = ""
							var changer : String = ""
							attaquant = cibleDisponible[0]
							while(!valide){
								if let typed : String = readLine(){
									print("......")
									print(typed)
									print(".....")
									if (typed == "changer"){
										valide = true
										changer="changer"
									}
									else if let n = Int(typed){
										input = n
										if (n>=0 && n<cibleDisponible.count){
											attaquant = cibleDisponible[input]
											if(attaquant.etat == etatCarte.Defensif){
												valide = true
												
											}
											else {
												print("Vous avez deja attaque avec cette carte")
											}
										}
										else{
											print("veuillez choisir une action correcte")
										}
									}
								}
							}
							print("typed2")
							print(typed)
							print("typed3")
							if(changer == "changer"){
								print("vous avez choisi de changer de cible")
								changerCible = true
							} 
							else if(joueurActuel.attaquer(joueuradverse : joueurAdverse , carteAttaquante: attaquant,carteAttaque: attaquer)){
								print("La carte attaquee est tombe au combat !")
								cibleMorte = true
								if(attaquer.unite == uniteCarte.Roi){
									joueurGagnant = joueurActuel
									partiFini = true
									break
								}
							
								else if (joueurAdverse.recupererChampDeBataille().champDeBatailleEstVide()){ // Si le joueur adverse n'a plus d'unite sur son champ de bataille
									if(joueurAdverse.royaume.nombreOccurence() + joueurAdverse.main.nombreOccurence() < 1){ // Si il n'a plus de carte dans le royaume ni dans la main : effondrement
										joueurGagnant = joueurActuel
										partiFini = true
										break
									} 
									else { // Si il lui reste au moins une carte dans la main ou dans le royaume : conscription
										if(!joueurAdverse.royaume.estVide()){
											print(joueurAdverse.nom)
											print(" vous etes force a déploye une carte venant de votre royaume, veuillez choisir les coordonnees de deploiement")
											choisirCoordonneeXY(JoueurSelectionner: joueurAdverse,X : &X, Y : &Y)
											cord = Coordonnee(x:X,y:Y)
											
											let carte_deployee = joueurAdverse.royaume.royaume[joueurAdverse.royaume.nombreOccurence()-1] 
											joueurAdverse.royaume.enleverCarte(carte : carte_deployee)
											joueurAdverse.deployerCarte(carte : carte_deployee,cord : cord)

										} 
										else {
											afficherMain(joueur : joueurActuel)
											print(joueurAdverse.nom)
											print(" veuillez choisir une carte à deployer")
											choisirCoordonneeXY(JoueurSelectionner: joueurAdverse,X : &X, Y : &Y)
											cord = Coordonnee(x:X,y:Y)
											joueurAdverse.deployerCarte(carte : joueurAdverse.main.recupererCarte(type: choisirTypeCarte())!,cord : cord)
											print("carte deployé !")

										}
									}
								}
							}
							else {
								print("veuillez choisir une reponse valide")
							}
						}	
						else {
							print("aucune unite ne peut attaquer cette cible")
							changerCible = true
						}
			
					}
				}
				
			}
			else {
					print("il n'y a aucune cible adverse...")
					attaque = false
				}
		}

	/* Choix de déployer une carte sur le champ de bataille */
	} 
	else if(choix == "deployer"){
		print("veuillez choisir une carte à deployer")
		choisirCoordonneeXY(JoueurSelectionner: joueurActuel,X : &X, Y : &Y)
		cord = Coordonnee(x:X,y:Y)
		var choix_carte = joueur2.main.recupererCarte(type : choisirTypeCarte())
		while choix_carte == nil{
		print("Vous ne possedez pas cette carte, veuillez en choisir une autre")
		choix_carte = joueur2.main.recupererCarte(type : choisirTypeCarte())
		}
		guard let c:Carte = choix_carte else {fatalError("Carte vide")}
		joueurActuel.deployerCarte(carte : c,cord : cord)
		print("carte deployee !")
	}
	tour = tour+1
}

print(joueurGagnant.nom+" est le gagnant de la partie !")
	























