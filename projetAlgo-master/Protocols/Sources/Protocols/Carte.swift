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
