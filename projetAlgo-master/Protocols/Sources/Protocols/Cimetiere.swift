//
import Foundation



class Cimetiere: Sequence{
    var prec: CimetiereNoeud
    var suiv: CimetiereNoeud
    
    init(){
        
    }
}


fileprivate class CimetiereIterator{
    private let cimetiere : Cimetiere
    private var courant : Carte?
    
    init(_ c: Cimetiere){
        self.cimetiere=c
    }
    mutating func next()->Carte?{
        
    }
    
}
