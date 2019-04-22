############# Readme du projet Formation #################


1.	Un JOB récupère un script sh stocké sur GIT

2.	Le JOB lance le script sh en post build (après le build du clean et deploy)

3.	le script sh récupère le .jar du projet SERVER dans SNAPSHOT ou RELEASE

4.	Envoie de la version du SNAPSHOT ou RELEASE récupérée, dans un dossier /DATA/projet sur une machine virtuelle (VM3)









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
	Configuration de Jenkins. Jenkins doit récupérer le repo git, et doit lancer les commandes clean deploy, en se basant sur le POM.XML et le fichier settings.xml
	Création branche Develop et push du projet
	Configuration SSH, création d'une clé enregistrée sur GIT
	Création Job Release









############# SCRIPT SH POST BUILD ################







1.	On récupère la version renseignée sur jenkins (snapshot, release)
	
	On utilise une commande GREP pour vérifier si la version de l'artifact renseignée contient "SNAPSHOT"
	
	Si la version est une SNAPSHOT, on corrige l'url d'accès pour pouvoir la télécharger sur le REPO NEXUS
	
	On récupère la dernière version dans le maven-metadata.xml grâce la balise "lastupdated"
	
	Une fois la version SNAPSHOT ou RELEASE téléchargée on test la connexion en SSH sur la VM3 et on vérifie si le dossier /DATA/projet existe	
	
	Si le dossier est inexistant on le créé
	
	Enfin copie le .jar dans le dossier /DATA/projet