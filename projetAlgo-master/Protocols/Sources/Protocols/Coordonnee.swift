import Fondation


struct Coordonnee : CoordonneeProtocol {
    fileprivate var x : Int
    fileprivate var y : Int
    
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
    
    // func retournerCarte()->Carte? {
    //
    //}
    
    
}
