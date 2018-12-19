//
import Foundation



class Cimetiere: Sequence{
    fileprivate var cimetiere:[Carte]
    init(){
        cimetiere=[]
    }
}


fileprivate class CimetiereIterator{
    private let cimetiere : Cimetiere
    private var courant : Carte?
    
    init(_ c: Cimetiere){
        self.cimetiere=c
    }
    mutating func next()->Carte?{
        if cimetiere.isEmpty{
            return nil
        }
        else{
            
    }
    
}
