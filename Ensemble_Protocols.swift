import Foundation









enum etatCarte{
    case Offensif,Defensif
}
// enumeration permettant de connaitre le rôle d'un carte existante
enum uniteCarte{
    case Garde,Soldat,Archer,Roi
}







































struct Coordonnee {
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
		if(chp.plateau[self.x][self.y]==nil) {
			return nil
		}
		else {
			return chp.plateau[self.x][self.y]
		}
    }
}








































class Joueur  {
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
        
        main.ajouterCarte(carte : Sommet(self.pioche))
        pioche.supprimerCarte()
    }
    
    func peutAttaquer()->Bool {
        for carte in self.champ_de_bataille.plateau {
            if carte != [nil] {
		var etat:etatCarte
		etat=Offensif
                if carte.etat == etat {
                    return True
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
        carte.changerEtat(etat : Defensif)
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
		if carteAttaquante.recupererEtat() == Offensif {
			fatalError("On veut attaquer avec une carte déjà en posiion offensive")
		}
		carteAttaquante.changerEtat(etat:Offensif)
		if carteAttaque.recupererEtat() == Defensif {
			var AttaqueDefense : Int = carteAttaquante.recupererDefDefensive()
		}
		else {
			var AttaqueDefense : Int = carteAttaquante.recupererDefOffensive()
		}
		if carteAttaquante.recupererAttaque == AttaqueDefense {
			self.capturer(joueuradverse : joueuradverse , carte : carteAttaque)		
			return true
		}
		else if (carteAttaquante.recupererAttaque > AttaqueDefense || carteAttaquante.recupererAttaque > carteAttaque.recupererSante) {
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
			carteAttaquante.diminuerSante(attaque : carteAttaquante.recupererAttaque)
			return false
		}
	 }
	 
	 
	
    func demobiliser(carte : Carte) {
        if self.main.estVide() {
            fatalError("On veut demobiliser une main avec une main vide")
        }
        //il faudrait vérifier que la carte est bien dans la main mais il faut donc rajouter une fonction dans le type Main
        self.royaume.ajouterCarte(carte : Carte)
        self.main.enleverCarte(carte : carte)
    }
	
	private func position_portee(position : Coordonnee, portee : Portee) -> Coordonnee? {
		var cord : Coordonnee
		switch (position) {
			case (position.positionX()==0 && position.positionY()==0) :
				switch (portee) {
					case (portee.positionY()<1) :
						return nil
					case (portee.positionX()==-2 && portee.positionY()==1 ) :
						return nil
					case (portee.positionX()==-1 && portee.positionY()==1 ) :
						return nil
					case (portee.positionX()==0 && portee.positionY()==1 ) :
						cord=Coordonnee(x:2 , y:0)
						return cord
					case (portee.positionX()==1 && portee.positionY()==1 ) :
						cord=Coordonnee(x:1 , y:0)
						return cord
					case (portee.positionX()==2 && portee.positionY()==1 ) :
						cord=Coordonnee(x:0 , y:0)
						return cord
					case (portee.positionX()==-2 && portee.positionY()==2 ) :
						return nil
					case (portee.positionX()==-1 && portee.positionY()==2 ) :
						return nil
					case (portee.positionX()==0 && portee.positionY()==2 ) :
						cord=Coordonnee(x:2 , y:1)
						return cord
					case (portee.positionX()==1 && portee.positionY()==2 ) :
						cord=Coordonnee(x:1 , y:1)
						return cord
					case (portee.positionX()==2 && portee.positionY()==2 ) :
						cord=Coordonnee(x:0 , y:1)
						return cord
						
				}
			case (position.positionX()==1 && position.positionY()==0) :
				switch (portee) {
					case (portee.positionY()<1) :
						return nil
					case (portee.positionX()==-2 && portee.positionY()==1 ) :
						return nil
					case (portee.positionX()==-1 && portee.positionY()==1 ) :
						cord=Coordonnee(x:2 , y:0)
						return cord
					case (portee.positionX()==0 && portee.positionY()==1 ) :
						cord=Coordonnee(x:1 , y:0)
						return cord
					case (portee.positionX()==1 && portee.positionY()==1 ) :
						cord=Coordonnee(x:0 , y:0)
						return cord
					case (portee.positionX()==2 && portee.positionY()==1 ) :
						return nil
					case (portee.positionX()==-2 && portee.positionY()==2 ) :
						return nil
					case (portee.positionX()==-1 && portee.positionY()==2 ) :
						cord=Coordonnee(x:2 , y:1)
						return cord
					case (portee.positionX()==0 && portee.positionY()==2 ) :
						cord=Coordonnee(x:1 , y:1)
						return cord
					case (portee.positionX()==1 && portee.positionY()==2 ) :
						cord=Coordonnee(x:0 , y:1)
						return cord
					case (portee.positionX()==2 && portee.positionY()==2 ) :
						return nil	
				}
			case (position.positionX()==2 && position.positionY()==0) :
				switch (portee) {
					case (portee.positionY()<1) :
						return nil
					case (portee.positionX()==-2 && portee.positionY()==1 ) :
						cord=Coordonnee(x:2 , y:0)
						return cord
					case (portee.positionX()==-1 && portee.positionY()==1 ) :
						cord=Coordonnee(x:1 , y:0)
						return cord
					case (portee.positionX()==0 && portee.positionY()==1 ) :
						cord=Coordonnee(x:0 , y:0)
						return cord
					case (portee.positionX()==1 && portee.positionY()==1 ) :
						return nil
					case (portee.positionX()==2 && portee.positionY()==1 ) :
						return nil
					case (portee.positionX()==-2 && portee.positionY()==2 ) :
						cord=Coordonnee(x:2 , y:1)
						return cord
					case (portee.positionX()==-1 && portee.positionY()==2 ) :
						cord=Coordonnee(x:1 , y:1)
						return cord
					case (portee.positionX()==0 && portee.positionY()==2 ) :
						cord=Coordonnee(x:0 , y:1)
						return cord
					case (portee.positionX()==1 && portee.positionY()==2 ) :
						return nil
					case (portee.positionX()==2 && portee.positionY()==2 ) :
						return nil
						
				}
			case (position.positionX()==0 && position.positionY()==1) :
				switch (portee) {
					case (portee.positionY()<2) :
						return nil
					case (portee.positionX()==-2 && portee.positionY()==2 ) :
						return nil
					case (portee.positionX()==-1 && portee.positionY()==2 ) :
						return nil
					case (portee.positionX()==0 && portee.positionY()==2 ) :
						cord=Coordonnee(x:2 , y:0)
						return cord
					case (portee.positionX()==1 && portee.positionY()==2 ) :
						cord=Coordonnee(x:1 , y:0)
						return cord
					case (portee.positionX()==2 && portee.positionY()==2 ) :
						cord=Coordonnee(x:0 , y:0)
						return cord	
				}
			case (position.positionX()==1 && position.positionY()==1) :
				switch (portee) {
					case (portee.positionY()<2) :
						return nil
					case (portee.positionX()==-2 && portee.positionY()==2 ) :
						return nil
					case (portee.positionX()==-1 && portee.positionY()==2 ) :
						cord=Coordonnee(x:2 , y:0)
						return cord
					case (portee.positionX()==0 && portee.positionY()==2 ) :
						cord=Coordonnee(x:1 , y:0)
						return cord
					case (portee.positionX()==1 && portee.positionY()==2 ) :
						cord=Coordonnee(x:1 , y:0)
						return cord
					case (portee.positionX()==2 && portee.positionY()==2 ) :
						return nil
				}
			case (position.positionX()==2 && position.positionY()==1) :
				switch (portee) {
					case (portee.positionY()<2) :
						return nil
					case (portee.positionX()==-2 && portee.positionY()==2 ) :
						cord=Coordonnee(x:2 , y:0)
						return cord
					case (portee.positionX()==-1 && portee.positionY()==2 ) :
						cord=Coordonnee(x:1 , y:0)
						return cord
					case (portee.positionX()==0 && portee.positionY()==2 ) :
						cord=Coordonnee(x:0 , y:0)
						return cord
					case (portee.positionX()==1 && portee.positionY()==2 ) :
						return nil
					case (portee.positionX()==2 && portee.positionY()==2 ) :
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
        
        unites = []
        champ_de_bataille_adverse = joueuradverse.recupererChampDeBataille()
        champ_de_bataille = self.champ_de_bataille
        
        for i in 0 ... 1 {
            for j in 0 ... 2 {
                position = Coordonnee(x:j,y:i)
                if !champ_de_bataille_adverse.positionLibre(cord:position) {
                    carte = champ_de_bataille.plateau[i][j];
                    if unitePouvantAttaquer(joueuradverse : joueuradverse, carte : carte)!=[]{
                        unites.append(champ_de_bataille_adverse.plateau[i][j])
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









































//Definition de la structure Portee, qui correspond a la portee d'une carte. (0,0) correspond a la carte elle meme.
import Foundation



class RoyaumeIterator {
    var royaume : Royaume
    var i : Int = 0

    init(main: Main) {
        self.royaume = royaume
    }

    func next() -> Carte? {
    	let liste = self.royaume
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
	var royaume : [Carte]?
   
   
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
		var trouve : Bool = True
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
		return MainIterator(royaume:self)
	}
	
}










































class Carte: {
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
		self.sante=self.defDefensive = defDefensive
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
    
	func recupererdefDefensive()->Inr{
        return self.defDefensive
    }
	
	func recupererdefOffensive()->Inr{
        return self.defOffensive
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
	func recupererAttaque(){
		return self.attaque
	}
	
	//Rajouté des spécifs
	func recupererDefDefenseive(){
		return self.defDefensive
	}
	
	//Rajouté des spécifs
	func recupererDefOffenseive(){
		return self.defOffensive
	}
}







































class ChampIterator  {
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


class ChampDeBataille {
    var plateau: [[Carte?]] = [[nil,nil,nil],[nil,nil,nil]]
    
    init() {
        
    }
    
    func makeIterator() -> Self{
        return ChampIterator(plateau:Self)
    }
    
    func positionLibre(cord : Coordonnee)->Bool{
        return plateau[cord.positionY()][cord.positionX()]==nil
    }
    
    func insererCarte(carte : Carte, cord : Coordonnee) {
        if !positionLibre(cord){
            fatalError("Insertion sur une carte non vide")
        }
        self.plateau[cord.positionY()][cord.positionX()] = carte
    }
    
    func supprimerCarte(cord : Coordonnee) {
        if positionLibre(cord){
            fatalError("Suppression d'une case vide")
        }
        self.plateau[cord.positionY()][cord.positionX()] = nil
    }
    
    func avancerCarte(cord : Coordonnee) {
        if cord.positionY() == 0 {
            fatalError("On essaie d'avancer une carte en position avant")
        }
        cordFinale = Coordonnee(x : cord.positionX(), y : cord.positionY()-1)
        if !positionLibre(cordFinale){
            fatalError("On essaie d'avancer une carte sur une position non libre")
        }
        var tmp : Carte = self.plateau[cord.positionY()][cord.positionX()]
        self.plateau[cord.positionY()][cord.positionX()] = nil
        self.plateau[cord.positionY()-1][cord.positionX()] = tmp
    }
    
    func recupererPosition(carte : Carte)->Coordonnee {
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
                    return False
                }
            }
        }
        return True
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









































class MainIterator  {
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



class Main  {
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
		if self.main==nil {
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












































class PiocheIterator  {
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
struct Pioche :  {
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

    







