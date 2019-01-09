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
