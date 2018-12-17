/* ------- Programme Main ------- */
import Protocols

//afficherChampBataile : Joueur
//permet d'afficher le camp d'un joueur
func afficherChampBataile(joueur: Joueur){
	var champ = joueur.recupererChampDeBataille()

	while let element = champ.next(){
		print("carte :"+element.retournerCarte().recupererUnite()+"->["+element.positionX()+";"+element.positionY()+"]")
	}
}


//afficherMain : Joueur
//permet d'afficher la  main d'un joueur
func afficherMain(joueur: Joueur){
	var ligne = ""
	print("**********************************************")
	for i in 0...Joueur.main.nbOccurences()-1{

		if(Joueur.main.RecupererMain()[i] is Carte){
			ligne += ("-"+Joueur.main.recupererMain()[i].recupererUnite()+"(id:"+Joueur.main.recupererMain()[i].recupererIdCarte()+") -")
		}

	}
	print(ligne)
	print("********************************************")

}


//afficherUnites: [Carte]
//correspond a afficher graphiquement une liste de carte
func afficherUnites(unite: [Carte]){
	var ligne : String
	print("**********************************************")
	for(let i =0;i<unite.count;++i){

		if(unite[i] is Carte){
			ligne += ("-"+unite[i].recupererUnite()+"(id:"+unite[i].recupererIdCarte()+") -")
		}else{
			ligne += ("-"+"   "+"-")
		}

	}
	print(ligne)
	print("********************************************")

}

//permet de selectionner une coordonnée X et Y
func choisirCoordonneeXY(JoueurSelectionner: Joueur,X : inout Int, Y : inout Int){
	repeat{
		print("Choisissez une coordonnée X:")

		if let typed = readLine(){
			if let n = Int(typed){
				X = n
			}
		}

		print("Choisissez une coordonnée Y:")
		if let typed = readLine(){
			if let n = Int(typed){
				X = n
			}
		}

	}while(!(x < 3 && x >=0 && y < 2 && y>=0 && JoueurSelectionner.recupererChampDeBataille().positionLibre(x: X,y: Y)))
}


func choisirTypeCarte()->uniteCarte{
	print("choisissez entre : 1- Soldat 2- Archer 3- Garde")
	var choix = ""
	while(choix != "Soldat" || choix != "Archer" || choix != "Garde"){
		if let typed = readLine(){
				choix = typed

		} else {
			print("votre choix est incorrecte")
		}
	}

	var type : UniteCarte;
	if(choix=="Soldat"){
		type= UniteCarte.Soldat
	}
	else if(choix=="Archer"){
		type= UniteCarte.Archer

	else if(choix=="Garde"){
		type= UniteCarte.Garde
	}
	return type
}

/* Initialisation de la partie */
print("Joueur 1 : Veuillez saisir un nom pour votre joueur : ")
var choix : String

if let typed = readLine(){
	choix=typed
}
var joueur1 = JoueurProtocol(nom : choix)

print("Joueur 2 : Veuillez saisir un nom pour votre joueur : ")
if let typed = readLine(){
	choix=typed
}
var joueur2 = JoueurProtocol(nom : choix)

var joueurGagnant : JoueurProtocol
var partiFini = false

print("Joueur 1 : veuillez selectionner une carte à mettre au royaume")
afficherMain(joueur : joueur1)

joueur1.demobiliser(carte : joueur1.main.recupererCarte(type : choisirTypeCarte()))

print("mettre un carte au front")
afficherMain(joueur : joueur1)

choisirCoordonneeXY(JoueurSelectionner: joueur1,X : X, Y : Y)

joueur1.deployerCarte(carte : joueur1.main.recupererCarte(type : choisirTypeCarte()),x: X, y: Y)

print("Joueur 2 : veuillez selectionner (un numero) une carte à mettre au royaume")
afficherMain(joueur : joueur2)

joueur2.demobiliser(carte: joueur2.main.recupererCarte(type : choisirTypeCarte()))

print("mettre un carte au front")
print(afficherMain(joueur : joueur2))

choisirCoordonneeXY(JoueurSelectionner: joueur2,X : X, Y : Y)

joueur2.deployerCarte(joueur2.main.recupererCarte(type : choisirTypeCarte()),x: X, y: Y)

/* Boucle principale du jeu */
var tour=1
var joueurActuel : JoueurProtocol
var joueurAdverse : JoueurProtocol
var changerCible = false
var cibleMorte = false
var valide = false
var cibleDisponible : [Carte]
var unite : [Carte]
var pouvantAttaquer : [Carte]
var attaquer : Carte //carte qui est attaqué
var attaquant : Carte //Carte attaquante
var attaque : false //permettant de lancer une attaque
var X : Int //utilisé pour déployé une carte
var Y : Int //utilisé pour déployé une carte

while(!partiFini){
	if(tour%2 == 0){
		joueurActuel = joueur2 //attention le joueur doit être de type réference et non pas de type valeur !!!
		joueurAdverse = joueur1
		print("à toi de jouer joueur 2 !")

	} else {
		joueurActuel = joueur1
		joueurAdverse = joueur2
		print("à toi de joueur joueur 1 !")
	}

	/* Mise en position défensive de toutes les cartes du champ de bataille du joueur */
	for carte in joueurActuel.recupererChampDeBataille(joueurActuel){
		if carte is Carte{
            carte.changerEtat(etat: etatCarte.defensif)
		}
	}

	if(joueurActuel.pioche.nombreOccurence()>0){
		joueurActuel.piocher()

	/* Si les deux joueurs n'ont plus de carte dans leur pioche, on regarde qui à le plus de carte dans son royaume pour désigner le gagnant*/
	} else if (joueurAdverse.pioche.nombreOccurence() == 0){
		if(joueurActuel.royaume.nombreOccurence()>joueurAdverse.royaume.nombreOccurence()){
			joueurGagnant = joueurActuel

		} else {
			joueurGagnant = joueurAdverse
		}

		partiFini = true;
		break

	}
	print("champ de bataille adverse : ")
	print(afficherChampBataile(joueur: joueurAdverse))
	print("votre main : ")
	afficherMain(joueur : joueurActuel)

	//phase action
	if let typed = readLine(){
		choix=typed
	}
	/* Choix de l'action à faire pour ce tour */
	print("Veuillez saisir une action à faire (attaquer / deployer / rien) : ")
	while(choix != "rien" || choix != "deployer" || choix != "attaquer"){
		print("saisi non valide, veuillez réitérer")
		if let typed = readLine(){
			choix = typed
		}
	}
	/* Choix de ne rien faire */
	if(choix == "rien"){
		print("vous decidez de passer votre tour")

	/* Choix d'attaquer l'adversaire */
	} else if (choix == "attaquer"){
		attaque = true
		attaquer : CarteProtocol
		while(attaque){
	 		pouvantAttaquer = joueurActuel.UnitePouvantAttaquer()
      cibleDisponible = joueurActuel.ciblesDisponible(joueur : joueurAdverse)
			if(cibleDisponible.count>0 || pouvantAttaquer){
				afficherUnites(unite: cibleDisponible)
				print("Choisir une cible ou arreter l'attaque avec \"stop\"")
				valide = false

				while(!valide){
					if let typed = readLine(){
						if let n = Int(typed){
							input = n
							valide = true
							attaquer = cibleDisponible[input]

						} else if (typed == "stop"){
							valide = true
							print("l'attaque est stoppée !")
							attaque = false

						} else {
							print("veuillez choisir une action correcte")
						}
					}
				}

				if(attaque==true){
					changerCible = false
					cibleMorte = false
					while(changerCible == false || cibleMorte == false){
            unite = joueurActuel.unitePouvantAttaquer(carte : attaquer) //ne montrer que les soldats qui sont en mode defensif

						if(unite.count>0){ // Si le joueur possède des cartes capable d'atteindre des cartes ennemis
							print(afficherUnites(unite: unite))
							print("Avec quelle carte voulez vous attaquer ? (tapez la position du soldat dans la liste (commence par 0) ou changer de cible ? (tapez \"changer\")")

							while(!valide){
								if let typed = readLine(){
									if let n = Int(typed){
										input = n
										valide = true
										attaquant = unite[input] //selection d'un attaquant
                    if(joueurActuel.attaquer(carteAttaquante: attaquant,carteAttaque: attaquer)){
											print("La carte attaquée est tombé au combat !")
											cibleMorte = true
                      if(attaquer.unite == uniteCarte.Roi){
                        joueurGagnant = joueurActuel
                        partiFini = true
                        break

	                    } else if (joueurAdverse.recupererChampDeBataille().champDeBatailleEstVide()){ // Si le joueur adverse n'a plus d'unite sur son champ de bataille
	                        if(joueurAdverse.royaume.nombreOccurence() + joueurAdverse.main.nombreOccurence() < 1){ // Si il n'a plus de carte dans le royaume ni dans la main : effondrement
	                            joueurGagnant = joueurActuel
	                            partiFini = true
	                            break

	                        } else { // Si il lui reste au moins une carte dans la main ou dans le royaume : conscription
	                        	if(!joueurAdverse.royaume.estVide()){
															print(joueurAdverse.nom+" vous êtes forcé à déployé une carte venant de votre royaume, veuillez choisir les coordonnées de deploiement")
															choisirCoordonneeXY(JoueurSelectionner: joueurAdverse,X : X, Y : Y)
															joueurAdverse.deployerCarte(carte : joueurAdverse.royaume.enleverCarte(),x : X,y : Y)

	                          } else {
	                            	afficherMain(joueur : joueurActuel)
	                            	print(joueurAdverse.nom+" veuillez choisir une carte à deployer")
																choisirCoordonneeXY(JoueurSelectionner: joueurAdverse,X : X, Y : Y)
	                            	joueurAdverse.deployerCarte(carte : joueurAdverse.main.recupererCarte(type: choisirTypeCarte()),x: X, y: Y)
	                            	print("carte deployé !")

	                          }
	                        }
                    	}
										}
									} else if(typed == "changer"){
										valide = true
										print("vous avez choisi de changer de cible")
										changerCible = true
									} else {
										print("veuillez choisir une réponse valide")
									}
								}
							}

						} else {
							print("aucune unité ne peut attaquer cette cible")
							changerCible = true
						}
					}
				}

			} else {
				print("il n'y a aucune cible adverse...")
				attaque = false
			}
		}

	/* Choix de déployer une carte sur le champ de bataille */
	} else if(choix == "deployer"){
		print("veuillez choisir une carte à deployer")
		choisirCoordonneeXY(JoueurSelectionner: joueurActuel,X : X, Y : Y)
		joueurActuel.deployerCarte(carte : joueurActuel.main.recupererCarte(position: choisirTypeCarte()),x: X, y: Y)
		print("carte deployée !")
	}
	tour = tour+1
}

print(joueurGagnant.nom+" est le gagnant de la partie !")
