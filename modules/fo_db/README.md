## Composant ballerina fo_db

Cette librairie a été créé pour le ticket EA-437, afin de gérer les accès à la DB FO:

* expose une api d'accès à, et requètage SQL de, cette DB,
* est prévue pour contenir toutes la logique d'accès à cette DB afin de ne pas l'éparpiller/dupliquer dans les autres composant,
* permet l'évolution (prévue) vers une api orm via l'intgération du module "bal persist" en isolant déjà le code d'accès à cette DB dans un composant dédié (contrainte de bal persist).

### Déploiement et configuration

* Pré-requis: avoir installé Ballerina,  
* cloner ce repo et se mettre sur la branche correspondant à l'environnement,
* remplacer les REPLACEME dans le block Config.toml ci-dessous (NB: pour une bdd dans un docker local, sauf si on sait vraiment ce qu'on fait, mettre 127.0.0.1 et pas localhost);
```
[conf]
host = "REPLACEME"
user = "REPLACEME"
password = "REPLACEME"
database = "REPLACEME"    
```
* exécuter les procédures de déploiement des README des composant intègrés (ces composant sont indiqués dans les section dependency du fichier Ballerina.toml),