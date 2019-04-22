# WUNDER IT ###################################### PROJET 2 ################################TOUMI # LEBRETON ## 2019 #



#!/bin/bash



# récupération de la version désirée passée à jenkins (snapshot, release)

version_artifact=$1

# définition des variables d'environnement nécessaires

chemin_metadata=http://192.168.100.130:8081/repository/maven-snapshots/com/lesformateurs/maven-project/devopsapp/
chemin_snapshot=http://192.168.100.130:8081/repository/maven-snapshots/com/lesformateurs/maven-project/server/$version
chemin_release=http://192.168.100.130:8081/repository/maven-releases/com/lesformateurs/maven-project/server/$version
adresse_vm3=192.168.100.1



# verification de la version

if [[ $(grep "SNAPSHOT" <<<$version_artifact) ]]

#######################################################
# si la version est une snapshots/

    then
	
# récupération de la version sans "SNAPSHOT" 

version_snapshot='echo $version_artifact | grep -c "-SNAPSHOT"'
	
# récupération de la dernière version dans le metadata

derniere_version=$(curl -s $chemin_metadata/maven-metadata.xml | grep latest | sed "s/.*<latest>\([^<]*\)<\/latest>.*/\1/")

# ajout du point au milieu du numéro version

derniere_version_bon_format=$(echo $derniere_version | sed 's@\(........\)@\1.@g')

# adresse finale pour récupérer la bonne version de l'artifact

adresse_telechargement=$chemin_snapshot/$version_artifact/$derniere_version/$version_snapshot-$derniere_version_bon_format

dernier_build=$(curl -s $adresse_telechargement/maven-metadata.xml | grep '<value>' | head -1 | sed "s/.*<value>\([^<]*\)<\/value>.*/\1/")
build_jar=$dernier_build.jar

# téléchargement de la bonne version de l'artifact

projet=wget $adresse_telechargement/$build_jar

# connexion a la VM3

ssh root@$adresse_vm3

# test si le dossier existe, sinon on le créer

[ -d /data/projet ] || mkdir /data/projet

# copie du .jar dans /data/projet

scp $projet root@$adresse_vm3:/data/projet



#########################################################
# si la version n'est pas une snapshot, c'est donc une release

    else


# récupération de la dernière version dans le metadata

derniere_version=$(curl -s $chemin_metadata/maven-metadata.xml | grep latest | sed "s/.*<latest>\([^<]*\)<\/latest>.*/\1/")

adresse_telechargement=$chemin_release/$version_artifact

dernier_build=$(curl -s $adresse_telechargement/maven-metadata.xml | grep '<value>' | head -1 | sed "s/.*<value>\([^<]*\)<\/value>.*/\1/")
build_jar=server-$version_artifact.jar

# téléchargement de la bonne version de l'artifact

projet=wget $adresse_telechargement/$build_jar

#  connexion a la VM3

ssh root@$adresse_vm3

# test si le dossier existe, sinon on le créer

[ -d /data/projet ] || mkdir /data/projet

# copie du .jar dans /data/projet

scp $projet root@$adresse_vm3:/data/projet


fi
