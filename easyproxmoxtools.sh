#!/bin/bash
#     ____     ######################################
#    /___/`    # easyproxmoxtools.sh  
#    (O,O)     # Utilité: ce script sert à configurer les serveurs
#   /(   )\    # Usage: easytools.sh -option1 -option2 ... (Voir l'aide -h)
# --==M=M==--  # Auteur: Alex FALZON
#     Easy     # Mise à jour le: 15/07/2024
# F O R M E R  ######################################

nomduscript="Easy PMT"
# http://www.octetmalin.net/linux/tutoriels/figlet.php
# Exemple d'utilisation
# figlet -ck `wget -qO- icanhazip.com`

############################################################################
####################   Déclaration des variables   #########################
############################################################################

# Définition des couleurs du script
# http://ti1.free.fr/index.php/bash-mise-en-forme-de-textes-dans-un-terminal/
# https://stackabuse.com/how-to-change-the-output-color-of-echo-in-linux/
# Exemple d'utilisation
# echo -e "${rougefonce}Bonjour${neutre} ${jaune}les gens${neutre}"

maron='\e[0;3m'
noir='\e[0;30m'
gris='\e[1;30m'
rougefonce='\e[0;31m'
rose='\e[1;31m'
vertfonce='\e[0;32m'
vertclair='\e[1;32m'
orange='\e[0;33m'
jaune='\e[1;33m'
bleufonce='\e[0;34m'
bleuclair='\e[1;34m'
violetfonce='\e[0;35m'
violetclair='\e[1;35m'
cyanfonce='\e[0;36m'
cyanclair='\e[1;36m'
grisclair='\e[0;37m'
blanc='\e[1;37m'
neutre='\e[0;m'

sudo apt-get -y install figlet > /dev/null

# Initialisation des tableaux logo et nom du script
declare -a nomScripMultiligne
while IFS= read -r ligne; do
    nomScripMultiligne+=("$ligne")
done <<< `figlet -k $nomduscript`

declare -a logoEasy
logoEasy=(
    " ${bleuclair}    ____   ${vertfonce}"
    " ${bleuclair}   /___/${rougefonce}\`  ${vertfonce}"
    " ${maron}   (${jaune}O${maron},${jaune}O${maron})${vertfonce}   "
    " ${maron}  /(   )\\ ${vertfonce} "
    " ${grisclair}--==${noir}M${grisclair}=${noir}M${grisclair}==--${vertfonce}"
    " ${vertclair}    Easy   ${vertfonce}"
    " ${vertfonce}F O R M E R${neutre}"
)

# Déclaration des tableaux associatifs pour stocker les informations
declare -A helpDescriptions
declare -A categoryMenus
declare -A nameMenus
declare -A commutatorLetters
declare -A commutatorWords
declare -A commutatorLettersErrors
declare -A commutatorWordsErrors

############################################################################
####################   Déclaration des fonctions   #########################
############################################################################

# afficher le nom du script
printLogo(){
	for ligne in "${logoEasy[@]}"; do
		echo -e "$ligne"
	done
}

# afficher le nom du script
printScriptName(){
	for element in "${nomScripMultiligne[@]}"; do
		echo -e "${vertfonce} $element ${neutre}"
	done
}

# afficher le nom du script centré
printScriptNameCenter(){
	echo -e "${vertfonce}`figlet -ck $nomduscript`${neutre}"
}

# afficher le logo et le nom du script
printLogoAndNameScript(){
	for i in "${!logoEasy[@]}"; do
		echo -e "${logoEasy[$i]}" "${nomScripMultiligne[$i]}"
	done
	echo -e "                         Easy ProxMox Tools - By Easyformer"
}

# Fonction pour parser le script et extraire les informations
parser_fonctions() {
    local current_function=""
    while IFS= read -r line; do
        # Check for function names
        if [[ $line =~ ^([a-zA-Z_][a-zA-Z0-9_]*)\s*\(\) ]]; then
            current_function="${BASH_REMATCH[1]}"
        fi

        # Check for meta information if current_function is set
        if [[ -n $current_function ]]; then
            if [[ $line =~ ^\#helpDescription=\"(.*)\"$ ]]; then
                helpDescriptions["$current_function"]="${BASH_REMATCH[1]}"
            elif [[ $line =~ ^\#categoryMenu=\"(.*)\"$ ]]; then
                categoryMenus["$current_function"]="${BASH_REMATCH[1]}"
            elif [[ $line =~ ^\#nameMenu=\"(.*)\"$ ]]; then
                nameMenus["$current_function"]="${BASH_REMATCH[1]}"
            elif [[ $line =~ ^\#commutatorLetter=\"(.*)\"$ ]]; then
			echo "#commutatorLetter=${BASH_REMATCH[1]}"
				# vérification des lettres en doublon
				# for letter in "${commutatorLetters[@]}"; do
					# if [[ -n "$letter" ]] && [ "${BASH_REMATCH[1]}" == "$letter" ]; then
				# echo "--${commutatorLetters[@]} ++$letter"
						# commutatorLettersErrors+=("$letter")
					# fi
				# done
                commutatorLetters["$current_function"]="${BASH_REMATCH[1]}"
            elif [[ $line =~ ^\#commutatorWord=\"(.*)\"$ ]]; then
				# vérification des mots en doublon
				# for word in "${commutatorWords[@]}"; do
					# if [[ -n "$word" ]] && [ "${BASH_REMATCH[1]}" == "$word" ]; then
				# echo "${commutatorWords[@]} $word"
						# commutatorWordsErrors+=("$word")
					# fi
				# done
                commutatorWords["$current_function"]="${BASH_REMATCH[1]}"
            fi
        fi
    done < "$0"
}

printInfoFunction(){
	# Afficher les informations extraites
    echo "  -------------------------------------"
    echo -e "${vertfonce}       Manuel pour les développeurs${neutre}"
    echo "  -------------------------------------"
	menu_options=()
	for ((i = 0; i < ${#optionsMainMenu[@]}; i+=2)); do
		menu_options+=("${optionsMainMenu[$i]}")
	done
	for opt in "${menu_options[@]}"; do
        for ((i = 0; i < ${#menu_options[@]}; i++)); do
            if [[ "$opt" == "${menu_options[$i]}" ]]; then
                if [[ "${optionsMainMenu[$((i * 2 + 1))]}" != "quit" ]] && [[ "${optionsMainMenu[$((i * 2 + 1))]}" != "help" ]]; then
					echo -e "${vertfonce}  ${optionsMainMenu[$((i * 2))]}${neutre}"
					for func in "${!helpDescriptions[@]}"; do
						if [[ "${optionsMainMenu[$((i * 2 + 1))]}" == "${categoryMenus[$func]}" ]]; then
							echo "    Fonction: $func"
							echo "      helpDescription: ${helpDescriptions[$func]}"
							echo "      categoryMenu: ${categoryMenus[$func]}"
							echo "      nameMenu: ${nameMenus[$func]}"
							echo "      commutatorLetter: ${commutatorLetters[$func]}"
							echo "      commutatorWord: ${commutatorWords[$func]}"
							echo ""
						fi
					done
                fi
            fi
        done
    done
}

printHelp() {
	printLogoAndNameScript
    echo "  -------------------------------------"
    echo -e "${vertfonce}          Manuel d'utilisation${neutre}"
    echo "  -------------------------------------"
    echo "  [Tappez q pour quitter l'aide]"
    echo ""
	menu_options=()
	for ((i = 0; i < ${#optionsMainMenu[@]}; i+=2)); do
		menu_options+=("${optionsMainMenu[$i]}")
	done
	for opt in "${menu_options[@]}"; do
        for ((i = 0; i < ${#menu_options[@]}; i++)); do
            if [[ "$opt" == "${menu_options[$i]}" ]]; then
                if [[ "${optionsMainMenu[$((i * 2 + 1))]}" != "quit" ]] && [[ "${optionsMainMenu[$((i * 2 + 1))]}" != "help" ]]; then
					echo -e "${vertfonce}  ${optionsMainMenu[$((i * 2))]}${neutre}"
					for func in "${!helpDescriptions[@]}"; do
						if [[ "${optionsMainMenu[$((i * 2 + 1))]}" == "${categoryMenus[$func]}" ]]; then
							if [[ -n ${commutatorLetters[$func]} && -n ${commutatorWords[$func]} ]];then
								echo -e "  -${commutatorLetters[$func]} ou --${commutatorWords[$func]} (${categoryMenus[$func]})"
								echo "      ${helpDescriptions[$func]}"
								echo ""
							elif [[ -n ${commutatorLetters[$func]} ]];then
								echo -e "  -${commutatorLetters[$func]} (${categoryMenus[$func]})"
								echo "      ${helpDescriptions[$func]}"
								echo ""
							elif [[ -n ${commutatorWords[$func]} ]];then
								echo -e "  --${commutatorWords[$func]} (${categoryMenus[$func]})"
								echo "      ${helpDescriptions[$func]}"
								echo ""
							fi
						fi
					done
                fi
            fi
        done
    done
	
	
	printInfoFunction
    echo ""
    echo "  [Tappez q pour quitter l'aide]"
    echo ""
}

printHelpMore() {
	helpContent=$(printHelp)
	echo "$helpContent" | more
}

printMainPage(){
	clear
	printLogoAndNameScript
	for ((i = 0; i < ${#commutatorLettersErrors[@]}; i+=1)); do
		echo -e "${rougefonce}  Attention le commutateur -${commutatorLettersErrors[$i]} est en doublon${neutre}"
	done
	for ((i = 0; i < ${#commutatorWordsErrors[@]}; i+=1)); do
		echo -e "${rougefonce}  Attention le commutateur --${commutatorWordsErrors[$i]} est en doublon${neutre}"
	done
	# Appel de la fonction pour afficher le menu
	printMainMenu
}

# Fonction pour afficher le menu principal et gérer les choix
printMainMenu() {

	# Créer un tableau uniquement pour les options de menu
	menu_options=()
	for ((i = 0; i < ${#optionsMainMenu[@]}; i+=2)); do
		menu_options+=("${optionsMainMenu[$i]}")
	done

    echo ""
    echo -e "${vertfonce}     Menu principal${neutre}"
    echo ""
    PS3='  Veuillez choisir une option: '
    select opt in "${menu_options[@]}"; do
        for ((i = 0; i < ${#menu_options[@]}; i++)); do
            if [[ "$opt" == "${menu_options[$i]}" ]]; then
                if [[ "${optionsMainMenu[$((i * 2 + 1))]}" == "quit" ]]; then
					exit 1
                    #break 2
                elif [[ "${optionsMainMenu[$((i * 2 + 1))]}" == "help" ]]; then
					printHelpMore
                    printMainPage
                else
                    printSubMenu  "${optionsMainMenu[$((i * 2 + 1))]}" "${optionsMainMenu[$((i * 2))]}"
					printMainPage
                fi
            fi
        done
        if [[ "$opt" == "" ]]; then
            echo -e "${rougefonce}     Option invalide $REPLY${neutre}"
        fi
    done
}

printSubMenu() {
	clear
	printLogoAndNameScript
    echo ""
	menuTitle="$2"
	first=${menuTitle:0:1}
	rest=${menuTitle:1}
	menuTitleLower=${first,,}$rest
    echo -e "${vertfonce}     Menu $menuTitleLower${neutre}"
    echo ""
	
	sub_menu_text=()
	sub_menu_function=()
	for func in "${!helpDescriptions[@]}"; do
		if [ -n "$1" ] && [ -n "${categoryMenus[$func]}" ] && [ "${categoryMenus[$func]}" == "$1" ]; then
			sub_menu_text+=("${nameMenus[$func]}")
			sub_menu_function+=("$func")
		fi
	done
	sub_menu_text+=("[Manuel d'utilisation]")
	sub_menu_function+=("help")
	sub_menu_text+=("[Retour au menu principal]")
	sub_menu_function+=("quit")
	PS3='  Veuillez choisir une option: '
    select optMenu in "${sub_menu_text[@]}"; do
        for ((i = 0; i < ${#sub_menu_text[@]}; i++)); do
            if [[ "$optMenu" == "${sub_menu_text[$i]}" ]]; then
                if [[ "${sub_menu_function[$i]}" == "quit" ]]; then
					printMainPage
                elif [[ "${sub_menu_function[$i]}" == "help" ]]; then
					printHelpMore
                    printSubMenu  "$1" "$2"
                else
                    ${sub_menu_function[$i]}
                    printSubMenu  "$1" "$2"
                fi
            fi
        done
        if [[ "$optMenu" == "" ]]; then
            echo -e "${rougefonce}     Option invalide $REPLY${neutre}"
        fi
    done

}

############################################################################
# Les informations suivantes doivent toujours être présentes dans les fonctions
# pour automatiser l'aide, le lancement par attribut et l'insertion dans les menus :
############################################################################
#helpDescription=""
#categoryMenu=""
#nameMenu=""
#commutatorLetter=""
#commutatorWord=""
############################################################################
# Voici les catégoris de menu que vous pouvez mettre :
#   "outils_proxmox_ve" "assistant_a_domicile" "automatisation" "mqtt" "base_de_donnees"
#   "zigbee_zwave_matiere" "suivi_analyse" "docker_kubernetes" "systeme_operateur" "cle_en_main"
#   "serveur_reseau" "medias_photo" "enregistreur_video_numerique_nvr" "bloqueur_de_publicites_dns"
#   "Document - Notes" "document_notes" "tableaux_de_bord" "fichier_code" "divers"
############################################################################
# pour en rajouter utiliser la variable suivante:
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
    "[Manuel d'utilisation]" "help"
    "[Quitter]" "quit"
)
############################################################################

############################################################################
####################   Déclaration des fonctions   #########################
####################     relatives aux outils      #########################
####################     présents dans le menu     #########################
############################################################################

post-installation_du_serveur_de_sauvegarde_proxmox(){
#helpDescription="Le script donnera des options pour désactiver le référentiel d'entreprise, ajouter/corriger les sources PBS, activer le référentiel sans abonnement, ajouter un référentiel de test, désactiver le Nag d'abonnement, mettre à jour le serveur de sauvegarde Proxmox et redémarrer PBS. Exécutez la commande ci-dessous dans le shell du serveur de sauvegarde Proxmox . ⚠️ Serveur de sauvegarde Proxmox UNIQUEMENT Il est recommandé de répondre « oui » (y) à toutes les options présentées au cours du processus."
#categoryMenu="outils_proxmox_ve"
#nameMenu="Post-installation du serveur de sauvegarde Proxmox"
#commutatorLetter=""
#commutatorWord="post-installation_du_serveur_de_sauvegarde_proxmox"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/misc/post-pbs-install.sh)"
}

regulateur_de_mise_a_lechelle_du_processeur_proxmox_ve(){
#helpDescription="Le régulateur de mise à l'échelle du processeur détermine la manière dont la fréquence du processeur est ajustée en fonction de la charge de travail, dans le but d'économiser de l'énergie ou d'améliorer les performances. En augmentant ou en diminuant la fréquence, le système d'exploitation peut optimiser l'utilisation du processeur et économiser de l'énergie lorsque cela est possible. Régulateurs de mise à l'échelle génériques. Exécutez la commande ci-dessous dans le shell Proxmox VE."
#categoryMenu="outils_proxmox_ve"
#nameMenu="Régulateur de mise à l'échelle du processeur Proxmox VE"
#commutatorLetter=""
#commutatorWord="regulateur_de_mise_a_lechelle_du_processeur_proxmox_ve"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/misc/scaling-governor.sh)"
}

programme_de_mise_a_jour_proxmox_ve_cron_lxc(){
#helpDescription="Ce script ajoutera/supprimera une planification crontab qui met à jour tous les LXC tous les dimanches à minuit. Pour exclure les LXC de la mise à jour, modifiez crontab (crontab -e) et ajoutez CTID comme indiqué dans l'exemple (-s 103 111) exemple: 0 0 * * 0 PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin /bin/bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/misc/update-lxcs-cron.sh)\" -s 103 111 >>/var/log/update-lxcs-cron.log 2>/dev/null Exécutez la commande ci-dessous dans le shell Proxmox VE."
#categoryMenu="outils_proxmox_ve"
#nameMenu="Programme de mise à jour Proxmox VE Cron LXC"
#commutatorLetter=""
#commutatorWord="programme_de_mise_a_jour_proxmox_ve_cron_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/misc/cron-update-lxcs.sh)"
}

sauvegarde_de_lhote_proxmox_ve(){
#helpDescription="Ce script sert d'utilitaire de sauvegarde polyvalent, permettant aux utilisateurs de spécifier à la fois le chemin de sauvegarde et le répertoire dans lequel ils souhaitent travailler. Cette flexibilité permet aux utilisateurs de sélectionner les fichiers et répertoires spécifiques qu'ils souhaitent sauvegarder, ce qui le rend compatible avec une large gamme d'hôtes, sans se limiter à Proxmox. Exécutez la commande ci-dessous dans le shell Proxmox VE ou sur n’importe quel hôte. Une sauvegarde devient inefficace lorsqu'elle reste stockée sur l'hôte."
#categoryMenu="outils_proxmox_ve"
#nameMenu="Sauvegarde de l'hôte Proxmox VE"
#commutatorLetter=""
#commutatorWord="sauvegarde_de_lhote_proxmox_ve"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/misc/host-backup.sh)"
}

nettoyage_du_noyau_proxmox_ve(){
#helpDescription="Le nettoyage des images de noyau inutilisées est bénéfique pour réduire la longueur du menu GRUB et libérer de l'espace disque. En supprimant les noyaux anciens et inutilisés, le système est en mesure de conserver de l'espace disque et de rationaliser le processus de démarrage. Exécutez la commande ci-dessous dans le shell Proxmox VE."
#categoryMenu="outils_proxmox_ve"
#nameMenu="Nettoyage du noyau Proxmox VE"
#commutatorLetter=""
#commutatorWord="nettoyage_du_noyau_proxmox_ve"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/misc/kernel-clean.sh)"
}

broche_du_noyau_proxmox_ve(){
#helpDescription="Kernel Pin est un outil essentiel pour gérer sans effort l'épinglage et le désépinglage du noyau. Exécutez la commande ci-dessous dans le shell Proxmox VE."
#categoryMenu="outils_proxmox_ve"
#nameMenu="Broche du noyau Proxmox VE"
#commutatorLetter=""
#commutatorWord="broche_du_noyau_proxmox_ve"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/misc/kernel-pin.sh)"
}

nettoyeur_proxmox_ve_lxc(){
#helpDescription="Ce script fournit des options pour supprimer les journaux et le cache, et repeupler les listes apt pour les systèmes Ubuntu et Debian. Exécutez la commande ci-dessous dans le shell Proxmox VE."
#categoryMenu="outils_proxmox_ve"
#nameMenu="Nettoyeur Proxmox VE LXC"
#commutatorLetter=""
#commutatorWord="nettoyeur_proxmox_ve_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/misc/clean-lxcs.sh)"
}

modification_du_systeme_de_fichiers_proxmox_ve_lxc(){
#helpDescription="Cela permet de maintenir les performances du SSD en gérant les blocs inutilisés. Les systèmes de stockage à provisionnement léger nécessitent également une gestion pour éviter toute utilisation inutile du stockage. Les machines virtuelles automatisent fstrim, tandis que les conteneurs LXC ont besoin de processus fstrim manuels ou automatisés pour des performances optimales. Ceci est conçu pour fonctionner uniquement avec les SSD sur les systèmes de fichiers ext4. Plus d'informations. Exécutez la commande ci-dessous dans le shell Proxmox VE."
#categoryMenu="outils_proxmox_ve"
#nameMenu="Modification du système de fichiers Proxmox VE LXC"
#commutatorLetter=""
#commutatorWord="modification_du_systeme_de_fichiers_proxmox_ve_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/misc/fstrim.sh)"
}

mise_a_jour_proxmox_ve_lxc(){
#helpDescription="Ce script a été créé pour simplifier et accélérer le processus de mise à jour de tous les conteneurs LXC sur différentes distributions Linux, telles que Ubuntu, Debian, Devuan, Alpine Linux, CentOS-Rocky-Alma, Fedora et ArchLinux. Il est conçu pour ignorer automatiquement les modèles et les conteneurs spécifiques pendant la mise à jour, améliorant ainsi sa commodité et sa facilité d'utilisation. Exécutez la commande ci-dessous dans le shell Proxmox VE."
#categoryMenu="outils_proxmox_ve"
#nameMenu="Mise à jour Proxmox VE LXC"
#commutatorLetter=""
#commutatorWord="mise_a_jour_proxmox_ve_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/misc/update-lxcs.sh)"
}



moniteur_proxmox_ve_all(){
#helpDescription="Ce script ajoutera Monitor-All à Proxmox VE, qui surveillera l'état de toutes vos instances, conteneurs et machines virtuelles, à l'exception des modèles et des modèles définis par l'utilisateur, et les redémarrera ou les réinitialisera automatiquement s'ils ne répondent plus. Monitor-All conserve également un journal de l'ensemble du processus, ce qui peut être utile à des fins de dépannage et de surveillance. Les machines virtuelles sans l'agent invité QEMU installé doivent être exclues. Avant de générer un nouveau CT/VM non trouvé dans ce référentiel, il est nécessaire d'arrêter Proxmox VE Monitor-All en exécutant systemctl stop ping-instances. Toutes les commandes sont exécutées à partir du shell Proxmox VE."
#categoryMenu="outils_proxmox_ve"
#nameMenu="Moniteur Proxmox VE-All"
#commutatorLetter=""
#commutatorWord="moniteur_proxmox_ve_all"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/misc/monitor-all.sh)"
	# a revoir #####################################################################################################

}

installation_netdata_proxmox_ve(){
#helpDescription="Netdata est un outil de surveillance des performances en temps réel open source conçu pour fournir des informations sur les performances et l'état des systèmes et des applications. Il est souvent utilisé par les administrateurs système, les professionnels DevOps et les développeurs pour surveiller et résoudre les problèmes sur les serveurs et autres appareils. Pour installer/désinstaller Netdata sur Proxmox VE, exécutez la commande ci-dessous dans le shell Proxmox VE."
#categoryMenu="outils_proxmox_ve"
#nameMenu="Installation Netdata sur Proxmox VE"
#commutatorLetter=""
#commutatorWord="installation_netdata_proxmox_ve"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/misc/netdata.sh)"
	# a revoir #####################################################################################################
}

post_installation_proxmox_ve(){
#helpDescription="Ce script fournit des options de gestion des référentiels Proxmox VE, notamment la désactivation du référentiel Enterprise, l'ajout ou la correction des sources PVE, l'activation du référentiel sans abonnement, l'ajout du référentiel de test, la désactivation du nag d'abonnement, la mise à jour de Proxmox VE et le redémarrage du système. Exécutez la commande ci-dessous dans le shell Proxmox VE. Il est recommandé de répondre « oui » (y) à toutes les options présentées au cours du processus."
#categoryMenu="outils_proxmox_ve"
#nameMenu="Post-installation de Proxmox VE"
#commutatorLetter=""
#commutatorWord="post_installation_proxmox_ve"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/misc/post-pve-install.sh)"
}

microcode_processeur_proxmox_ve(){
#helpDescription="Le microcode du processeur est une couche de logiciel de bas niveau qui s'exécute sur le processeur et fournit des correctifs ou des mises à jour à son micrologiciel. Les mises à jour du microcode peuvent corriger les bogues matériels, améliorer les performances et renforcer les fonctions de sécurité du processeur. Exécutez la commande ci-dessous dans le shell Proxmox VE. Après un redémarrage, vous pouvez vérifier si des mises à jour du microcode sont actuellement en vigueur en exécutant la commande suivante : journalctl -k | grep -E \"microcode\" | head -n 1"
#categoryMenu="outils_proxmox_ve"
#nameMenu="Microcode du processeur Proxmox VE"
#commutatorLetter=""
#commutatorWord="microcode_processeur_proxmox_ve"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/misc/microcode.sh)"
	# a revoir #####################################################################################################

}

conteneur_home_assistant_lxc(){
#helpDescription="Une installation autonome basée sur un conteneur de Home Assistant Core signifie que le logiciel est installé dans un conteneur Docker, distinct du système d'exploitation hôte. Cela permet une flexibilité et une évolutivité, ainsi qu'une sécurité améliorée, car le conteneur peut être facilement déplacé ou isolé des autres processus sur l'hôte. Si le LXC est créé avec Privilège, le script configurera automatiquement le relais USB. Pour créer un nouveau conteneur Proxmox VE Home Assistant LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. Pour mettre à jour des conteneurs, supprimer des images ou installer HACS, exécutez la commande ci-dessous (ou saisissez update) dans la console LXC. Commande pour créer un nouveau conteneur Proxmox VE Home Assistant LXC : bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/homeassistant.sh)" Commande pour mettre à jour des conteneurs, supprimer des images ou installer HACS dans la console LXC : update"
#categoryMenu="assistant_a_domicile"
#nameMenu="Conteneur Home Assistant LXC"
#commutatorLetter=""
#commutatorWord="conteneur_home_assistant_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/homeassistant.sh)"
}

assistant_domestique_core_lxc(){
#helpDescription="Une installation autonome de Home Assistant Core fait référence à une configuration dans laquelle le logiciel Home Assistant Core est installé directement sur un appareil ou un système d'exploitation, sans utiliser de conteneurs Docker. Cela fournit une solution plus simple, mais moins flexible et évolutive, car le logiciel est étroitement couplé au système sous-jacent. Si le LXC est créé avec Privilège, le script configurera automatiquement le relais USB. Utilisez UNIQUEMENT Ubuntu 24.04 Nécessite PVE 8.2.2 avec le noyau 6.8.4-3-pve ou plus récent Pour créer un nouveau Proxmox VE Home Assistant Core LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. Pour mettre à jour, installer HACS ou Filebrowser, exécutez la commande ci-dessous (ou saisissez update) dans la console LXC. Commande pour créer un nouveau Proxmox VE Home Assistant Core LXC : bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/homeassistant-core.sh)" Commande pour mettre à jour, installer HACS ou Filebrowser dans la console LXC : update"
#categoryMenu="assistant_a_domicile"
#nameMenu="Assistant domestique Core LXC"
#commutatorLetter=""
#commutatorWord="assistant_domestique_core_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/homeassistant-core.sh)"
}

machine_virtuelle_home_assistant_os(){
#helpDescription="Possibilité de créer une machine virtuelle à l'aide d'une image stable, bêta ou de développement Ce script automatise le processus de création d'une machine virtuelle (VM) à l'aide de l'image disque officielle KVM (qcow2) fournie par l'équipe Home Assistant. Il consiste à rechercher, télécharger et extraire l'image, à définir les paramètres définis par l'utilisateur, à importer et à connecter le disque, à définir l'ordre de démarrage et à démarrer la VM. Il prend en charge différents types de stockage et n'implique aucune installation cachée. Le disque doit avoir une taille minimale de 32 Go et sa taille ne peut pas être modifiée lors de la création de la VM. Pour créer une nouvelle machine virtuelle Proxmox VE Home Assistant OS, exécutez la commande ci-dessous dans le shell Proxmox VE. Commande pour créer une nouvelle machine virtuelle Proxmox VE Home Assistant OS : bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/vm/haos-vm.sh)""
#categoryMenu="machine_virtuelle"
#nameMenu="Machine virtuelle du système d'exploitation Home Assistant"
#commutatorLetter=""
#commutatorWord="machine_virtuelle_home_assistant_os"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/vm/haos-vm.sh)"
}

machine_virtuelle_haos_pimox(){
#helpDescription="Possibilité de créer une machine virtuelle à l'aide d'une image stable, bêta ou de développement Le script automatise le processus manuel de recherche, de téléchargement et d'extraction de l'image disque aarch64 (qcow2) fournie par l'équipe Home Assistant, la création d'une VM avec des paramètres définis par l'utilisateur, l'importation et la connexion du disque, la définition de l'ordre de démarrage et le démarrage de la VM. Pour créer une nouvelle VM PiMox HAOS, exécutez la commande ci-dessous dans le shell Proxmox VE. Commande pour créer une nouvelle VM PiMox HAOS : bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/vm/pimox-haos-vm.sh)""
#categoryMenu="machine_virtuelle"
#nameMenu="Machine virtuelle HAOS PiMox"
#commutatorLetter=""
#commutatorWord="machine_virtuelle_haos_pimox"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/vm/pimox-haos-vm.sh)"
}

conteneur_podman_homeassistant_lxc(){
#helpDescription="NE FONCTIONNE PAS SUR ZFS Une installation autonome de Home Assistant Core basée sur un conteneur Podman signifie que le logiciel Home Assistant Core est installé dans un conteneur géré par Podman, distinct du système d'exploitation hôte. Cela fournit une solution flexible et évolutive pour l'exécution du logiciel, car le conteneur peut être facilement déplacé entre les systèmes hôtes ou isolé des autres processus pour des raisons de sécurité. Podman est un outil open source populaire pour la gestion des conteneurs, similaire à Docker, mais conçu pour être utilisé sur les systèmes Linux sans démon. 🛈 Si le LXC est créé avec Privilège, le script configurera automatiquement le relais USB. Pour créer un nouveau conteneur Proxmox VE Podman Home Assistant LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. Commande pour créer un nouveau conteneur Podman Home Assistant LXC : bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/podman-homeassistant.sh)""
#categoryMenu="conteneur_podman"
#nameMenu="Conteneur Podman Home Assistant LXC"
#commutatorLetter=""
#commutatorWord="conteneur_podman_homeassistant_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/podman-homeassistant.sh)"
}

esphome_lxc(){
#helpDescription="ESPHome est une plateforme permettant de contrôler des appareils basés sur ESP8266/ESP32 à l'aide de fichiers de configuration et de les intégrer aux systèmes domotiques. Elle offre un moyen simple et flexible de configurer et de gérer les fonctionnalités de ces appareils, notamment la définition et l'automatisation des actions, la surveillance des capteurs et la connexion aux réseaux et autres services. ESPHome est conçu pour être convivial et facile à utiliser, et prend en charge une large gamme de fonctionnalités et d'intégrations, ce qui en fait un choix populaire pour les projets domotiques et les applications IoT. Pour créer un nouveau Proxmox VE ESPHome LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. Commande pour créer un nouveau conteneur ESPHome LXC : bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/esphome.sh)""
#categoryMenu="conteneur"
#nameMenu="ESPHome LXC"
#commutatorLetter=""
#commutatorWord="esphome_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/esphome.sh)"
}

fhem_lxc(){
#helpDescription="FHEM signifie « Freundliche Hausautomation und Energie-Messung », ce qui signifie « Automatisation domestique et mesure de l'énergie conviviales ». Le logiciel peut s'interfacer avec une large gamme d'appareils, notamment des systèmes d'éclairage, des thermostats, des stations météorologiques et des appareils multimédias, entre autres. Pour créer un nouveau Proxmox VE FHEM LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. Commande pour créer un nouveau conteneur FHEM LXC : bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/fhem.sh)""
#categoryMenu="conteneur"
#nameMenu="FHEM LXC"
#commutatorLetter=""
#commutatorWord="fhem_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/fhem.sh)"
}

homebridge_lxc(){
#helpDescription="Homebridge est une plate-forme logicielle open source populaire qui vous permet d'intégrer des appareils et des services de maison intelligente qui ne prennent pas en charge nativement le protocole HomeKit d'Apple dans l'écosystème HomeKit. Cela vous permet de contrôler et d'automatiser ces appareils à l'aide de Siri, de l'application Home ou d'autres applications compatibles HomeKit, ce qui facilite le regroupement d'une variété d'appareils différents dans un système de maison intelligente unifié. Avec Homebridge, vous pouvez étendre les capacités de votre maison intelligente, ouvrant ainsi de nouvelles possibilités d'automatisation et de contrôle de vos appareils et systèmes. Pour créer un nouveau Proxmox VE Homebridge LXC, exécutez la commande ci-dessous dans le shell Proxmox VE : bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/homebridge.sh)"" 
#categoryMenu="conteneur"
#nameMenu="Pont Homebridge LXC"
#commutatorLetter=""
#commutatorWord="homebridge_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/homebridge.sh)"
}

iobroker_lxc(){
#helpDescription="ioBroker est une plateforme open source permettant de créer et de gérer des systèmes domotiques intelligents. Elle fournit une interface de contrôle et de gestion centralisée pour les appareils connectés, les capteurs et autres appareils IoT. ioBroker s'intègre à une large gamme de systèmes, d'appareils et de services de maison intelligente populaires, ce qui facilite l'automatisation des tâches et des processus, la surveillance et le contrôle des appareils, ainsi que la collecte et l'analyse de données provenant de diverses sources. Grâce à son architecture flexible et à son interface facile à utiliser, ioBroker est conçu pour permettre aux utilisateurs de créer et de personnaliser facilement leurs propres systèmes domotiques intelligents, quels que soient leur formation technique ou leur expérience. Pour créer un nouveau Proxmox VE ioBroker LXC, exécutez la commande ci-dessous dans le shell Proxmox VE : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/iobroker.sh)\"" 
#categoryMenu="conteneur"
#nameMenu="ioBroker LXC"
#commutatorLetter=""
#commutatorWord="iobroker_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/iobroker.sh)"
}

n8n_lxc(){
#helpDescription="n8n est un outil d'automatisation des flux de travail qui permet aux utilisateurs d'automatiser diverses tâches et processus en connectant diverses sources de données, systèmes et services. Il fournit une interface visuelle pour la création de flux de travail, permettant aux utilisateurs de définir et d'automatiser facilement des séquences d'actions complexes, telles que le traitement des données, la ramification conditionnelle et les appels d'API. n8n prend en charge une large gamme d'intégrations, ce qui en fait un outil polyvalent pour automatiser une variété de cas d'utilisation, des flux de travail de traitement de données simples aux processus commerciaux complexes. Grâce à son architecture extensible, n8n est conçu pour être facilement personnalisable et peut être adapté pour répondre aux besoins spécifiques de différents utilisateurs et secteurs d'activité. Pour créer un nouveau Proxmox VE n8n LXC, exécutez la commande ci-dessous dans le shell Proxmox VE : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/n8n.sh)\""
#categoryMenu="conteneur"
#nameMenu="n8n LXC"
#commutatorLetter=""
#commutatorWord="n8n_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/n8n.sh)"
}

node_red_lxc(){
#helpDescription="Node-RED est un outil de programmation visuelle qui permet aux développeurs et aux non-développeurs de connecter facilement des périphériques matériels, des API et des services en ligne pour créer des applications personnalisées. Il fournit une interface visuelle pour la création de flux de travail, ce qui facilite la création et la modification d'intégrations complexes sans avoir à écrire de code. Node-RED est utilisé dans une large gamme d'applications, des automatisations simples aux intégrations complexes, et est connu pour sa simplicité, sa polyvalence et sa facilité d'utilisation. Pour créer un nouveau Proxmox VE Node-RED LXC, exécutez la commande ci-dessous dans le shell Proxmox VE : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/node-red.sh)\""
#categoryMenu="conteneur"
#nameMenu="Node-RED LXC"
#commutatorLetter=""
#commutatorWord="node_red_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/node-red.sh)"
}

openhab_lxc(){
#helpDescription="openHAB est une plate-forme domotique open source populaire qui fournit une solution indépendante des fournisseurs et des technologies pour l'intégration et l'automatisation de divers appareils et services de maison intelligente. Elle prend en charge une large gamme d'appareils et de protocoles, ce qui facilite le regroupement de différents systèmes et appareils dans un écosystème de maison intelligente unifié. Grâce à son interface conviviale et à ses puissantes capacités d'automatisation, openHAB facilite la création d'automatisations personnalisées et la surveillance et le contrôle de vos appareils et systèmes de maison intelligente, le tout à partir d'une seule interface. Pour créer un nouveau Proxmox VE openHAB LXC, exécutez la commande ci-dessous dans le shell Proxmox VE : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/openhab.sh)\""
#categoryMenu="conteneur"
#nameMenu="OpenHAB LXC"
#commutatorLetter=""
#commutatorWord="openhab_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/openhab.sh)"
}

emqx_lxc(){
#helpDescription="EMQX est un broker MQTT open source doté d'un moteur de traitement de messages en temps réel hautes performances. Il est conçu pour gérer les déploiements IoT à grande échelle, offrant une livraison de messages rapide et fiable pour les appareils connectés. EMQX est connu pour son évolutivité, sa fiabilité et sa faible latence, ce qui en fait un choix populaire pour les applications IoT et M2M. Il offre également une large gamme de fonctionnalités et de plugins pour une sécurité, une surveillance et une gestion améliorées. Pour créer un nouveau Proxmox VE EMQX LXC, exécutez la commande ci-dessous dans le shell Proxmox VE : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/emqx.sh)\""
#categoryMenu="conteneur"
#nameMenu="EMQX LXC"
#commutatorLetter=""
#commutatorWord="emqx_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/emqx.sh)"
}

hivemq_ce_lxc(){
#helpDescription="HiveMQ CE est un courtier MQTT open source basé sur Java qui prend entièrement en charge MQTT 3.x et MQTT 5. Pour créer un nouveau Proxmox VE HiveMQ CE LXC, exécutez la commande ci-dessous dans le shell Proxmox VE : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/hivemq.sh)\""
#categoryMenu="conteneur"
#nameMenu="HiveMQ CE LXC"
#commutatorLetter=""
#commutatorWord="hivemq_ce_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/hivemq.sh)"
}

mqtt_lxc(){
#helpDescription="Eclipse Mosquitto est un courtier de messages open source qui implémente le protocole MQTT (Message Queuing Telemetry Transport). Il s'agit d'un courtier de messages léger et simple à utiliser qui permet aux appareils et applications IoT de communiquer entre eux en échangeant des messages en temps réel. Mosquitto est largement utilisé dans les applications IoT, en raison de ses faibles besoins en ressources et de sa compatibilité avec une large gamme d'appareils et de plates-formes. Pour créer un nouveau Proxmox VE MQTT LXC, exécutez la commande ci-dessous dans le shell Proxmox VE : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/mqtt.sh)\""
#categoryMenu="conteneur"
#nameMenu="MQTT LXC"
#commutatorLetter=""
#commutatorWord="mqtt_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/mqtt.sh)"
}

lapinmq_lxc(){
#helpDescription="RabbitMQ est un courtier de messagerie et de streaming fiable et mature, facile à déployer dans des environnements cloud, sur site et sur votre machine locale. Pour créer un nouveau RabbitMQ LXC Proxmox VE, exécutez la commande ci-dessous dans le shell Proxmox VE : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/rabbitmq.sh)\""
#categoryMenu="conteneur"
#nameMenu="LapinMQ LXC"
#commutatorLetter=""
#commutatorWord="lapinmq_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/rabbitmq.sh)"
}

apache_cassandra_lxc(){
#helpDescription="Apache Cassandra est une base de données distribuée NoSQL open source à laquelle des milliers d'entreprises font confiance pour son évolutivité et sa haute disponibilité sans compromettre les performances. Pour créer un nouveau Proxmox VE Apache Cassandra LXC, exécutez la commande ci-dessous dans le shell Proxmox VE : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/apache-cassandra.sh)\""
#categoryMenu="conteneur"
#nameMenu="Apache Cassandra LXC"
#commutatorLetter=""
#commutatorWord="apache_cassandra_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/apache-cassandra.sh)"
}

apache_couchdb_lxc(){
#helpDescription="Apache CouchDB est une base de données NoSQL avec une synchronisation multi-maître transparente, adaptée du Big Data au mobile, avec une API HTTP/JSON intuitive et conçue pour la fiabilité. Pour créer un nouveau Proxmox VE Apache CouchDB LXC, exécutez la commande ci-dessous dans le shell Proxmox VE : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/apache-couchdb.sh)\""
#categoryMenu="conteneur"
#nameMenu="Apache CouchDB LXC"
#commutatorLetter=""
#commutatorWord="apache_couchdb_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/apache-couchdb.sh)"
}

influxdb_lxc(){
#helpDescription="InfluxDB est une base de données optimisée pour les données horodatées, comme les métriques IoT et industrielles. Vous pouvez choisir d'installer InfluxDB v1 avec Chronograf ou InfluxDB v2 avec Telegraf. Telegraf collecte et envoie des données de métriques et d'événements vers diverses sorties. Pour créer un nouveau Proxmox VE InfluxDB LXC, exécutez la commande ci-dessous dans le shell Proxmox VE : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/influxdb.sh)\""
#categoryMenu="conteneur"
#nameMenu="InfluxDB LXC"
#commutatorLetter=""
#commutatorWord="influxdb_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/influxdb.sh)"
}

mariadb_lxc(){
#helpDescription="MariaDB est une version dérivée de MySQL, offrant des fonctionnalités de niveau entreprise et un support commercial. Pour créer un nouveau Proxmox VE MariaDB LXC, exécutez la commande : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/mariadb.sh)\""
#categoryMenu="conteneur"
#nameMenu="MariaDB LXC"
#commutatorLetter=""
#commutatorWord="mariadb_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/mariadb.sh)"
}

mongodb_lxc(){
#helpDescription="MongoDB est une base de données NoSQL avec un modèle de données orienté document, idéal pour gérer de gros volumes de données. Pour créer un nouveau Proxmox VE MongoDB LXC, exécutez la commande : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/mongodb.sh)\""
#categoryMenu="conteneur"
#nameMenu="MongoDB LXC"
#commutatorLetter=""
#commutatorWord="mongodb_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/mongodb.sh)"
}

pocketbase_lxc(){
#helpDescription="Pocketbase est un backend open source avec une base de données SQLite intégrée, des abonnements en temps réel, une gestion d'authentification intégrée, une interface utilisateur de tableau de bord et une API REST. Pour créer un nouveau Proxmox VE Pocketbase LXC, exécutez la commande : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/pocketbase.sh)\""
#categoryMenu="conteneur"
#nameMenu="Pocketbase LXC"
#commutatorLetter=""
#commutatorWord="pocketbase_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/pocketbase.sh)"
}

postgresql_lxc(){
#helpDescription="PostgreSQL est un système de gestion de base de données relationnelle open source connu pour son extensibilité et son strict respect des normes SQL. Pour créer un nouveau Proxmox VE PostgreSQL LXC, exécutez la commande : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/postgresql.sh)\". Paramètres par défaut : 1 Go de RAM - 4 Go de stockage - 1 vCPU. Adminer est un outil de gestion de base de données complet. Interface administrateur : IP/adminer/. Post-installation."
#categoryMenu="conteneur"
#nameMenu="PostgreSQL LXC"
#commutatorLetter=""
#commutatorWord="postgresql_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/postgresql.sh)"
}

redis_lxc(){
#helpDescription="Redis est un magasin de données open source en mémoire utilisé comme cache, base de données vectorielle, base de données de documents, moteur de streaming et courtier de messages. Pour créer un nouveau Proxmox VE Redis LXC, exécutez la commande : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/redis.sh)\". Paramètres par défaut : 1 Go de RAM - 4 Go de stockage - 1 vCPU. Configuration de Redis : nano /etc/redis/redis.conf"
#categoryMenu="conteneur"
#nameMenu="Redis LXC"
#commutatorLetter=""
#commutatorWord="redis_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/redis.sh)"
}

deconz_lxc(){
#helpDescription="deCONZ est un logiciel de gestion et de contrôle des appareils domestiques intelligents basés sur Zigbee. Il permet de paramétrer, de configurer et de visualiser l'état des appareils connectés, ainsi que de déclencher des actions et des automatisations. Il fonctionne comme un pont entre le réseau Zigbee et d'autres systèmes domotiques et peut être utilisé comme solution autonome ou intégré dans des configurations existantes. Pour créer un nouveau Proxmox VE deCONZ LXC, exécutez la commande : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/deconz.sh)\". Paramètres par défaut : 1 Go de RAM - 4 Go de stockage - 2 vCPU - Privilégié. Interface deCONZ : IP:80"
#categoryMenu="conteneur"
#nameMenu="deCONZ LXC"
#commutatorLetter=""
#commutatorWord="deconz_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/deconz.sh)"
}

matterbridge_lxc(){
#helpDescription="Matterbridge vous permet de rendre tous vos appareils Matter opérationnels en quelques minutes sans avoir à vous soucier du processus de couplage de chaque appareil. Pour créer un nouveau Proxmox VE Matterbridge LXC, exécutez la commande : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/matterbridge.sh)\". Paramètres par défaut : 1 Go de RAM - 4 Go de stockage - 1 vCPU. Interface Matterbridge : IP:8283"
#categoryMenu="conteneur"
#nameMenu="Matterbridge LXC"
#commutatorLetter=""
#commutatorWord="matterbridge_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/matterbridge.sh)"
}

zwave_js_ui_lxc(){
#helpDescription="Z-Wave JS UI est un logiciel open source qui sert de passerelle entre les appareils Z-Wave et le protocole MQTT (Message Queuing Telemetry Transport), permettant aux utilisateurs de contrôler et de surveiller leurs appareils Z-Wave via une interface utilisateur. Pour créer une nouvelle interface utilisateur Z-Wave JS LXC Proxmox VE, exécutez la commande : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/zwave-js-ui.sh)\". Paramètres par défaut : 1 Go de RAM - 4 Go de stockage - 2 vCPU - Privilégié. Interface utilisateur Z-Wave JS : IP : 8091"
#categoryMenu="conteneur"
#nameMenu="Interface utilisateur Z-Wave JS LXC"
#commutatorLetter=""
#commutatorWord="zwave_js_ui_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/zwave-js-ui.sh)"
}

zigbee2mqtt_lxc(){
#helpDescription="Zigbee2MQTT est un projet logiciel open source qui vous permet d'utiliser des appareils domestiques intelligents basés sur Zigbee (tels que ceux vendus sous les marques Philips Hue et Ikea Tradfri) avec des systèmes domotiques basés sur MQTT, comme Home Assistant, Node-RED et d'autres. Pour créer un nouveau Proxmox VE Zigbee2MQTT LXC, exécutez la commande : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/zigbee2mqtt.sh)\". Paramètres par défaut : 1 Go de RAM - 4 Go de stockage - 2 vCPU - Privilégié. En guise d'alternative, vous pouvez utiliser Alpine Linux et le package Zigbee2MQTT pour créer un conteneur Zigbee2MQTT LXC avec un temps de création plus rapide et une utilisation minimale des ressources système. Pour créer un nouveau Proxmox VE Alpine-Zigbee2MQTT LXC, exécutez la commande : bash -c \"$(wget -qO - https://github.com/tteck/Proxmox/raw/main/ct/alpine-zigbee2mqtt.sh)\". Paramètres par défaut : 256 Mo de RAM - 300 Mo de stockage - 1 vCPU - Privilégié. Post-installation"
#categoryMenu="conteneur"
#nameMenu="Zigbee2MQTT LXC"
#commutatorLetter=""
#commutatorWord="zigbee2mqtt_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/zigbee2mqtt.sh)"
}

alpine_zigbee2mqtt_lxc(){
#helpDescription="En guise d'alternative, vous pouvez utiliser Alpine Linux et le package Zigbee2MQTT pour créer un conteneur Zigbee2MQTT LXC avec un temps de création plus rapide et une utilisation minimale des ressources système. Pour créer un nouveau Proxmox VE Alpine-Zigbee2MQTT LXC, exécutez la commande : bash -c \"$(wget -qO - https://github.com/tteck/Proxmox/raw/main/ct/alpine-zigbee2mqtt.sh)\". Paramètres par défaut : 256 Mo de RAM - 300 Mo de stockage - 1 vCPU - Privilégié. Post-installation"
#categoryMenu="conteneur"
#nameMenu="Alpine-Zigbee2MQTT LXC"
#commutatorLetter=""
#commutatorWord="alpine_zigbee2mqtt_lxc"
    bash -c "$(wget -qO - https://github.com/tteck/Proxmox/raw/main/ct/alpine-zigbee2mqtt.sh)"
}

changedetection_lxc(){
#helpDescription="Change Detection est un service qui vous permet de surveiller les modifications apportées aux pages Web et de recevoir des notifications lorsque des modifications se produisent. Pour créer un nouveau LXC de détection des modifications Proxmox VE, exécutez la commande : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/changedetection.sh)\". Paramètres par défaut : 512 Mo de RAM - 2 Go de stockage - 1 vCPU. Pour mettre à jour la détection des modifications, exécutez la commande : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/changedetection.sh)\" (ou saisissez update) dans la console LXC. Interface de détection de changement : IP:5000"
#categoryMenu="conteneur"
#nameMenu="Change Detection LXC"
#commutatorLetter=""
#commutatorWord="changedetection_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/changedetection.sh)"
}

glances_lxc(){
#helpDescription="Glances est un outil de surveillance multiplateforme open source. Il permet de surveiller en temps réel divers aspects de votre système tels que le processeur, la mémoire, le disque, l'utilisation du réseau, etc. Pour installer Glances, exécutez la commande : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/misc/glances.sh)\". Paramètres par défaut : 512 Mo de RAM - 2 Go de stockage - 1 vCPU. Interface Glances : IP:61208"
#categoryMenu="conteneur"
#nameMenu="Glances LXC"
#commutatorLetter=""
#commutatorWord="glances_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/misc/glances.sh)"
}


grafana_lxc(){
#helpDescription="Grafana est une plateforme de visualisation et de surveillance des données qui permet aux utilisateurs d'interroger, de visualiser, d'alerter et de comprendre les métriques, les journaux et d'autres sources de données. Pour créer un nouveau Proxmox VE Grafana LXC, exécutez la commande : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/grafana.sh)\". Paramètres par défaut : 512 Mo de RAM - 2 Go de stockage - 1 vCPU. En guise d'alternative, vous pouvez utiliser Alpine Linux et le package Grafana pour créer un conteneur Grafana LXC avec un temps de création plus rapide et une utilisation minimale des ressources système. Pour créer un nouveau Proxmox VE Alpine-Grafana LXC, exécutez la commande : bash -c \"$(wget -qO - https://github.com/tteck/Proxmox/raw/main/ct/alpine-grafana.sh)\". Paramètres par défaut : 256 Mio de RAM - 500 Mio de stockage - 1 vCPU. Interface Grafana : IP:3000. Connexion initiale : nom d'utilisateur admin, mot de passe admin"
#categoryMenu="conteneur"
#nameMenu="Grafana LXC"
#commutatorLetter=""
#commutatorWord="grafana_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/grafana.sh)"
}

myspeed_lxc(){
#helpDescription="MySpeed est un logiciel d'analyse de test de vitesse qui enregistre votre vitesse Internet jusqu'à 30 jours. Pour créer un nouveau Proxmox VE MySpeed LXC, exécutez la commande : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/myspeed.sh)\". Paramètres par défaut : 1 Go de RAM - 4 Go de stockage - 1 vCPU. Pour mettre à jour MySpeed, exécutez la commande : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/myspeed.sh)\" (ou saisissez update) dans la console LXC. Interface MySpeed : IP : 5216"
#categoryMenu="conteneur"
#nameMenu="MySpeed LXC"
#commutatorLetter=""
#commutatorWord="myspeed_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/myspeed.sh)"
}

notifiarr_lxc(){
#helpDescription="Notifiarr est un système spécialement conçu pour rassembler de nombreuses applications afin de gérer et de personnaliser les notifications via Discord. Pour créer un nouveau Proxmox VE Notifiarr LXC, exécutez la commande : bash -c \"$(wget -qO - https://github.com/tteck/Proxmox/raw/main/ct/notifiarr.sh)\". Paramètres par défaut : 512 Mo de RAM - 2 Go de stockage - 1 vCPU. Modifiez manuellement /etc/notifiarr/notifiarr.confpour saisir la clé API de Notifiarr.com et créez un mot de passe pour l'interface utilisateur. Interface de notification : IP : 5454"
#categoryMenu="conteneur"
#nameMenu="Notifiarr LXC"
#commutatorLetter=""
#commutatorWord="notifiarr_lxc"
    bash -c "$(wget -qO - https://github.com/tteck/Proxmox/raw/main/ct/notifiarr.sh)"
}

openobserve_lxc(){
#helpDescription="OpenObserve est une solution simple mais sophistiquée de recherche de journaux, de surveillance d'infrastructure et d'APM. Pour créer un nouveau Proxmox VE OpenObserve LXC, exécutez la commande : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/openobserve.sh)\". Paramètres par défaut : 512 Mo de RAM - 3 Go de stockage - 1 vCPU. Pour mettre à jour OpenObserve, exécutez la commande : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/openobserve.sh)\" (ou saisissez update) dans la console LXC. Interface OpenObserve : IP:5080"
#categoryMenu="conteneur"
#nameMenu="OpenObserve LXC"
#commutatorLetter=""
#commutatorWord="openobserve_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/openobserve.sh)"
}

peanut_lxc(){
#helpDescription="PeaNUT est un petit tableau de bord pour les outils UPS réseau. Pour créer un nouveau Proxmox VE PeaNUT LXC, exécutez la commande : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/peanut.sh)\". Paramètres par défaut : 1 Go de RAM - 4 Go de stockage - 1 vCPU. Pour mettre à jour PeaNUT, exécutez la commande : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/peanut.sh)\" (ou saisissez update) dans la console LXC. Interface PeaNUT : IP:3000"
#categoryMenu="conteneur"
#nameMenu="PeaNUT LXC"
#commutatorLetter=""
#commutatorWord="peanut_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/peanut.sh)"
}

pialert_lxc(){
#helpDescription="Pi.Alert est un détecteur d'intrusion WIFI/LAN. Il vérifie les appareils connectés et vous alerte en cas d'appareils inconnus. Il prévient également de la déconnexion des appareils \"toujours connectés\". Pour créer un nouveau Proxmox VE Pi.Alert LXC, exécutez la commande : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/pialert.sh)\". Paramètres par défaut : 512 Mo de RAM - 3 Go de stockage - 1 vCPU. Pour mettre à jour Pi.Alert, exécutez la commande : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/pialert.sh)\" (ou saisissez update) dans la console LXC. Interface Pi.Alert : IP/pialert/"
#categoryMenu="conteneur"
#nameMenu="Pi.Alert LXC"
#commutatorLetter=""
#commutatorWord="pialert_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/pialert.sh)"
}

prometheus_lxc(){
#helpDescription="Prometheus est largement utilisé pour surveiller les performances et l'état de santé de divers composants et applications d'infrastructure, et déclencher des alertes en fonction de règles prédéfinies. Il dispose d'un modèle de données multidimensionnel et prend en charge diverses sources et exportateurs de données, ce qui en fait une solution de surveillance extrêmement flexible et évolutive. Pour créer un nouveau Proxmox VE Prometheus LXC, exécutez la commande : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/prometheus.sh)\". Paramètres par défaut : 2 Go de RAM - 4 Go de stockage - 1 vCPU. Interface Prometheus : IP:9090"
#categoryMenu="conteneur"
#nameMenu="Prometheus LXC"
#commutatorLetter=""
#commutatorWord="prometheus_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/prometheus.sh)"
}

smokeping_lxc(){
#helpDescription="SmokePing est un outil de mesure de latence de luxe. Il peut mesurer, stocker et afficher la latence, la distribution de la latence et la perte de paquets. Pour créer un nouveau Proxmox VE SmokePing LXC, exécutez la commande : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/smokeping.sh)\". Paramètres par défaut : 512 Mo de RAM - 2 Go de stockage - 1 vCPU. Interface de SmokePing : IP/smokeping"
#categoryMenu="conteneur"
#nameMenu="SmokePing LXC"
#commutatorLetter=""
#commutatorWord="smokeping_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/smokeping.sh)"
}

umami_lxc(){
#helpDescription="Umami facilite la collecte, l'analyse et la compréhension de vos données Web, tout en préservant la confidentialité des visiteurs et la propriété des données. Pour créer un nouveau Proxmox VE Umami LXC, exécutez la commande : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/umami.sh)\". Paramètres par défaut : 1 Go de RAM - 12 Go de stockage - 1 vCPU. Pour mettre à jour Umami, exécutez la commande : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/umami.sh)\" (ou saisissez update) dans la console LXC. Interface Umami : IP:3000"
#categoryMenu="conteneur"
#nameMenu="Umami LXC"
#commutatorLetter=""
#commutatorWord="umami_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/umami.sh)"
}

uptimekuma_lxc(){
#helpDescription="Uptime Kuma est un système de surveillance et d'alerte qui surveille la disponibilité et les performances des serveurs, des sites Web et d'autres appareils connectés à Internet. Pour créer un nouveau Proxmox VE Uptime Kuma LXC, exécutez la commande : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/uptimekuma.sh)\". Paramètres par défaut : 1 Go de RAM - 2 Go de stockage - 1 vCPU. Pour mettre à jour Uptime Kuma, exécutez la commande : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/uptimekuma.sh)\" (ou saisissez update) dans la console LXC. Interface Kuma de disponibilité : IP:3001"
#categoryMenu="conteneur"
#nameMenu="Uptime Kuma LXC"
#commutatorLetter=""
#commutatorWord="uptimekuma_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/uptimekuma.sh)"
}

watchyourlan_lxc(){
#helpDescription="WatchYourLAN est un scanner IP réseau léger avec interface graphique Web. Pour créer un nouveau Proxmox VE WatchYourLAN LXC, exécutez la commande : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/watchyourlan.sh)\". Paramètres par défaut : 512 Mo de RAM - 2 Go de stockage - 1 vCPU. Pour mettre à jour WatchYourLAN, exécutez la commande : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/watchyourlan.sh)\" (ou saisissez update) dans la console LXC. Interface WatchYourLAN : IP:8840"
#categoryMenu="conteneur"
#nameMenu="WatchYourLAN LXC"
#commutatorLetter=""
#commutatorWord="watchyourlan_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/watchyourlan.sh)"
}

zabbix_lxc(){
#helpDescription="Zabbix est une solution de surveillance tout-en-un avec une variété de fonctionnalités de qualité professionnelle disponibles dès la sortie de la boîte. Pour créer un nouveau Proxmox VE Zabbix LXC, exécutez la commande : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/zabbix.sh)\". Paramètres par défaut : 4 Go de RAM - 6 Go de stockage - 2 vCPU. Informations d'identification : Mot de passe admin: zabbix. Informations d'identification de la base de données : cat zabbix.creds. Interface Zabbix : IP:5454"
#categoryMenu="conteneur"
#nameMenu="Zabbix LXC"
#commutatorLetter=""
#commutatorWord="zabbix_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/zabbix.sh)"
}

casaos_lxc(){
#helpDescription="CasaOS est un logiciel qui vise à faciliter la création d'un système cloud personnel à domicile. Pour créer un nouveau Proxmox VE CasaOS LXC, exécutez la commande : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/casaos.sh)\". Paramètres par défaut : 2 Go de RAM - 8 Go de stockage - 2 vCPU. Interface CasaOS : IP"
#categoryMenu="conteneur"
#nameMenu="CasaOS LXC"
#commutatorLetter=""
#commutatorWord="casaos_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/casaos.sh)"
}

docker_lxc(){
#helpDescription="Docker est un projet open source permettant d'automatiser le déploiement d'applications sous forme de conteneurs portables et autonomes. Pour créer un nouveau Proxmox VE Docker LXC, exécutez la commande : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/docker.sh)\". Paramètres par défaut : 2 Go de RAM - 4 Go de stockage - 2 vCPU. En guise d’alternative, vous pouvez utiliser Alpine Linux et le package Docker pour créer un conteneur Docker LXC avec un temps de création plus rapide et une utilisation minimale des ressources système. Pour créer un nouveau Proxmox VE Alpine-Docker LXC, exécutez la commande : bash -c \"$(wget -qO - https://github.com/tteck/Proxmox/raw/main/ct/alpine-docker.sh)\". Interface Portainer : (https) IP : 9443"
#categoryMenu="conteneur"
#nameMenu="Docker LXC"
#commutatorLetter=""
#commutatorWord="docker_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/docker.sh)"
}

dockge_lxc(){
#helpDescription="Dockge est un gestionnaire orienté pile Docker compose.yaml auto-hébergé, sophistiqué, facile à utiliser et réactif. Pour créer un nouveau Proxmox VE Dockge LXC, exécutez la commande : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/dockge.sh)\". Paramètres par défaut : 2 Go de RAM - 18 Go de stockage - 2 vCPU. Interface de la station d'accueil : IP:5001. Pour mettre à jour Dockge : cd /opt/dockge && docker compose pull && docker compose up -d"
#categoryMenu="conteneur"
#nameMenu="Dockge LXC"
#commutatorLetter=""
#commutatorWord="dockge_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/dockge.sh)"
}

podman_lxc(){
#helpDescription="Podman est un moteur de conteneur open source, sans démon et portable qui permet aux utilisateurs de gérer des conteneurs sur des systèmes Linux sans qu'un démon ou un service système ne soit exécuté en arrière-plan. Pour créer un nouveau Proxmox VE Podman LXC, exécutez la commande : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/podman.sh)\". Paramètres par défaut : 2 Go de RAM - 4 Go de stockage - 2 vCPU"
#categoryMenu="conteneur"
#nameMenu="Podman LXC"
#commutatorLetter=""
#commutatorWord="podman_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/podman.sh)"
}

runtipi_lxc(){
#helpDescription="Runtipi vous permet d'installer toutes vos applications auto-hébergées préférées sans avoir à configurer et à gérer chaque service. Pour créer un nouveau Runtipi LXC Proxmox VE, exécutez la commande : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/runtipi.sh)\". Paramètres par défaut : 2 Go de RAM - 8 Go de stockage - 2 vCPU. Interface Runtipi : IP"
#categoryMenu="conteneur"
#nameMenu="Runtipi LXC"
#commutatorLetter=""
#commutatorWord="runtipi_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/runtipi.sh)"
}

alpine_lxc(){
#helpDescription="Une distribution Linux légère et orientée sécurité basée sur musl et BusyBox. Pour créer un nouveau Proxmox VE Alpine LXC, exécutez la commande : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/alpine.sh)\". Paramètres par défaut : 512 Mo de RAM - 100 Mo de stockage - 1 vCPU. Mot de passe par défaut : alpine. Pour mettre à jour Alpine : apk update && apk upgrade"
#categoryMenu="conteneur"
#nameMenu="Alpine LXC"
#commutatorLetter=""
#commutatorWord="alpine_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/alpine.sh)"
}

debian_vm(){
#helpDescription="Debian Linux est une distribution qui privilégie les logiciels libres. Pour créer une nouvelle machine virtuelle Debian 12 Proxmox VE, exécutez la commande : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/vm/debian-vm.sh)\". Paramètres par défaut : 2 Go de RAM - 2 Go de stockage - 2 vCPU. Plus d'infos sur https://github.com/tteck/Proxmox/discussions/1988"
#categoryMenu="machine virtuelle"
#nameMenu="Debian 12 VM"
#commutatorLetter=""
#commutatorWord="debian_vm"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/vm/debian-vm.sh)"
}

debian_lxc(){
#helpDescription="Debian Linux est une distribution qui privilégie les logiciels libres. Pour créer un nouveau Proxmox VE Debian LXC, exécutez la commande : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/debian.sh)\". Paramètres par défaut : 512 Mo de RAM - 2 Go de stockage - 1 vCPU"
#categoryMenu="conteneur"
#nameMenu="Debian LXC"
#commutatorLetter=""
#commutatorWord="debian_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/debian.sh)"
}

ubuntu2204_vm(){
#helpDescription="Ubuntu est une distribution basée sur Debian. Pour créer une nouvelle VM Proxmox VE Ubuntu 22.04, exécutez la commande : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/vm/ubuntu2204-vm.sh)\". Paramètres par défaut : 2 Go de RAM - 2 Go de stockage - 2 vCPU. Plus d'infos sur https://github.com/tteck/Proxmox/discussions/2072"
#categoryMenu="machine virtuelle"
#nameMenu="Ubuntu 22.04 VM"
#commutatorLetter=""
#commutatorWord="ubuntu2204_vm"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/vm/ubuntu2204-vm.sh)"
}

ubuntu2404_vm(){
#helpDescription="Ubuntu est une distribution basée sur Debian. Pour créer une nouvelle VM Proxmox VE Ubuntu 24.04, exécutez la commande : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/vm/ubuntu2404-vm.sh)\". Paramètres par défaut : 2 Go de RAM - 2 Go de stockage - 2 vCPU. Plus d'infos sur https://github.com/tteck/Proxmox/discussions/2072"
#categoryMenu="machine virtuelle"
#nameMenu="Ubuntu 24.04 VM"
#commutatorLetter=""
#commutatorWord="ubuntu2404_vm"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/vm/ubuntu2404-vm.sh)"
}


ubuntu_lxc(){
#helpDescription="Ubuntu est une distribution basée sur Debian, conçue pour avoir des versions régulières et une expérience utilisateur cohérente. Pour créer un nouveau Proxmox VE Ubuntu LXC (version 22.04 par défaut), exécutez la commande : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/ubuntu.sh)\". Paramètres par défaut : 512 Mo de RAM - 2 Go de stockage - 1 vCPU - 22.04"
#categoryMenu="conteneur"
#nameMenu="Ubuntu LXC"
#commutatorLetter=""
#commutatorWord="ubuntu_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/ubuntu.sh)"
}

all_templates_lxc() {
#helpDescription="Script pour créer un modèle LXC sur Proxmox VE. Pour créer un modèle, exécutez : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/misc/all-templates.sh)\". Paramètres par défaut : 2 Go de RAM - 8 Go de stockage - 2 vCPU - onboot 0 - DHCP - Sans privilège."
#categoryMenu="LXC"
#nameMenu="Modèles LXC"
#commutatorLetter=""
#commutatorWord="all_templates_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/misc/all-templates.sh)"
}

turnkey_lxc() {
#helpDescription="Créer une nouvelle appliance Proxmox VE TurnKey LXC préconfigurée. Pour créer, exécutez : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/turnkey/turnkey.sh)\". Les paramètres des ressources et du réseau sont ajustables après la création."
#categoryMenu="LXC"
#nameMenu="TurnKey LXC"
#commutatorLetter=""
#commutatorWord="turnkey_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/turnkey/turnkey.sh)"
}

apt_cacher_ng_lxc() {
    #helpDescription="Créer un nouveau Proxmox VE Apt-Cacher-NG LXC. Pour créer, exécutez : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/apt-cacher-ng.sh)\"."
    #categoryMenu="LXC"
    #nameMenu="Apt-Cacher-NG LXC"
    #commutatorLetter=""
    #commutatorWord="apt_cacher_ng_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/apt-cacher-ng.sh)"
}

bunkerweb_lxc() {
    #helpDescription="Créer un nouveau BunkerWeb LXC Proxmox VE. Pour créer, exécutez : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/bunkerweb.sh)\"."
    #categoryMenu="LXC"
    #nameMenu="BunkerWeb LXC"
    #commutatorLetter=""
    #commutatorWord="bunkerweb_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/bunkerweb.sh)"
}

caddy_lxc() {
    #helpDescription="Créer un nouveau Caddy LXC Proxmox VE. Pour créer, exécutez : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/caddy.sh)\"."
    #categoryMenu="LXC"
    #nameMenu="Caddy LXC"
    #commutatorLetter=""
    #commutatorWord="caddy_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/caddy.sh)"
}

cloudflared_lxc() {
    #helpDescription="Créer un nouveau Cloudflared LXC Proxmox VE. Pour créer, exécutez : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/cloudflared.sh)\"."
    #categoryMenu="LXC"
    #nameMenu="Cloudflared LXC"
    #commutatorLetter=""
    #commutatorWord="cloudflared_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/cloudflared.sh)"
}

cronicle_lxc() {
    #helpDescription="Créer un nouveau LXC principal Proxmox VE Cronicle. Pour créer, exécutez : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/cronicle.sh)\"."
    #categoryMenu="LXC"
    #nameMenu="Cronicle LXC"
    #commutatorLetter=""
    #commutatorWord="cronicle_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/cronicle.sh)"
}

cronicle_lxc() {
    #helpDescription="Créer un nouveau LXC principal Proxmox VE Cronicle. Pour créer, exécutez : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/cronicle.sh)\"."
    #categoryMenu="LXC"
    #nameMenu="Cronicle LXC"
    #commutatorLetter=""
    #commutatorWord="cronicle_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/cronicle.sh)"
}

flaresolverr_lxc() {
    #helpDescription="Créer un nouveau FlareSolverr LXC Proxmox VE. Pour créer, exécutez : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/flaresolverr.sh)\"."
    #categoryMenu="LXC"
    #nameMenu="FlareSolverr LXC"
    #commutatorLetter=""
    #commutatorWord="flaresolverr_lxc"
    
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/flaresolverr.sh)"
}

headscale_lxc() {
    #helpDescription="Créer un nouveau Headscale LXC Proxmox VE. Pour créer, exécutez : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/headscale.sh)\"."
    #categoryMenu="LXC"
    #nameMenu="Headscale LXC"
    #commutatorLetter=""
    #commutatorWord="headscale_lxc"
    
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/headscale.sh)"
}

iventoy_lxc() {
    #helpDescription="Créer un nouveau Proxmox VE iVentoy LXC. Pour créer, exécutez : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/iventoy.sh)\"."
    #categoryMenu="LXC"
    #nameMenu="iVentoy LXC"
    #commutatorLetter=""
    #commutatorWord="iventoy_lxc"
    
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/iventoy.sh)"
}

keycloak_lxc() {
    #helpDescription="Créer un nouveau Proxmox VE Keycloak LXC. Pour créer, exécutez : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/keycloak.sh)\"."
    #categoryMenu="LXC"
    #nameMenu="Keycloak LXC"
    #commutatorLetter=""
    #commutatorWord="keycloak_lxc"
    
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/keycloak.sh)"
}

meshcentral_lxc() {
    #helpDescription="Créer un nouveau Proxmox VE MeshCentral LXC. Pour créer, exécutez : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/meshcentral.sh)\"."
    #categoryMenu="LXC"
    #nameMenu="MeshCentral LXC"
    #commutatorLetter=""
    #commutatorWord="meshcentral_lxc"
    
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/meshcentral.sh)"
}

machine_virtuelle_chr_routeros_de_mikrotik() {
#helpDescription="Mikrotik RouterOS CHR est un système d'exploitation basé sur Linux qui transforme un ordinateur en routeur. Il offre une large gamme de fonctionnalités pour le routage réseau, le pare-feu, la gestion de la bande passante, le point d'accès sans fil, la liaison de retour, la passerelle de point d'accès, le serveur VPN et plus encore. Il est hautement personnalisable pour répondre aux besoins spécifiques des administrateurs réseau, offrant une gestion avancée des réseaux avec surveillance de la performance et de la sécurité. Pour créer une nouvelle machine virtuelle Proxmox VE Mikrotik RouterOS CHR, exécutez la commande suivante dans le shell Proxmox VE : bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/vm/mikrotik-routeros.sh)\". La configuration initiale s'effectue via la console VM. Accédez à l'adresse IP à gérer. Connexion initiale : nom d'utilisateur admin, mot de passe no password."
#categoryMenu="serveur_reseau"
#nameMenu="Machine virtuelle CHR RouterOS de Mikrotik"
#commutatorLetter=""
#commutatorWord="machine_virtuelle_chr_routeros_de_mikrotik"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/vm/mikrotik-routeros.sh)"
}

installation_de_netbird() {
#helpDescription="NetBird combine un réseau privé peer-to-peer sans configuration et un système de contrôle d'accès centralisé dans une seule plate-forme, ce qui facilite la création de réseaux privés sécurisés pour votre organisation ou votre domicile. Pour installer NetBird sur un LXC existant, exécutez la commande ci-dessous dans le shell Proxmox VE. Une fois le script terminé, redémarrez le LXC puis exécutez le netbird updans la console LXC."
#categoryMenu="outils_proxmox_ve"
#nameMenu="NetBird"
#commutatorLetter=""
#commutatorWord="installation_de_netbird"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/misc/add-netbird-lxc.sh)"
}

nginx_proxy_manager_lxc() {
#helpDescription="Nginx Proxy Manager est un outil qui fournit une interface Web pour gérer les proxys inverses Nginx. Il permet aux utilisateurs d'exposer facilement et en toute sécurité leurs services sur Internet en fournissant des fonctionnalités telles que le cryptage HTTPS, le mappage de domaine et le contrôle d'accès. Il élimine le besoin de configuration manuelle des proxys inverses Nginx, ce qui permet aux utilisateurs d'exposer rapidement et en toute sécurité leurs services au public. Pour créer un nouveau conteneur LXC Proxmox VE Nginx Proxy Manager, exécutez la commande ci-dessous dans le shell Proxmox VE. Pour mettre à jour Nginx Proxy Manager, exécutez la commande ci-dessous (ou saisissez update) dans la console LXC. ⚡ Paramètres par défaut : 1 Go de RAM - 3 Go de stockage - 1 vCPU ⚡ 🚨 Comme il existe des centaines d'instances de Certbot, il est nécessaire d'installer le Certbot spécifique de votre choix. Transférez le port 80de 443votre routeur vers votre IP Nginx Proxy Manager LXC. Ajoutez la commande ci-dessous à votre configuration.yamlHome Assistant. Copie http: use_x_forwarded_for: true trusted_proxies: - 192.168.100.27 ###(Nginx Proxy Manager LXC IP)### Interface du gestionnaire de proxy Nginx : IP : 81 ⚙️ Connexion initiale nom d'utilisateur admin@example.com mot de passe changeme"
#categoryMenu="serveur_reseau"
#nameMenu="Gestionnaire de proxy Nginx"
#commutatorLetter=""
#commutatorWord="nginx_proxy_manager_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/nginxproxymanager.sh)"
}

omada_lxc() {
#helpDescription="Omada Controller est une application logicielle utilisée pour gérer les périphériques EAP (Enterprise Access Point) Omada de TP-Link. Elle permet aux administrateurs de gérer de manière centralisée un grand nombre de points d'accès d'entreprise, de surveiller les performances du réseau et de contrôler l'accès des utilisateurs au réseau. Le logiciel fournit une interface intuitive pour la configuration du réseau, les mises à niveau du micrologiciel et la surveillance du réseau. En utilisant Omada Controller, les administrateurs peuvent rationaliser le processus de gestion, réduire les interventions manuelles et améliorer la sécurité et la fiabilité globales du réseau. Pour créer un nouveau contrôleur Proxmox VE Omada LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. Pour mettre à jour Omada, exécutez la commande ci-dessous (ou saisissez update) dans la console LXC. ⚡ Paramètres par défaut : 2 Go de RAM - 8 Go de stockage - 2 vCPU ⚡ Interface Omada : (https)IP:8043"
#categoryMenu="serveur_reseau"
#nameMenu="Contrôleur Omada"
#commutatorLetter=""
#commutatorWord="omada_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/omada.sh)"
}

openwrt_vm() {
#helpDescription="OpenWrt est un puissant firmware open source qui peut transformer une large gamme de périphériques réseau en routeurs hautement personnalisables et riches en fonctionnalités, offrant aux utilisateurs un meilleur contrôle et une meilleure flexibilité sur leur infrastructure réseau. Pour créer une nouvelle machine virtuelle Proxmox VE OpenWrt, exécutez la commande ci-dessous dans le shell Proxmox VE. ⚡ Paramètres par défaut : 256 Mo de RAM - 512 Mo de stockage - 1 CPU ⚡"
#categoryMenu="systeme_operateur"
#nameMenu="Machine virtuelle OpenWrt"
#commutatorLetter=""
#commutatorWord="openwrt_vm"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/vm/openwrt.sh)"
}

pbs_lxc() {
#helpDescription="Proxmox Backup Server est une solution de sauvegarde d'entreprise permettant de sauvegarder et de restaurer des machines virtuelles, des conteneurs et des hôtes physiques. En prenant en charge les sauvegardes incrémentielles entièrement dédupliquées, Proxmox Backup Server réduit considérablement la charge réseau et économise un espace de stockage précieux. Pour créer un nouveau Proxmox VE Proxmox Backup Server LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. ⚡ Paramètres par défaut : 2 Go de RAM - 10 Go de stockage - 2 vCPU ⚡ Interface du serveur de sauvegarde Proxmox : IP : 8007 Définissez un mot de passe root si vous utilisez la connexion automatique. Ce sera le mot de passe PBS."
#categoryMenu="serveur_reseau"
#nameMenu="Serveur de sauvegarde Proxmox LXC"
#commutatorLetter=""
#commutatorWord="pbs_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/pbs.sh)"
}

tailscale_lxc() {
#helpDescription="Tailscale est une solution de réseau définie par logiciel qui permet une communication sécurisée entre les appareils via Internet. Elle crée un réseau privé virtuel (VPN) qui permet aux appareils de communiquer entre eux comme s'ils se trouvaient sur le même réseau local. Tailscale fonctionne même lorsque les appareils sont séparés par des pare-feu ou des sous-réseaux, et fournit une communication sécurisée et cryptée entre les appareils. Avec Tailscale, les utilisateurs peuvent connecter des appareils, des serveurs, des ordinateurs et des instances cloud pour créer un réseau sécurisé, ce qui facilite la gestion et le contrôle de l'accès aux ressources. Tailscale est conçu pour être facile à configurer et à utiliser, offrant une solution simplifiée pour une communication sécurisée entre les appareils sur Internet. Pour installer Tailscale sur un LXC existant, exécutez la commande ci-dessous dans le shell Proxmox VE. Une fois le script terminé, redémarrez le LXC puis exécutez-le tailscale updans la console LXC"
#categoryMenu="serveur_reseau"
#nameMenu="Échelle arrière"
#commutatorLetter=""
#commutatorWord="tailscale_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/misc/add-tailscale-lxc.sh)"
}

traefik_lxc() {
#helpDescription="Traefik est un routeur de périphérie open source et un proxy inverse qui simplifie la gestion des microservices. Il détecte automatiquement les services, met à jour dynamiquement les règles de routage sans temps d'arrêt, assure l'équilibrage de charge, gère la terminaison SSL et prend en charge divers intergiciels pour des fonctionnalités supplémentaires. Idéal pour les environnements cloud natifs, il s'intègre parfaitement à des plateformes telles que Docker et Kubernetes. Pour créer un nouveau Proxmox VE Traefik LXC, exécutez la commande ci-dessous dans le shell Proxmox VE."
#categoryMenu="serveur_reseau"
#nameMenu="Traefik LXC"
#commutatorLetter=""
#commutatorWord="traefik_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/traefik.sh)"
}

unifi_lxc() {
#helpDescription="UniFi Network Server est un logiciel qui permet de gérer et de surveiller les réseaux UniFi (Wi-Fi, Ethernet, etc.) en fournissant une interface utilisateur intuitive et des fonctionnalités avancées. Il permet aux administrateurs réseau de configurer, de surveiller et de mettre à niveau les périphériques réseau, ainsi que d'afficher les statistiques du réseau, les périphériques clients et les événements historiques. L'objectif de l'application est de rendre la gestion des réseaux UniFi plus simple et plus efficace. Pour créer un nouveau Proxmox VE UniFi Network Server LXC, exécutez la commande ci-dessous dans le shell Proxmox VE."
#categoryMenu="serveur_reseau"
#nameMenu="Serveur réseau UniFi LXC"
#commutatorLetter=""
#commutatorWord="unifi_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/unifi.sh)"
}

wireguard_lxc() {
#helpDescription="WireGuard est un logiciel de réseau privé virtuel (VPN) gratuit et open source qui utilise la cryptographie moderne pour sécuriser les données transmises sur un réseau. Il est conçu pour être rapide, sécurisé et facile à utiliser. WireGuard prend en charge divers systèmes d'exploitation, notamment Linux, Windows, macOS, Android et iOS. Il fonctionne au niveau de la couche réseau et peut être utilisé avec une large gamme de protocoles et de configurations. Contrairement à d'autres protocoles VPN, WireGuard est conçu pour être simple et rapide, en mettant l'accent sur la sécurité et la rapidité. Il est connu pour sa facilité d'installation et de configuration, ce qui en fait un choix populaire pour une utilisation personnelle et commerciale. Pour créer un nouveau Proxmox VE WireGuard LXC, exécutez la commande ci-dessous dans le shell Proxmox VE."
#categoryMenu="serveur_reseau"
#nameMenu="WireGuard LXC"
#commutatorLetter=""
#commutatorWord="wireguard_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/wireguard.sh)"
}

yunohost_lxc() {
#helpDescription="YunoHost est un système d'exploitation visant à simplifier l'administration d'un serveur, et donc à démocratiser l'auto-hébergement, tout en veillant à ce qu'il reste fiable, sécurisé, éthique et léger. Pour créer un nouveau Proxmox VE YunoHost LXC, exécutez la commande ci-dessous dans le shell Proxmox VE."
#categoryMenu="serveur_reseau"
#nameMenu="YunoHost LXC"
#commutatorLetter=""
#commutatorWord="yunohost_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/yunohost.sh)"
}

zoraxy_lxc() {
#helpDescription="Zoraxy est une solution de routage réseau domestique tout-en-un. Pour créer un nouveau Proxmox VE Zoraxy LXC, exécutez la commande ci-dessous dans le shell Proxmox VE."
#categoryMenu="serveur_reseau"
#nameMenu="Zoraxy LXC"
#commutatorLetter=""
#commutatorWord="zoraxy_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/zoraxy.sh)"
}

bibliotheque_audio_lxc() {
#helpDescription="Audiobookshelf est un serveur de livres audio et de podcasts auto-hébergé. Pour créer un nouveau Proxmox VE Audiobookshelf LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. ⚡ Paramètres par défaut : 2 Go de RAM - 4 Go de stockage - 2 vCPU ⚡ Interface de bibliothèque audio : IP:13378"
#categoryMenu="medias_photo"
#nameMenu="Bibliothèque audio LXC"
#commutatorLetter=""
#commutatorWord="bibliotheque_audio_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/audiobookshelf.sh)"
}

bazarr_lxc() {
#helpDescription="Bazarr est une application complémentaire de Sonarr et Radarr qui gère et télécharge les sous-titres en fonction de vos besoins. Pour créer un nouveau Proxmox VE Bazarr LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. ⚡ Paramètres par défaut : 1 Go de RAM - 4 Go de stockage - 2 vCPU ⚡ Interface Bazarr : IP:6767"
#categoryMenu="medias_photo"
#nameMenu="Bazarr LXC"
#commutatorLetter=""
#commutatorWord="bazarr_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/bazarr.sh)"
}

calibre_web_lxc() {
#helpDescription="Calibre-Web est une application Web permettant de parcourir, de lire et de télécharger des livres électroniques stockés dans une base de données Calibre. Pour créer un nouveau Calibre-Web LXC Proxmox VE, exécutez la commande ci-dessous dans le shell Proxmox VE. ⚡ Paramètres par défaut : 2 Go de RAM - 4 Go de stockage - 2 vCPU ⚡ Interface Web Calibre : IP:8083 ⚙️ Connexion initiale nom d'utilisateur admin mot de passe admin123"
#categoryMenu="medias_photo"
#nameMenu="Calibre Web LXC"
#commutatorLetter=""
#commutatorWord="calibre_web_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/calibre-web.sh)"
}

emby_lxc() {
#helpDescription="Emby rassemble vos vidéos personnelles, votre musique, vos photos et votre télévision en direct. Avec prise en charge de l'accélération matérielle privilégiée/non privilégiée. Pour créer un nouveau serveur multimédia Proxmox VE Emby LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. ⚡ Paramètres par défaut : 2 Go de RAM - 8 Go de stockage - 2 vCPU ⚡ Interface du serveur multimédia Emby : IP : 8096"
#categoryMenu="medias_photo"
#nameMenu="Serveur multimédia Emby LXC"
#commutatorLetter=""
#commutatorWord="emby_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/emby.sh)"
}

ersatztv_lxc() {
#helpDescription="ErsatzTV est un logiciel permettant de configurer et de diffuser des chaînes en direct personnalisées à l'aide de votre bibliothèque multimédia. Pour créer un nouveau Proxmox VE ErsatzTV LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. ⚡ Paramètres par défaut : 1 Go de RAM - 5 Go de stockage - 1 vCPU ⚡ Interface TV de remplacement : IP : 8409"
#categoryMenu="medias_photo"
#nameMenu="Téléviseur de remplacement LXC"
#commutatorLetter=""
#commutatorWord="ersatztv_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/ersatztv.sh)"
}

jellyfin_lxc() {
#helpDescription="Pour créer un nouveau Proxmox VE Jellyfin Media Server LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. ⚡ Paramètres par défaut : 2 Go de RAM - 8 Go de stockage - 2 vCPU ⚡ Interface du serveur multimédia Jellyfin : IP : 8096 Chemin FFmpeg :/usr/lib/jellyfin-ffmpeg/ffmpeg"
#categoryMenu="medias_photo"
#nameMenu="Serveur multimédia Jellyfin LXC"
#commutatorLetter=""
#commutatorWord="jellyfin_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/jellyfin.sh)"
}

jellyseerr_lxc() {
#helpDescription="Jellyseerr est une application logicielle gratuite et open source permettant de gérer les demandes de votre bibliothèque multimédia. Il s'agit d'un fork d'Overseerr conçu pour apporter un support aux serveurs multimédia Jellyfin et Emby. Pour créer un nouveau Jellyseerr LXC Proxmox VE, exécutez la commande ci-dessous dans le shell Proxmox VE. ⚡ Paramètres par défaut : 2 Go de RAM - 8 Go de stockage - 2 vCPU ⚡ Interface Jellyseerr : IP:5055"
#categoryMenu="medias_photo"
#nameMenu="Jellyseerr LXC"
#commutatorLetter=""
#commutatorWord="jellyseerr_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/jellyseerr.sh)"
}

bibliotheque_audio_lxc() {
#helpDescription="Audiobookshelf est un serveur de livres audio et de podcasts auto-hébergé. Pour créer un nouveau Proxmox VE Audiobookshelf LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. ⚡ Paramètres par défaut : 2 Go de RAM - 4 Go de stockage - 2 vCPU ⚡ Interface de bibliothèque audio : IP:13378"
#categoryMenu="medias_photo"
#nameMenu="Bibliothèque audio LXC"
#commutatorLetter=""
#commutatorWord="bibliotheque_audio_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/audiobookshelf.sh)"
}

lidarr_lxc() {
#helpDescription="Lidarr est un outil de gestion de musique conçu pour les utilisateurs Usenet et BitTorrent. Il permet aux utilisateurs de gérer et d'organiser facilement leur collection de musique. Lidarr s'intègre aux clients Usenet et BitTorrent les plus populaires, tels que Sonarr et Radarr, pour automatiser le téléchargement et l'organisation des fichiers musicaux. Le logiciel fournit une interface Web pour la gestion et l'organisation de la musique, ce qui facilite la recherche et la découverte de chansons, d'albums et d'artistes. Lidarr prend également en charge la gestion des métadonnées, notamment les pochettes d'album, les informations sur les artistes et les paroles, ce qui permet aux utilisateurs de garder facilement leur collection de musique organisée et à jour. Le logiciel est conçu pour être facile à utiliser et fournit une interface simple et intuitive pour la gestion et l'organisation des collections de musique, ce qui en fait un outil précieux pour les mélomanes qui souhaitent garder leur collection organisée et à jour. Avec Lidarr, les utilisateurs peuvent profiter de leur collection de musique où qu'ils se trouvent, ce qui en fait un outil puissant pour la gestion et le partage de fichiers musicaux. Pour créer un nouveau Proxmox VE Lidarr LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. ⚡ Paramètres par défaut : 1 Go de RAM - 4 Go de stockage - 2 vCPU ⚡ Interface Lidarr : IP:8686"
#categoryMenu="medias_photo"
#nameMenu="Lidarr LXC"
#commutatorLetter=""
#commutatorWord="lidarr_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/lidarr.sh)"
}

mediamtx_lxc() {
#helpDescription="MediaMTX est un serveur multimédia et proxy multimédia SRT / WebRTC / RTSP / RTMP / LL-HLS prêt à l'emploi qui vous permet de lire, publier, proxy, enregistrer et lire des flux vidéo et audio. Pour créer un nouveau Proxmox VE MediaMTX LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. ⚡ Paramètres par défaut : 2 Go de RAM - 4 Go de stockage - 2 vCPU ⚡ Interface MediaMTX : AUCUNE Instructions"
#categoryMenu="medias_photo"
#nameMenu="MédiaMTX LXC"
#commutatorLetter=""
#commutatorWord="mediamtx_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/mediamtx.sh)"
}

meduse_lxc() {
#helpDescription="Medusa est un gestionnaire de bibliothèque vidéo automatique pour les émissions de télévision. Il surveille les nouveaux épisodes de vos émissions préférées et, lorsqu'ils sont publiés, il fait sa magie : recherche, téléchargement et traitement automatiques de torrents/nzb aux qualités souhaitées. Pour créer un nouveau Proxmox VE Medusa LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. Pour mettre à jour Medusa, exécutez la commande ci-dessous (ou saisissez update) dans la console LXC. ⚡ Paramètres par défaut : 1 Go de RAM - 6 Go de stockage - 2 vCPU ⚡ Interface Medusa : IP:8081"
#categoryMenu="medias_photo"
#nameMenu="Méduse LXC"
#commutatorLetter=""
#commutatorWord="meduse_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/medusa.sh)"
}

metube_lxc() {
#helpDescription="MeTube vous permet de télécharger des vidéos depuis YouTube et des dizaines d'autres sites. Pour créer un nouveau Proxmox VE MeTube LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. Pour mettre à jour MeTube, exécutez la commande ci-dessous (ou saisissez update) dans la console LXC. ⚡ Paramètres par défaut : 1 Go de RAM - 10 Go de stockage - 1 vCPU ⚡ Interface MeTube : IP : 8081"
#categoryMenu="medias_photo"
#nameMenu="MeTube LXC"
#commutatorLetter=""
#commutatorWord="metube_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/metube.sh)"
}

navidrome_lxc() {
#helpDescription="Navidrome est une solution de serveur musical qui rend votre collection musicale accessible depuis n'importe où. Il offre une interface utilisateur Web moderne et une compatibilité avec une gamme d'applications mobiles tierces pour les appareils iOS et Android. Avec Navidrome, les utilisateurs peuvent accéder à leur collection musicale depuis n'importe où, que ce soit à la maison ou en déplacement. Le logiciel prend en charge une variété de formats musicaux, ce qui permet aux utilisateurs de lire facilement leurs chansons et albums préférés. Navidrome fournit une interface simple et conviviale pour la gestion et l'organisation des collections musicales, ce qui en fait un outil précieux pour les mélomanes qui souhaitent accéder à leur musique depuis n'importe où. Le logiciel est conçu pour être facile à configurer et à utiliser, ce qui en fait un choix populaire pour ceux qui souhaitent héberger leur propre serveur de musique et profiter de leur collection musicale depuis n'importe où. Pour créer un nouveau Proxmox VE Navidrome LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. Pour mettre à jour Navidrome, exécutez la commande ci-dessous (ou saisissez update) dans la console LXC. ⚡ Paramètres par défaut : 1 Go de RAM - 4 Go de stockage - 2 vCPU ⚡ Pour modifier le chemin du dossier de musique Navidrome, modifiez :/var/lib/navidrome/navidrome.toml Interface du Navidrome : IP:4533"
#categoryMenu="medias_photo"
#nameMenu="Navidrome LXC"
#commutatorLetter=""
#commutatorWord="navidrome_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/navidrome.sh)"
}

nextcloud_lxc() {
#helpDescription="NextCloudPi est une solution auto-hébergée populaire pour la collaboration de fichiers et le stockage de données. Elle est basée sur le logiciel NextCloud, une plate-forme open source de gestion de données. Pour créer un nouveau Proxmox VE NextCloudPi LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. Paramètres par défaut : 2 Go de RAM - 8 Go de stockage - 2 vCPU Interface NextCloudPi : (https)IP"
#categoryMenu="medias_photo"
#nameMenu="Nextcloud LXC"
#commutatorLetter=""
#commutatorWord="nextcloud_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/nextcloudpi.sh)"
}

alpine_nextcloud_hub_lxc() {
#helpDescription="Alpine Nextcloud Hub intègre les quatre produits clés de Nextcloud : Fichiers, Talk, Groupware et Office dans une seule plateforme, optimisant ainsi le flux de collaboration. Pour créer un nouveau Proxmox VE Alpine Nextcloud Hub LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. Pour mettre à jour Alpine Nextcloud ou afficher les informations de connexion Alpine Nextcloud, exécutez la commande ci-dessous dans la console LXC. Paramètres par défaut : 1 Go de RAM - 2 Go de stockage - 2 vCPU Interface du hub Alpine Nextcloud : (https)IP"
#categoryMenu="medias_photo"
#nameMenu="Alpine Nextcloud Hub LXC"
#commutatorLetter=""
#commutatorWord="alpine_nextcloud_hub_lxc"
    bash -c "$(wget -qO - https://github.com/tteck/Proxmox/raw/main/ct/alpine-nextcloud.sh)"
}

turnkey_nextcloud_lxc() {
#helpDescription="TurnKey Nextcloud vous permet de stocker vos fichiers, dossiers, contacts, galeries de photos, calendriers et bien plus encore sur un serveur de votre choix. Accédez à ce dossier depuis votre appareil mobile, votre ordinateur de bureau ou un navigateur Web. Accédez à vos données où que vous soyez, quand vous en avez besoin. Pour créer un nouveau Proxmox VE TurnKey Nextcloud LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. Interface TurnKey Nextcloud : (https)IP"
#categoryMenu="medias_photo"
#nameMenu="TurnKey Nextcloud LXC"
#commutatorLetter=""
#commutatorWord="turnkey_nextcloud_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/turnkey/turnkey.sh)"
}

ombi_lxc() {
#helpDescription="Ombi est une application Web auto-hébergée conçue pour permettre aux utilisateurs de Plex, Emby ou Jellyfin partagés de bénéficier de capacités de demande de contenu automatisées. En s'intégrant à divers outils DVR d'émissions télévisées et de films, Ombi garantit une expérience fluide et complète à vos utilisateurs, leur permettant de demander eux-mêmes du contenu sans effort. Pour créer un nouveau Proxmox VE Ombi LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. Paramètres par défaut : 1 Go de RAM - 4 Go de stockage - 1 vCPU Interface Ombi : IP:5000"
#categoryMenu="medias_photo"
#nameMenu="Ombi LXC"
#commutatorLetter=""
#commutatorWord="ombi_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/ombi.sh)"
}

openmediavault_lxc() {
#helpDescription="OpenMediaVault est une solution de stockage en réseau (NAS) de nouvelle génération basée sur Debian Linux. Elle fournit une interface Web pour la gestion et le stockage des données numériques, ce qui la rend facile à utiliser et à configurer. OpenMediaVault prend en charge divers protocoles de stockage, notamment SMB/CIFS, NFS et FTP, et offre une large gamme de fonctionnalités pour la gestion des données, telles que la gestion des utilisateurs et des groupes, les quotas de disque et la sauvegarde et la récupération des données. Le logiciel est conçu pour être flexible et évolutif, ce qui en fait une solution précieuse pour une utilisation personnelle et professionnelle. OpenMediaVault fournit une plate-forme stable et fiable pour la gestion et le stockage des données numériques, ce qui en fait un choix populaire pour ceux qui souhaitent héberger leurs propres données et garantir leur sécurité et leur confidentialité. Avec OpenMediaVault, les utilisateurs peuvent accéder à leurs données de n'importe où et les partager facilement avec d'autres, ce qui en fait un outil précieux pour la collaboration et la gestion des données. Pour créer un nouveau Proxmox VE OpenMediaVault LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. Paramètres par défaut : 1 Go de RAM - 4 Go de stockage - 2 vCPU Interface OpenMediaVault : IP Connexion initiale : nom d'utilisateur admin, mot de passe openmediavault"
#categoryMenu="medias_photo"
#nameMenu="OpenMediaVault LXC"
#commutatorLetter=""
#commutatorWord="openmediavault_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/omv.sh)"
}

surveillant_lxc() {
#helpDescription="Overseerr est un outil de gestion des requêtes et de découverte de médias conçu pour fonctionner avec votre écosystème Plex existant. Pour créer un nouveau Proxmox VE Overseerr LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. Pour mettre à jour Overseerr, exécutez la commande ci-dessous (ou saisissez update) dans la console LXC. Paramètres par défaut : 2 Go de RAM - 8 Go de stockage - 2 vCPU Interface du superviseur : IP : 5055"
#categoryMenu="medias_photo"
#nameMenu="Surveillant LXC"
#commutatorLetter=""
#commutatorWord="surveillant_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/overseerr.sh)"
}

owncast_lxc() {
#helpDescription="Owncast est un serveur de vidéo en direct et de chat Web gratuit et open source à utiliser avec les logiciels de diffusion populaires existants. Pour créer un nouveau Proxmox VE Owncast LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. Paramètres par défaut : 2 Go de RAM - 2 Go de stockage - 2 vCPU Interface Owncast : IP : 8080 Interface d'administration Owncast : IP : 8080/admin Connexion initiale de l'administrateur nom d'utilisateur admin mot de passe abc123"
#categoryMenu="medias_photo"
#nameMenu="Owncast LXC"
#commutatorLetter=""
#commutatorWord="owncast_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/owncast.sh)"
}

machine_virtuelle_owncloud() {
#helpDescription="TurnKey ownCloud est un serveur de partage de fichiers open source et une plate-forme de collaboration qui peut stocker votre contenu personnel, comme des documents et des images, dans un emplacement centralisé. Pour créer une nouvelle machine virtuelle ownCloud Proxmox VE TurnKey, exécutez la commande ci-dessous dans le shell Proxmox VE. Paramètres par défaut : 2 Go de RAM - 8 Go de stockage - 2 vCPU Interface ownCloud : IP"
#categoryMenu="medias_photo"
#nameMenu="Machine virtuelle ownCloud"
#commutatorLetter=""
#commutatorWord="machine_virtuelle_owncloud"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/vm/owncloud-vm.sh)"
}

petio_lxc() {
#helpDescription="Petio est une application compagnon tierce disponible pour les propriétaires de serveurs Plex pour permettre à leurs utilisateurs de demander, d'examiner et de découvrir du contenu. Pour créer un nouveau Proxmox VE Petio LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. Paramètres par défaut : 1 Go de RAM - 4 Go de stockage - 2 vCPU Interface Petio : IP:7777"
#categoryMenu="medias_photo"
#nameMenu="Pétio LXC"
#commutatorLetter=""
#commutatorWord="petio_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/petio.sh)"
}

photoprism_lxc() {
#helpDescription="PhotoPrism est une application de photos basée sur l'IA pour le Web décentralisé. Elle utilise les dernières technologies pour étiqueter et trouver automatiquement des images sans vous gêner. Pour créer un nouveau Proxmox VE PhotoPrism LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. Paramètres par défaut : 2 Go de RAM - 8 Go de stockage - 2 vCPU Interface PhotoPrism : IP:2342 Connexion initiale : nom d'utilisateur admin, mot de passe changeme"
#categoryMenu="medias_photo"
#nameMenu="PhotoPrism LXC"
#commutatorLetter=""
#commutatorWord="photoprism_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/photoprism.sh)"
}

serveur_multimedia_plex_lxc() {
#helpDescription="Avec prise en charge de l'accélération matérielle privilégiée/non privilégiée. Pour créer un nouveau serveur multimédia Plex Proxmox VE LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. Paramètres par défaut : 2 Go de RAM - 8 Go de stockage - 2 vCPU Interface du serveur multimédia Plex : IP : 32400/web"
#categoryMenu="medias_photo"
#nameMenu="Serveur multimédia Plex LXC"
#commutatorLetter=""
#commutatorWord="serveur_multimedia_plex_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/plex.sh)"
}

prowlarr_lxc() {
#helpDescription="Prowlarr est un outil logiciel conçu pour s'intégrer à diverses applications PVR (Personal Video Recorder). Il facilite la gestion et l'organisation des collections d'émissions de télévision et de films en automatisant le téléchargement et l'organisation des fichiers multimédias. Pour créer un nouveau Proxmox VE Prowlarr LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. Paramètres par défaut : 1 Go de RAM - 4 Go de stockage - 2 vCPU Interface Prowlarr : IP : 9696"
#categoryMenu="medias_photo"
#nameMenu="Prowlarr LXC"
#commutatorLetter=""
#commutatorWord="prowlarr_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/prowlarr.sh)"
}

radarr_lxc() {
#helpDescription="Radarr est un outil de gestion de films conçu pour les utilisateurs Usenet et BitTorrent. Il permet aux utilisateurs de gérer et d'organiser facilement leur collection de films en automatisant le téléchargement et l'organisation des fichiers de films. Pour créer un nouveau Proxmox VE Radarr LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. Paramètres par défaut : 1 Go de RAM - 4 Go de stockage - 2 vCPU Interface Radarr : IP : 7878"
#categoryMenu="medias_photo"
#nameMenu="Radarr LXC"
#commutatorLetter=""
#commutatorWord="radarr_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/radarr.sh)"
}

readarr_lxc() {
#helpDescription="Readarr est un outil de gestion de livres électroniques et de livres audio conçu pour les utilisateurs Usenet et BitTorrent. Il permet aux utilisateurs de gérer et d'organiser facilement leur collection de livres électroniques et de livres audio en automatisant le téléchargement et l'organisation des fichiers. Pour créer un nouveau Proxmox VE Readarr LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. Paramètres par défaut : 1 Go de RAM - 4 Go de stockage - 2 vCPU Interface Readarr : IP : 8787"
#categoryMenu="medias_photo"
#nameMenu="Readarr LXC"
#commutatorLetter=""
#commutatorWord="readarr_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/readarr.sh)"
}

sonarr_lxc() {
#helpDescription="Sonarr est un logiciel d'enregistrement vidéo personnel (PVR) conçu pour les utilisateurs Usenet et BitTorrent. Il permet de gérer et d'organiser facilement les collections d'émissions de télévision en automatisant le téléchargement et l'organisation des fichiers. Pour créer un nouveau Proxmox VE Sonarr LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. Paramètres par défaut : 1 Go de RAM - 4 Go de stockage - 2 vCPU Interface Sonarr : IP:8989"
#categoryMenu="medias_photo"
#nameMenu="Sonarr LXC"
#commutatorLetter=""
#commutatorWord="sonarr_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/sonarr.sh)"
}

tautulli_lxc() {
#helpDescription="Tautulli vous permet de surveiller et de suivre l'utilisation de votre serveur multimédia Plex, notamment en affichant des statistiques et en analysant votre bibliothèque multimédia. Pour créer un nouveau Proxmox VE Tautulli LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. Paramètres par défaut : 1 Go de RAM - 4 Go de stockage - 2 vCPU Interface Tautulli : IP:8181"
#categoryMenu="medias_video"
#nameMenu="Tautulli LXC"
#commutatorLetter=""
#commutatorWord="tautulli_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/tautulli.sh)"
}

tdarr_lxc() {
#helpDescription="Tdarr est une application de transcodage multimédia conçue pour automatiser la gestion du transcodage et du remuxage d'une bibliothèque multimédia. Pour créer un nouveau Proxmox VE Tdarr LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. Paramètres par défaut : 2 Go de RAM - 4 Go de stockage - 2 vCPU Interface Tdarr : IP : 8265"
#categoryMenu="medias_video"
#nameMenu="Tdarr LXC"
#commutatorLetter=""
#commutatorWord="tdarr_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/tdarr.sh)"
}

filet_lxc() {
#helpDescription="Threadfin est un proxy M3U pour Kernel, Plex, Jellyfin ou Emby, basé sur xTeVe. Pour créer un nouveau Threadfin LXC Proxmox VE, exécutez la commande ci-dessous dans le shell Proxmox VE. Pour mettre à jour Threadfin, exécutez la commande ci-dessous (ou saisissez update) dans la console LXC. Copie bash -c \"\$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/threadfin.sh)\" ⚡ Paramètres par défaut : 1 Go de RAM - 4 Go de stockage - 1 vCPU ⚡ Interface Threadfin : IP:34400/web"
#categoryMenu="medias_video"
#nameMenu="Threadfin (Filet) LXC"
#commutatorLetter=""
#commutatorWord="filet_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/threadfin.sh)"
}

lxc_sans_maniaque() {
#helpDescription="Unmanic est un outil simple pour optimiser votre bibliothèque de fichiers. Vous pouvez l'utiliser pour convertir vos fichiers en un format unique et uniforme, gérer les mouvements de fichiers en fonction des horodatages ou exécuter des commandes personnalisées sur un fichier en fonction de sa taille. Pour créer un nouveau Proxmox VE Unmanic LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. Pour mettre à jour Unmanic, exécutez la commande ci-dessous (ou saisissez update) dans la console LXC. Copie bash -c \"\$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/unmanic.sh)\" ⚡ Paramètres par défaut : 2 Go de RAM - 4 Go de stockage - 2 vCPU - Privilégié ⚡ Interface Unmanic : IP : 8888"
#categoryMenu="medias_photo"
#nameMenu="Unmanic (sans maniaque) LXC"
#commutatorLetter=""
#commutatorWord="lxc_sans_maniaque"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/unmanic.sh)"
}

whisparr_lxc() {
#helpDescription="Whisparr est un gestionnaire de collection de films pour adultes pour les utilisateurs Usenet et BitTorrent. Pour créer un nouveau Proxmox VE Whisparr LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. Copie bash -c \"\$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/whisparr.sh)\" ⚡ Paramètres par défaut : 1 Go de RAM - 4 Go de stockage - 2 vCPU ⚡ Interface Whisparr : IP:6969"
#categoryMenu="medias_photo"
#nameMenu="Whisparr LXC"
#commutatorLetter=""
#commutatorWord="whisparr_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/whisparr.sh)"
}

agentdvr_lxc() {
#helpDescription="AgentDVR une nouvelle solution de vidéosurveillance pour l'Internet des objets. Pour créer un nouveau Proxmox VE AgentDVR LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. Copie bash -c \"\$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/agentdvr.sh)\" ⚡ Paramètres par défaut : 2 Go de RAM - 8 Go de stockage - 2 vCPU - Privilégié ⚡ Interface AgentDVR : IP : 8090"
#categoryMenu="enregistreur_video_numerique_nvr"
#nameMenu="AgentDVR LXC"
#commutatorLetter=""
#commutatorWord="agentdvr_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/agentdvr.sh)"
}

serveur_dvr_de_chaines_lxc() {
#helpDescription="Channels DVR Server fonctionne sur votre ordinateur ou votre périphérique NAS à la maison. Vous n'avez pas à vous soucier du cloud. Vos émissions de télévision et vos films seront toujours disponibles. Pour créer un nouveau serveur DVR de canaux Proxmox VE LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. Copie bash -c \"\$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/channels.sh)\" ⚡ Paramètres par défaut : 1 Go de RAM - 8 Go de stockage - 2 vCPU - Privilégié ⚡ Interface du serveur DVR des canaux : IP : 8089"
#categoryMenu="enregistreur_video_numerique_nvr"
#nameMenu="Serveur DVR de chaînes LXC"
#commutatorLetter=""
#commutatorWord="serveur_dvr_de_chaines_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/channels.sh)"
}

frigate_lxc() {
#helpDescription="Frigate est un NVR open source conçu autour de la détection d'objets par IA en temps réel. Tout le traitement est effectué localement sur votre propre matériel et les flux de vos caméras ne quittent jamais votre domicile. Pour créer une nouvelle Proxmox VE Frigate LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. Copie bash -c \"\$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/frigate.sh)\" ⚡ Paramètres par défaut : 1 Go de RAM - 20 Go de stockage - 4 vCPU - Privilégié ⚡ Interface de frégate : IP:5000 Interface go2rtc : IP:1984"
#categoryMenu="enregistreur_video_numerique_nvr"
#nameMenu="Frégate LXC"
#commutatorLetter=""
#commutatorWord="frigate_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/frigate.sh)"
}

motioneye_lxc() {
#helpDescription="MotionEye est un logiciel d'enregistrement vidéo en réseau (NVR) open source et auto-hébergé conçu pour gérer et surveiller les caméras IP. Il fonctionne sur différentes plates-formes telles que Linux, Raspberry Pi et Docker, et offre des fonctionnalités telles que le streaming vidéo en temps réel, la détection de mouvement et des vues de caméra personnalisables. Pour créer un nouveau Proxmox VE MotionEye NVR LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. Copie bash -c \"\$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/motioneye.sh)\" ⚡ Paramètres par défaut : 2 Go de RAM - 8 Go de stockage - 2 vCPU ⚡ Interface MotionEye : IP : 8765 ⚙️ Connexion initiale nom d'utilisateur admin mot de passe"
#categoryMenu="enregistreur_video_numerique_nvr"
#nameMenu="Enregistreur vidéo en réseau MotionEye LXC"
#commutatorLetter=""
#commutatorWord="motioneye_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/motioneye.sh)"
}

scrypted_lxc() {
#helpDescription="Scrypted se concentre sur la fourniture d'une expérience transparente pour la gestion et l'utilisation des caméras dans une configuration de maison intelligente. Il offre des fonctionnalités telles que la gestion des caméras, le déclenchement d'événements, le stockage de vidéos et d'images et l'intégration avec d'autres appareils et services de maison intelligente. Scrypted est conçu pour faciliter la configuration et l'utilisation des caméras dans un système domotique, en fournissant une interface simple et conviviale pour la surveillance et l'automatisation des tâches liées aux caméras. 🛈 Si le LXC est créé avec Privilège, le script configurera automatiquement le relais USB. Pour créer un nouveau LXC crypté Proxmox VE, exécutez la commande ci-dessous dans le shell Proxmox VE. Copie bash -c \"\$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/scrypted.sh)\" ⚡ Paramètres par défaut : 2 Go de RAM - 8 Go de stockage - 2 vCPU ⚡ Interface cryptée : (https)IP : 10443"
#categoryMenu="enregistreur_video_numerique_nvr"
#nameMenu="LXC crypté"
#commutatorLetter=""
#commutatorWord="scrypted_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/scrypted.sh)"
}

shinobi_lxc() {
#helpDescription="Shinobi est un logiciel d'enregistrement vidéo en réseau (NVR) open source et auto-hébergé. Il vous permet de gérer et de surveiller les caméras de sécurité et d'enregistrer des séquences vidéo. Shinobi peut être exécuté sur différentes plates-formes, notamment Linux, macOS et Raspberry Pi, et offre des fonctionnalités telles que le streaming en temps réel, la détection de mouvement et les notifications par e-mail. Pour créer un nouveau NVR Proxmox VE Shinobi LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. Copie bash -c \"\$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/shinobi.sh)\" ⚡ Paramètres par défaut : 2 Go de RAM - 8 Go de stockage - 2 vCPU - Privilégié ⚡ Interface Shinobi : IP : 8080 Interface d'administration Shinobi : IP:8080/super ⚙️ Connexion initiale de l'administrateur nom d'utilisateur admin@shinobi.video mot de passe admin"
#categoryMenu="enregistreur_video_numerique_nvr"
#nameMenu="Enregistreur vidéo en réseau Shinobi LXC"
#commutatorLetter=""
#commutatorWord="shinobi_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/shinobi.sh)"
}

adguard_home_lxc() {
#helpDescription="AdGuard Home est un bloqueur de publicités open source et auto-hébergé sur tout le réseau. Il bloque les publicités, les trackers, les sites Web de phishing et de malware, et offre une protection contre les menaces en ligne. AdGuard Home est une solution basée sur DNS, ce qui signifie qu'il bloque les publicités et le contenu malveillant au niveau du réseau, avant même qu'il n'atteigne votre appareil. Il fonctionne sur votre réseau domestique et peut être facilement configuré et géré via une interface Web. Il fournit des statistiques et des journaux détaillés, vous permettant de voir quels sites Web sont bloqués et pourquoi. AdGuard Home est conçu pour être rapide, léger et facile à utiliser, ce qui en fait une solution idéale pour les utilisateurs à domicile qui souhaitent bloquer les publicités, protéger leur vie privée et améliorer la vitesse et la sécurité de leur expérience en ligne. Pour créer un nouveau Proxmox VE AdGuard Home LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. Copie bash -c \"\$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/adguard.sh)\" ⚡ Paramètres par défaut : 512 Mo de RAM - 2 Go de stockage - 1 vCPU ⚡ Interface de configuration d'AdGuard Home : IP : 3000 (après la configuration, utilisez uniquement l'IP) (Pour l'intégration de Home Assistant, utilisez le port 80 non 3000)"
#categoryMenu="bloqueur_de_publicites_dns"
#nameMenu="AdGuard Home (Accueil AdGuard) LXC"
#commutatorLetter=""
#commutatorWord="adguard_home_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/adguard.sh)"
}

blocky_lxc() {
#helpDescription="Blocky is a software tool designed for blocking unwanted ads and trackers on local networks. It functions as a DNS proxy and runs on the Go programming language. Blocky intercepts requests to advertisements and other unwanted content and blocks them before they reach the end user. This results in a cleaner, faster, and more secure online experience for users connected to the local network. Blocky is open-source, easy to configure and can be run on a variety of devices, making it a versatile solution for small to medium-sized local networks. To create a new Proxmox VE Blocky LXC, run the command below in the Proxmox VE Shell. Copy bash -c \"\$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/blocky.sh)\" ⚡ Default Settings: 512MiB RAM - 2GB Storage - 1vCPU ⚡ ⚙️ Blocky Config Path Copy /opt/blocky/config.yml"
#categoryMenu="bloqueur_de_publicites_dns"
#nameMenu="Blocky LXC"
#commutatorLetter=""
#commutatorWord="blocky_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/blocky.sh)"
}

pihole_lxc() {
#helpDescription="Pi-hole is a free, open-source network-level advertisement and Internet tracker blocking application. It runs on a Raspberry Pi or other Linux-based systems and acts as a DNS sinkhole, blocking unwanted traffic before it reaches a user's device. Pi-hole can also function as a DHCP server, providing IP addresses and other network configuration information to devices on a network. The software is highly configurable and supports a wide range of customizations, such as allowing or blocking specific domains, setting up blocklists and whitelists, and customizing the appearance of the web-based interface. The main purpose of Pi-hole is to protect users' privacy and security by blocking unwanted and potentially malicious content, such as ads, trackers, and malware. It is designed to be easy to set up and use, and can be configured through a web-based interface or through a terminal-based command-line interface. To create a new Proxmox VE Pi-hole LXC, run the command below in the Proxmox VE Shell. To Update Pi-hole, run the command below (or type update) in the LXC Console. Copy bash -c \"\$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/pihole.sh)\" ⚡ Default Settings: 512MiB RAM - 2GB Storage - 1vCPU ⚡ ⚠️ Reboot Pi-hole LXC after install Pi-hole Interface: IP/admin ⚙️ To set your password: Copy pihole -a -p"
#categoryMenu="bloqueur_de_publicites_dns"
#nameMenu="Pi-hole LXC"
#commutatorLetter=""
#commutatorWord="pihole_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/pihole.sh)"
}

technitiumdns_lxc() {
#helpDescription="Technitium DNS Server is a free, open-source and privacy-focused DNS (Domain Name System) server software for Windows, Linux, and macOS. It is designed to provide a secure, fast, and reliable DNS resolution service to its users. The server can be configured through a web-based interface, and it supports a variety of advanced features, such as automatic IP updates, IPv6 support, caching of DNS queries, and the ability to block unwanted domains. It is also designed to be highly secure, with built-in measures to prevent common types of DNS attacks and data leaks. Technitium DNS Server is aimed at providing an alternative to traditional DNS servers, which often have privacy and security concerns associated with them, and it is ideal for users who are looking for a more secure and private DNS resolution service. To create a new Proxmox VE Technitium DNS LXC, run the command below in the Proxmox VE Shell. To Update Technitium DNS, run the command below (or type update) in the LXC Console. Copy bash -c \"\$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/technitiumdns.sh)\" ⚡ Default Settings: 512MiB RAM - 2GB Storage - 1vCPU ⚡ Technitium DNS Interface: IP:5380"
#categoryMenu="serveur_dns"
#nameMenu="Technitium DNS LXC"
#commutatorLetter=""
#commutatorWord="technitiumdns_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/technitiumdns.sh)"
}

kavita_lxc() {
#helpDescription="Kavita is a fast, feature-rich, cross-platform reading server. Built with a focus on manga, it aims to be a complete solution for all your reading needs. To create a new Proxmox VE Kavita LXC, run the command below in the Proxmox VE Shell. To Update Kavita, run the command below (or type update) in the LXC Console. Copy bash -c \"\$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/kavita.sh)\" ⚡ Default Settings: 2GB RAM - 8GB Storage - 2vCPU ⚡ Kavita Interface: IP:5000"
#categoryMenu="document_notes"
#nameMenu="Kavita LXC"
#commutatorLetter=""
#commutatorWord="kavita_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/kavita.sh)"
}

nocodb_lxc() {
#helpDescription="NocoDB is a document-oriented database management system utilizing the NoSQL data model, offering flexibility and scalability. It stores data in JSON format, supporting various data types and providing features like real-time synchronization, auto-indexing, and full-text search. NocoDB includes a web-based interface for managing and querying data, suitable for small projects to large enterprise systems. To create a new Proxmox VE NocoDB LXC, run the command below in the Proxmox VE Shell. To Update NocoDB, run the command below (or type update) in the LXC Console. Copy bash -c \"\$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/nocodb.sh)\" ⚡ Default Settings: 1GB RAM - 4GB Storage - 1vCPU ⚡ NocoDB Interface: IP:8080/dashboard"
#categoryMenu="document_notes"
#nameMenu="NocoDB LXC"
#commutatorLetter=""
#commutatorWord="nocodb_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/nocodb.sh)"
}

paperless_ngx_lxc() {
#helpDescription="Paperless-ngx is a software tool for digitizing and organizing paper documents, providing a web-based interface for scanning, uploading, and organizing documents. It uses OCR technology to extract text from scanned images, making documents searchable and improving document management efficiency. To create a new Proxmox VE Paperless-ngx LXC, run the command below in the Proxmox VE Shell. To Update Paperless-ngx or Show Login Credentials, run the command below (or type update) in the LXC Console. Copy bash -c \"\$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/paperless-ngx.sh)\" ⚡ Default Settings: 2GB RAM - 8GB Storage - 2vCPU ⚡ Paperless-ngx Interface: IP:8000"
#categoryMenu="document_notes"
#nameMenu="Paperless-ngx LXC"
#commutatorLetter=""
#commutatorWord="paperless_ngx_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/paperless-ngx.sh)"
}

stirling_pdf_lxc() {
#helpDescription="Stirling-PDF is a powerful locally hosted web-based PDF manipulation tool that allows you to perform various operations on PDF files, such as splitting, merging, converting, reorganizing, adding images, rotating, compressing, and more. To create a new Proxmox VE Stirling-PDF LXC, run the command below in the Proxmox VE Shell. To update Stirling-PDF, run the command below (or type update) in the LXC Console. bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/stirling-pdf.sh)\" ⚡ Default Settings: 2GB RAM - 8GB Storage - 2vCPU ⚡ Stirling-PDF Interface: IP:8080"
#categoryMenu="document_notes"
#nameMenu="Stirling-PDF LXC"
#commutatorLetter=""
#commutatorWord="stirling_pdf_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/stirling-pdf.sh)"
}

trilium_lxc() {
#helpDescription="Trilium is an open-source note-taking and personal knowledge management application. It allows users to organize and manage their notes, ideas, and information in a single place, using a hierarchical tree-like structure. Trilium offers a range of features, including rich text formatting, links, images, and attachments, making it easy to create and structure notes. The software is designed to be flexible and customizable, with a range of customization options and plugins available, including themes, export options, and more. Trilium is a self-hosted solution, and can be run on a local machine or a cloud-based server, providing users with full control over their notes and information. To create a new Proxmox VE Trilium LXC, run the command below in the Proxmox VE Shell. To update Trilium, run the command below (or type update) in the LXC Console. bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/trilium.sh)\" ⚡ Default Settings: 512MiB RAM - 2GB Storage - 1vCPU ⚡ Trilium Interface: IP:8080"
#categoryMenu="document_notes"
#nameMenu="Trilium LXC"
#commutatorLetter=""
#commutatorWord="trilium_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/trilium.sh)"
}

wikijs_lxc() {
#helpDescription="Wiki.js is a free, open-source, and modern wiki application built using Node.js. It is designed to be fast, easy to use, and flexible, with a range of features for collaboration, knowledge management, and content creation. Wiki.js supports Markdown syntax for editing pages, and includes features such as version control, page history, and access control, making it easy to manage content and collaborate with others. The software is fully customizable, with a range of themes and extensions available, and can be deployed on a local server or in the cloud, making it an ideal choice for small teams and organizations looking to create and manage a wiki. Wiki.js provides a modern, user-friendly interface, and supports a range of data sources, including local file systems, databases, and cloud storage services. To create a new Proxmox VE Wiki.js LXC, run the command below in the Proxmox VE Shell. To update Wiki.js, run the command below (or type update) in the LXC Console. bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/wikijs.sh)\" ⚡ Default Settings: 512MiB RAM - 2GB Storage - 1vCPU ⚡ Wiki.js Interface: IP:3000"
#categoryMenu="document_notes"
#nameMenu="Wiki.js LXC"
#commutatorLetter=""
#commutatorWord="wikijs_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/wikijs.sh)"
}

dashy_lxc() {
#helpDescription="Dashy est une solution qui vous aide à organiser vos services auto-hébergés en centralisant l'accès à ceux-ci via une interface unique. Pour créer un nouveau Proxmox VE Dashy LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. Pour mettre à jour Dashy, exécutez la commande ci-dessous (ou saisissez update) dans la console LXC. bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/dashy.sh)\" ⚡ Paramètres par défaut : 2 Go de RAM - 6 Go de stockage - 2 vCPU ⚡ Interface Dashy : IP : 4000"
#categoryMenu="tableaux_de_bord"
#nameMenu="Dashy LXC"
#commutatorLetter=""
#commutatorWord="dashy_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/dashy.sh)"
}

fenrus_lxc() {
#helpDescription="Fenrus est une page d'accueil personnelle pour un accès rapide à toutes vos applications/sites personnels. Pour créer un nouveau Proxmox VE Fenrus LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/fenrus.sh)\" ⚡ Paramètres par défaut : 512 Mo de RAM - 4 Go de stockage - 1 vCPU ⚡ Interface Fenrus : IP : 5000"
#categoryMenu="tableaux_de_bord"
#nameMenu="Fenrus LXC"
#commutatorLetter=""
#commutatorWord="fenrus_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/fenrus.sh)"
}

tableau_de_bord_heimdall_lxc() {
#helpDescription="Heimdall Dashboard est un tableau de bord Web auto-hébergé permettant de gérer et de surveiller l'état des applications et des serveurs. Il vous permet de suivre l'état de vos systèmes à partir d'un emplacement unique et centralisé et de recevoir des notifications en cas de problème. Avec Heimdall Dashboard, vous avez un contrôle total sur vos données et pouvez les personnaliser pour répondre à vos besoins spécifiques. L'auto-hébergement du tableau de bord vous donne la possibilité de l'exécuter sur votre propre infrastructure, ce qui en fait une solution adaptée aux organisations qui accordent la priorité à la sécurité et à la confidentialité des données. Pour créer un nouveau tableau de bord Heimdall LXC Proxmox VE, exécutez la commande ci-dessous dans le shell Proxmox VE. bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/heimdall-dashboard.sh)\" ⚡ Paramètres par défaut : 512 Mo de RAM - 2 Go de stockage - 1 vCPU ⚡ Interface du tableau de bord Heimdall : IP : 7990"
#categoryMenu="tableaux_de_bord"
#nameMenu="Tableau de bord Heimdall LXC"
#commutatorLetter=""
#commutatorWord="tableau_de_bord_heimdall_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/heimdall-dashboard.sh)"
}

homarr_lxc() {
#helpDescription="Homarr est un tableau de bord élégant et moderne qui met toutes vos applications et services à portée de main. Pour créer un nouveau Proxmox VE Homarr LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/homarr.sh)\" ⚡ Paramètres par défaut : 2 Go de RAM - 8 Go de stockage - 2 vCPU ⚡ Interface Homarr : IP:3000"
#categoryMenu="tableaux_de_bord"
#nameMenu="Homarr LXC"
#commutatorLetter=""
#commutatorWord="homarr_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/homarr.sh)"
}

page_d_accueil_lxc() {
#helpDescription="Homepage est une solution de tableau de bord auto-hébergée pour centraliser et organiser les données et les informations. Pour créer une nouvelle page d'accueil Proxmox VE LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/homepage.sh)\" ⚡ Paramètres par défaut : 1 Go de RAM - 3 Go de stockage - 2 vCPU ⚡ Chemin de configuration (bookmarks.yaml, services.yaml, widgets.yaml) : /opt/homepage/config/ Interface de la page d'accueil : IP:3000"
#categoryMenu="tableaux_de_bord"
#nameMenu="Homepage (Page d'accueil) LXC"
#commutatorLetter=""
#commutatorWord="page_d_accueil_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/homepage.sh)"
}

homere_lxc() {
#helpDescription="Homer est un générateur de page d'accueil statique simple et léger qui vous permet de créer et de gérer une page d'accueil pour votre serveur. Il utilise un fichier de configuration YAML pour définir la mise en page et le contenu de votre page d'accueil, ce qui facilite sa configuration et sa personnalisation. La page d'accueil générée est statique, ce qui signifie qu'elle ne nécessite aucun traitement côté serveur, ce qui la rend rapide et efficace à utiliser. Homer est conçu pour être une solution flexible et nécessitant peu de maintenance pour organiser et accéder à vos services et informations à partir d'un emplacement unique et centralisé. Pour créer un nouveau Proxmox VE Homer LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/homer.sh)\" ⚡ Paramètres par défaut : 512 Mo de RAM - 2 Go de stockage - 1 vCPU ⚡ Interface Homer : IP:8010 ⚙️ Chemin de configuration /opt/homer/assets/config.yml"
#categoryMenu="tableaux_de_bord"
#nameMenu="Homer LXC"
#commutatorLetter=""
#commutatorWord="homere_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/homer.sh)"
}

lienwarden_lxc() {
#helpDescription="Linkwarden est un gestionnaire de signets collaboratif open source entièrement auto-hébergé pour collecter, organiser et archiver des pages Web. Pour créer un nouveau Proxmox VE Linkwarden LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/linkwarden.sh)\" ⚡ Paramètres par défaut : 2 Go de RAM - 8 Go de stockage - 2 vCPU ⚡ Interface Linkwarden : IP : 3000 Afficher les informations d'identification de la base de données/administrateur :cat linkwarden.creds"
#categoryMenu="tableaux_de_bord"
#nameMenu="Linkwarden LXC"
#commutatorLetter=""
#commutatorWord="lienwarden_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/linkwarden.sh)"
}

mafl_lxc() {
#helpDescription="Mafl est un service intuitif pour organiser votre page d'accueil. Personnalisez Mafl selon vos besoins individuels et travaillez encore plus efficacement ! Pour créer un nouveau Proxmox VE Mafl LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/mafl.sh)\" ⚡ Paramètres par défaut : 1 Go de RAM - 6 Go de stockage - 1 vCPU ⚡ Interface Mafl : IP:3000 Les services, les icônes, la langue et d'autres paramètres sont définis dans un seul fichier config.yml. Copie nano /opt/mafl/data/config.yml"
#categoryMenu="tableaux_de_bord"
#nameMenu="Mafl LXC"
#commutatorLetter=""
#commutatorWord="mafl_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/mafl.sh)"
}

boite_a_olives() {
#helpDescription="OliveTin fournit un moyen sécurisé et simple d'exécuter des commandes shell prédéterminées via une interface Web. Pour installer OliveTin, ⚠️ exécutez la commande ci-dessous dans la console LXC. bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/misc/olivetin.sh)\" Interface OliveTin : IP:1337 ⚙️ Chemin de configuration Copie /etc/OliveTin/config.yaml"
#categoryMenu="divers"
#nameMenu="OliveTin (Boîte à olives)"
#commutatorLetter=""
#commutatorWord="boite_a_olives"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/misc/olivetin.sh)"
}

aria2_lxc() {
#helpDescription="Aria2 est un utilitaire de téléchargement multi-protocole et multi-source, multi-plateforme et léger, fonctionnant en ligne de commande. Il prend en charge HTTP/HTTPS, FTP, SFTP, BitTorrent et Metalink. Pour créer un nouveau Proxmox VE Aria2 LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/aria2.sh)\" ⚡ Paramètres par défaut : 1 Go de RAM - 8 Go de stockage - 2 vCPU ⚡ Interface AriaNG : IP : 6880 Dans la console LXC, exécutez cat rpc.secretpour afficher le secret RPC. Copiez ce jeton et collez-le dans la zone Jeton secret RPC Aria2 dans les paramètres AriaNG. Cliquez ensuite sur le bouton Recharger AriaNG."
#categoryMenu="fichier_code"
#nameMenu="Aria2 LXC"
#commutatorLetter=""
#commutatorWord="aria2_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/aria2.sh)"
}

autobrr_lxc() {
#helpDescription="Autobrr est un outil de téléchargement de torrents qui automatise le processus de téléchargement de torrents. Il est conçu pour être moderne et convivial, offrant aux utilisateurs un moyen pratique et efficace de télécharger des fichiers torrent. Avec Autobrr, vous pouvez planifier et gérer vos téléchargements de torrents, et avoir la possibilité de télécharger automatiquement des torrents en fonction de certaines conditions, telles que l'heure de la journée ou la disponibilité des seeds. Cela peut vous faire gagner du temps et des efforts, vous permettant de vous concentrer sur d'autres tâches pendant que vos torrents sont téléchargés en arrière-plan. Pour créer un nouveau Proxmox VE Autobrr LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/autobrr.sh)\" ⚡ Paramètres par défaut : 2 Go de RAM - 8 Go de stockage - 2 vCPU ⚡ Interface Autobrr : IP : 7474"
#categoryMenu="fichier_code"
#nameMenu="Autobrr LXC"
#commutatorLetter=""
#commutatorWord="autobrr_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/autobrr.sh)"
}

daemonsync_lxc() {
#helpDescription="Synchronisez les fichiers de l'application vers le serveur, partagez des photos et des vidéos, sauvegardez vos données et restez en sécurité au sein du réseau local. Pour créer un nouveau Proxmox VE Daemon Sync Server LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/daemonsync.sh)\" ⚡ Paramètres par défaut : 512 Mo de RAM - 8 Go de stockage - 1 vCPU ⚡ Interface du serveur Daemon Sync : IP : 8084"
#categoryMenu="fichier_code"
#nameMenu="Serveur de synchronisation Daemon LXC"
#commutatorLetter=""
#commutatorWord="daemonsync_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/daemonsync.sh)"
}

deluge_lxc() {
#helpDescription="Deluge est un client BitTorrent léger, gratuit et open source. Il prend en charge diverses plates-formes, notamment Windows, Linux et macOS, et offre des fonctionnalités telles que l'échange entre pairs, DHT et les liens magnétiques. Pour créer un nouveau Proxmox VE Deluge LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/deluge.sh)\" ⚡ Paramètres par défaut : 2 Go de RAM - 4 Go de stockage - 2 vCPU ⚡ ⚙️ Connexion initiale mot de passe deluge Interface Déluge : IP:8112"
#categoryMenu="fichier_code"
#nameMenu="Déluge LXC"
#commutatorLetter=""
#commutatorWord="deluge_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/deluge.sh)"
}

file_browser_lxc() {
#helpDescription="File Browser propose une interface Web conviviale pour la gestion des fichiers dans un répertoire désigné. Il vous permet d'effectuer diverses actions telles que le téléchargement, la suppression, la prévisualisation, le changement de nom et la modification de fichiers. Pour installer ou désinstaller le navigateur de fichiers, ⚠️ exécutez la commande ci-dessous dans la console LXC. bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/misc/filebrowser.sh)\" Interface du navigateur de fichiers : IP : 8080 ⚙️ Connexion initiale (non requise pour l'absence d'authentification) nom d'utilisateur admin mot de passe changeme ⚙️ Pour mettre à jour le navigateur de fichiers Curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash"
#categoryMenu="fichier_code"
#nameMenu="File Browser (Navigateur de fichiers) LXC"
#commutatorLetter=""
#commutatorWord="file_browser_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/misc/filebrowser.sh)"
}

forgejo_lxc() {
#helpDescription="Forgejo est un service Git open source et auto-hébergé qui permet aux particuliers et aux équipes de gérer leurs référentiels de code. Pour créer un nouveau Proxmox VE Forgejo LXC, exécutez la commande ci-dessous dans le shell Proxmox VE . Pour mettre à jour Forgejo, exécutez la commande ci-dessous (ou saisissez update) dans la console LXC. bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/forgejo.sh)\" ⚡ Paramètres par défaut : 2 Go de RAM - 10 Go de stockage - 2 vCPU ⚡ Interface Forgejo : IP:3000"
#categoryMenu="fichier_code"
#nameMenu="Forgejo LXC"
#commutatorLetter=""
#commutatorWord="forgejo_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/forgejo.sh)"
}

gokapi_lxc() {
#helpDescription="Gokapi est un serveur léger pour partager des fichiers, qui expirent après un certain nombre de téléchargements ou de jours. Pour créer un nouveau Proxmox VE Gokapi LXC, exécutez la commande ci-dessous dans le shell Proxmox VE . Pour mettre à jour Gokapi, exécutez la commande ci-dessous (ou saisissez update) dans la console LXC . bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/gokapi.sh)\" ⚡ Paramètres par défaut : 512 Mo de RAM - 4 Go de stockage - 1 vCPU ⚡ Interface Gokapi : IP:53842/configuration"
#categoryMenu="fichier_code"
#nameMenu="Gokapi LXC"
#commutatorLetter=""
#commutatorWord="gokapi_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/gokapi.sh)"
}

jackett_lxc() {
#helpDescription="Jackett prend en charge une large gamme de trackers, y compris les plus populaires comme The Pirate Bay, RARBG et Torrentz2, ainsi que de nombreux trackers privés. Il peut être intégré à plusieurs clients BitTorrent, notamment qBittorrent, Deluge et uTorrent, entre autres. Pour créer un nouveau Proxmox VE Jackett LXC, exécutez la commande ci-dessous dans le shell Proxmox VE . bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/jackett.sh)\" ⚡ Paramètres par défaut : 512 Mo de RAM - 2 Go de stockage - 1 vCPU ⚡ Interface Jackett : IP:9117"
#categoryMenu="code"
#nameMenu="Jackett LXC"
#commutatorLetter=""
#commutatorWord="jackett_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/jackett.sh)"
}

kubo_lxc() {
#helpDescription="Kubo a été la première implémentation d'IPFS et est aujourd'hui la plus utilisée. Il implémente le système de fichiers interplanétaire - la norme Web3 pour l'adressage de contenu, interopérable avec HTTP. Il est donc alimenté par les modèles de données d'IPLD et la libp2p pour la communication réseau. Kubo est écrit en Go. Pour créer un nouveau Proxmox VE Kubo LXC, exécutez la commande ci-dessous dans le shell Proxmox VE . bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/kubo.sh)\" ⚡ Paramètres par défaut : 4 Go de RAM - 4 Go de stockage - 2 vCPU ⚡ Interface Kubo : IP:5001/webui"
#categoryMenu="code"
#nameMenu="Kubo LXC"
#commutatorLetter=""
#commutatorWord="kubo_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/kubo.sh)"
}

pairdrop_lxc() {
#helpDescription="PairDrop : Partage de fichiers local dans votre navigateur. Pour créer un nouveau PairDrop LXC Proxmox VE, exécutez la commande ci-dessous dans le shell Proxmox VE . bash -c \"$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/pairdrop.sh)\" ⚡ Paramètres par défaut : 512 Mo de RAM - 4 Go de stockage - 1 vCPU ⚡ Interface PairDrop : IP : 3000"
#categoryMenu="code"
#nameMenu="PairDrop LXC"
#commutatorLetter=""
#commutatorWord="pairdrop_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/pairdrop.sh)"
}

partage_pingvin_lxc() {
#helpDescription="Pingvin Share est une plateforme de partage de fichiers auto-hébergée et une alternative à WeTransfer. Pour créer un nouveau partage Pingvin LXC Proxmox VE, exécutez la commande ci-dessous dans le shell Proxmox VE. Paramètres par défaut : 2 Go de RAM - 8 Go de stockage - 2 vCPU. Interface de partage Pingvin : IP : 3000."
#categoryMenu="fichier_code"
#nameMenu="Partage Pingvin LXC"
#commutatorLetter=""
#commutatorWord="partage_pingvin_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/pingvin.sh)"
}

qbittorrent_lxc() {
#helpDescription="qBittorrent propose une interface conviviale qui permet aux utilisateurs de rechercher et de télécharger facilement des fichiers torrent. Il prend également en charge les liens magnétiques, qui permettent aux utilisateurs de commencer à télécharger des fichiers sans avoir besoin d'un fichier torrent. Pour créer un nouveau Proxmox VE qBittorrent LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. Paramètres par défaut : 2 Go de RAM - 8 Go de stockage - 2 vCPU. Interface qBittorrent : IP:8090. Connexion initiale : nom d'utilisateur admin, mot de passe changeme."
#categoryMenu="fichier_code"
#nameMenu="qBittorrent LXC"
#commutatorLetter=""
#commutatorWord="qbittorrent_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/qbittorrent.sh)"
}

rdtclient_lxc() {
#helpDescription="RDTClient est une interface Web pour gérer vos torrents sur Real-Debrid, AllDebrid ou Premiumize. Pour créer un nouveau client Torrent Real-Debrid LXC Proxmox VE, exécutez la commande ci-dessous dans le shell Proxmox VE. Paramètres par défaut : 1 Go de RAM - 4 Go de stockage - 1 vCPU. Interface client Real-Debrid Torrent : IP : 6 500."
#categoryMenu="fichier_code"
#nameMenu="Client Torrent Real-Debrid LXC"
#commutatorLetter=""
#commutatorWord="rdtclient_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/rdtclient.sh)"
}

sabnzbd_lxc() {
#helpDescription="SABnzbd est un logiciel gratuit et open source permettant de télécharger des fichiers binaires à partir de groupes de discussion Usenet. Il est conçu pour être facile à utiliser et offre une détection et une réparation automatiques des erreurs, la planification des téléchargements et l'intégration avec d'autres applications. SABnzbd est spécialement conçu pour télécharger des fichiers binaires comme des images, de la musique et des vidéos à partir de groupes de discussion Usenet. Pour créer un nouveau Proxmox VE SABnzbd LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. Paramètres par défaut : 2 Go de RAM - 8 Go de stockage - 2 vCPU. Interface SABnzbd : IP : 7777."
#categoryMenu="fichier_code"
#nameMenu="SABnzbd LXC"
#commutatorLetter=""
#commutatorWord="sabnzbd_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/sabnzbd.sh)"
}

sftpgo_lxc() {
#helpDescription="SFTPGo est un serveur SFTP complet et hautement configurable avec prise en charge optionnelle de HTTP/S, FTP/S et WebDAV. Plusieurs backends de stockage sont pris en charge : système de fichiers local, système de fichiers local chiffré, stockage d'objets S3 (compatible), stockage Google Cloud, stockage Azure Blob, SFTP. Pour créer un nouveau Proxmox VE SFTPGo LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. Paramètres par défaut : 2 Go de RAM - 4 Go de stockage - 2 vCPU. Interface SFTPGo : IP : 8080/web/admin."
#categoryMenu="fichier_code"
#nameMenu="SFTPGo LXC"
#commutatorLetter=""
#commutatorWord="sftpgo_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/sftpgo.sh)"
}

syncthing_lxc() {
#helpDescription="Syncthing est un outil de synchronisation de fichiers open source qui permet aux utilisateurs de synchroniser leurs fichiers sur plusieurs appareils en utilisant la synchronisation peer-to-peer. Il ne dépend d'aucun serveur central, donc tous les transferts de données se font directement entre les appareils. Pour créer un nouveau Proxmox VE Syncthing LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. Paramètres par défaut : 2 Go de RAM - 8 Go de stockage - 2 vCPU. Interface de synchronisation : IP:8384."
#categoryMenu="fichier_code"
#nameMenu="Synchronisation LXC"
#commutatorLetter=""
#commutatorWord="syncthing_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/syncthing.sh)"
}

transmission_lxc() {
#helpDescription="Transmission est un client BitTorrent gratuit et open source connu pour ses vitesses de téléchargement rapides et sa facilité d'utilisation. Il prend en charge diverses plates-formes telles que Windows, Linux et macOS et dispose de fonctionnalités telles qu'une interface Web, un échange entre pairs et des transferts cryptés. Pour créer un nouveau Proxmox VE Transmission LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. Paramètres par défaut : 2 Go de RAM - 8 Go de stockage - 2 vCPU. Connexion initiale : mot de passe de l'utilisateur transmission. Interface de transmission : IP:9091/transmission."
#categoryMenu="fichier_code"
#nameMenu="Transmission LXC"
#commutatorLetter=""
#commutatorWord="transmission_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/transmission.sh)"
}

serveur_vs_code() {
#helpDescription="VS Code Server est un service que vous pouvez exécuter sur une machine de développement distante, comme votre ordinateur de bureau ou une machine virtuelle (VM). Il vous permet de vous connecter en toute sécurité à cette machine distante depuis n'importe où via une URL vscode.dev, sans nécessiter de SSH. Pour installer VS Code Server, exécutez la commande ci-dessous dans la console LXC. Interface du serveur VS Code : IP : 8680."
#categoryMenu="fichier_code"
#nameMenu="Serveur VS Code"
#commutatorLetter=""
#commutatorWord="serveur_vs_code"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/misc/code-server.sh)"
}

administration_du_systeme_webmin() {
#helpDescription="Webmin fournit une interface utilisateur graphique (GUI) pour des tâches telles que la gestion des comptes utilisateurs, la gestion des packages, la configuration du système de fichiers, la configuration du réseau, etc. Pour installer l’administration système Webmin, exécutez la commande ci-dessous dans la console LXC. Interface Webmin : (https)IP:10000. Connexion initiale nom d'utilisateur root mot de passe root. Pour mettre à jour Webmin, utilisez l'option 'Update from the Webmin UI'. Pour désinstaller Webmin, exécutez 'bash /etc/webmin/uninstall.sh'."
#categoryMenu="systeme_operateur"
#nameMenu="Administration du système Webmin"
#commutatorLetter=""
#commutatorWord="administration_du_systeme_webmin"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/misc/webmin.sh)"
}

budget_actuel_lxc() {
#helpDescription="Actual Budget est une application ultra-rapide et axée sur la confidentialité pour gérer vos finances. Au cœur de cette application se trouve la méthodologie éprouvée et très appréciée de budgétisation par enveloppes. Pour créer un nouveau budget réel LXC Proxmox VE, exécutez la commande ci-dessous dans le shell Proxmox VE. Interface budgétaire actuelle : IP : 5006"
#categoryMenu="divers"
#nameMenu="Budget actuel LXC"
#commutatorLetter=""
#commutatorWord="budget_actuel_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/actualbudget.sh)"
}

commafeed_lxc() {
#helpDescription="CommaFeed est un lecteur RSS auto-hébergé inspiré de Google Reader. Pour créer un nouveau CommaFeed LXC Proxmox VE, exécutez la commande ci-dessous dans le shell Proxmox VE. Interface CommaFeed : IP : 8082"
#categoryMenu="divers"
#nameMenu="CommaFeed LXC"
#commutatorLetter=""
#commutatorWord="commafeed_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/commafeed.sh)"
}

flowiseai_lxc() {
#helpDescription="FlowiseAI est un outil low-code open source permettant aux développeurs de créer des flux d'orchestration LLM et des agents d'IA personnalisés. Pour créer un nouveau Proxmox VE FlowiseAI LXC, exécutez la commande suivante dans le shell Proxmox VE. Interface FlowiseAI - IP:3000"
#categoryMenu="divers"
#nameMenu="FlowiseAI LXC"
#commutatorLetter=""
#commutatorWord="flowiseai_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/flowiseai.sh)"
}

go2rtc_lxc() {
#helpDescription="go2rtc est l'application de streaming de caméra ultime avec prise en charge RTSP, WebRTC, HomeKit, FFmpeg, RTMP, etc. Pour créer un nouveau Proxmox VE go2rtc LXC, exécutez la commande suivante dans le shell Proxmox VE. Interface go2rtc - IP:1984"
#categoryMenu="divers"
#nameMenu="go2rtc LXC"
#commutatorLetter=""
#commutatorWord="go2rtc_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/go2rtc.sh)"
}

gotify_lxc() {
#helpDescription="Gotify est un serveur simple pour envoyer et recevoir des messages. Pour créer un nouveau Proxmox VE Gotify LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. Interface Gotify : IP"
#categoryMenu="divers"
#nameMenu="Gotify LXC"
#commutatorLetter=""
#commutatorWord="gotify_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/gotify.sh)"
}

epicerie_lxc() {
#helpDescription="Grocy est une solution Web de gestion des courses et des articles ménagers auto-hébergée pour votre maison. Elle vous aide à suivre vos courses et vos articles ménagers, à gérer votre liste de courses et à suivre votre garde-manger, vos recettes, vos plans de repas et bien plus encore. Pour créer un nouveau grocy LXC Proxmox VE, exécutez la commande ci-dessous dans le shell Proxmox VE. Interface de l'épicerie : IP"
#categoryMenu="divers"
#nameMenu="Grocy (Épicerie) LXC"
#commutatorLetter=""
#commutatorWord="epicerie_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/grocy.sh)"
}

hyperhdr_lxc() {
#helpDescription="HyperHDR est une implémentation d'éclairage ambiant open source hautement optimisée basée sur une analyse moderne des flux vidéo et audio numériques. Pour créer un nouveau Proxmox VE HyperHDR LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. Interface HyperHDR : IP : 8090"
#categoryMenu="divers"
#nameMenu="HyperHDR LXC"
#commutatorLetter=""
#commutatorWord="hyperhdr_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/hyperhdr.sh)"
}

hyperion_lxc() {
#helpDescription="Hyperion est une implémentation open source d'éclairage ambiant. Elle prend en charge de nombreux appareils LED et cartes d'acquisition vidéo. Pour créer un nouveau Proxmox VE Hyperion LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. Interface Hyperion : IP : 8090"
#categoryMenu="divers"
#nameMenu="Hyperion"
#commutatorLetter=""
#commutatorWord="hyperion_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/hyperion.sh)"
}

serveur_magicmirror_lxc() {
#helpDescription="MagicMirror² est un logiciel de miroir intelligent open source permettant de créer un miroir intelligent personnalisé affichant des informations telles que la météo, les actualités, le calendrier, etc. Pour créer un nouveau serveur MagicMirror LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. Interface MagicMirror : IP:8080"
#categoryMenu="divers"
#nameMenu="MagicMirror LXC"
#commutatorLetter=""
#commutatorWord="serveur_magicmirror_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/magicmirror.sh)"
}

ntfy_lxc() {
#helpDescription="ntfy (prononcé notifier) est un service de notifications pub-sub simple basé sur HTTP. Il vous permet d'envoyer des notifications sur votre téléphone ou votre ordinateur de bureau via des scripts depuis n'importe quel ordinateur et/ou en utilisant une API REST. Pour créer un nouveau Proxmox VE ntfy LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. Interface ntfy : IP"
#categoryMenu="divers"
#nameMenu="ntfy LXC"
#commutatorLetter=""
#commutatorWord="ntfy_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/ntfy.sh)"
}

octoprint_lxc() {
#helpDescription="OctoPrint est un logiciel de contrôle d'imprimante 3D gratuit et open source basé sur le Web qui vous permet de contrôler et de surveiller à distance votre imprimante 3D à partir d'une interface Web. Pour créer un nouveau Proxmox VE OctoPrint LXC, exécutez la commande suivante dans le shell Proxmox VE. Interface OctoPrint : IP:5000"
#categoryMenu="divers"
#nameMenu="Octoprint LXC"
#commutatorLetter=""
#commutatorWord="octoprint_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/octoprint.sh)"
}

readeck_lxc() {
#helpDescription="Readeck vous aide à conserver tout le contenu Web que vous souhaiterez revoir dans une heure, demain ou dans 20 ans. Pour créer un nouveau Readeck LXC Proxmox VE, exécutez la commande suivante dans le shell Proxmox VE. Interface Readeck : IP:8000"
#categoryMenu="divers"
#nameMenu="readeck LXC"
#commutatorLetter=""
#commutatorWord="readeck_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/readeck.sh)"
}

rtsptoweb_lxc() {
#helpDescription="RTSPtoWeb convertit vos flux RTSP en formats utilisables dans un navigateur Web comme MSE (Media Source Extensions), WebRTC ou HLS. Pour créer un nouveau Proxmox VE RTSPtoWeb LXC, exécutez la commande suivante dans le shell Proxmox VE. Interface RTSP vers WEB : IP:8083"
#categoryMenu="divers"
#nameMenu="rtsptoweb LXC"
#commutatorLetter=""
#commutatorWord="rtsptoweb_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/rtsptoweb.sh)"
}

spoolman_lxc() {
#helpDescription="Spoolman est un service Web auto-hébergé conçu pour vous aider à gérer efficacement vos bobines de filament d'imprimante 3D et à surveiller leur utilisation. Pour créer un nouveau Spoolman LXC Proxmox VE, exécutez la commande suivante dans le shell Proxmox VE. Interface Spoolman : IP:7912"
#categoryMenu="divers"
#nameMenu="spoolman (Bobine) LXC"
#commutatorLetter=""
#commutatorWord="spoolman_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/spoolman.sh)"
}

recettes_tandoori_lxc() {
#helpDescription="Tandoor Recipes est une application pour gérer des recettes, planifier des repas, créer des listes de courses et bien plus encore ! Pour créer une nouvelle recette Tandoori LXC Proxmox VE, exécutez la commande suivante dans le shell Proxmox VE. Interface de recettes Tandoor : IP:8002"
#categoryMenu="divers"
#nameMenu="recettes tandoori"
#commutatorLetter=""
#commutatorWord="recettes_tandoori_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/tandoor.sh)"
}

tasmoadmin_lxc() {
#helpDescription="TasmoAdmin est une plateforme d'administration pour les appareils flashés avec Tasmota. Pour créer un nouveau Proxmox VE TasmoAdmin LXC, exécutez la commande suivante dans le shell Proxmox VE. Interface d'administration Tasmo : IP:9999"
#categoryMenu="divers"
#nameMenu="tasmoadmin LXC"
#commutatorLetter=""
#commutatorWord="tasmoadmin_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/tasmoadmin.sh)"
}

traccar_lxc() {
#helpDescription="Traccar est un système de suivi GPS open source. Pour créer un nouveau Proxmox VE Traccar LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. Interface Traccar : IP:8082"
#categoryMenu="divers"
#nameMenu="traccar LXC"
#commutatorLetter=""
#commutatorWord="traccar_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/traccar.sh)"
}

vaultwarden_lxc() {
#helpDescription="Vaultwarden est un gestionnaire de mots de passe auto-hébergé. Pour créer un nouveau Proxmox VE Vaultwarden LXC, exécutez la commande ci-dessous dans le shell Proxmox VE. Interface Vaultwarden : IP : 8000"
#categoryMenu="divers"
#nameMenu="vaultwarden LXC"
#commutatorLetter=""
#commutatorWord="vaultwarden_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/vaultwarden.sh)"
}

wastebin_lxc() {
#helpDescription="Wastebin est un pastebin minimaliste. Pour créer un nouveau Wastebin LXC Proxmox VE, exécutez la commande ci-dessous dans le shell Proxmox VE. Interface de la poubelle : IP:8088"
#categoryMenu="divers"
#nameMenu="wastebin LXC"
#commutatorLetter=""
#commutatorWord="wastebin_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/wastebin.sh)"
}

whoogle_lxc() {
#helpDescription="Obtenez des résultats de recherche Google sans publicité, javascript, liens AMP, cookies ou suivi d'adresse IP. Pour créer un nouveau Whoogle LXC Proxmox VE, exécutez la commande ci-dessous dans le shell Proxmox VE. Interface Whoogle : IP:5000"
#categoryMenu="divers"
#nameMenu="whoogle LXC"
#commutatorLetter=""
#commutatorWord="whoogle_lxc"
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/whoogle.sh)"
}


############################################################################
####################      Appel des fonctions      #########################
############################################################################

# Appel de la fonction pour parser les fonctions
parser_fonctions

# verifif de la presence des attributs
for attribut in $*
do
	if [ $attribut = "--help" ] || [[ $attribut =~ ^\-[^-]*h ]];then
		printHelpMore
        printMainPage
	fi
	for func in "${!helpDescriptions[@]}"; do
		if [ $attribut = "--${commutatorWords[$func]}" ] || ( [[ -n ${commutatorLetters[$func]} ]]  && [[ $attribut =~ ^\-[^-]*${commutatorLetters[$func]} ]] );then
			$func
			echo $func
			sleep 2
		fi
	done
done

# Affichage de la page principale
printMainPage
