//
import Foundation



class Cimetiere: Sequence{
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

