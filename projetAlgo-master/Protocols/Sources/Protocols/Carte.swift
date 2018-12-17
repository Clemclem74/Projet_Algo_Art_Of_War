//
import Foundation

class Carte: CarteProtocol{
    var id: Int
    var attaque: Int
    var defDefensive: Int
    var defOffensive: Int
    var etat: etatCarte
    var unite: uniteCarte
    var portee: [Portee]
    
    init(id : Int, attaque : Int, defDefensive : Int, defOffensive : Int, etat : etatCarte, unite : uniteCarte, portee : [Portee]){
        self.id = id
        self.attaque = attaque
        self.defDefensive = defDefensive
        self.defOffensive = defOffensive
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
}
