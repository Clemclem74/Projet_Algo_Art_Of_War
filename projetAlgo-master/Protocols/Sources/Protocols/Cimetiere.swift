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
    
    func EstVide()->Bool{
        return self.cimetiere.isEmpty
    }
    
    
}

