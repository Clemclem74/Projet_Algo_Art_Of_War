import Protocols

/* test unitaires */

func testUnitaire()->Int{
var erreur = 0;



//Coordonnees
var coor : CoordonneeProtocol(x: 1,y :1)
if(coor.positionX != 1){
	erreur=erreur+1
}
if(coor.positionY !=1){
	erreur=erreur+1
}
var testCartecoordonnee = CarteProtocol(id : 2,defDefensive : 2,defOffensive : 2,etat : etatCarte.Defensif,unite : uniteCarte.Roi)
coor.lierCarte(carte : testCartecoordonnee)
if(coor.retournerCarte != testCartecoordonnee){
	erreur=erreur+1
}
//Champ de champDeBataille

var ChampDeBataille : ChampBatailleProtocol
if(!champDeBataille.champDeBatailleEstVide()){
	erreur=erreur+1
}
//carte

var carte = CarteProtocol(id : 2,defDefensive : 2,defOffensive : 2,etat : etatCarte.Defensif,unite : uniteCarte.Roi)
if(carte.recupererIdCarte()->Int != 2){
	erreur=erreur+1
}
if(carte.recupererUnite() != "Roi"){
	erreur=erreur+1
}
carte.changerEtat(etatCarte.Offensif)
if(carte.etat != etatCarte.Offensif){
	erreur = erreur+1
	print("problème dans le changement d'état d'une carte")
}
do {
    var carteTest = try CarteProtocol(id : 2,defDefensive : 2,defOffensive : 2,etat : etatCarte.Defensif,unite :uniteCarte.Roi)
    erreur = erreur+1
    print("il y a un problème dans la création d'une carte")
} catch {
    print("test création d'un carte, passé")
}
//pioche
var pioche = PiocheProtocol()
if(pioche.nombreOccurence()!=20){
	erreur = erreur+1
	print("il y a un problème dans la création de la pioche")
}
var nombre = pioche.nbOccurence()-1
pioche.supprimerCarte()
if(pioche.nbOccurence!=nombre){
	erreur = erreur+1
	print("il y a un problème dans la fonction de suppréssion de carte dans la pioche")
}
//main
var main = MainProtocol()
main.ajouterCarte(carte: carte)
if(main.nbOccurence()!=2){
	erreur = erreur+1
	print("il y a un soucis dans l'ajout d'une carte dans la main")
}
var carteFausse = CarteProtocol(id : 3,defDefensive : 2,defOffensive : 2,etat : etatCarte.Defensif,unite : uniteCarte.Archer)
do{
    try main.enleverCarte(carte: carteFausse)
}catch{
	erreur = erreur+1
	print("on ne peut pas enlever une carte qui n'est pas dans le jeu")
}
if(main.afficherMain().count<1){ //il s'agit ici de voir si le string renvoyé par le joueur est supérieur à 1 caractère, autrement il est faux
	erreur = erreur+1
	print("il y a un problème dans l'affichage de la main")
}
main.enleverCarte(carte: carte)
if(main.nbOccurence() != 1){ //il ne devrait rester que le roi !
	erreur = erreur+1
	print("il y a un soucis dans la suppression de carte dans la main")
}
//coordonnée
    do {
        var coord = try PorteeProtocol(x: 0,y: 0)
        erreur = erreur+1
        print("il y a un soucis dans les coordonnées, on ne peut pas avoir comme coordonnée d'attaque 'sois-même'")
    } catch {
        print("test passé")
    }
    do {
        var coord = try PorteeProtocol(x: 1,y: 1)
        print("test passé")
    } catch {
        erreur = erreur+1
        print("il y a un soucis dans les coordonnées, on a pas pu initiliser les coordonnées")
    }
    do {
        var coord = try PorteeProtocol(x: 3,y: 4)
        erreur = erreur+1
        print("il y a un soucis dans les coordonnées, on ne peut avoir des coordonnées relatives supérieur à la taille du terrain")
    } catch {
        print("test des coordonnées réussi")
    }

//cimetiere
var cimetiere = CimetiereProtocol()
if(cimetiere.nombreOccurence() != 0){
	print("il y a un problème dans l'initilisation de cimetière")
}
if(cimetiere.nombreOccurence() > 42){//nombre de carte maximum dans une partie (joueur1 et joueur2)
	erreur = erreur+1
	print("il y a plus de carte dans le cimetière que de carte disponible dans la partie !")
}
var testCarte = CarteProtocol(id : 1, attaque : 1, defDefensive : 1, defOffensive : 1, etat : etatCarte.Defensif, unite : uniteCarte.Garde, portee : [PorteeProtocol(x:0,y:0)])
cimetiere.ajouterCarte(carte : testCarte)
if(cimetiere.nombreOccurence() != 1){
	erreur = erreur+1
	print("il y a un problème dans le nombre de carte présente dans le cimetière")
}
//royaume
var royaume = RoyaumeProtocol()
if(royaume.nombreOccurence() != 0){
    erreur = erreur+1
    print("erreur lors de la création d'un royaume")
}
var testCarte = CarteProtocol(id : 1, attaque : 1, defDefensive : 1, defOffensive : 1, etat : etatCarte.Defensif, unite : uniteCarte.Garde, portee : [PorteeProtocol(x:0,y:0)])
royaume.ajouterCarte(carte: testCarte)
if(royaume.nombreOccurence() != 1){
    erreur = erreur+1
    print("erreur dans l'ajout de carte dans le royaume")
}
var CarteEnleve = royaume.enleverCarte()
if(royaume.nombreOccurence() != 0){
    erreur = erreur+1
    print("erreur lors de la supression de carte dans le royaume")
}



var carteTest = CarteProtocol(id : 1, attaque : 1, defDefensive : 1, defOffensive : 1, etat : etatCarte.Defensif, unite : uniteCarte.Garde, portee : [PorteeProtocol(x:0,y:0)])

/* Test init() */
var joueurTest = JoueurProtocol()
if(joueurTest.cimetiere.estVide()){
    print("Création du cimetière : OK")
} else {
    print("Création du cimetière : Erreur")
    erreur = erreur + 1
}

if(joueurTest.royaume.estVide()){
    print("Création du royaume : OK")
} else {
    print("Création du royaume : Erreur")
    erreur = erreur + 1
}

if(joueurTest.champDeBataille.estVide()){
    print("Création du champ de bataille : OK")
} else {
    print("Création du champ de bataille : Erreur")
    erreur = erreur + 1
}

if(joueurTest.main.nombreOccurence() == 4 /* + vérifier qu'il y a un roi, dans la phase d'initilisation on doit tirer des cartes*/){
    print("Création de la main : OK")
} else {
    print("Création de la main : Erreur")
    erreur = erreur + 1
}

if(joueurTest.pioche.nombreOccurence() == 17){//3 cartes ont du être tiré lors de l'initialisation du joueur
    print("Création de la pioche : OK")
} else {
    print("Création de la pioche : Erreur")
    erreur = erreur + 1
}


/* Test piocher() */
joueurTest = JoueurProtocol()

var nbCartePiocheAvantPioche = joueurTest.pioche.nombreOccurence()
var nbCarteMainAvantPioche = joueurTest.main.nombreOccurence()

joueurTest.piocher()

var nbCartePiocheApresPioche = joueurTest.pioche.nombreOccurence()
var nbCarteMainApresPioche = joueurTest.main.nombreOccurence()

if(nbCartePiocheAvantPioche - nbCartePiocheApresPioche == 1 && nbCarteMainApresPioche - nbCarteMainAvantPioche == 1){
    print("Execution de piocher : OK")
} else {
    print("Execution de piocher : Erreur")
    erreur = erreur + 1
}


/* Test attaquer()  */

var carteTestAlliee = CarteProtocol(id : 11, attaque : 5, defDefensive : 1, defOffensive : 1, etat : etatCarte.Defensif, unite : uniteCarte.Garde, portee : [PorteeProtocol(x:0,y:0)])
var carteTestEnnemis = CarteProtocol(id : 10, attaque : 1, defDefensive : 2, defOffensive : 1, etat : etatCarte.Defensif, unite : uniteCarte.Garde, portee : [PorteeProtocol(x:0,y:0)])

if(joueurTest.attaquer(carteAttaquante : carteTestAlliee, carteAttaque : carteTestEnnemis)){
    print("Execution attaquer : OK")
} else {
    print("Execution attaquer : Erreur")
    erreur = erreur + 1
}

/* Test capturer() */

var nbCarteAvantCapturer = joueurTest.royaume.nombreOccurence()
joueurTest.capturer(carteTest)
var nbCarteApresCapturer = joueurTest.royaume.nombreOccurence()
if(nbCarteApresCapturer - nbCarteAvantCapturer == 1){
    print("Execution capturer : OK")
} else {
    print("Execution capturer : Erreur")
    erreur = erreur + 1
}

var resultat = testUnitaire()
var stringResulat = String(resultat)


print("il y a "+stringResulat+" erreur(s)")
