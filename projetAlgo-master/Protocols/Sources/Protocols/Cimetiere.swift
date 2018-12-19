//
import Foundation



class Cimetiere: Sequence{
    fileprivate var cimetiere:[Carte]
    init(){
        cimetiere=[]
    }
}


fileprivate class CimetiereIterator{
    private var cimetiere : Cimetiere
    private var courant : Carte?
    
    init(_ c: Cimetiere){
        self.cimetiere=c
    }
    mutating func next()->Carte?{
        if self.cimetiere.isEmpty{
            return nil
        }
        else{
            var cle=0
            for (item,value) in self.cimetiere.enumerated{
                if value==courant{
                    cle=item+1
                }
            }
            return self.cimetiere[cle]
        }
    }
    
}
