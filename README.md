
> Pour éditer le fichier readme en markdown https://readme.easyformer.fr/


## Sources des scripts lancés provenant du MIT et vérifiables ICI
https://tteck.github.io/Proxmox/

# easyproxmoxtools
Easy proxmox tools est un lanceur d'installations de VM et de containers LXC dédié à la gestion de ProxMox VE.

Script de personnalisation et d'administration de linux en bash.

Le script Easytools génère automatiquement :
 - L'aide utilisateur,
 - L'aide développeur,
 - Le menu principal,
 - Les sous-menus,
 - Les commutateurs de lancement par lettre,
 - et les commutateurs de lancement par mot.

## Capture de l'interface

![easyproxmoxtools_capture](/easyproxmoxtools_capture.png "easyproxmoxtools_capture").

## Pour l'utiliser sur votre Débian ou Ubuntu tappez simplement:
    
    cd /root
    wget https://raw.githubusercontent.com/easyformer/easyproxmoxtools/main/easyproxmoxtools.sh
    chmod +x easyproxmoxtools.sh
    ./easyproxmoxtools.sh
    

## Voici un exemple de fonction à intégrer dans le code pour ce faire:
> Les commentaires sont obligatoires...

    installation_gitlab(){
    #helpDescription="Installe et configure GitLab pour la gestion de code source"
    #categoryMenu="apps" 
    #nameMenu="Installation de GitLab"
    #commutatorLetter="g"
    #commutatorWord="install-gitlab"
        echo -e "Installation de GitLab..."
        apt-get install -y gitlab
    }


> Voici les catégories de menu que vous pouvez mettre (dans #categoryMenu) :
> 
> **"outils_proxmox_ve"**, **"assistant_a_domicile"**, **"automatisation"**, **"mqtt"**, **"base_de_donnees"**, **"zigbee_zwave_matiere"**, **"suivi_analyse"**, **"docker_kubernetes"**, **"systeme_operateur"**, **"cle_en_main"**, **"serveur_reseau"**, **"medias_photo"**, **"enregistreur_video_numerique_nvr"**, **"bloqueur_de_publicites_dns"**, **"document_notes"**, **"tableaux_de_bord"**, **"fichier_code"** et **"divers"**.


## Pour en ajouter utiliser la variable suivante:

    optionsMainMenu=(
        "Outils Proxmox VE" "outils_proxmox_ve"
        "Assistant à domicile" "assistant_a_domicile"
        "Automatisation" "automatisation"
        "MQTT" "mqtt"
        "Base de données" "base_de_donnees"
        "Zigbee - Zwave - Matière" "zigbee_zwave_matiere"
        "Suivi - Analyse" "suivi_analyse"
        "Docker-Kubernetes" "docker_kubernetes"
        "Système opérateur" "systeme_operateur"
        "Clé en main" "cle_en_main"
        "Serveur - Réseau" "serveur_reseau"
        "Médias - Photo" "medias_photo"
        "Enregistreur vidéo numérique (NVR)" "enregistreur_video_numerique_nvr"
        "Bloqueur de publicités - DNS" "bloqueur_de_publicites_dns"
        "Document - Notes" "document_notes"
        "Tableaux de bord" "tableaux_de_bord"
        "Fichier - Code" "fichier_code"
        "Divers" "divers"
    )

## Vous pouvez simplement ajouter des fonctions avec votre IA préférée en tappant:

    Peux-tu me générer une fonction en shell pour ubuntu respectant la structure suivante:
    nom_de_la_fonction(){
    #helpDescription="mettre ici une explication de ce que cela fait"
    #categoryMenu="outils_proxmox_ve"
    #nameMenu="Mettre ici le nom de la fonction telle qu'elle sera écrite dans le menu"
    #commutatorLetter="Mettre ici la lettre qui sera utilisé comme commutateur de lancement"
    #commutatorWord="Mettre ici un mot ou groupe de mots sans espaces avec des underscores si'il le faut et qui sera utilisé comme commutateur de lancement"
        #Mettre le code demmandé ici...   
    }
    Seules les catégories suivantes doivent être utilisées "outils_proxmox_ve", "assistant_a_domicile", "automatisation", "mqtt", "base_de_donnees", "zigbee_zwave_matiere", "suivi_analyse", "docker_kubernetes", "systeme_operateur", "cle_en_main", "serveur_reseau", "medias_photo", "enregistreur_video_numerique_nvr", "bloqueur_de_publicites_dns", "document_notes", "tableaux_de_bord", "fichier_code" et "divers" dans #categoryMenu.
    il ne faut pas mettre d'espace avant les 5 premiers commentaires: #helpDescription, #categoryMenu, #nameMenu, #commutatorLetter et #commutatorWord.
    Le script devra faire ...





