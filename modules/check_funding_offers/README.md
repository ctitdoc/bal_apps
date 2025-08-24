## Composant ballerina check_funding_offers

Ce composant a été créé pour le ticket EA-440 : il détecte les offres bloquées en état de simulation de financement (ETAT_OFFRE_STOCK_ATTENTE_FO = 12) :
* interroge régulièrement la base de données pour identifier les offres restées bloquées dans cet état,
* calcule, pour chaque offre, le nombre de jours écoulés depuis son passage en état 12,
* génère un rapport listant les offres concernées avec les informations nécessaires au suivi (identifiants, dates, statut, durée d’attente, etc.).


### Déploiement et configuration

* Pré-requis: avoir installé Ballerina,  
* cloner ce repo et se mettre sur la branche correspondant à l'environnement,
* remplacer les REPLACEME dans le block Config.toml ci-dessous
```
[ballerina.log]
level = "DEBUG"

[job_patch.conf]
port = 9988

[bo_db.conf]
host = "REPLACEME"
user = "REPLACEME"
password = "REPLACEME"
database = "REPLACEME"
 
[teams.conf]
webhookUrl = "REPLACEME"
channelId = "REPLACEME"
apiKey = "REPLACEME"
```
_Si on ne sait pas oû trouver les valeur, demander aux "gens qui savent"._

* exécuter les procédures de déploiement et configuration des README des composant intégrés : ces composant sont déclarés dans les section "dependency" du fichier Ballerina.toml.
