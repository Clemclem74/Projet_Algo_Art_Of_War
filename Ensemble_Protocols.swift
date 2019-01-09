//
import Foundation

class Carte: CarteProtocol{
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
    
    mutating func changerEtat(etat: etatCarte){
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
	mutating func diminuerSante(attaque : Int){
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


























// enumeration permettant de connaitre le statut d'une carte
public enum etatCarte{
    case Offensif,Defensif
}
// enumeration permettant de connaitre le rôle d'un carte existante
public enum uniteCarte{
    case Garde,Soldat,Archer,Roi
}

//TYPE carte contient toutes les informations d'une carte pour une utilisation en jeu. Identifiant,point d'attaque, points de défense
public protocol CarteProtocol{
    associatedtype Coordonnees : PorteeProtocol
    init()

    // init : Int x Int x Int x etatCarte x uniteCarte x [Coordonnees] -> Carte
    // Création d'une carte avec une valeur d'attaque, de défense défensive, de défense offensive, la liste des coordonnées relatives représentant la portée (case qu'il peut attaquer), son unité, il y a également une variable représentant la vie restante d'une unite permettant de voir la vie restant d'une carte après une attaque, qui sera reinitialisé en fin de tour de jeu
    // pre : l'id ne doit pas être négatif, l'id doit être unique pour chaque carte,la valeur d'attaque ne doit pas être négative, la valeur de défense Defensive ne doit pas être negative, la valeur de      défense Offensive ne doit pas être négative
    init(id : Int, attaque : Int, defDefensive : Int, defOffensive : Int, etat : etatCarte, unite : uniteCarte, portee : [Coordonnees])

    // changerEtat : etatCarte
    // etat : l'état de la carte
    // Permet le changement d'état d'une carte (de defensif à offensif et inversement)
    mutating func changerEtat(etat : etatCarte)


    //recupererUnite : -> UniteCarte
    //retourne l'unité de la carte
    func recupererUnite()->uniteCarte


    // recupererIdCarte : Id
    // retourne l'id de la carte
    func recupererIdCarte()->Int
}



































import Foundation
class ChampDeBataille: ChampDeBatailleProtocol {
    var plateau: [[Carte?]] = [[Vide,Vide,Vide],[Vide,Vide,Vide]]
    
    init() {
        
    }
    
    func positionLibre(cord : Coordonnees)->Bool{
        return plateau[cord.positionY()][cord.positionX()]==Vide
    }
    
    mutating func insererCarte(carte : Carte, cord : Coordonnes) {
        if !positionLibre(cord){
            fatalError("Insertion sur une carte non vide")
        }
        self.plateau[cord.positionY()][cord.positionX()] = carte
    }
    
    mutating func supprimerCarte(cord : Coordonnees) {
        if positionLibre(cord){
            fatalError("Suppression d'une case vide")
        }
        self.plateau[cord.positionY()][cord.positionX()] = Vide
    }
    
    mutating func avancerCarte(cord : Coordonnees) {
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



































import Foundation
// Type ChampDeBataille est une collection de positions contenant des cartes
//(0,0) correspond à F1
public protocol ChampDeBatailleProtocol : Sequence {
  associatedtype Carte: CarteProtocol
    associatedtype Coordonnees: CoordonneesProtocol
	associatedtype ChampIteratorProtocol : IteratorProtocol
	where ChampIteratorProtocol.Element == CarteProtocol


  // init:
  // initialisé à vide
  init()

  //insererCarte : ChampDeBataille x Carte x Int x Int
  //pre: la case de doit pas être deja occupé
  //post: une carte est ajouté sur le terrain
    mutating func insererCarte(carte: Carte, cord : Coordonnees)

  //supprimerCarte : ChampDeBataille Int x Int
  //pre: la case de doit pas être vide
  //post: une carte est supprimé du champ de bataille
  mutating func supprimerCarte(cord : Coordonnees)

  //avancerCarte : ChampDeBataille Int x Int
  //les coordonnées en paramètre correspondent aux coordonnée actuel de la carte
  //pre: la carte doit être en position arrière, et la position devant elle doit être libre(vide)
  //post: une carte est avancé au front
  mutating func avancerCarte(cord : Coordonnees)

  //positionLibre: Int x Int -> Bool
  //les paramètres sont des int correspondant à des coordonnées
  //retourne vrai si les coordonnées ne sont pas prise par une carte, faux sinon
  func positionLibre(cord : Coordonnees)->Bool

  //recupererPositionX : Carte -> Int
  //pre: la carte doit exister dans le champ de bataille
  //post: retour de la position X de la carte
  func recupererPositionX(carte : Carte)->Int

  //recupererPositionY: Carte -> Int
  //pre: la carte doit exister dans le champ de bataille
  //post: retour de la position Y de la carte
  func recupererPositionY(carte : Carte)->Int

  // champDeBatailleVide : -> Bool
  // Regarde si il y des cartes sur le champ de bataille
  // Retourne true si la champ de bataille est rempli de nil
  func champDeBatailleEstVide()->Bool


  // makeIterator : ChampBatailleProtocol -> MainIteratorProtocol
  // crée un itérateur sur la collection pour itérer avec for in
  func makeIterator()->ChampIteratorProtocol
}

public protocol ChampIteratorProtocol : IteratorProtocol{

}



































//
import Foundation



class Cimetiere: Sequence{
    fileprivate var cimetiere:[Carte]
    init(){
        cimetiere=[]
    }
    
    
    mutating func ajouterCarte(carte : Carte){
        self.cimetiere.append(carte)
    }
    
    func nombreOccurence()->Int{
        return self.cimetiere.count
    }
    
    func estVide()->Bool{
        return self.cimetiere.isEmpty
    }
    
    
}





























import Foundation
// Type Cimetiere contient une liste de carte, pouvant etre parcouru par un itérateur
public protocol CimetiereProtocol : Sequence {
  associatedtype Carte: CarteProtocol
  associatedtype CimetiereIteratorProtocol : IteratorProtocol
  where CimetiereIteratorProtocol.Element == CarteProtocol


  // ajouterCarte : Carte
  // carte : la carte à ajouter sur dans le cimetière
  // pre : la carte ajoutée ne doit pas déja être présente dans le cimetière
  // ajouter un carte au cimetière
  mutating func ajouterCarte(carte : Carte)

  // nombreOccurence:
  // calcule le nombre de carte dans le cimetière
  // retourne le nombre de carte présent dans le cimetière
  func nombreOccurence()->Int

  // estVide:
  // retourne vrai si le cimetiere est vide
  func estVide()->Bool

  // makeIterator : Cimetier -> CimetiereIteratorProtocol
  // crée un itérateur sur la collection pour itérer les cartes
  func makeIterator()->CimetiereIteratorProtocol


}

public protocol CimetiereIteratorProtocol : IteratorProtocol{
        associatedtype Carte: CarteProtocol
	func next()->Carte?
}





























import Fondation


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
		if(chp.plateau[self.x][self.y]==Vide {
			return Vide
		}
		else {
			return chp.plateau[self.x][self.y]
		}
    }
    
    
}





























// Coordonnee (0,0) correspond à la position F1
// Type Coordonnees est un couple de coodonnées représentant la position de la carte sur un champ de bataille
public protocol CoordonneeProtocol {
    associatedtype Carte: CarteProtocol
    // init : Int x Int
    // Création d'un couple de coordonnées x et y
    init(x : Int, y : Int)

    //positionX : ->Int
    //retourne la position X d'une coordonnée
    func positionX()->Int
    //retourne la position Y d'une coordonnée
    func positionY()->Int

    //retournerCarte : ->Carte ?
    //retourne la carte associée à la coordonnée, retourne vide si il y en a pas
    func retournerCarte()->Carte?

    //lierCarte : Coordonnee x Carte
    //lie une carte à une coordonnée
    func lierCarte(carte : Carte){
		
	}

}



































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
	
	privatefunc position_portee(position : Coordonnees, portee : Portee) -> Coordonnees? {
		var cord : Coordonnees
		switch (position) {
			case (position.positionX()==0 && position.positionY()==0) :
				switch (portee) {
					case (portee.positionY()<1) :
						return Vide
					case (portee.positionX()==-2 && portee.positionY()==1 ) :
						return Vide
					case (portee.positionX()==-1 && portee.positionY()==1 ) :
						return Vide
					case (portee.positionX()==0 && portee.positionY()==1 ) :
						cord=Coordonnees(x:2 ; y:0)
						return cord
					case (portee.positionX()==1 && portee.positionY()==1 ) :
						cord=Coordonnees(x:1 ; y:0)
						return cord
					case (portee.positionX()==2 && portee.positionY()==1 ) :
						cord=Coordonnees(x:0 ; y:0)
						return cord
					case (portee.positionX()==-2 && portee.positionY()==2 ) :
						return Vide
					case (portee.positionX()==-1 && portee.positionY()==2 ) :
						return Vide
					case (portee.positionX()==0 && portee.positionY()==2 ) :
						cord=Coordonnees(x:2 ; y:1)
						return cord
					case (portee.positionX()==1 && portee.positionY()==2 ) :
						cord=Coordonnees(x:1 ; y:1)
						return cord
					case (portee.positionX()==2 && portee.positionY()==2 ) :
						cord=Coordonnees(x:0 ; y:1)
						return cord
						
				}
			case (position.positionX()==1 && position.positionY()==0) :
				switch (portee) {
					case (portee.positionY()<1) :
						return Vide
					case (portee.positionX()==-2 && portee.positionY()==1 ) :
						return Vide
					case (portee.positionX()==-1 && portee.positionY()==1 ) :
						cord=Coordonnees(x:2 ; y:0)
						return cord
					case (portee.positionX()==0 && portee.positionY()==1 ) :
						cord=Coordonnees(x:1 ; y:0)
						return cord
					case (portee.positionX()==1 && portee.positionY()==1 ) :
						cord=Coordonnees(x:0 ; y:0)
						return cord
					case (portee.positionX()==2 && portee.positionY()==1 ) :
						return Vide
					case (portee.positionX()==-2 && portee.positionY()==2 ) :
						return Vide
					case (portee.positionX()==-1 && portee.positionY()==2 ) :
						cord=Coordonnees(x:2 ; y:1)
						return cord
					case (portee.positionX()==0 && portee.positionY()==2 ) :
						cord=Coordonnees(x:1 ; y:1)
						return cord
					case (portee.positionX()==1 && portee.positionY()==2 ) :
						cord=Coordonnees(x:0 ; y:1)
						return cord
					case (portee.positionX()==2 && portee.positionY()==2 ) :
						return Vide	
				}
			case (position.positionX()==2 && position.positionY()==0) :
				switch (portee) {
					case (portee.positionY()<1) :
						return Vide
					case (portee.positionX()==-2 && portee.positionY()==1 ) :
						cord=Coordonnees(x:2 ; y:0)
						return cord
					case (portee.positionX()==-1 && portee.positionY()==1 ) :
						cord=Coordonnees(x:1 ; y:0)
						return cord
					case (portee.positionX()==0 && portee.positionY()==1 ) :
						cord=Coordonnees(x:0 ; y:0)
						return cord
					case (portee.positionX()==1 && portee.positionY()==1 ) :
						return Vide
					case (portee.positionX()==2 && portee.positionY()==1 ) :
						return Vide
					case (portee.positionX()==-2 && portee.positionY()==2 ) :
						cord=Coordonnees(x:2 ; y:1)
						return cord
					case (portee.positionX()==-1 && portee.positionY()==2 ) :
						cord=Coordonnees(x:1 ; y:1)
						return cord
					case (portee.positionX()==0 && portee.positionY()==2 ) :
						cord=Coordonnees(x:0 ; y:1)
						return cord
					case (portee.positionX()==1 && portee.positionY()==2 ) :
						return Vide
					case (portee.positionX()==2 && portee.positionY()==2 ) :
						return Vide
						
				}
			case (position.positionX()==0 && position.positionY()==1) :
				switch (portee) {
					case (portee.positionY()<2) :
						return Vide
					case (portee.positionX()==-2 && portee.positionY()==2 ) :
						return Vide
					case (portee.positionX()==-1 && portee.positionY()==2 ) :
						return Vide
					case (portee.positionX()==0 && portee.positionY()==2 ) :
						cord=Coordonnees(x:2 ; y:0)
						return cord
					case (portee.positionX()==1 && portee.positionY()==2 ) :
						cord=Coordonnees(x:1 ; y:0)
						return cord
					case (portee.positionX()==2 && portee.positionY()==2 ) :
						cord=Coordonnees(x:0 ; y:0)
						return cord	
				}
			case (position.positionX()==1 && position.positionY()==1) :
				switch (portee) {
					case (portee.positionY()<2) :
						return Vide
					case (portee.positionX()==-2 && portee.positionY()==2 ) :
						return Vide
					case (portee.positionX()==-1 && portee.positionY()==2 ) :
						cord=Coordonnees(x:2 ; y:0)
						return cord
					case (portee.positionX()==0 && portee.positionY()==2 ) :
						cord=Coordonnees(x:1 ; y:0)
						return cord
					case (portee.positionX()==1 && portee.positionY()==2 ) :
						cord=Coordonnees(x:1 ; y:0)
						return cord
					case (portee.positionX()==2 && portee.positionY()==2 ) :
						return Vide
				}
			case (position.positionX()==2 && position.positionY()==1) :
				switch (portee) {
					case (portee.positionY()<2) :
						return Vide
					case (portee.positionX()==-2 && portee.positionY()==2 ) :
						cord=Coordonnees(x:2 ; y:0)
						return cord
					case (portee.positionX()==-1 && portee.positionY()==2 ) :
						cord=Coordonnees(x:1 ; y:0)
						return cord
					case (portee.positionX()==0 && portee.positionY()==2 ) :
						cord=Coordonnees(x:0 ; y:0)
						return cord
					case (portee.positionX()==1 && portee.positionY()==2 ) :
						return Vide
					case (portee.positionX()==2 && portee.positionY()==2 ) :
						return Vide
				}
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
	
	func ciblesDisponible(joueuradverse : Joueur)->[Carte]{
        
        var unites: [Carte]
        var champ_de_bataille_adverse : ChampDeBataille
        var champ_de_bataille : ChampDeBataille
        
        unites = []
        champ_de_bataille_adverse = joueuradverse.recupererChampDeBataille()
        champ_de_bataille = self.champ_de_bataille
        
        for i in 0 ... 1 {
            for j in 0 ... 2 {
                position = Coordonnees(x:j,y:i)
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
        var position_carte : Coordonnees
        var carte_attaquante : Carte
        var portee: Portee
        var unites: [Carte]
        var position:Coordonnees
        
        unites = []
        champ_de_bataille_adverse = joueuradverse.recupererChampDeBataille()
        position_carte = champ_de_bataille_adverse.recupererPosition(carte : carte)
        champ_de_bataille = self.champ_de_bataille
        
        for i in 0 ... 1 {
            for j in 0 ... 2 {
                position = Coordonnees(x:j,y:i)
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




































//Type Joueur contenant une liste représentant son champ de bataille et d'autres élements utile pour une partie
public protocol JoueurProtocol{
    associatedtype Carte: CarteProtocol
    associatedtype ChampDeBataille: ChampDeBatailleProtocol
    associatedtype Joueur: CarteProtocol
    //permet de récuperer le nom du joueur
    var nom : String {get set}
    
    // init : -> Joueur
    // Création d'un Joueur, initalisé avec une pioche mélangée, une main possédant 1 roi + 3 cartes (qui seront pioché dans la pioche genéré),
    // un royaume de carte vide, un champ de bataille sous forme de tableau "2D" vide et un cimetière de carte vide.
    init(nom: String)
    init()

    // piocher :
    // Récupère la première carte dans la pioche et la met dans la main en la supprimant de la pioche
    // pre : la pioche ne doit pas être vide
    // post : la main a une carte en plus
    mutating func piocher()

    // peutAttaquer :
    // Permet de savoir si le joueur a au moins une de ses unités en position défensive
    // post : retourne vrai si le joueur peut attaquer, retourne faux sinon
    func peutAttaquer()->Bool

    // compterCarteChampDeBataille : -> Int
    // Compte le nombre de carte sur le champ de bataille
    // Retourne le nombre de carte sur le champ de bataille
    func compterCarteChampDeBataille()->Int

    // deployerCarte : Carte
    // pre : La main ne doit pas être vide
    // pre : X et Y sont les coordonnées sur laquelle la carte va être placé, il ne doit pas y avoir de carte sur ces coordonnées et doit pointer sur le champ de bataille (pas en dehors)
    // post : La carte est supprimé de la main
    mutating func deployerCarte(carte : Carte, x: Int, y: Int)

    // recupererChampDeBataille : -> ChampDeBataille
    // un joueur est placé en paramètre, cella permet de récuperer son camp de champ de bataille
    // renvoie le champ de bataille
    func recupererChampDeBataille()->ChampDeBataille

    // avancerCarte : Carte
    // Avance une carte positionnée en arrière sur le front correspondant
    // pre : La carte doit être sur une position d'arrière et ne pas avoir de carte devant elle
    // note: Cette fonction est appelé quand un carte du "front" est amené au cimetière, la carte du "fond" est donc amené l'avant
    mutating func avancerCarte(carte : Carte)

    // attaquer : Carte x Coordonnees
    // Attaque une carte ennemie avec une carte du champ de bataille
    // carteAttaquante : la carte attanquante
    // carteAttaque : la carte attaquée
    // Retourne true si la carte adverse est tuée ou capturée, false sinon
    mutating func attaquer(carteAttaquante : Carte, carteAttaque : Carte)->Bool

    // demobiliser : Carte
    // Place une carte dans le royaume en la supprimant de la main
    // pre : la main ne doit pas être vide
    mutating func demobiliser(carte : Carte)

    // capturer : Carte
    // Place une carte ennemie dans le royaume
    mutating func capturer(carte : Carte)


    // ciblesDisponible : Joueur ->[Carte]
    // Calcul les cartes que le joueur peut attaquer
    // joueur : joueur adverse
    // Retourne la liste des cartes disponible à l'attaque, carte qui seront rangées dans l'ordre correspondant à la fonction "afficherCibleDisponibles()"
    func ciblesDisponible(joueur : Joueur)->[Carte]

    // UnitePouvantAttaquer : Carte -> [Carte]
    // Calcul les cartes que le joueur peut utiliser pour attaquer une carte adversaire donnée en paramètre et les place dans un tableau
    // carte : la carte ciblée
    // Retourne la liste des cartes que le joueur peut utiliser, sur leur position respective
    func unitePouvantAttaquer(carte : Carte)->[Carte]

}



































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
   
   
   init(numeoRoi : Int){
		var ensemble_cord : [Coordonnees]=[]
        var coord = Coordonnees(x : -2 , y : 1)
        ensemble_cord.append(coord)
		coord = Coordonnees(x : -1 , y : 1)
        ensemble_cord.append(coord)
		coord = Coordonnees(x : 0 , y : 1)
        ensemble_cord.append(coord)
		coord = Coordonnees(x : 1 , y : 1)
        ensemble_cord.append(coord)
		coord = Coordonnees(x : 2 , y : 1)
        ensemble_cord.append(coord)
		if numeoRoi == 1 {
			coord = Coordonnees(x : 0 , y : 2)
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

    








	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
import Foundation
// Type Main contient une liste de carte et est parcourru par un itérateur
public protocol MainProtocol : Sequence {
  associatedtype Carte: CarteProtocol
	associatedtype MainIteratorProtocol : IteratorProtocol
	where MainIteratorProtocol.Element == CarteProtocol
 

  // init:
  // doit créer une liste contenant un Roi (à définir parmis les 2 disponible)
  init()

  // recupererCarte: Int -> Carte
  // type : recuperer un type de carte
  // permet de récuperer la n-ième carte d'une main
  // cette fonction retourne une carte
  // post : une carte est retourné
  func recupererCarte(type : uniteCarte)->Carte

  // ajouterCarte : Carte
  // permet d'ajouter une carte dans la main d'un joueur
  // carte : carte à ajouter dans la main
  // pre : on ne peut pas ajouter une carte qui est deja présente dans la main
  // post : ajoute une carte à la liste
  mutating func ajouterCarte(carte : Carte)

  // enleverCarte : Carte
  // permet d'enlever une carte de la main d'un joueur
  // carte : la carte à enlever de la main
  // pre : la carte doit être présente dans la main
  // post : la carte est enlevée de la liste de carte de la main
  // note : la liste de carte ne doit pas être vide pour permettre la suppression d'une carte
  mutating func enleverCarte(carte : Carte)

  // recupererMain -> [Carte]?
  // retourne : une chaine de caractère correspondant au carte
  // pre : la main ne doit pas être vide
  // fonction retournant un string correspondant au nom des cartes (avec numéro pour selection via input) présentes dans la main
  // note : faire en sorte de permettre au joueur de choisir parmis les cartes en rendant l'affichage le plus intuitif et visible possible
  func recupererMain()->[Carte]?

  // nombreOccurence -> Int
  // permet de calculer le nombre de carte présent dans la main d'un joueur
  // post : retourne un nombre correspondant au nombre de carte dans la main
  func nombreOccurence()->Int

  // estVide : -> Bool
  // retourne vrai si la main est vide
  func estVide()->Bool

  // makeIterator : MainProtocol -> MainIteratorProtocol
  // crée un itérateur sur la collection pour itérer avec for in
  func makeIterator()->MainIteratorProtocol
}

public protocol MainIteratorProtocol : IteratorProtocol{
    associatedtype Carte: CarteProtocol
    func next()->Carte?
}






































import Foundation
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
        var ensemble_cord : [Coordonnees]=[]
        var coord = Coordonnees(x : 0 , y : 1)
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
        
        coord = Coordonnees(x : -2 , y : 1)
        ensemble_cord[0] = coord
        coord = Coordonnees(x : -1 , y : 2)
        ensemble_cord.append(coord)
        coord = Coordonnees(x : 1 , y : 2)
        ensemble_cord.append(coord)
        coord = Coordonnees(x : 2 , y : 1)
        ensemble_cord.append(coord)
       
        for i in 18 ... 22 {
            carte = Carte(id : i , attaque : 1 , defDefensive : 2 , defOffensive : 1 , etat : Defensif , unite : Archer , portee : ensemble_cord)
            self.pioche.empiler(carte : carte)
        }
    }
    
    mutating func supprimerCarte(){
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
    
    
    mutating func melangerPioche()
        var tmp : [Piece] = []
        while !estVide() {
            tmp.append(Sommet(pioche : self.pioche))
            Depiler(pioche : self.pioche)
        }
        tmp.shuffle()
        for i in 0 ... tmp.count-1 {
            Empiler(pioche : self.pioche , carte : tmp[i])
        }    
 }


fileprivate class PilePiocheNV {
    var val : Carte 
    var suiv : PilePioche 
    var nb : Int
    
    init(carte : Carte, suiv : Pile = nil){
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


mutating func Empiler(pioche : PilePioche , carte : Carte){
    pioche.nb = pioche.nb + 1
    return = PilePiocheNV(carte : carte, suiv : pioche) 
}

mutating func Depiler(pioche : PilePioche) {
    guard let p = pioche else {
        fatalError("Erreur depile une pile vide")
    }
    pioche.nb = pioche.nb - 1
    return p.suiv
}

    








	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

	

import Foundation
// Type Pioche contient une liste de carte et un itérateur permettant de la parcourir
public protocol PiocheProtocol : Sequence {

  associatedtype Carte: CarteProtocol
	associatedtype PiocheIteratorProtocol : IteratorProtocol
	where PiocheIteratorProtocol.Element == CarteProtocol

  // melangerPioche :
  // Mélange la pioche du joueur
  // post : les cartes ont un ordre différent dans la liste
  mutating func melangerPioche()

  // supprimerCarte:
  // Supprime la première carte de la pioche
  // post : supprime la derniere carte de la pioche
  // notes : la pioche ne doit pas être vide sinon renvoie une erreur
  mutating func supprimerCarte()

  // nombreOccurence:
  // calcul le nombre de carte dans une pioche
  // post : retourne le nombre de carte présent dans la pioche même si le nombre d'occurence est 0
  func nombreOccurence()->Int

  // init:
  // la pioche doit être initialisée avec les 20 cartes (aucun roi) dont 9 Soldats,6 Gardes, 5 Archers
  init()

  // estVide()
  // retourne vrai si la pioche est vide
  func estVide()->Bool

  // makeIterator : PiocheProtcol -> PiocheIteratorProtocol
  // crée un itérateur sur la collection pour itérer avec for in
  func makeIterator()->PiocheIteratorProtocol

}

public protocol PiocheIteratorProtocol : IteratorProtocol{
    associatedtype Carte: CarteProtocol
    func next()->Carte?
}







































//Definition de la structure Portee, qui correspond a la portee d'une carte. (0,0) correspond a la carte elle meme.
import Foundation

struct Portee: PorteeProtocol{
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






































// portee(0,0) correspond aux coordonnées de la carte
// Type Coordonnees est un couple de coodonnées RELATIVES à une carte servant à definir la portée d'attaque d'une carte
public protocol PorteeProtocol {
    // init : Int x Int
    // Création d'un couple de coordonnées x et y relative par rapport aux joueurs

    init(x : Int, y : Int)

}



































//Definition de la structure Portee, qui correspond a la portee d'une carte. (0,0) correspond a la carte elle meme.
import Foundation



class RoyaumeIterator : IteratorProtocol {
    var royaume : Royaume
    var i : Int = 0

    init(main: Main) {
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





class Royaume : Sequence{
	var royaume : [Cartes]?
   
   
	init() {
		royaume = []
	}
   
	func (ajouterCarte : Carte){
		self.royaume.append(Carte)
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
		if self.royaume == Vide {
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





































import Foundation
// Type Royaume contient une liste de Carte , un itérateur permet de parcourir cette liste
public protocol RoyaumeProtocol : Sequence {
  associatedtype Carte: CarteProtocol
  associatedtype RoyaumeIteratorProtocol : IteratorProtocol
  where RoyaumeIteratorProtocol.Element == CarteProtocol

  // le Royaume est initialisé avec une liste de carte vide représentant son peuple
  init()

  // ajouterCarte : Carte
  // ajoute un carte au royaume à la fin de la liste
  // pre : la carte ne doit pas déja être présente dans le royaume
  mutating func ajouterCarte(carte : Carte)

  // nombreOccurence ->Int
  // compte le nombre de carte présent dans un royaume et renvoie la donnée
  func nombreOccurence()->Int 

  // enleverCarte: -> Carte
  // precondition: le royaume ne doit pas être vide
  // permet d'enlever la première carte d'un royaume si celui-ci n'est pas vide, dans le cas contraire affiche un message,
  // retourne la carte supprimée qui va être posée sur le champ de bataille
  mutating func enleverCarte()->Carte

  // estVide: ->Bool
  // retourne vrai si le royaume est vide
  // notes: va être utilisé pour la verification de victoire
  func estVide()->Bool

  // makeIterator : RoyaumeProtocol -> RoyaumeIteratorProtocol
  // crée un itérateur sur la collection pour itérer avec for in
  func makeIterator()->RoyaumeIteratorProtocol
}

public protocol RoyaumeIteratorProtocol : IteratorProtocol{
    associatedtype Carte: CarteProtocol
    func next()->Carte?
}













































/* ------- Programme Main ------- */
import Protocols

//afficherChampBataile : Joueur
//permet d'afficher le camp d'un joueur
func afficherChampBataile(joueur: Joueur){
	var champ = joueur.recupererChampDeBataille()

	while let element = champ.next(){
		print("carte :"+element.retournerCarte().recupererUnite()+"->["+element.positionX()+";"+element.positionY()+"]")
	}
}


//afficherMain : Joueur
//permet d'afficher la  main d'un joueur
func afficherMain(joueur: Joueur){
	var ligne = ""
	print("**********************************************")
	for i in 0...Joueur.main.nbOccurences()-1{

		if(Joueur.main.RecupererMain()[i] is Carte){
			ligne += ("-"+Joueur.main.recupererMain()[i].recupererUnite()+"(id:"+Joueur.main.recupererMain()[i].recupererIdCarte()+") -")
		}

	}
	print(ligne)
	print("********************************************")

}


//afficherUnites: [Carte]
//correspond a afficher graphiquement une liste de carte
func afficherUnites(unite: [Carte]){
	var ligne : String
	print("**********************************************")
	for(let i =0;i<unite.count;++i){

		if(unite[i] is Carte){
			ligne += ("-"+unite[i].recupererUnite()+"(id:"+unite[i].recupererIdCarte()+") -")
		}else{
			ligne += ("-"+"   "+"-")
		}

	}
	print(ligne)
	print("********************************************")

}

//permet de selectionner une coordonnée X et Y
func choisirCoordonneeXY(JoueurSelectionner: Joueur,X : inout Int, Y : inout Int){
	repeat{
		print("Choisissez une coordonnée X:")

		if let typed = readLine(){
			if let n = Int(typed){
				X = n
			}
		}

		print("Choisissez une coordonnée Y:")
		if let typed = readLine(){
			if let n = Int(typed){
				X = n
			}
		}

	}while(!(x < 3 && x >=0 && y < 2 && y>=0 && JoueurSelectionner.recupererChampDeBataille().positionLibre(x: X,y: Y)))
}


func choisirTypeCarte()->uniteCarte{
	print("choisissez entre : 1- Soldat 2- Archer 3- Garde")
	var choix = ""
	while(choix != "Soldat" || choix != "Archer" || choix != "Garde"){
		if let typed = readLine(){
				choix = typed

		} else {
			print("votre choix est incorrecte")
		}
	}

	var type : UniteCarte;
	if(choix=="Soldat"){
		type= UniteCarte.Soldat
	}
	else if(choix=="Archer"){
		type= UniteCarte.Archer

	else if(choix=="Garde"){
		type= UniteCarte.Garde
	}
	return type
}

/* Initialisation de la partie */
print("Joueur 1 : Veuillez saisir un nom pour votre joueur : ")
var choix : String

if let typed = readLine(){
	choix=typed
}
var joueur1 = JoueurProtocol(nom : choix)

print("Joueur 2 : Veuillez saisir un nom pour votre joueur : ")
if let typed = readLine(){
	choix=typed
}
var joueur2 = JoueurProtocol(nom : choix)

var joueurGagnant : JoueurProtocol
var partiFini = false

print("Joueur 1 : veuillez selectionner une carte à mettre au royaume")
afficherMain(joueur : joueur1)

joueur1.demobiliser(carte : joueur1.main.recupererCarte(type : choisirTypeCarte()))

print("mettre un carte au front")
afficherMain(joueur : joueur1)

choisirCoordonneeXY(JoueurSelectionner: joueur1,X : X, Y : Y)

joueur1.deployerCarte(carte : joueur1.main.recupererCarte(type : choisirTypeCarte()),x: X, y: Y)

print("Joueur 2 : veuillez selectionner (un numero) une carte à mettre au royaume")
afficherMain(joueur : joueur2)

joueur2.demobiliser(carte: joueur2.main.recupererCarte(type : choisirTypeCarte()))

print("mettre un carte au front")
print(afficherMain(joueur : joueur2))

choisirCoordonneeXY(JoueurSelectionner: joueur2,X : X, Y : Y)

joueur2.deployerCarte(joueur2.main.recupererCarte(type : choisirTypeCarte()),x: X, y: Y)





/* Boucle principale du jeu */
var tour=1
var joueurActuel : JoueurProtocol
var joueurAdverse : JoueurProtocol
var changerCible = false
var cibleMorte = false
var valide = false
var cibleDisponible : [Carte]
var unite : [Carte]
var pouvantAttaquer : [Carte]
var attaquer : Carte //carte qui est attaqué
var attaquant : Carte //Carte attaquante
var attaque : false //permettant de lancer une attaque
var X : Int //utilisé pour déployé une carte
var Y : Int //utilisé pour déployé une carte

while(!partiFini){
	if(tour%2 == 0){
		joueurActuel = joueur2 //attention le joueur doit être de type réference et non pas de type valeur !!!
		joueurAdverse = joueur1
		print("à toi de jouer joueur 2 !")

	} else {
		joueurActuel = joueur1
		joueurAdverse = joueur2
		print("à toi de joueur joueur 1 !")
	}

	/* Mise en position défensive de toutes les cartes du champ de bataille du joueur */
	for carte in joueurActuel.recupererChampDeBataille(joueurActuel){
		if carte is Carte{
            carte.changerEtat(etat: etatCarte.defensif)
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
	print(afficherChampBataile(joueur: joueurAdverse))
	print("votre main : ")
	afficherMain(joueur : joueurActuel)

	//phase action
	if let typed = readLine(){
		choix=typed
	}
	/* Choix de l'action à faire pour ce tour */
	print("Veuillez saisir une action à faire (attaquer / deployer / rien) : ")
	while(choix != "rien" || choix != "deployer" || choix != "attaquer"){
		print("saisi non valide, veuillez réitérer")
		if let typed = readLine(){
			choix = typed
		}
	}
	/* Choix de ne rien faire */
	if(choix == "rien"){
		print("vous decidez de passer votre tour")

	/* Choix d'attaquer l'adversaire */
	} else if (choix == "attaquer"){
	//-----------------------------------------------RAJOUTER REMPLISSAGE SANTE CARTES---------------------------------------------------------------------------------------------------------------------------
		attaque = true
		attaquer : CarteProtocol
		while(attaque){
	 		pouvantAttaquer = joueurActuel.UnitePouvantAttaquer()
			cibleDisponible = joueurActuel.ciblesDisponible(joueur : joueurAdverse)
			if(cibleDisponible.count>0 || pouvantAttaquer){
				afficherUnites(unite: cibleDisponible)
				print("Choisir une cible ou arreter l'attaque avec \"stop\"")
				valide = false

				while(!valide){
					if let typed = readLine(){
						if let n = Int(typed){
							input = n
							valide = true
							attaquer = cibleDisponible[input]

						} else if (typed == "stop"){
							valide = true
							print("l'attaque est stoppée !")
							attaque = false

						} else {
							print("veuillez choisir une action correcte")
						}
					}
				}

				if(attaque==true){
					changerCible = false
					cibleMorte = false
					while(changerCible == false || cibleMorte == false){
						unite = joueurActuel.unitePouvantAttaquer(carte : attaquer) //ne montrer que les soldats qui sont en mode defensif

						if(unite.count>0){ // Si le joueur possède des cartes capable d'atteindre des cartes ennemis
							print(afficherUnites(unite: unite))
							print("Avec quelle carte voulez vous attaquer ? (tapez la position du soldat dans la liste (commence par 0) ou changer de cible ? (tapez \"changer\")")

							while(!valide){
								if let typed = readLine(){
									if let n = Int(typed){
										input = n
										valide = true
										attaquant = unite[input] //selection d'un attaquant
                    if(joueurActuel.attaquer(carteAttaquante: attaquant,carteAttaque: attaquer)){
											print("La carte attaquée est tombé au combat !")
											cibleMorte = true
                      if(attaquer.unite == uniteCarte.Roi){
                        joueurGagnant = joueurActuel
                        partiFini = true
                        break

	                    } else if (joueurAdverse.recupererChampDeBataille().champDeBatailleEstVide()){ // Si le joueur adverse n'a plus d'unite sur son champ de bataille
	                        if(joueurAdverse.royaume.nombreOccurence() + joueurAdverse.main.nombreOccurence() < 1){ // Si il n'a plus de carte dans le royaume ni dans la main : effondrement
	                            joueurGagnant = joueurActuel
	                            partiFini = true
	                            break

	                        } else { // Si il lui reste au moins une carte dans la main ou dans le royaume : conscription
	                        	if(!joueurAdverse.royaume.estVide()){
															print(joueurAdverse.nom+" vous êtes forcé à déployé une carte venant de votre royaume, veuillez choisir les coordonnées de deploiement")
															choisirCoordonneeXY(JoueurSelectionner: joueurAdverse,X : X, Y : Y)
															joueurAdverse.deployerCarte(carte : joueurAdverse.royaume.enleverCarte(),x : X,y : Y)

	                          } else {
	                            	afficherMain(joueur : joueurActuel)
	                            	print(joueurAdverse.nom+" veuillez choisir une carte à deployer")
																choisirCoordonneeXY(JoueurSelectionner: joueurAdverse,X : X, Y : Y)
	                            	joueurAdverse.deployerCarte(carte : joueurAdverse.main.recupererCarte(type: choisirTypeCarte()),x: X, y: Y)
	                            	print("carte deployé !")

	                          }
	                        }
                    	}
										}
									} else if(typed == "changer"){
										valide = true
										print("vous avez choisi de changer de cible")
										changerCible = true
									} else {
										print("veuillez choisir une réponse valide")
									}
								}
							}

						} else {
							print("aucune unité ne peut attaquer cette cible")
							changerCible = true
						}
					}
				}

			} else {
				print("il n'y a aucune cible adverse...")
				attaque = false
			}
		}

	/* Choix de déployer une carte sur le champ de bataille */
	} else if(choix == "deployer"){
		print("veuillez choisir une carte à deployer")
		choisirCoordonneeXY(JoueurSelectionner: joueurActuel,X : X, Y : Y)
		joueurActuel.deployerCarte(carte : joueurActuel.main.recupererCarte(position: choisirTypeCarte()),x: X, y: Y)
		print("carte deployée !")
	}
	tour = tour+1
}

print(joueurGagnant.nom+" est le gagnant de la partie !")
