############# Readme du projet Formation #################

projet: - deployer le projet su un repo nexus sur une machine distante (VM)
	- créer un job RELEASE
	- créer un script prenant en paramètre la version voulu et récupérant la version la plus
	récente du .jar sur le repositery NEXUS pour le copier dans un dossier spécifique ("DATA/projet/") sur
	une troisièpme machine



1.	Un JOB récupère un script sh stocké sur GIT
2.	Le JOB lance le script sh en post build (après le build du clean et deploy)
3.	le script sh récupère le .jar du projet SERVER dans SNAPSHOT ou RELEASE
4.	Copie de la version du SNAPSHOT ou RELEASE récupérée, dans un dossier /DATA/projet sur une machine virtuelle (VM3)





############# Préparation de l'Infrastructure ##############





1.	Installation des Machines Virtuelles (VM).
	Configuration réseau en Bridge, afin de les faire communiquer ensemble: 
	Edit
	Virtual Newtwork Editor
	Change Settings => selectionner une Vmnet disponible pour la monter en Bridge.
	Aller dans l'onglet VM et cliquer sur Settings
	Selectionner le Network Adaptater et renseigner le VMnet configuré juste avant.


2.	Installation de Nexus et Maven
	Installation de Git
	Installation Jenkins puis installation du plugin Nexus, dans le plugin management (gestion des plugins)
	Création du Job Deploy Nexus en créant un projet Maven (folder)
	Configuration du POM.XML, corriger les erreurs de syntaxe, les numéros de versions, les Id.
	Configuration de Jenkins. Jenkins doit récupérer le repo git, et doit lancer les commandes clean deploy, en se basant sur le 		POM.XML et le fichier settings.xml
	Création branche Develop et push du projet
	Configuration SSH, création d'une clé enregistrée sur GIT
	Création Job Release





############# SCRIPT SH POST BUILD ################





1.	On récupère la version en paramètre passé à jenkins avec notre script (snapshot, release)
	
2.	On utilise une commande GREP pour vérifier si la version de l'artifact renseignée contient "SNAPSHOT"
	
3.	Si la version est une SNAPSHOT, on corrige l'url d'accès pour pouvoir la télécharger sur le REPO NEXUS
	
4.	On vérifie prendre la dernière version dans le maven-metadata.xml grâce la balise "lastupdated"
	
5.	Une fois la version SNAPSHOT ou RELEASE téléchargée, on test la connexion en SSH sur la VM3 et on éffectue un
	test pour savoir si le dossier "/DATA/projet" existe, sinon on le créer.
	
6.	Enfin copie le .jar dans le dossier /DATA/projet

