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
    
    // func retournerCarte()->Carte? {
    //
    //}
    
    
}
